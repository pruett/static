[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './date.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-appointment-date'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  propTypes:
    appointment: React.PropTypes.shape
      day_of_week: React.PropTypes.string
      day_of_month: React.PropTypes.string
    cssModifier: React.PropTypes.string
    isActive: React.PropTypes.bool
    isPast: React.PropTypes.bool
    isToday: React.PropTypes.bool
    manageSetDate: React.PropTypes.func

  getDefaultProps: ->
    cssModifier: ''

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-pr
      u-tac
      u-pt12 u-pb12
      u-color-bg--white
      u-cursor--pointer"
    input:
      "#{@BLOCK_CLASS}__input
      u-hide--visual"
    background:
      "#{@BLOCK_CLASS}__background
      u-size--fill
      u-pa
      u-bw1 u-bss
      u-bc--light-gray"
    day:
      "#{@BLOCK_CLASS}__day
      u-reset u-fs14 u-mt8 u-mb8
      u-db u-fws"
    date:
      "#{@BLOCK_CLASS}__date
      u-reset u-fs40 u-mb8
      u-fws
      u-db"
    slots:
      "#{@BLOCK_CLASS}__slots
      u-reset u-fs14 u-color--dark-gray-alt-3
      u-db u-fsi u-ffs"

  classesWillUpdate: ->
    # Use `u-dn` to hide past date components, and `-past` for styling the first
    # date that hasn't passed via sibling selector.
    block:
      'u-dn -past': @props.isPast

  getDayOfWeek: (dayOfWeek) ->
    if @props.isToday
      'Today'
    else
      dayOfWeek.substr 0, 3

  handleChange: (evt) ->
    if _.isFunction @props.manageSetDate
      @props.manageSetDate evt.target.value
    @trackInteraction 'appointments-set-date', evt

  render: ->
    {date, day_of_week, day_of_month, slots} = @props.appointment

    classes = @getClasses()

    inputId = "date-#{date}"
    inputProps =
      className: classes.input
      id: inputId
      name: 'date'
      onChange: @handleChange
      type: 'radio'
      value: date

    if @props.isActive
      _.assign inputProps, checked: true

    if slots.length is 0
      _.assign inputProps, disabled: true

    <label className=classes.block htmlFor=inputId>
      <input {...inputProps} />
      <span className=classes.background />
      <span children=@getDayOfWeek(day_of_week)
        className=classes.day />
      <span children=day_of_month
        className=classes.date />
      <span children="#{slots.length} available"
        className=classes.slots />
    </label>
