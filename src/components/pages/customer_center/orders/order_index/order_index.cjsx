[
  _
  React

  LayoutDefault

  Alert
  BannerCTA
  Breadcrumbs
  Container
  Row

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/quanta/icons/alert/alert'
  require 'components/molecules/banner_with_cta/banner_with_cta'
  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/organisms/customer_center/container/container'
  require 'components/atoms/buttons/row/row'

  require 'components/mixins/mixins'

  require '../orders.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-order-index'

  statics:
    route: ->
      visibleBeforeMount: true
      path: '/account/orders'
      handler: 'AccountOrders'
      bundle: 'customer-center'
      title: 'Orders'

  mixins: [
    Mixins.classes
    Mixins.context
    Mixins.conversion
    Mixins.dispatcher
  ]

  propTypes:
    orders: React.PropTypes.arrayOf React.PropTypes.object
    counts: React.PropTypes.arrayOf React.PropTypes.object

  receiveStoreChanges: -> [
    'account'
  ]

  getDefaultProps: ->
    currentPage: 1

  getStaticClasses: ->
    block: @BLOCK_CLASS
    columns:
      "#{@BLOCK_CLASS}__columns
      grid"
    column_content:
      "#{@BLOCK_CLASS}__column-content
      grid__cell unit-4-12--tablet"
    date:
      "#{@BLOCK_CLASS}__date
      u-reset u-ffs"
    order_num:
      "#{@BLOCK_CLASS}__order-num
      u-reset u-color--dark-gray-alt-2"
    order_status:
      "#{@BLOCK_CLASS}__order-status"
    line_item:
      "#{@BLOCK_CLASS}__line-item"
    alert:
      "#{@BLOCK_CLASS}__alert"
    issues:
      "#{@BLOCK_CLASS}__issues"
    cta:
      "#{@BLOCK_CLASS}__cta"
    dotted:
      "#{@BLOCK_CLASS}__dotted"
    header:
      "#{@BLOCK_CLASS}__header
      u-reset u-ffs u-fs40 u-fws"
    orders:
      "#{@BLOCK_CLASS}__orders
      u-mln6 u-mrn6"

  renderIssue: (issue, i) ->
    <BannerCTA {...issue} key=i showEyeExamLink=true />

  renderOrderRow: (order) ->
    placed = @convert 'date', 'object', order.placed

    line_item = _.first order.line_items

    body = <div className=@classes.columns>
      <div className=@classes.column_content>
        <div className=@classes.date>{placed.month} {placed.date}, {placed.year}</div>
        <div className=@classes.order_num>Order no. {order.id}</div>
      </div>
      <div className=@classes.column_content>
        {if line_item?.option_type is 'hto'
          <span className="u-reset u-fws">
            Home Try-On
          </span>
        else if line_item?.option_type is 'giftcard'
          <span className="u-reset u-fws">
            ${line_item?.amount_cents/100} Gift Card
          </span>
        else
          [
            <span className='u-reset u-ttc u-fws'>{line_item?.display_name}</span>
            if line_item?.category is 'frame'
              [
                <span className='u-reset u-fws' key='in'> in </span>
                <span className='u-reset u-ttc u-fws' key='color'>
                  {line_item?.color}
                </span>
              ]
          ]
        }
      </div>
      <div className=@classes.column_content>
        {if order.order_issue?
            <div className="#{@classes.order_status} -notice">
                We need some more info!
            </div>
        else
            <span className=@classes.order_status children=order.status.headline />
        }
      </div>
    </div>

    <Row
      route="/account/orders/#{order.id}"
      key=order.id
      children=body />

  render: ->
    @classes = @getClasses()
    account = @getStore('account')
    orders = account.orders or []
    ordersCount = account.counts?.orders or 0

    breadcrumbs = [
      { 'text': 'Account', 'href': '/account' },
      { 'text': 'Orders' }
    ]

    firstName = account.customer?.first_name or 'Hey'

    <LayoutDefault {...@props}>

      <Breadcrumbs links=breadcrumbs />

      <div className=@classes.block>

        {if false and account.issues.length > 0 then [
          <section className=@classes.issues>
            <div className=@classes.cta>
              {firstName}, we need your help!
            </div>
            {_.map account.issues, @renderIssue}
          </section>
          <hr className=@classes.dotted />
        ]}

        <div className=@classes.header>
          Orders
        </div>

        {if account.__fetched
          <div className=@classes.orders>
            {_.map orders, @renderOrderRow}
          </div>}

      </div>

    </LayoutDefault>
