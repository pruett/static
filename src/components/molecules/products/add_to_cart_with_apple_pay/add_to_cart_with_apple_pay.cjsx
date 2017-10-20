_ = require 'lodash'
React = require 'react/addons'

Picture = require 'components/atoms/images/picture/picture'
QuantityButtons = require 'components/atoms/products/quantity_control/buttons/buttons'
QuantitySelect = require 'components/atoms/products/quantity_control/select/select'

Mixins = require 'components/mixins/mixins'

require './add_to_cart_with_apple_pay.scss'


APPLE_PAY_IMAGES =
  mobile:
    mediaQuery: '(min-width: 0)'
    quality: 90
    sizes: '140px'
    url: '//i.warbycdn.com/v/c/assets/apple-pay/image/apple-pay-white-mobile/1/a5f6c1a7b7.jpg'
    widths: [140, 210, 280]
  tablet:
    mediaQuery: '(min-width: 600px)'
    quality: 90
    sizes: '180px'
    url: '//i.warbycdn.com/v/c/assets/apple-pay/image/apple-pay-white-tablet/1/8118c4e495.jpg'
    widths: [180, 270, 360]

module.exports = React.createClass
  BLOCK_CLASS: 'c-product-add-to-cart-with-apple-pay'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  propTypes:
    addToCart: React.PropTypes.func.isRequired
    addToCartWithApplePay: React.PropTypes.func.isRequired
    changeQuantity: React.PropTypes.func.isRequired
    errors: React.PropTypes.object
    selectedQuantity: React.PropTypes.number.isRequired

  getDefaultProps: ->
    errors: {}

  getStaticClasses: ->
    buttonClasses =
      "#{@BLOCK_CLASS}__button
      u-fs16 u-fwb
      u-h60
      u-pr24 u-pl24
      u-bc--black
      u-bw1 u-bss"

    block:
      "#{@BLOCK_CLASS}
      u-m0a"
    quantityButtons:
      "#{@BLOCK_CLASS}__quantity-buttons
      u-dib u-dn--1200
      u-w100p
      u-mb12"
    quantitySelect:
      "#{@BLOCK_CLASS}__quantity-select
      u-dn u-dib--1200
      u-mr12--600
      u-pr"
    buttonContainer:
      "#{@BLOCK_CLASS}__button-container
      u-vat
      u-db u-dib--600
      u-mrn6 u-mln6
      u-w100p--600 u-wauto--1200"
    buttonStandard:
      "#{buttonClasses}
      u-button -button-blue
      u-mr6 u-ml6"
    buttonApplePay:
      "#{buttonClasses} -apple-pay
      u-button -button-white
      u-mr6 u-ml6"
    applePayImg:
      'u-db
      u-ma'
    error:
      'u-reset
      u-color--yellow
      u-fs14 u-fs16--600
      u-mt18
      u-tac
      u-fws'

  render: ->
    classes = @getClasses()

    quantityProps = _.pick @props, 'changeQuantity', 'selectedQuantity'

    <div className=classes.block>
      <QuantityButtons {...quantityProps}
        cssModifier=classes.quantityButtons />

      <QuantitySelect {...quantityProps}
        applePay=true
        cssModifier=classes.quantitySelect />

      <div className=classes.buttonContainer>
        <button children='Add to cart'
          className=classes.buttonStandard
          onClick=@props.addToCart
          type='button' />

        <button className=classes.buttonApplePay
          onClick=@props.addToCartWithApplePay
          type='button'>
          <Picture children={@getPictureChildren({
            sources: [APPLE_PAY_IMAGES.tablet, APPLE_PAY_IMAGES.mobile]
            img:
              alt: 'Buy with Apple Pay'
              className: classes.applePayImg
          })} />
        </button>
      </div>

      {Object.keys(@props.errors).map (key) ->
        error = @props.errors[key]

        <p key=key
          children=error
          className=classes.error />
      , @}
    </div>
