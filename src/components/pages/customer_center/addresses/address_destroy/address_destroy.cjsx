[
  React

  LayoutDefault

  AddressDestroyModal

  Mixins
] = [
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/molecules/addresses/address_destroy_modal/address_destroy_modal'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  statics:
    route: ->
      path: '/account/addresses/{address_id}/delete'
      handler: 'AccountAddresses'
      bundle: 'customer-center'
      title: 'Delete Address'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  receiveStoreChanges: -> [
    'account'
  ]

  handleClickDelete: (address) ->
    @commandDispatcher 'account', 'destroyAddress', address

  render: ->
    account = @getStore('account')

    if account.__fetched
      addressId = parseInt(@getRouteParams().address_id)
      address = @findObjectOr404 account.addresses, id: addressId

    <LayoutDefault {...@props}>
      {if account.__fetched
        <AddressDestroyModal {...@props}
          handleClickDelete=@handleClickDelete
          address=address
          routeCancel='/account/addresses' />}
    </LayoutDefault>
