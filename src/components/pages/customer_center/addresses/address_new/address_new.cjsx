[
  _
  React

  LayoutDefault

  Breadcrumbs
  Container
  AddressForm

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/organisms/customer_center/container/container'
  require 'components/organisms/forms/address_form/address_form'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  statics:
    route: ->
      path: '/account/addresses/new'
      handler: 'AccountAddresses'
      bundle: 'customer-center'
      title: 'New Address'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  receiveStoreChanges: -> [
    'account'
  ]

  manageSubmit: (state) ->
    @commandDispatcher 'account', 'saveAddress', state

  render: ->
    account = @getStore 'account'

    if account.__fetched
      address = _.pick account.customer, 'first_name', 'last_name'
    else
      address = {}

    breadcrumbs = [
      { text: 'Account', href: '/account' }
      { text: 'Addresses', href: '/account/addresses' }
      { text: "New"}
    ]

    <LayoutDefault {...@props}>
      <Breadcrumbs links=breadcrumbs />
      <Container {...@props} heading='New address' cssModifier='-form-large'>
        <AddressForm {...@props}
          restrictToLocale=false
          manageSubmit=@manageSubmit
          address=address
          addressErrors=account.addressErrors />
      </Container>
    </LayoutDefault>
