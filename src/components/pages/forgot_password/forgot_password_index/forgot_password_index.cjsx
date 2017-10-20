[
  _
  React

  LayoutDefault

  ForgotPassword

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/forgot_password/forgot_password_form/forgot_password_form'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  statics:
    route: ->
      path: '/account/forgot-password'
      handler: 'Default'
      bundle: 'session'
      title: 'Forgot Password'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  receiveStoreChanges: -> [
    'password'
    'session'
  ]

  manageSubmit: (email) ->
    @commandDispatcher 'password', 'forgotPassword',
      email: email

  render: ->
    errors = @getStore('password').forgotPasswordErrors

    <LayoutDefault {...@props}>

      <ForgotPassword
        {...@props}
        initialEmail=@getStore('session').initialEmail
        cssModifier='-margin'
        manageSubmit=@manageSubmit
        errors=errors />

    </LayoutDefault>
