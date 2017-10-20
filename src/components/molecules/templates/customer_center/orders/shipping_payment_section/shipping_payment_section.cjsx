[
  _
  React

  OrderDetailsSection
  ShippingAddressNotice
  Link
  Address
  TotalsTable
  CreditCardIcon
  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/templates/customer_center/orders/details_section/details_section'
  require 'components/atoms/templates/customer_center/orders/shipping_address_notice/shipping_address_notice'
  require 'components/atoms/link/link'
  require 'components/atoms/address/address'
  require 'components/atoms/totals_table/totals_table'
  require 'components/atoms/icons/credit_card/credit_card'
  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-shipping-payments-section'

  mixins: [
    Mixins.classes
    Mixins.conversion
    Mixins.context
    Mixins.dispatcher
  ]

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS} grid"
    address:
      ''
    addressTitle:
      'u-reset u-fs16 u-fws'
    promo:
      "#{@BLOCK_CLASS}__promo u-reset u-fs16 u-fws u-ffs u-fs20"
    halfGrid:
      'grid__cell unit-1-2--tablet'
    orderDetails:
      '-order-details'
    paymentTitle:
      'u-m0 u-fws'
    paymentItem:
      'u-m0'

  classesWillUpdate: ->
    address:
      'grid__cell unit-1-2--tablet': @props.isHto

  render: ->
    classes = @getClasses()

    isRecentlyPlaced = @convert('date', 'days-since', @props.order?.placed) < 12
    isPickup = @props.order.facility_id?
    addressTitle = if isPickup then 'Store address:' else 'Address:'
    address = @props.order?.shipping_address

    <div className=classes.block>
      <OrderDetailsSection sectionType='shipping' isHto=@props.isHto isPickup=isPickup>
        <div className=classes.address>
          <p className=classes.addressTitle children=addressTitle />
          <Address {...address}
            cssModifier=classes.orderDetails />

          {<ShippingAddressNotice /> if isRecentlyPlaced}
        </div>

        {if @props.isHto
          <div className=classes.halfGrid>
            <p className=classes.promo>
              Need help picking the perfect pair?
            </p>
            <p className=classes.promo>
              <Link href='#livechat'>
                Chat with a personal stylist.
              </Link>
            </p>
          </div>}
      </OrderDetailsSection>

      {unless @props.isHto
        <OrderDetailsSection sectionType='payment'>
          <TotalsTable {...@props.order} />

          <div>
            <p className=classes.paymentTitle children='Payment method:' />
            {_.map @props.order?.payments, (payment) ->
              switch payment.type
                when 'cash'
                  'Cash'
                when 'credit_card'
                  <p className=classes.paymentItem key=payment.amount>
                    <CreditCardIcon cardType=payment.cc_type />
                    Ending in <span children="#{payment.cc_last_four}" />
                  </p>
            }
          </div>
        </OrderDetailsSection>}
    </div>
