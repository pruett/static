[
  _
  React

  LayoutDefault

  Alert
  Card
  IntroMessage
  BannerCTA
  CTA
  IconAddresses
  IconBookmarks
  IconFavorites
  IconOrders
  IconPrescriptions
  IconProfile

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/quanta/icons/alert/alert'
  require 'components/molecules/card/card'
  require 'components/molecules/intro_message/intro_message'
  require 'components/molecules/banner_with_cta/banner_with_cta'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/icons/customer_center/addresses/addresses'
  require 'components/atoms/icons/customer_center/bookmarks/bookmarks'
  require 'components/atoms/icons/customer_center/favorites/favorites'
  require 'components/atoms/icons/customer_center/orders/orders'
  require 'components/atoms/icons/customer_center/prescriptions/prescriptions'
  require 'components/atoms/icons/customer_center/profile/profile'

  require 'components/mixins/mixins'

  require './dashboard_index.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-dashboard-index'

  statics:
    route: ->
      visibleBeforeMount: true
      path: '/account'
      handler: 'AccountDashboard'
      bundle: 'customer-center'
      title: 'Account'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.conversion
    Mixins.dispatcher
  ]

  receiveStoreChanges: -> [
    'account'
  ]

  getDescription: (options) ->
    {count, multiple, single, zero} = options
    return zero     if count is 0  and zero
    return single   if count < 2   and single
    return multiple if count < 2   and multiple
    return "#{multiple} (#{count})" if multiple
    return ''

  getStaticClasses: ->
    block: @BLOCK_CLASS
    issues:
      "#{@BLOCK_CLASS}__issues"
    cta:
      "#{@BLOCK_CLASS}__cta
      u-fws"
    alert:
      "#{@BLOCK_CLASS}__alert"
    dotted:
      "#{@BLOCK_CLASS}__dotted"
    header:
      "#{@BLOCK_CLASS}__header
      u-ffs u-fs40 u-fws"
    cards:
      "#{@BLOCK_CLASS}__cards"
    divider:
      "#{@BLOCK_CLASS}__divider"
    logout:
      "#{@BLOCK_CLASS}__logout
       u-dn--720"
    warning:
      "#{@BLOCK_CLASS}__warning"
    active_order:
      "#{@BLOCK_CLASS}__active-order"

  renderIssue: (suppressUpload, issue, i) ->
    <BannerCTA
      {...issue}
      key=i
      suppressUpload=suppressUpload
      showEyeExamLink=true
      cssModifier=@classes.warning />

  renderOrder: (order, i) ->
    <Card {...order} key=order.id cssModifier=@classes.active_order route="/account/orders/#{order.id}" />

  renderCard: (card, i) ->
    if card.count or card.persist
      <Card {...card} key=card.heading />

  render: ->
    @classes = @getClasses()
    account = @getStore('account')

    if not account.__fetched
      return <LayoutDefault {...@props} isAlt=true />

    activeOrders = _.reduce account.orders, (active, order) =>
      if @convert('date', 'days-since', order.placed) < 30
        active.push order
      active
    , []

    activeOrders = _.take activeOrders, 4

    cards = []
    cards.push(
      heading: 'Orders'
      persist: false
      icon: IconOrders
      route: '/account/orders'
      count: account.counts.orders
      description: @getDescription
        count: account.counts.orders
        multiple: 'See complete history'
        single: 'See recent order'
    ) if account.orders

    cards.push(
      heading: 'Favorites'
      persist: true
      icon: IconFavorites
      route: '/account/favorites'
      description: 'The frames you <3'
    )

    cards.push(
      heading: 'Profile'
      persist: true
      icon: IconProfile
      route: '/account/profile'
      description: 'Manage account details'
    ) if account.customer

    cards.push(
      heading: 'Prescriptions'
      persist: false
      icon: IconPrescriptions
      route: '/account/prescriptions'
      count: account.counts.prescriptions
      description: @getDescription
        count: account.counts.prescriptions
        multiple: 'See all'
        single: 'Edit prescription'
    ) if account.prescriptions

    cards.push(
      heading: 'Addresses'
      persist: true
      icon: IconAddresses
      route: '/account/addresses'
      count: account.counts.addresses
      description: @getDescription
        count: account.counts.addresses
        multiple: 'See all'
        single: 'Edit yours'
        zero: 'Add one'
    ) if account.addresses

    cards.push(
      heading: 'Bookmarks'
      persist: false
      icon: IconBookmarks
      route: '/account/bookmarks'
      count: account.counts.bookmarks
      description: @getDescription
        count: account.counts.bookmarks
        single: 'See yours'
        multiple: 'See all'
    ) if account.bookmarks

    firstName = account.customer?.first_name or 'Hey'

    # kludgey workaround for multiple upload CTAs binding to the wrong context
    # TODO: find some way to fix this or wait until CJSX does
    uploads = _.filter account.issues,
      (issue) -> issue.action.toLowerCase() is 'upload'
    suppressUpload = uploads.length > 1

    <LayoutDefault {...@props} isAlt=true>

      <div className=@classes.block>

        {if account.issues.length > 0 then [
          <section className=@classes.issues>
            <div className=@classes.cta>
              {firstName}, we need your help!
            </div>
            {_.map account.issues, @renderIssue.bind(@, suppressUpload)}
          </section>
          <hr className=@classes.dotted />
        ]}

        <div className=@classes.header>
          Account
        </div>

        {if activeOrders.length > 0
          <section className=@classes.cards>
            {_.map activeOrders, @renderOrder}
          </section>}

        <hr className=@classes.divider />

        <section className=@classes.cards>
          {_.map cards, @renderCard}
        </section>

        <p className=@classes.logout>
          <CTA
            analyticsSlug='customerCenter-click-logout'
            cssModifier='-cta-small u-ffss u-fs12 u-fws'
            href='/logout'
            tagName='a'
            children='Log out' />
        </p>

      </div>

    </LayoutDefault>
