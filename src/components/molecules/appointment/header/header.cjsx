[
  React

  LogoImage

  Mixins
] = [
  require 'react/addons'

  require 'components/atoms/images/logo/logo'

  require 'components/mixins/mixins'

  require './header.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-appointment-header'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.conversion
    Mixins.dispatcher
  ]

  propTypes:
    appointment: React.PropTypes.object
    status: React.PropTypes.oneOf ['new', 'inProgress', 'complete']

  getDefaultProps: ->
    appointment: {}
    status: 'new'

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-grid
      u-pr
      u-mla u-mra u-mb18 u-mb36--600 u-mb60--1200
      u-color-bg--light-gray-alt-2"
    contents:
      'u-pr
      u-center-y
      u-pt4--600'
    homeLink:
      "#{@BLOCK_CLASS}__home-link
      u-dib--600
      u-mb2--600"
    tagline:
      'u-fs14
      u-color--dark-gray-alt-1
      u-fr
      u-dn u-dib--600'
    cancelLink:
      "#{@BLOCK_CLASS}__cancel-link
      u-fr
      u-pl12
      u-ttu
      u-reset  u-fs14 u-ls2_5 u-ttu u-fs12--900"
    appointmentTime:
      'u-fr--600
      u-reset u-fs14 u-ls2_5 u-ttu u-fs12--900'

  classesWillUpdate: ->
    status = @props.status

    homeLink:
      'u-dib': status is 'new'
      'u-dn': status is 'inProgress'
      'u-db': status is 'complete'
      'u-tac': status is 'complete'
      '-complete': status is 'complete'

  handleClickCancel: (evt) ->
    evt.preventDefault()
    @commandDispatcher 'appointments', 'change'
    @trackInteraction 'appointments-cancel-appointment', evt

    if history and _.isFunction history.go
      history.go -1

  handleClickChange: (evt) ->
    evt.preventDefault()
    @commandDispatcher 'appointments', 'change'
    @trackInteraction 'appointments-change-appointment', evt

  formatAppointmentDateTime: (dateTime) ->
    {day, month, date, hours, minutes} = @convert 'utcdate', 'object', "#{dateTime}Z"

    day = day.substr 0, 3
    month = month.substr 0, 3
    period = if hours < 12 then 'A.M.' else 'P.M.'
    hours = if hours > 12 then hours - 12 else hours
    minutes = if minutes < 10 then "0#{minutes}" else minutes

    "#{day}, #{month} #{date} - #{hours}:#{minutes} #{period}"

  render: ->
    classes = @getClasses()

    <header role='banner' className=classes.block>
      <div className=classes.contents>
        <a href='/' className=classes.homeLink>
          <LogoImage />
        </a>

        {switch @props.status
          when 'new'
            <a href='/appointments/eye-exams'
              children='Cancel'
              className=classes.cancelLink
              key='cancel'
              onClick=@handleClickCancel />
          when 'inProgress'
            [
              <a href='/appointments/eye-exams'
                children='Change'
                className=classes.cancelLink
                key='change'
                onClick=@handleClickChange />
              <span children={@formatAppointmentDateTime(
                  _.get @props, 'appointment.date.timestamp'
                )}
                className=classes.appointmentTime
                key='appointment-time' />
            ]
          when 'complete'
            <span className=classes.tagline
              children='We look forward to seeing you.'
              key='tagline' />
        }
      </div>
    </header>
