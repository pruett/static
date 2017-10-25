[
  _
  Backbone

  BaseDispatcher
  AppointmentModel
  LocationModel
  LoginModel
  AppointmentsCollection
  Logger
] = [
  require 'lodash'
  require '../backbone/backbone'

  require './base_dispatcher'
  require '../backbone/models/appointment_model'
  require '../backbone/models/location_model'
  require '../backbone/models/login_model'
  require '../backbone/collections/appointments_collection'
  require '../logger'
]

log = Logger.get('AppointmentsDispatcher').log

apiServicesByUrlSlug =
  'eye-exams': 'optometrist'
  'frame-studio': 'photographer'
  'optician': 'optician'

class AppointmentsDispatcher extends BaseDispatcher
  channel: -> 'appointments'

  mixins: -> ['api']

  wake: ->
    unless @getAppointmentsEndpoint()
      @throwError statusCode: 404

    @model('appointment').set(@getAppointmentDefaults())

    @model('appointmentConfirmation').sessionStart(
      name: 'appointment'
      ttl: 2 * 24 * 60 * 60 * 1000  # 48 hours.
    )

    session = @requestDispatcher 'session', 'store'
    if session
      # The `events` hash isn't initialized on the dispatcher until after
      # `wake()` executes, so manually call these change handlers here.
      @handleSessionStoreChange session
      @onAppointmentChange()

  models: ->
    LocationModel::url = @getLocationEndpoint()

    appointment:
      class: AppointmentModel
    appointmentConfirmation:
      class: AppointmentModel
    location:
      class: LocationModel
      fetchOnWake: true

  collections: ->
    AppointmentsCollection::url = @getAppointmentsEndpoint()

    appointments:
      class: AppointmentsCollection
      fetchOnWake: true

  getStoreChangeHandlers: ->
    session: 'handleSessionStoreChange'

  getInitialStore: -> @buildStoreData()

  storeDidInitialize: ->
    @setPageTitle()

  setPageTitle: ->
    super(
      /^\/appointments\/(eye-exams|frame-studio)\/.*$/
      "#{_.get @data('location'), 'name', ''}
        #{_.startCase _.get(@currentLocation(), 'params.service_key')}"
    )

  events: ->
    'change appointment': @onAppointmentChange
    'error appointments': @onAppointmentsError
    'sync appointments': @onAppointmentsSync

  onAppointmentChange: ->
    @replaceStore @buildStoreData()

  onAppointmentsError: (collection, xhr) ->
    @throwError statusCode: xhr.status

  onAppointmentsSync: (collection) ->
    log 'onAppointmentsSync', collection
    @setStore
      appointments: @data 'appointments'
      __fetched: true
    @setPageTitle()

  handleSessionStoreChange: (store) ->
    customer = store.customer or {}

    return unless customer.authenticated

    customerAttrs = _.pick customer, 'first_name', 'last_name', 'email'

    _.assign customerAttrs,
      account_email: customerAttrs.email
      authenticated: true
      create_account: false
      customer_id: customer.id

    @model('appointment').set(customerAttrs)

  locationDidChange: ->
    log 'locationDidChange'

    # We've gone to the confirmation page or returned from the confirmation
    # page to the new appointment page. Mostly for the latter case, ensure
    # we're starting with fresh data.
    @model('appointment').set(@getAppointmentDefaults())
    @collection('appointments').fetch()

    session = @requestDispatcher 'session', 'store'
    if session
      @handleSessionStoreChange session

  buildStoreData: ->
    appointments: @data 'appointments'
    appointment: @data 'appointment'
    appointmentConfirmation: @data 'appointmentConfirmation'
    location: @data 'location'
    __fetched: @collection('appointments').isFetched()

  getAppointmentsEndpoint: ->
    {city_slug, location_slug, service_key} = @getUrlFields()

    if city_slug and location_slug and service_key
      "/api/v2/appointments/#{city_slug}/#{location_slug}\
        /#{service_key}/availability/#{@getDate()}/30"

  getLocationEndpoint: ->
    {city_slug, location_slug} = @getUrlFields()

    if city_slug and location_slug
      "/api/v2/retail/locations/#{city_slug}/#{location_slug}"

  getAppointmentDefaults: ->
    # Get UTC time at 00:00 today for comparison against other datetime values
    # in components.
    today = new Date
    today.setUTCHours 0, 0, 0, 0

    urlFields = @getUrlFields()

    _.assign urlFields,
      booking_status: 'new'
      redirectOnSave: true
      create_account: urlFields.service_key is 'optometrist'
      email_subscription: true
      over_eighteen: false
      today: today.getTime()

  getUrlFields: ->
    {city_slug, location_slug} = _.get @currentLocation(), 'params', {}

    service_key = apiServicesByUrlSlug['eye-exams']

    {city_slug, location_slug, service_key}

  getDate: ->
    # Build date string such that all data will start from yesterday's date,
    # for cases where users and GMT are a day apart.
    date = new Date()
    date.setUTCDate(date.getUTCDate() - 1)

    "#{date.getUTCFullYear()}-#{date.getUTCMonth() + 1}-#{date.getUTCDate()}"

  onAppointmentSaveError: (analyticsSlug, model, xhr, options) ->
    log 'onAppointmentSaveError', arguments
    appointment = @model 'appointment'
    appointment.unset 'errors'
    appointment.set('errors', @parseApiError xhr.response)

    @collection('appointments').fetch()

    @pushEvent "#{analyticsSlug}-error"

  onAppointmentSaveSuccess: (analyticsSlug) ->
    log 'onAppointmentSaveSuccess', analyticsSlug

    # Persist appointment data via a separate model for confirmation.
    @model('appointmentConfirmation').clear()
      .set(@data('appointment'))
    @setStore 'appointmentConfirmation', @data 'appointmentConfirmation'

    {city_slug, location_slug, service_key} = @data 'appointment'

    if @data('appointment').redirectOnSave
      @navigate "/appointments/#{_.get @currentLocation(), 'params.service_key'}\
        /#{city_slug}/#{location_slug}/confirmation"
    else
      @model('appointment').set({booking_status: 'complete'})
      @setStore 'appointment', @data('appointment')

    @pushEvent "#{analyticsSlug}-success"

  onLoginError: (model, xhr, options) ->
    log 'onLogInError', arguments
    appointment = @model 'appointment'
    appointment.unset 'errors'
    appointment.set('errors', @parseApiError xhr.response)

    @pushEvent 'appointments-submit-bookUser-error'

  onLoginSuccess: ->
    log 'onLoginSuccess'
    @commands.save.call @, 'appointments-submit-bookUser'

  commands:
    set: (attrs) ->
      log 'set', attrs
      @model('appointment').set(attrs)

    clearConfirmation: ->
      @setStore 'appointmentConfirmation', @model('appointmentConfirmation').clear()

    change: ->
      log 'change'
      @model('appointment').unset('date')
        .set(booking_status: 'new')

    save: (analyticsSlug) ->
      log 'save'
      appointment = @model 'appointment'
      appointment.unset 'errors'
      errors = appointment.validate()

      if errors
        appointment.set(errors: errors)
      else
        appointment.save null,
          type: 'POST'
          error: @onAppointmentSaveError.bind(@, analyticsSlug)
          success: @onAppointmentSaveSuccess.bind(@, analyticsSlug)

    dismissNotice: ->
      log 'dismissNotice'
      @model('appointment').set(show_notice: false)

    logInAndSave: ->
      log 'logInAndSave'
      appointment = @data 'appointment'
      email = appointment.account_email
      password = appointment.account_password
      login = new LoginModel {email, password}

      errors = login.validate()
      if errors
        @model('appointment').unset 'errors'
        @model('appointment').set('errors', errors)
      else
        login.save null,
          error: @onLoginError.bind @
          success: @onLoginCreateAppointment.bind @

  onLoginCreateAppointment: (model) ->
    customer = model.get("customer") or {}

    return unless customer.authenticated

    customerAttrs = _.pick customer, 'first_name', 'last_name', 'email'

    _.assign customerAttrs,
      account_email: customerAttrs.email
      authenticated: true
      create_account: false
      customer_id: customer.id
      require_customer_id: true

    @model('appointment').set(customerAttrs)

    @commands.save.call @, 'appointments-submit-bookUser'


  requests:
    validate: (attrs) ->
      log 'validate', attrs

      appointment = @model 'appointment'
      appointment.unset 'errors'
      errors = appointment.preValidate attrs

      if errors
        appointment.set(errors: errors)
        errors

module.exports = AppointmentsDispatcher
