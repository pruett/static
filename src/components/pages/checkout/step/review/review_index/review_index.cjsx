[
  _
  React

  LayoutCheckout

  CheckoutReview

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_checkout/layout_checkout'

  require 'components/organisms/checkout/review/review'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  statics:
    route: ->
      path: '/checkout/step/review'
      handler: 'Checkout'
      bundle: 'checkout'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  receiveStoreChanges: -> [
    'estimate'
    'checkout'
  ]

  render: ->
    estimate = @getStore 'estimate'
    checkout = @getStore 'checkout'

    existingPrescription = _.find _.get(checkout, 'account.prescriptions'),
      id: _.get(estimate, 'prescriptions[0].existing_prescription_id')

    <LayoutCheckout {...@props}
      cssModifier='-layout-wide-v2'
      checkoutSteps=estimate.steps
      checkoutNotification=checkout.notification
      showNotification=true>

      {if estimate.__fetched
        <CheckoutReview
          {...@props}
          {...estimate}
          existingPrescription=existingPrescription />}
      </LayoutCheckout>
