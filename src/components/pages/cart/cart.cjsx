# Active Experiments
# photoCopy

[
  _
  React

  LayoutDefault

  CartWrapper

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/cart/cart_wrapper/cart_wrapper'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-cart'

  CONTENT_PATH: '/cart'

  mixins: [
    Mixins.analytics
    Mixins.context
    Mixins.dispatcher
  ]

  statics:
    route: ->
      visibleBeforeMount: true
      handler: 'Cart'
      path: '/cart'
      title: 'Cart'
      asyncPrefetch: [
        '/eyeglasses/.*'
        '/sunglasses/.*'
      ]

  receiveStoreChanges: -> [
    'applePay'
    'cart'
  ]

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  manageFillHomeTryOn: ->
    @commandDispatcher 'cart', 'fillHomeTryOn'

  manageRemoveItem: (item) ->
    @trackInteraction "cart-remove-#{item.product_id}"
    @commandDispatcher 'cart', 'removeItem', item

  render: ->
    <LayoutDefault {...@props}>
      <CartWrapper {...@props}
        applePay=@getStore('applePay')
        cms={@getContentVariation @CONTENT_PATH}
        cart=@getStore('cart')
        manageRemoveItem=@manageRemoveItem
        manageFillHomeTryOn=@manageFillHomeTryOn
        photoVariant={@getExperimentVariant('photoCopy')} />
    </LayoutDefault>
