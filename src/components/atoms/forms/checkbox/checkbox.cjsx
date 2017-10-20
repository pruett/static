[
  _
  React

  IconCheckmark
  FilterSwatch

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/checkmark/checkmark'
  require 'components/quanta/icons/filter_swatch/filter_swatch'

  require 'components/mixins/mixins'

  require './checkbox.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-checkbox'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    disabled: React.PropTypes.bool
    readOnly: React.PropTypes.bool
    colorSwatch: React.PropTypes.bool
    txtLabel: React.PropTypes.node
    name: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    disabled: false
    readOnly: false
    colorSwatch: false
    isToggle: false
    txtLabel: ''
    name: 'checkbox'
    cssModifier: ''
    cssModifierInput: ''

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
    "
    input: "
      #{@BLOCK_CLASS}__input
      #{@props.cssModifierInput}
    "
    swatch: "
      #{@BLOCK_CLASS}__swatch
    "
    swatch_text: "
      #{@BLOCK_CLASS}__swatch-text
    "
    icon: "
      #{@BLOCK_CLASS}__icon
      #{@props.cssModifierInput}
    "
    toggle: "
      #{@BLOCK_CLASS}__toggle
      u-db u-pa u-l0
      u-center-y
    "

  classesWillUpdate: ->
    block:
      '-toggle': @props.isToggle
      '-disabled': @props.disabled

  handleChange: (evt) ->
    @commandDispatcher 'analytics', 'pushFormEvent', evt
    @props.checkedLink.requestChange(evt.target.checked) if @props.checkedLink?
    @props.onChange(evt) if _.isFunction(@props.onChange)

  render: ->
    defaultChecked = if @props.checkedLink?
        @props.checkedLink.value
      else
        @props.defaultChecked

    props = _.assign _.omit(@props, 'onChange', 'checkedLink'),
      onChange: @handleChange
      defaultChecked: defaultChecked

    classes = @getClasses()

    if @props.colorSwatch
      name = _.upperFirst @props.txtLabel
      Checkbox = <FilterSwatch {...@props} cssModifier=classes.swatch />
      TextLabel = <span className=classes.swatch_text children=name data-name=name />
    else
      Checkbox = if @props.isToggle
        <span className=classes.toggle />
      else
        <IconCheckmark {...@props} cssModifier=classes.icon />
      TextLabel = <span children=@props.txtLabel />

    <label className=classes.block>
      <input
        {...props}
        type='checkbox'
        className=classes.input />
      {Checkbox}
      {TextLabel}
    </label>
