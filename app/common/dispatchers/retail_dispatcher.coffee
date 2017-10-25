[
  _
  Backbone

  BaseDispatcher
  RetailCollection
  Logger
] = [
  require 'lodash'
  require '../backbone/backbone'

  require './base_dispatcher'
  require '../backbone/collections/retail_collection'
  require '../logger'
]

log = Logger.get('RetailDispatcher').log

class RetailDispatcher extends BaseDispatcher
  channel: -> 'retail'

  collections: ->
    retail:
      class: RetailCollection
      fetchOnWake: true

  events: ->
    'sync retail': @onRetailSync
    'error retail': @onRetailError

  onRetailSync: -> @replaceStore @buildStoreData(@currentLocation())

  onRetailError: (collection, xhr) ->
    unless collection.isFetched()
      # Throw error if API returns error, unless previously fetched.
      @throwError statusCode: xhr.status

  getInitialStore: -> @buildStoreData @currentLocation()

  wake: ->
    # Fetch the retail endpoint periodically (but infrequently) to ensure
    # we're showing a current open/closed status.
    clearInterval @fetchInterval
    @fetchInterval = setInterval @onRetailSync.bind(@), 10 * 60000  # 10 minutes.

  getRetailDetailVersion: ->
    if @inExperiment('newRetailDetail', 'enabled') then 'v2' else 'v1'

  getLocationStatus: (loc, schedule) ->
    isOpenDaily: @isOpenDaily schedule.hours
    currentStatus: @getCurrentStatus schedule.hours, loc.timezone_offset

  buildStoreData: (currentLocation) ->
    isFetched = @collection('retail').isFetched()
    locations = @data 'retail'

    store =
      __fetched: isFetched
      location: null
      locations: locations
      retailDetailVersion: @getRetailDetailVersion()

    if @inExperiment('eyeExamToggleRetail', 'enabled')
      store.locationsEyeExam = _.filter(locations, 'offers_eye_exams')

    slugs = _.pick currentLocation.params, 'location_slug', 'city_slug'

    if slugs.location_slug and slugs.city_slug
      # We're on an individual location page.

      store.location = _.find store.locations, (loc) ->
        loc.location_slug is slugs.location_slug and
          loc.city_slug is slugs.city_slug

      if store.location
        nearbyLocationSlugs = _.get store.location, 'cms_content.nearby_locations', ''
        store.nearbyLocations = _.filter store.locations, (loc) ->
          locSlug = _.get loc, 'cms_content.facility_slug'
          locSlug and nearbyLocationSlugs.indexOf(locSlug) > -1

        _.map store.nearbyLocations, (location, i) =>
          schedule = _.find location.schedules, name: 'Store'
          _.assign(location, @getLocationStatus(location, schedule)) if schedule

        schedule = _.find store.location.schedules, name: 'Store'
        _.assign(store, @getLocationStatus(store.location, schedule)) if schedule

        store.hasLaunched = _.get store.location, 'cms_content.has_launched', true

        @setPageTitle(
          /^\/retail.*$/
          _.get store.location, 'cms_content.name', ''
        )
      else if isFetched
        @throwError statusCode: 404


    store

  locationDidChange: (nextLocation, prevLocation) ->
    if _.startsWith(nextLocation.route, '/retail')
      @replaceStore @buildStoreData(nextLocation)

  getCurrentStatus: (hours, offset) ->
    now = new Date()
    dateFields = @getDateFields now
    schedule = hours[dateFields.day.toLowerCase()]

    if _.isEmpty(schedule) or _.get(schedule, 'closed')
      return 'closed'

    openHour = @getRfcHour schedule.open
    closeHour = @getRfcHour schedule.close

    openMSec = @parseDate dateFields, openHour, offset
    closeMSec = @parseDate dateFields, closeHour, offset

    nowMSec = now.getTime()
    if nowMSec > openMSec and nowMSec < closeMSec
      'open'
    else
      'closed'

  getRfcHour: (cmsHour) ->
    timeOfDay = cmsHour.slice(-5).toLowerCase()
    timeOnly = cmsHour.slice 0, -5

    hours = parseInt(timeOnly.split(':')[0])
    minutes = timeOnly.split(':')[1]

    # 12:xx AM (Midnight) => 0:xx
    if timeOfDay is ' a.m.' and hours is 12
      hours = 0

    # 1:xx PM - 11:xx PM => 13:xx - 23:xx
    else if timeOfDay is ' p.m.' and hours isnt 12
      hours = hours + 12

    return "#{hours}:#{minutes}"

  parseDate: (fields, time, offset) ->
    Date.parse "#{fields.day}, #{fields.date}
      #{fields.month} #{fields.year}
      #{time}:00 #{offset}"

  getDateFields: (date) ->
    rfcMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    rfcDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    day: rfcDays[date.getDay()]
    date: date.getDate()
    month: rfcMonths[date.getMonth()]
    year: date.getFullYear()

  isOpenDaily: (hours) ->
    monHours = hours.mon
    return false unless (monHours and _.size(hours) is 7)

    _.reduce hours, (acc, date) ->
      acc and
        date.open is monHours.open and
          date.close is monHours.close
    , true

module.exports = RetailDispatcher
