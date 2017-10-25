Backbone = require '../../backbone/backbone'

class JobsCollection extends Backbone.BaseCollection
  url: -> @apiBaseUrl('jobs')

  parse: (resp) ->
    resp.departments.forEach (department) ->
      department.jobs.forEach (job) ->

        # Parse Greenhouse's metadata fields into more straightforward custom fields
        # on the base job object. This obviates the need to iterate over each job's metadata
        # array each time we want one specific metadata field.
        if not job.custom
          job.custom = {}
        job.custom.is_featured = false
        job.custom.is_lab = false
        job.custom.is_retail = false
        job.custom.locality = null
        job.custom.region = null

        job.metadata.forEach (md) ->
          mdName = md.name.replace(/\W/g, '').toLowerCase()
          if md.value is true
            if mdName is 'featuredjob'
              job.custom.is_featured = true
            else if mdName is 'lablocation'
              job.custom.is_lab = true
            else if mdName is 'retaillocation'
              job.custom.is_retail = true

          if mdName in ['locality', 'localitycity']
            job.custom.locality = md.value
          else if mdName in ['region', 'regionstate']
            job.custom.region = md.value

    resp.departments

module.exports = JobsCollection
