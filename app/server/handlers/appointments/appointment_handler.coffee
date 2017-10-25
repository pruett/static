[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

apiServicesByUrlSlug =
  'eye-exams': 'optometrist'
  'frame-studio': 'photographer'
  'optician': 'optician'

class AppointmentHandler extends BaseHandler
  name: -> 'Appointment'

  prefetch: -> _.compact [
    @getAppointmentsEndpoint()
    @getContentEndpoint()
    @getLocationEndpoint()
    '/api/v2/variations/retail/responsive-appointment-global'
  ]

  prefetchOptions: ->
    timeout: 5000

  prepare: ->
    appointmentsEndpoint = @getAppointmentsEndpoint()
    prefetchError = @prefetchErrors[appointmentsEndpoint]

    unless appointmentsEndpoint
      @throwError statusCode: 404
      false

    else if _.isNumber prefetchError
      @throwError prefetchError
      false

    else
      true

  getAppointmentsEndpoint: ->
    {api_service_key, city_slug, location_slug} = @getUrlFields()

    if api_service_key and city_slug and location_slug
      "/api/v2/appointments/#{city_slug}/#{location_slug}\
        /#{api_service_key}/availability/#{@getDate()}/30"

  getContentEndpoint: ->
    {city_slug, location_slug, service_key} = @getUrlFields()

    if city_slug and location_slug and service_key
      "/api/v2/variations/appointments/#{city_slug}/#{location_slug}/#{service_key}"

  getLocationEndpoint: ->
    {city_slug, location_slug} = @getUrlFields()

    if city_slug and location_slug
      "/api/v2/retail/locations/#{city_slug}/#{location_slug}"

  getUrlFields: ->
    urlFields = _.pick @request.params,
      'city_slug', 'location_slug', 'service_key'

    if urlFields.service_key
      urlFields.api_service_key = apiServicesByUrlSlug[urlFields.service_key]

    urlFields

  getDate: ->
    # Build date string such that all data will start from yesterday's date,
    # for cases where users and GMT are a day apart.
    date = new Date()
    date.setUTCDate(date.getUTCDate() - 1)

    "#{date.getUTCFullYear()}-#{date.getUTCMonth() + 1}-#{date.getUTCDate()}"


module.exports = AppointmentHandler
