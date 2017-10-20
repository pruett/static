[
  _
  React

  LayoutDefault

  Breadcrumbs
  Container
  ProfileForm

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/organisms/customer_center/container/container'
  require 'components/organisms/forms/profile_form/profile_form'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-profile-edit'

  statics:
    route: ->
      path: '/account/profile'
      handler: 'AccountProfile'
      bundle: 'customer-center'
      title: 'Edit Profile'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    React.addons.LinkedStateMixin
  ]

  receiveStoreChanges: -> [
    'account'
  ]

  manageSubmit: (state) ->
    @commandDispatcher 'account', 'saveCustomer', state

  handleChangeEmail: (email) ->
    @commandDispatcher 'account', 'changeCustomerEmail', email

  render: ->
    account = @getStore 'account'
    customer = account.customer or {}
    customerErrors = account.customerErrors or {}

    breadcrumbs = [
      { text: 'Account', href: '/account' }
      { text: 'Profile' }
    ]

    <LayoutDefault {...@props}>
      <Breadcrumbs links=breadcrumbs />
      <Container heading='Edit your profile' cssModifier='-form'>
        {if account.__fetched
          <ProfileForm {...@props}
            handleChangeEmail=@handleChangeEmail
            manageSubmit=@manageSubmit
            customer=customer
            customerErrors=customerErrors />}
      </Container>
    </LayoutDefault>
