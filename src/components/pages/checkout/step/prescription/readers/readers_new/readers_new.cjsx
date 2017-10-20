[
  React

  LayoutCheckout

  ReadersForm

  Mixins
] = [
  require 'react/addons'

  require 'components/layouts/layout_checkout/layout_checkout'

  require 'components/organisms/forms/readers_form/readers_form'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  statics:
    route: ->
      path: '/checkout/step/prescription/readers'
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
      showProgress=false
      showLogo=false
      previousRoute='/checkout/step/prescription'
      backLinkText='Back to prescription options'>

      {if estimate.__fetched
        <ReadersForm
          {...@props}
          {...estimate} />}
    </LayoutCheckout>
