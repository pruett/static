React = require 'react/addons'

QuantitySelect = require 'components/atoms/products/quantity_control/select/select'

Mixins = require 'components/mixins/mixins'

require './add_to_cart.scss'


module.exports = React.createClass
  BLOCK_CLASS: 'c-product-add-to-cart'

  mixins: [Mixins.classes]

  propTypes:
    addToCart: React.PropTypes.func
    changeQuantity: React.PropTypes.func
    inStock: React.PropTypes.bool
    selectedQuantity: React.PropTypes.number

  getStaticClasses: ->
    quantitySelect:
      "#{@BLOCK_CLASS}__quantity-select
      u-dib
      u-vat
      u-w3c
      u-pr
      u-pr6"
    buttonContainer:
      "#{@BLOCK_CLASS}__button-container
      u-dib
      u-vat
      u-pl6
      u-w9c"
    button:
      "#{@BLOCK_CLASS}__button
      u-button -button-blue
      u-fs16 u-fwb
      u-h60
      u-pr24 u-pl24"

  render: ->
    classes = @getClasses()

    {inStock} = @props

    <div>
      <QuantitySelect
        changeQuantity=@props.changeQuantity
        cssModifier=classes.quantitySelect
        selectedQuantity=@props.selectedQuantity />

      <div className=classes.buttonContainer>
        <button
          children={if inStock then 'Add to cart' else 'Out of stock'}
          className=classes.button
          disabled={not inStock}
          onClick=@props.addToCart
          type='button' />
      </div>
    </div>
