[
  React

  LayoutCheckout

  LensTypeForm

  Mixins
] = [
  require 'react/addons'

  require 'components/layouts/layout_checkout/layout_checkout'

  require 'components/organisms/forms/lens_type_form/lens_type_form'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  statics:
    route: ->
      path: '/checkout/step/prescription/lens'
      handler: 'Checkout'
      bundle: 'checkout'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  receiveStoreChanges: -> [
    'estimate'
  ]

  render: ->
    estimate = @getStore 'estimate'

    <LayoutCheckout {...@props}
      checkoutSteps=estimate.steps>

      {if estimate.__fetched
        <LensTypeForm
          {...@props}
          {...estimate} />}
    </LayoutCheckout>
