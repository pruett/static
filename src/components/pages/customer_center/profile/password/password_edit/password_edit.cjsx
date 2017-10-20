[
  React

  LayoutDefault

  Breadcrumbs
  Container
  PasswordForm

  Mixins
] = [
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/organisms/customer_center/container/container'
  require 'components/organisms/forms/password_form/password_form'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-password-edit'

  statics:
    route: ->
      path: '/account/profile/password'
      handler: 'AccountProfile'
      bundle: 'customer-center'
      title: 'Change Password'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    React.addons.LinkedStateMixin
  ]

  receiveStoreChanges: -> [
    'account'
  ]

  manageSubmit: (state) ->
    @commandDispatcher 'account', 'savePassword', state

  render: ->
    account = @getStore 'account'
    customer = account.customer or {}
    customerErrors = account.customerErrors or {}

    breadcrumbs = [
      { text: 'Account', href: '/account' }
      { text: 'Profile', href: '/account/profile' }
      { text: 'Password' }
    ]

    <LayoutDefault {...@props}>
      <Breadcrumbs links=breadcrumbs />
      <Container heading='Change your password' cssModifier='-form'>
        {if account.__fetched
          <PasswordForm {...@props}
            manageSubmit=@manageSubmit
            customer=customer
            customerErrors=customerErrors />}
      </Container>
    </LayoutDefault>
