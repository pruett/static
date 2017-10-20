[
  _
  React

  AppointmentBooker
  AppointmentCustomer
  AppointmentDateTime
  AppointmentUser
  AppointmentNotice

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/appointments/appointment/booker/booker'
  require 'components/organisms/appointments/appointment/customer/customer'
  require 'components/organisms/appointments/appointment/date_time/date_time'
  require 'components/organisms/appointments/appointment/user/user'
  require 'components/molecules/appointment/notice/notice'

  require 'components/mixins/mixins'

  require './container.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-appointment-container'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
    Mixins.conversion
    Mixins.analytics
    Mixins.scrolling
  ]

  propTypes:
    appointment: React.PropTypes.object
    appointments: React.PropTypes.array
    content: React.PropTypes.object
    session: React.PropTypes.object

  getDefaultProps: ->
    appointment: {}
    appointments: []
    content: {}
    session: null

  getInitialState: ->
    activeScreen: 'dateTime'
    activeDate: @getDefaultDate()

  getDefaultDate: ->
    appointment = _.find @props.appointments, (appt) ->
      appt.slots.length > 0

    if appointment then appointment.date

  componentWillReceiveProps: (nextProps) ->
    if nextProps.appointment.booking_status is 'new' and
      @props.appointment.booking_status isnt 'new'
        @setState activeScreen: 'dateTime'

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-grid u-pr
      u-mla u-mra"
    row:
      'u-grid__row'
    col:
      'u-grid__col u-w12c'
    noJs:
      'u-tac u-mb24'
    notice:
      'u-mb36 u-mb48--900'
    dateTime:
      "#{@BLOCK_CLASS}__screen"
    booker:
      "#{@BLOCK_CLASS}__screen"
    customer:
      "#{@BLOCK_CLASS}__screen"
    user:
      "#{@BLOCK_CLASS}__screen"

  classesWillUpdate: ->
    _.reduce ['dateTime', 'booker', 'customer', 'user'], (acc, screen) =>
      acc[screen] = '-inactive': @state.activeScreen isnt screen
      acc
    , {}

  scrollToAppointmentContainer: ->
    @scrollToNode(@props.appointmentContainerRef)

  manageDismissNotice: (evt) ->
    @commandDispatcher 'appointments', 'dismissNotice'

  manageSetDate: (date) ->
    @setState activeDate: date

  manageSetTimeSlot: (timeSlot) ->
    @commandDispatcher 'appointments', 'dismissNotice'

    @commandDispatcher 'appointments', 'set', {
      date:
        timestamp: timeSlot
      booking_status: 'inProgress'
    }

    nextScreen = switch _.get @props, 'appointment.service_key'
      when 'optometrist'
        'booker'
      when 'photographer'
        'customer'

    if nextScreen
      @setState activeScreen: nextScreen

    @scrollToAppointmentContainer()

  manageSetCustomerIsBooking: (isBooking) ->
    @commandDispatcher 'appointments', 'set', {
      customer_is_booking: isBooking
    }

    @setState activeScreen: 'customer'

    @scrollToAppointmentContainer()


  manageCustomerBook: (attrs) ->
    @commandDispatcher 'appointments', 'set', attrs

    if _.get(@props, 'appointment.service_key') is 'optometrist' and
      not _.get @props, 'session.customer.authenticated'
        # Customer is booking an eye exam but is not logged in. Validate the
        # available fields so far, then advance to login/create account screen.
        errors = @requestDispatcher 'appointments', 'validate', attrs
        if errors
          @trackInteraction 'appointments-showError-bookCustomer'
        else
          @setState activeScreen: 'user'

    else
      @commandDispatcher 'appointments', 'save', 'appointments-submit-bookCustomer'

    @scrollToAppointmentContainer()

  manageSetCreateAccount: (createAccount) ->
    @commandDispatcher 'appointments', 'set', create_account: createAccount

  manageUserBook: (attrs) ->
    @commandDispatcher 'appointments', 'set', attrs

    if _.get @props, 'appointment.create_account'
      @commandDispatcher 'appointments', 'save', 'appointments-submit-bookUser'
    else
      @commandDispatcher 'appointments', 'logInAndSave'

  render: ->
    customer = _.get @props, 'session.customer', {}
    content = @props.content or {}
    showNotice = _.get @props, 'appointment.show_notice'
    location = @props.location or {}

    classes = @getClasses()

    <div className=classes.block>
      <div className=classes.row>
        <div className=classes.col>
          <noscript>
            <p children='JavaScript is required to book appointments.'
              className=classes.noJs />
          </noscript>

          <form onSubmit=@handleSubmit>
            <AppointmentDateTime
              activeDate=@state.activeDate
              appointments=@props.appointments
              content=content
              cssModifier=classes.dateTime
              location=location
              manageSetDate=@manageSetDate
              manageSetTimeSlot=@manageSetTimeSlot
              today={_.get @props, 'appointment.today'} />

            <AppointmentBooker
              cssModifier=classes.booker
              manageSetCustomerIsBooking=@manageSetCustomerIsBooking />

            <AppointmentCustomer
              appointment=@props.appointment
              cssModifier=classes.customer
              customer=customer
              isVisible={@state.activeScreen is 'customer'}
              manageCustomerBook=@manageCustomerBook />

            {unless (customer and customer.authenticated)
              <AppointmentUser
                appointment=@props.appointment
                cssModifier=classes.user
                customer=customer
                manageSetCreateAccount=@manageSetCreateAccount
                manageUserBook=@manageUserBook />
            }
          </form>
        </div>
      </div>
    </div>
