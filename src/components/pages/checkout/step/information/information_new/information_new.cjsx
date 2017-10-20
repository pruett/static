[
  _
  React

  LayoutCheckout

  InformationForm

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_checkout/layout_checkout'

  require 'components/organisms/forms/checkout/step/information_form/information_form'

  require 'components/mixins/mixins'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  statics:
    route: ->
      path: '/checkout/step/information'
      handler: 'Checkout'
      bundle: 'checkout'
      asyncPrefetch: [
        '/cart'
        '/checkout'
      ]

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  receiveStoreChanges: -> [
    'checkout'
    'estimate'
  ]

  render: ->
    checkout = @getStore 'checkout'
    estimate = @getStore 'estimate'

    if estimate.__fetched and estimate.is_sun_only and not estimate.has_rx
      @commandDispatcher 'experiments', 'bucket', 'onePageNonRxSunCheckout'
      if @inExperiment 'onePageNonRxSunCheckout', 'one_page'
        onePageCheckout = true

    onePageCheckout or= estimate.is_hto_only

    <LayoutCheckout {...@props}
      showNotification=true
      showProgress={not onePageCheckout}
      forceFooter=true
      checkoutSteps=estimate.steps
      checkoutNotification=checkout.notification>

      {if estimate.__fetched and checkout.__fetched
        <InformationForm
          {...@props}
          {...estimate}
          savedAddresses=checkout.account.addresses
          savedPayments=checkout.account.payments
          skipReview=onePageCheckout />}
    </LayoutCheckout>
