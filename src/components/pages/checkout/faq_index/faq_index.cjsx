[
  _
  React

  LayoutCheckout

  CheckoutFaq

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_checkout/layout_checkout'

  require 'components/organisms/checkout/faq/faq'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  CONTENT_PATH: '/checkout/faq'

  statics:
    route: ->
      path: '/checkout/faq'
      handler: 'CheckoutFAQ'
      bundle: 'checkout'
      title: 'Checkout FAQ'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  receiveStoreChanges: -> [
    'routing'
  ]

  render: ->
    routing = @getStore 'routing'
    previousRoute = _.get routing, 'previous.pathname', '/checkout/step/information'

    <LayoutCheckout {...@props}
      showProgress=false
      showLogo=false
      previousRoute=previousRoute>

      <CheckoutFaq
        {...@props}
        content=@getContentVariation(@CONTENT_PATH) />

    </LayoutCheckout>
