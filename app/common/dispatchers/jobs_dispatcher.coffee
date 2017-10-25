[
  _

  Logger
  BaseDispatcher

  Backbone
  JobsCollection
] = [
  require 'lodash'

  require '../logger'
  require './base_dispatcher'

  require '../backbone/backbone'
  require '../backbone/collections/jobs_collection'
]

class VariationsEndpoint extends Backbone.BaseModel

class JobsDispatcher extends BaseDispatcher
  log = Logger.get('JobsDispatcher').log

  channel: -> 'jobs'

  mixins: -> [
    'cms'
  ]

  contentPath: -> '/jobs'

  models: ->
    path = @contentPath()
    VariationsEndpoint::url = "/api/v2/variations#{path}#{@getVariationQueryString path}"
    variations:
      class: VariationsEndpoint
      fetchOnWake: true

  collections: ->
    jobs:
      class: JobsCollection
      fetchOnWake: true

  getInitialStore: ->
    @buildStoreData()

  events: ->
    'sync jobs': @onJobsSync

  onJobsSync: ->
    @replaceStore @buildStoreData()

  onVariationsSync: ->
    @replaceStore @buildStoreData()

  getStructuredJobs: (jobsData, jobType, departmentGroups) ->
    allJobs = []

    if jobType is 'retail'
      # In the retail section, we group jobs by region (state/province) instead of by department.
      locations = {}
      _.forEach jobsData, (dept) ->
        for job in dept.jobs
          allJobs.push job
          # If the job belongs to a retail location, add it to the jobs for that location.
          # Otherwise ignore it, since jobType is 'retail'.
          if job.custom.is_retail
            # All retail jobs should have region and locality data, but in case some don't have
            # a region, we fall back to grouping those by `job.location.name`, which will
            # look like "New York, NY".
            locationName = job.custom.region or job.location.name

            if locations[locationName]
              if job.custom.region
                # Insert the job in the correct region, and keep the jobs within each region
                # sorted by locality.
                locations[locationName].splice _.sortedIndexBy(
                    locations[locationName],
                    job,
                    (existingJob) -> existingJob.custom.locality
                  ), 0, job
              else
                locations[locationName].push job
            else
              locations[locationName] = [job]
      groupedData = _.map locations, (jobs, name) ->
        jobs: jobs
        name: name
        slug: _.kebabCase name
      groupedData = _.sortBy groupedData, (group) -> group.slug
    else
      # Use groupIndexLookup to quickly look up a given location/department's group index
      groupIndexLookup = {}
      # Here we map Greenhouse's full list of departments to a CMS-based, shorter list
      # of departments to categorize jobs on the public site.
      groupedData = _.map departmentGroups, (group, i) ->
        cleanedDepartments = _.map (group.child_departments or '').split(';'),
          (dept) -> _.kebabCase dept

        for childDept in cleanedDepartments
          groupIndexLookup[childDept] = i

        child_departments: cleanedDepartments
        jobs: []
        name: group.name
        slug: _.kebabCase group.name

      _.forEach jobsData, (dept) =>
        groupIndex = groupIndexLookup[_.kebabCase dept.name]
        if not isNaN(groupIndex)
          group = groupedData[groupIndex]
          allJobs = allJobs.concat dept.jobs
          # Filter out retail location jobs, and filter lab jobs either in or out as appropriate.
          group.jobs = group.jobs.concat _.filter(
            dept.jobs,
            (job) =>
              if jobType is 'lab'
                not job.custom.is_retail and job.custom.is_lab
              else
                not job.custom.is_retail and not job.custom.is_lab
          )

      # Don't show empty departments on the labs tab
      if jobType is 'lab'
        groupedData = _.filter groupedData, 'jobs.length'

    allJobs: allJobs
    groupedData: groupedData

  getFeaturedJobs: (jobs, activeGroup) ->
    _.filter jobs, (job) =>
      if job.custom.is_featured
        if activeGroup is 'retail_stores'
          job.custom.is_retail and not job.custom.is_lab
        else if activeGroup is 'labs'
          not job.custom.is_retail and job.custom.is_lab
        else
          not job.custom.is_retail and not job.custom.is_lab
      else
        return false

  buildStoreData: ->
    cmsData = @getCmsData()
    departmentData =
      headquarters:
        name: 'corporate'
        order: 0
      retail:
        name: 'retail_stores'
        order: 1
      lab:
        name: 'labs'
        order: 2

    allJobTypes = _.keys departmentData
    jobType = _.get @currentLocation(), 'params.job_type', ''
    if jobType not in allJobTypes
      jobType = 'headquarters'

    {allJobs, groupedData} = @getStructuredJobs @data('jobs'), jobType, cmsData.department_groups
    activeJobGroup = departmentData[jobType].name

    __fetched: @collection('jobs').isFetched() and @model('variations').isFetched()
    activeJobGroup: activeJobGroup
    allJobTypes: allJobTypes
    content: cmsData
    departmentData: departmentData
    featuredJobs: @getFeaturedJobs allJobs, activeJobGroup
    groupedJobs: groupedData
    jobType: jobType

  getCmsData: ->
    endpoint = @model 'variations'
    return {} unless endpoint.isFetched()
    variations = _.get endpoint, 'attributes.variations', {}
    @getContentVariation variations

  commands:
    goToSubsection: (subsection) ->
      @navigate.bind @, "/jobs/#{subsection}"
      @replaceStore @buildStoreData()

module.exports = JobsDispatcher
