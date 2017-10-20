[
  _
  React

  LayoutCheckout

  ForgotPassword

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_checkout/layout_checkout'

  require 'components/organisms/forgot_password/forgot_password_form/forgot_password_form'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  statics:
    route: ->
      path: '/checkout/forgot-password'
      handler: 'Default'
      bundle: 'checkout-login'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  receiveStoreChanges: -> [
    'password'
  ]

  manageSubmit: (email) ->
    @commandDispatcher 'password', 'forgotPassword',
      { email: email }
      '/checkout/forgot-password/success'

  render: ->
    errors = @getStore('password').forgotPasswordErrors

    <LayoutCheckout {...@props} showProgress=false>

      <ForgotPassword
        {...@props}
        manageSubmit=@manageSubmit
        errors=errors />

    </LayoutCheckout>
