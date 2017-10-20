[
  _
  React

  LayoutAppointment

  AppointmentContainer
  AppointmentHeader

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_appointment/layout_appointment'

  require 'components/organisms/appointments/appointment/container/container'
  require 'components/molecules/appointment/header/header'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/appointments/{service_key}/{city_slug}/{location_slug}'
      handler: 'Appointment'
      bundle: 'appointments'

  LAYOUT_CONTENT_PATH: '/retail/responsive-appointment-global'

  getLocationContentPath: ->
    {service_key, city_slug, location_slug} = @getRouteParams()

    "/appointments/#{city_slug}/#{location_slug}/#{service_key}"

  fetchVariations: -> [
    @getLocationContentPath()
    @LAYOUT_CONTENT_PATH
  ]

  receiveStoreChanges: -> [
    'appointments'
    'content'
    'session'
  ]

  render: ->
    appointments = @getStore 'appointments'
    content =
      page: @getContentVariation @getLocationContentPath()
      layout: @getContentVariation @LAYOUT_CONTENT_PATH
    session = @getStore 'session'

    if appointments.__fetched and content.page
      appointment = appointments.appointment or {}

      <LayoutAppointment
        {...@props}
        appointment=appointment
        appointments=appointments.appointments
        content=content>
        <AppointmentContainer
          appointment=appointment
          appointments=appointments.appointments
          content=content.page
          key='container'
          location=appointments.location
          displayMeta=false
          session=session />
      </LayoutAppointment>
