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
  BLOCK_CLASS: 'c-customer-center-address-edit'

  statics:
    route: ->
      path: '/account/addresses/{address_id}/edit'
      handler: 'AccountAddresses'
      bundle: 'customer-center'
      title: 'Edit Address'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  receiveStoreChanges: -> [
    'account'
  ]

  manageSubmit: (state) ->
    @commandDispatcher 'account', 'saveAddress', state

  render: ->
    account = @getStore('account')
    addressErrors = account.addressErrors or {}

    if account.__fetched
      addressId = parseInt(@getRouteParams().address_id)
      address = @findObjectOr404 account.addresses, id: addressId
      addressForm = <AddressForm {...@props}
        restrictToLocale=false
        className="#{@BLOCK_CLASS}"
        manageSubmit=@manageSubmit
        address=address
        addressErrors=addressErrors />
    else
      addressForm = null

    breadcrumbs = [
      { text: 'Account', href: '/account' }
      { text: 'Addresses', href: '/account/addresses' }
      { text: "Edit"}
    ]

    <LayoutDefault {...@props}>
      <Breadcrumbs links=breadcrumbs />
      <Container {...@props} heading='Edit address' cssModifier='-form-large'>
        {addressForm}
      </Container>
    </LayoutDefault>
