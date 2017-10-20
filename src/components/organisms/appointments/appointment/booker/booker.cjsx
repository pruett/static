[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './booker.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-appointment-booker'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-fieldset-reset
      u-tac
      u-grid__row"
    legend:
      'u-fs20 u-fs30--600 u-fs34--1200
      u-fws
      u-ffs
      u-mb30'
    label:
      'u-ttc u-w100p'
    input:
      "#{@BLOCK_CLASS}__input
      u-hide--visual"
    labelText:
      "#{@BLOCK_CLASS}__label-text
      u-cursor--pointer
      u-button u-button-reset -button-blue u-fs16 u-fws u-ffss u-tac
      u-pt6 u-pb6
      "

  handleClick: (evt) ->
    if _.isFunction @props.manageSetCustomerIsBooking
      @props.manageSetCustomerIsBooking evt.target.value is 'yep'
    @trackInteraction "appointments-click-customerIsBooking-#{_.camelCase evt.target.value}", evt

  renderOption: (value, i) ->
    <label className=@classes.label key=i>
      <input className=@classes.input
        name='booker'
        onClick=@handleClick
        type='radio'
        value=value />

      <span children=value
        className=@classes.labelText
        variation='default' />
    </label>

  render: ->
    @classes = @getClasses()

    <fieldset className=@classes.block>
      <legend children='Is this appointment for you?'
        className=@classes.legend />

      <div className='u-df u-mb12 u-ma' style={{maxWidth: '500px'}}>
        {['yep', 'nope'].map @renderOption}
      </div>
    </fieldset>
