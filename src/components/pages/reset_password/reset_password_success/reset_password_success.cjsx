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

  require '../reset_password.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-reset-password'

  mixins: [
    Mixins.context
  ]

  statics:
    route: ->
      path: '/account/reset-password/success'
      handler: 'Default'
      bundle: 'session'
      title: 'Reset Password'

  render: ->
    <LayoutDefault {...@props}>
      <ModalAlert {...@props}
        txtHeading='Your password was changed.'
        txtConfirm='Log in now'
        routeConfirm='/login'>
      </ModalAlert>
    </LayoutDefault>
