[
  _
  React

  LayoutCheckout

  PrescriptionForm

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_checkout/layout_checkout'

  require 'components/organisms/forms/checkout/step/prescription_form/prescription_form'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  statics:
    route: ->
      path: '/checkout/step/prescription'
      handler: 'Checkout'
      bundle: 'checkout'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  receiveStoreChanges: -> [
    'checkout'
    'estimate'
  ]

  render: ->
    estimate = @getStore 'estimate'
    checkout = @getStore 'checkout'

    prescriptions = _.get checkout, 'account.prescriptions', []
    sortPrescriptions = _.orderBy prescriptions, 'expiration_date' , 'desc'

    savedPrescriptions = _.map sortPrescriptions, (prescription) ->
      dateExpiration = new Date prescription.expiration_date
      prescription.expired = dateExpiration.getTime() < Date.now()
      prescription

    <LayoutCheckout {...@props}
      checkoutSteps=estimate.steps
      checkoutNotification=checkout.notification>

      {if estimate.__fetched
        <PrescriptionForm
          {...@props}
          {...estimate}
          savedPrescriptions=savedPrescriptions
          hidePrescriptions={savedPrescriptions.splice(2)}
          showPrescriptions={savedPrescriptions} />}
    </LayoutCheckout>
