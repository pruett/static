[
  _
  React

  LayoutDefault

  OrderConfirmation

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/order_confirmation/order_confirmation'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  CONFIRMATION_PATH: '/checkout/confirmation'

  statics:
    route: ->
      path: '/checkout/confirmation'
      handler: 'CheckoutConfirmation'
      bundle: 'checkout'
      title: 'Thank you!'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  fetchVariations: -> [
    @CONFIRMATION_PATH
  ]

  receiveStoreChanges: -> [
    'postCheckout'
    'social'
  ]

  getOrderLeadTimeCategory: (postCheckout = {}) ->
    postCheckout.orderLeadTimeCategory

  showRxUpload: (postCheckout = {}) ->
    postCheckout.showRxUpload or false

  render: ->
    postCheckout = @getStore 'postCheckout'

    <LayoutDefault {...@props} cssModifier='-full-page -push-footer'>
      {if postCheckout.__fetched then (
        <OrderConfirmation orders=postCheckout.orders />
        )}
    </LayoutDefault>
