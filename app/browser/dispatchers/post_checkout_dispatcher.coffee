[
  _

  Backbone
  BaseDispatcher
  Logger
  EstimateAnalyticsModel
] = [
  require 'lodash'

  require '../../common/backbone/backbone'
  require '../../common/dispatchers/base_dispatcher'
  require '../logger'
  require '../../common/backbone/models/estimate/estimate_analytics_model'
]

class OrdersCollection extends Backbone.BaseCollection
  parse: (resp) -> resp.orders

class PostCheckoutDispatcher extends BaseDispatcher
  log = Logger.get('PostCheckoutDispatcher').log

  channel: -> 'postCheckout'

  mixins: -> [
    'modals'
  ]

  getInitialStore: ->
    __fetched: false
    orders: []

  wake: -> @fetchOrderDetails()

  fetchOrderDetails: ->
    if not @store.__fetched
      orders = new OrdersCollection
      orders.url = "/api/v2/account/order/#{_.get(@currentLocation(), 'query.orders', '')}"
      orders.fetch success: @onOrderDetailsSuccess.bind(@)

  onOrderDetailsSuccess: (items, xhr, options) ->
    @setStore
      __fetched: true
      orders: items.toJSON()

    @modals(success: 'submitOrder') if @modals(isShowing: 'submitOrder')

  commands:
    setEstimate: (analytics) ->
      # This is temporary, and will be replaced by a fetch of the order details
      estimateAnalytics = new EstimateAnalyticsModel analytics, parse: true
      @commandDispatcher 'analytics', 'pushCheckoutSuccess', estimateAnalytics

module.exports = PostCheckoutDispatcher
