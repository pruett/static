[
  _
  React

  LayoutDefault

  Confirm
  ModalAlert

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/molecules/modals/confirm/confirm'
  require 'components/organisms/modals/modal_alert/modal_alert'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-forgot-password-success'

  statics:
    route: ->
      path: '/checkout/forgot-password/success'
      handler: 'Default'
      bundle: 'checkout-login'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  receiveStoreChanges: -> [
    'password'
  ]

  render: ->
    email = @getStore('password').email
    message = "Password reset instructions sent"
    message = "#{message} to #{email}" if email

    <LayoutDefault {...@props}>

      <ModalAlert {...@props}
        txtHeading="#{message}."
        txtConfirm='Back to checkout'
        routeConfirm='/checkout/login'>
      </ModalAlert>

    </LayoutDefault>
