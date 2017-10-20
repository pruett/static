[
  _
  React

  LayoutCheckout

  CheckoutLogin

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_checkout/layout_checkout'

  require 'components/organisms/forms/checkout/checkout_login/checkout_login'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  statics:
    route: ->
      path: '/checkout'
      handler: 'CheckoutIndex'
      bundle: 'pre-checkout'
      title: 'Checkout'
      asyncPrefetch: [
        '/cart'
      ]

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  render: ->
    <LayoutCheckout {...@props} showProgress=false />

  componentDidMount: ->
    @commandDispatcher 'cart', 'createEstimate'
