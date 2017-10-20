[
  _
  React

  ClearInput

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/forms/actions/clear_input/clear_input'

  require 'components/mixins/mixins'

  require './actions.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-formgroup-actions'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    handleClickClear: React.PropTypes.func
    handleClickButton: React.PropTypes.func
    isFocused: React.PropTypes.bool
    cssModifier: React.PropTypes.string
    txtButton: React.PropTypes.string

  getDefaultProps: ->
    handleClickButton: ->
    isFocused: false
    cssModifier: ''

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}"
    clear:
      "#{@BLOCK_CLASS}__clear-input"
    button: "
      #{@BLOCK_CLASS}__button
      u-button -button-medium -button-small -button-gray
      u-reset u-fs14 u-fws"

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      {if _.isFunction @props.handleClickClear
        <ClearInput
          key='clear'
          cssModifier=classes.clear
          onClick=@props.handleClickClear />}

      {if @props.txtButton
        <button
          type='button'
          key='button'
          onClick=@props.handleClickButton
          children=@props.txtButton
          tabIndex=-1
          className=classes.button />}
    </div>
