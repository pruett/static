[
  _
  React

  Arrow

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/down_arrow/down_arrow'

  require 'components/mixins/mixins'

  require './calendar_fieldset.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-calendar-fieldset'

  mixins: [
    Mixins.classes
    Mixins.conversion
  ]

  propTypes:
    radioName: React.PropTypes.string
    daysFuture: React.PropTypes.number
    daysPast: React.PropTypes.number
    manageChangeDate: React.PropTypes.func
    formatDateValue: React.PropTypes.func
    constrainNav: React.PropTypes.bool
    cssModifiers: React.PropTypes.object
    days: React.PropTypes.array
    dateStart: (props, propName) ->
      new Error('Invalid date') unless _.isDate props[propName]

  getInitialState: ->
    # Set value to today.
    value: @props.formatDateValue @props.dateStart
    today: @props.formatDateValue new Date

  getDefaultProps: ->
    radioName: 'calendar' # Change radio name for multiple calendars.
    dateStart: new Date   # Starting date, usually today.
    constrainNav: true    # Disable navigation outside below limits.
    limitDaysFuture: 90   # Cutoff distance from dateStart for future dates.
    limitDaysPast: 0      # Cutoff distance from dateStart for past dates.
    cssModifiers: {}      # Use keys to override individual styles.
    days: [               # Day titles
      'S'
      'M'
      'T'
      'W'
      'TH'
      'F'
      'S'
    ]

    formatDateValue: (date) ->
      return '' unless _.isDate date
      # Return value of @props.manageChangeDate
      # Also generates key/id for input and label.
      "#{date.getMonth() + 1}/#{date.getDate()}/#{date.getFullYear()}"

    # manageChangeDate: (evt) ->

  setCurrentMonth: (date = @props.dateStart)->
    # Set current to first day of month and direction.
    if _.isDate date
      @setState
        current: new Date date.getFullYear(), date.getMonth(), 1
        backward: # Are we going backwards?
          if _.isDate @state.current
            date.getTime() < @state.current.getTime()
          else
            false

  componentWillMount: ->
    @setCurrentMonth()

  componentWillReceiveProps: (nextProps) ->
    @setCurrentMonth() if @props.dateStart isnt nextProps.dateStart

  shouldComponentUpdate: (nextProps, nextState) ->
    @state.current.getMonth() isnt nextState.current.getMonth()

  getStaticClasses: ->
    cssModifiers = @props.cssModifiers or {}

    block: "
      #{@BLOCK_CLASS}
      #{cssModifiers.block or ''}
      u-reset"
    date: "
      #{@BLOCK_CLASS}__date
      #{cssModifiers.date or ''}"
    day: "
      #{@BLOCK_CLASS}__day
      #{cssModifiers.day or ''}"
    heading: "
      #{@BLOCK_CLASS}__heading
      #{cssModifiers.heading or ''}"
    header: "
      #{@BLOCK_CLASS}__header
      #{cssModifiers.header or ''}"
    radio: "
      #{@BLOCK_CLASS}__radio
      u-hide--visual"
    months: "
      #{@BLOCK_CLASS}__months
      #{cssModifiers.months or ''}"
    month: "
      #{@BLOCK_CLASS}__month
      #{cssModifiers.month or ''}"
    title: "
      #{@BLOCK_CLASS}__title
      u-reset u-100p
      u-fs16 u-fs30--900 u-ffs u-fws
      #{cssModifiers.title or ''}"
    spacer: '
      u-fs16 u-fs30--900 u-ffs u-fws
      u-vh u-mt12 u-mb12 u-db
    '
    previous: "
      u-button-reset
      #{@BLOCK_CLASS}__button
      #{@BLOCK_CLASS}__button--prev
      #{cssModifiers.previous or ''}"
    next: "
      u-button-reset
      #{@BLOCK_CLASS}__button
      #{@BLOCK_CLASS}__button--next
      #{cssModifiers.next or ''}"
    arrow: "
      #{@BLOCK_CLASS}__arrow
      #{cssModifiers.arrow or ''}"

  handleChangeDate: (date, evt) ->
    @setState value: evt.target.value

    # Change month if clicking outliers.
    @setCurrentMonth(date) if date.getMonth() isnt @state.current.getMonth()

    @props.manageChangeDate(evt) if _.isFunction @props.manageChangeDate

  handleClickArrow: (date) ->
    @setCurrentMonth(date)

  isOutsideCutoff: (date) ->
    timeDays = 24 * 60 * 60 * 1000
    dayDiff = parseInt((date.getTime() - @props.dateStart.getTime()) / timeDays)
    dayDiff < -@props.limitDaysPast or dayDiff > @props.limitDaysFuture

  isntCurrentMonth: (date) ->
    @props.dateStart.getMonth() isnt date.getMonth()

  renderHeader: ->
    for day, index in @props.days
      <div className=@classes.header key="day-#{index}">
        <div className="#{@BLOCK_CLASS}__day" children=day />
      </div>

  renderDate: (date) ->
    value = @props.formatDateValue(date)

    cssDate = @classes.date or ''
    cssDate += ' -current-month' if @state.current.getMonth() is date.getMonth()
    cssDate += ' -today' if @state.today is value

    day = <span className=@classes.day children={date.getDate()} />

    [
      <input
        id=value
        value=value
        key="radio-#{value}"
        defaultChecked={@state.value is value}
        onChange={@handleChangeDate.bind(@, _.clone(date))}
        disabled={@isOutsideCutoff(date)}
        type='radio'
        name=@props.radioName
        className=@classes.radio />

      <label
        htmlFor=value
        key="label-#{value}"
        className=cssDate
        children=day />
    ]

  renderDates: ->
    date = _.clone @state.current # Clone so setDate doesn't mutate state.
    date.setDate date.getDate() - date.getDay() # Get first day of week.

    dates = []
    isSelectedVisible = false

    loop # while(true)
      for day in @props.days
        isSelectedVisible = true if @state.value is @props.formatDateValue(date)
        dates.push @renderDate(date)
        date.setDate(date.getDate() + 1)

      # Loop through days starting with Sunday
      # until next month starts week.
      break if date.getMonth() isnt @state.current.getMonth()

    # Append extra radio with value if selected is offscreen.
    unless isSelectedVisible
      dates.push [
        <input
          id=@state.value
          value=@state.value
          key="radio-#{@state.value}"
          defaultChecked=true
          type='radio'
          name=@props.radioName
          className=@classes.radio />
      ]

    dates

  render: ->
    return false unless _.isDate @props.dateStart

    @classes = @getClasses()

    title = @convert 'date', 'object', @state.current
    arrow = <Arrow cssModifier=@classes.arrow />

    monthIndex = @state.current.getMonth()

    # Clone current date to not mutate state.
    monthNext = new Date _.clone(@state.current).setMonth(monthIndex + 1)
    monthPrev = new Date _.clone(@state.current).setMonth(monthIndex - 1)

    # Get Transition Name
    transitionOffscreen = '-offscreen'
    transitionOffscreen = "#{transitionOffscreen}-backward" if @state.backward

    <fieldset className=@classes.block>

      <div className=@classes.heading>

        <button type='button'
          className=@classes.previous
          disabled={@isOutsideCutoff(monthPrev) and
            @isntCurrentMonth(monthPrev) and @props.constrainNav}
          onClick={@handleClickArrow.bind(@, monthPrev)}
          children=arrow />

        <ReactCSSTransitionGroup transitionName=transitionOffscreen>
          <span className="#{@classes.spacer}" children="Arrival month is" />
          <h2
            key="title-#{monthIndex}"
            className=@classes.title
            children="#{title.month} #{title.year}" />
        </ReactCSSTransitionGroup>

        <button
          type='button'
          className=@classes.next
          disabled={@isOutsideCutoff(monthNext) and @props.constrainNav}
          onClick={@handleClickArrow.bind(@, monthNext)}
          children=arrow />

      </div>

      {@renderHeader()}

      <ReactCSSTransitionGroup
        component='div'
        transitionName='-fade'
        className=@classes.months>

        <div className=@classes.month
          key="month-#{monthIndex}"
          children={@renderDates()} />

      </ReactCSSTransitionGroup>

    </fieldset>
