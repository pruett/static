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
      path: '/checkout/login'
      handler: 'CheckoutLogin'
      bundle: 'checkout-login'
      title: 'Checkout Login'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  propTypes:
    routeLoggedIn: React.PropTypes.string

  getDefaultProps: ->
    routeLoggedIn: '/checkout/step/information'

  receiveStoreChanges: -> [
    'session'
    'estimate'
  ]

  manageLoginSubmit: (attrs) ->
    @commandDispatcher 'session', 'login', attrs,
      routeSuccess: '/checkout/step/information'
      loginType: 'checkout'

  render: ->
    session = @getStore('session') or {}
    estimate = @getStore('estimate') or {}

    <LayoutCheckout {...@props}
      showProgress=false
      cssModifier='-layout-wide'
      cssMainModifier=''>
      <CheckoutLogin
        {...@props}
        loginErrors=session.loginErrors
        manageLoginSubmit=@manageLoginSubmit
        showTnc=estimate.is_hto_only />
    </LayoutCheckout>
