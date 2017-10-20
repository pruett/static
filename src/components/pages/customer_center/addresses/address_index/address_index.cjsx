[
  _
  React

  LayoutDefault

  Breadcrumbs
  Container
  EditableAddress
  CTA
  IconAdd

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/organisms/customer_center/container/container'
  require 'components/molecules/editable_address/editable_address'
  require 'components/atoms/buttons/cta/cta'
  require 'components/quanta/icons/add/add'

  require 'components/mixins/mixins'

  require './address_index.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-address-index'

  statics:
    route: ->
      path: '/account/addresses'
      handler: 'AccountAddresses'
      bundle: 'customer-center'
      title: 'Addresses'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  receiveStoreChanges: -> [
    'account'
  ]

  render: ->
    account = @getStore('account')
    return false unless account.__fetched

    breadcrumbs = [
      { text: 'Account', href: '/account' }
      { text: 'Addresses' }
    ]

    <LayoutDefault {...@props}>
      <Breadcrumbs links=breadcrumbs />
      <Container {...@props} heading='Addresses'>
        <div className="#{@BLOCK_CLASS}">
          <CTA
            analyticsSlug='customerCenter-add-address'
            tagName='a'
            cssModifier='-cta-small -cta-left u-ffss u-fs14 u-fws'
            href="/account/addresses/new">
            <IconAdd cssUtility='u-icon u-fill--dark-gray -icon-margin-right' />
            Add new address
          </CTA>

          <hr className="#{@BLOCK_CLASS}__hr u-hr -three -dark" />

          <div className="#{@BLOCK_CLASS}__list">
            {_.map account.addresses, (address, index) =>
              <EditableAddress {...@props}
                address=address
                key=index
                cssVariation="#{@BLOCK_CLASS}__item" />
            }
          </div>
        </div>
      </Container>
    </LayoutDefault>
