React = require 'react/addons'

Mixins = require 'components/mixins/mixins'

require './buttons.scss'


module.exports = React.createClass
  BLOCK_CLASS: 'c-product-quantity-buttons'

  mixins: [Mixins.classes]

  propTypes:
    changeQuantity: React.PropTypes.func
    cssModifier: React.PropTypes.string
    selectedQuantity: React.PropTypes.number

  getDefaultProps: ->
    changeQuantity: ->
    cssModifier: ''
    selectedQuantity: 1

  getStaticClasses: ->
    sharedClasses =
      'u-dib
      u-w4c
      u-vat'

    iconClasses =
      "#{@BLOCK_CLASS}__icon
      u-sign
      u-pr"

    block:
      @props.cssModifier
    leftButton:
      "#{@BLOCK_CLASS}__button -left-button
      #{sharedClasses}"
    hiddenLabel:
      'u-hide--visual'
    minusIcon:
      "#{iconClasses} -minus"
    output:
      "#{@BLOCK_CLASS}__output
      #{sharedClasses}
      u-fs16
      u-fws
      u-brw0 u-blw0"
    rightButton:
      "#{@BLOCK_CLASS}__button -right-button
      #{sharedClasses}"
    plusIcon:
      "#{iconClasses} -plus"

  handleClickMinus: (evt) ->
    @props.changeQuantity @props.selectedQuantity - 1

  handleClickPlus: (evt) ->
    @props.changeQuantity @props.selectedQuantity + 1

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <button className=classes.leftButton
        disabled={@props.selectedQuantity is 1}
        onClick=@handleClickMinus
        type='button'>
        <span className=classes.hiddenLabel
          children='Subtract 1' />
        <span className=classes.minusIcon />
      </button>

      <output children=@props.selectedQuantity
        className=classes.output />

      <button className=classes.rightButton
        onClick=@handleClickPlus
        type='button'>
        <span className=classes.hiddenLabel
          children='Add 1' />
        <span className=classes.plusIcon />
      </button>
    </div>
