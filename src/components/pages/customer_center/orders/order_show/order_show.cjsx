[
  _
  React

  LayoutDefault

  Breadcrumbs
  Container
  LineItem
  Markdown
  ShippingPaymentSection
  OrderDetailsSection
  OrderIssue
  TitleBlock
  ReturnExchangeNotice

  AtTheLab
  Received
  Shipped
  StorePickup
  StylizedArrow

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/organisms/customer_center/container/container'
  require 'components/molecules/line_item/line_item'
  require 'components/molecules/markdown/markdown'
  require 'components/molecules/templates/customer_center/orders/shipping_payment_section/shipping_payment_section'
  require 'components/molecules/templates/customer_center/orders/details_section/details_section'
  require 'components/molecules/templates/customer_center/orders/order_issue/order_issue'
  require 'components/atoms/title_block/title_block'
  require 'components/atoms/templates/customer_center/orders/return_exchange_notice/return_exchange_notice'

  require 'components/atoms/icons/customer_center/at_the_lab/at_the_lab'
  require 'components/atoms/icons/customer_center/received/received'
  require 'components/atoms/icons/customer_center/shipped/shipped'
  require 'components/atoms/icons/customer_center/store_pickup/store_pickup'
  require 'components/quanta/icons/stylized_arrow/stylized_arrow'

  require 'components/mixins/mixins'

  require '../orders.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-order-show'

  statics:
    route: ->
      path: '/account/orders/{order_id}'
      handler: 'AccountOrders'
      bundle: 'customer-center'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.conversion
    Mixins.dispatcher
    Mixins.routing
  ]

  getStaticClasses: ->
    block: @BLOCK_CLASS
    order_details:
      "#{@BLOCK_CLASS}__order-details"
    cta:
      "#{@BLOCK_CLASS}__cta
        u-reset u-fs16"
    dotted:
      "#{@BLOCK_CLASS}__dotted"
    order_date:
      "#{@BLOCK_CLASS}__order-date
       u-reset u-ffs"
    orderNum:
      "#{@BLOCK_CLASS}__order-num
       u-color--dark-gray-alt-2"
    productImages:
      "#{@BLOCK_CLASS}__product-images"
    lineItem:
      'u-w10c u-w6c--600 u-db u-m0a'
    icons:
      'u-db u-mla u-mra u-p0 u-pb3 u-mb12 u-tac'
    statusIcon:
      "#{@BLOCK_CLASS}__status-icon u-dib u-vam"
    arrowIcon:
      "#{@BLOCK_CLASS}__arrow-icon u-dib u-vam"
    arrow:
      'u-icon u-db u-fill--dark-gray'
    statusHeadline:
      'u-fs30 u-fs40--600 u-ffs u-fws'
    statusMessage:
      'u-ma u-mbn6 u-mb18--600 u-mt12
       u-mw600 u-fs16 u-ffss'
    received:
      'u-vatt u-db'
    atTheLab:
      'u-vatt u-db'
    shipped:
      'u-vatt u-db'

  classesWillUpdate: ->
    icon = _.get @getStore('account'), 'order.status.icon'

    received:
      'u-fill--blue': icon is 'received'
      'u-fill--dark-gray': icon isnt 'received'
    atTheLab:
      'u-fill--blue': icon is 'at-the-lab'
      'u-fill--dark-gray': icon isnt 'at-the-lab'
    shipped:
      'u-fill--blue': icon is 'shipped'
      'u-fill--dark-gray': icon isnt 'shipped'
    statusHeadline:
      'u-mt54': not icon

  receiveStoreChanges: -> [
    'account'
    'navigation'
  ]

  renderLineItem: (classes, item, index) ->
    <LineItem
      item=item
      multiColumn=false
      key=index
      imgSizes='(min-width: 500px) 500px, 100vw'
      cssModifier=classes.lineItem
      variation="customer-center" />

  renderTrackingNumber: (shipment, i, list) -> [
    <a href=shipment.narvar_url
       key="track_#{i}"
       onClick={@clickInteraction.bind(@, shipment.tracking_num)}
       children=shipment.tracking_num />
    if i < list.length - 1
      <span key="amp_#{i}">&nbsp;&amp;&nbsp;</span>
  ]

  getBreadcrumbLinks: (id) -> [
    {
      text: 'Account'
      href: '/account'
    },
    {
      text: 'Orders'
      href: '/account/orders'
    },
    {
      text: "no. #{id or ''}"
    }
  ]

  filterNonFaqLinks: (link) ->
    _.get(link, 'title', '').toLowerCase() isnt 'faq'

  getHelpData: (navigation) ->
    # Remove FAQ links from footer links to show.
    helpLinks = _.get navigation, 'help.links', []
    help:
      links: _.filter(helpLinks, @filterNonFaqLinks)

  renderOrderStatus: (order, navigation, classes) ->
    # TODO: Move into organism w/ CSS & clean-up logic.

    isHto = _.get(order, 'line_items[0].option_type') is 'hto'

    utc = @convert 'date', 'object', order.placed
    daysSince = @convert 'date', 'days-since', order.placed

    txtTitle = "Ordered on #{utc.month?.substr 0, 3} #{utc.date}, #{utc.year}"
    txtTitle += ' — Home Try-On' if isHto

    <div className=classes.block>
      <div className=classes.order_details>
        {if order.order_issue
          <OrderIssue order=order help_data=@getHelpData(navigation) />
        else [
          <div key='cta' className=classes.cta>
            {if _.get order, 'status.icon'
              <ul className=classes.icons>
                <li className=classes.statusIcon>
                  <Received cssUtility=classes.received />
                </li>
                <li className=classes.arrowIcon>
                  <StylizedArrow cssUtility=classes.arrow />
                </li>
                {if _.some(order.item_types, (type) -> type in ['rx', 'sun_rx']) then [
                  <li className=classes.statusIcon>
                    <AtTheLab cssUtility=classes.atTheLab />
                  </li>
                  <li className=classes.arrowIcon>
                    <StylizedArrow cssUtility=classes.arrow />
                  </li>
                ]}
                <li className=classes.statusIcon>
                  {if order.facility_id
                    <StorePickup cssUtility=classes.shipped />
                  else
                    <Shipped cssUtility=classes.shipped />
                  }
                </li>
              </ul>
            }

            {if order.status
              [
                <div key='headline' className=classes.statusHeadline children=order.status.headline />
                <Markdown key='message'
                  className=classes.statusMessage
                  rawMarkdown=order.status.message />
                if order.status.icon is 'shipped'
                  valid_tracking_numbers = _.filter(order.shipments, (shipment) -> shipment?.narvar_url?)
                  if valid_tracking_numbers.length > 0
                    <div key='tracking' className=classes.statusMessage>
                      Track your order: {
                        _.map(valid_tracking_numbers, @renderTrackingNumber)
                      }
                    </div>
              ]
            }
          </div>
          <hr key='dotted' className=classes.dotted />
        ]}

        <div className=classes.order_date children=txtTitle />
        <div className=classes.orderNum children="Order no. #{order.id}" />

        <div className=classes.productImages>
          {_.map order.line_items, @renderLineItem.bind(@, classes)}
        </div>

        {<ReturnExchangeNotice /> if daysSince < 30 and not isHto}

        <ShippingPaymentSection order=order isHto=isHto />
      </div>
    </div>

  render: ->
    classes = @getClasses()
    account = @getStore 'account'
    navigation = @getStore 'navigation'

    orderId = parseInt(@getRouteParams().order_id, 10)

    if account.__fetched
      # Pick order from accounts by URL param.
      order = @findObjectOr404(account.orders, id: orderId)
    else
      order = {}

    <LayoutDefault {...@props}>

      <Breadcrumbs links={@getBreadcrumbLinks(orderId)} />

      {@renderOrderStatus(order, navigation, classes) unless _.isEmpty order}

    </LayoutDefault>
