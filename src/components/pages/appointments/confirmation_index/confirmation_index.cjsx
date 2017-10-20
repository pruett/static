[
  React

  LayoutAppointment
  AppointmentSuccess

  Mixins
] = [
  require 'react/addons'

  require 'components/layouts/layout_appointment/layout_appointment'
  require 'components/organisms/appointments/appointment/success/success'

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
      path: '/appointments/{service_key}/{city_slug}/{location_slug}/confirmation'
      handler: 'Appointment'
      bundle: 'appointments'

  LAYOUT_CONTENT_PATH: '/retail/responsive-appointment-global'

  fetchVariations: -> [
    @LAYOUT_CONTENT_PATH
  ]

  receiveStoreChanges: -> [
    'appointments'
    'session'
  ]

  render: ->
    appointments = @getStore 'appointments'
    session = @getStore 'session'
    content = @getContentVariation @LAYOUT_CONTENT_PATH

    <LayoutAppointment {...@props} content=content>
      {if appointments.__fetched and content
        appointment = appointments.appointmentConfirmation or {}
        <AppointmentSuccess key='container' appointment=appointment />
      }
    </LayoutAppointment>
