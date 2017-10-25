[
  _

  Logger
  BaseDispatcher
] = [
  require 'lodash'

  require '../logger'
  require '../../common/dispatchers/base_dispatcher'
]


class SocialDispatcher extends BaseDispatcher
  log = Logger.get('SocialDispatcher').log

  channel: -> 'social'

  getInitialStore: ->
    friendbuy:
      isComplete: false
      isEnabled: _.get @appState, 'config.friendbuy.enabled'
      site: _.get @appState, 'config.friendbuy.site_id'
      widgetId: _.get @appState, 'config.friendbuy.widget_id'
      htoWidgetId: _.get @appState, 'config.friendbuy.hto_widget_id'

  getStoreChangeHandlers: ->
    postCheckout: 'handlePostCheckoutStoreChange'

  handlePostCheckoutStoreChange: (postCheckoutStore) ->
    # Don't call Friendbuy until widget div is available.
    @doFriendbuy() if postCheckoutStore.showConfirmation

  doFriendbuy: ->
    friendbuy = @store.friendbuy or {}
    return if friendbuy.isComplete or not friendbuy.isEnabled
    return if @getLocale().country isnt 'US'

    postCheckout = @getStore('postCheckout')

    return if _.isEmpty postCheckout.analytics

    # Assemble Friendbuy data from postCheckout store.
    data =
      site: friendbuy.site
      widget:
        if _.get postCheckout, 'analytics.is_hto_only'
          friendbuy.htoWidgetId
        else
          friendbuy.widgetId
      customer: id: _.get postCheckout, 'analytics.customer.id'
      order:
        id:  _.first _.get(postCheckout, 'completedOrderIds', [])
        amount: _.get postCheckout, 'analytics.totals.total'
      products: _.map _.get(postCheckout, 'analytics.items'), (item) ->
        sku: item.sku
        price: item.amount_cents
        qty: item.quantity

    # Push Friendbuy data onto associated array.
    window.friendbuy = [
      ['site', data.site]
      ['widget', data.widget]
      ['track', 'customer', data.customer]
      ['track', 'order', data.order]
      ['track', 'products', data.products]
    ]

    # Initalize Friendbuy to grab all data.
    @commandDispatcher('scripts', 'load',
      name: 'friendbuy'
      src: _.get @appState, 'config.scripts.friendbuy'
    )

    @setStore friendbuy: isComplete: true


module.exports = SocialDispatcher
