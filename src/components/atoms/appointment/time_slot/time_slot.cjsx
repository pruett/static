[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './time_slot.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-appointment-time-slot'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  propTypes:
    cssModifier: React.PropTypes.string
    formattedTime: React.PropTypes.string
    manageSetTimeSlot: React.PropTypes.func
    timestamp: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-pr
      u-cursor--pointer"
    input:
      "#{@BLOCK_CLASS}__input
      u-hide--visual"
    time:
      "#{@BLOCK_CLASS}__time
      u-pr
      u-tac
      u-fws u-fs16 u-color--dark-gray
      u-db
      u-bw1 u-bss u-color-bg--white"

  handleClick: (evt) ->
    if _.isFunction @props.manageSetTimeSlot
      @props.manageSetTimeSlot evt.target.value
    @trackInteraction 'appointments-set-timeSlot', evt

  render: ->
    classes = @getClasses()

    <label className=classes.block>
      <input className=classes.input
        onClick=@handleClick
        name='slot'
        type='radio'
        value=@props.timestamp />

      <span className=classes.time
        children=@props.formattedTime />
    </label>
