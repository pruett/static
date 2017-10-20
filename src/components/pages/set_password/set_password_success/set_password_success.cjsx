[
  React

  LayoutDefault

  ModalAlert

  Mixins
] = [
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/modals/modal_alert/modal_alert'

  require 'components/mixins/mixins'

  require '../set_password.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-set-password'

  mixins: [
    Mixins.context
  ]

  statics:
    route: ->
      path: '/account/set-password/success'
      handler: 'Default'
      bundle: 'session'
      title: 'Set Password'

  render: ->
    <LayoutDefault {...@props}>
      <ModalAlert {...@props}
        txtHeading='Your account has been created.'
        txtConfirm='Log in now'
        routeConfirm='/login'>
      </ModalAlert>
    </LayoutDefault>
