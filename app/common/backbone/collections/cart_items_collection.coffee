[
  _

  Backbone
  CartItem
] = [
  require 'lodash'

  require '../backbone'
  require '../models/cart_item_model'
]

class CartItemsCollection extends Backbone.BaseCollection
  HTO_LIMIT: 5
  model: CartItem

  parse: (resp) -> resp.items

  defaults: ->
    amount_cents: 0

  url: -> @apiBaseUrl('cart/items')

  lastProductUrl: ->
    maxId = 0
    @reduce (url, item) ->
      itemId = item.get('id') or 0
      if itemId > maxId
        maxId = itemId
        url = item.get('product_url')
      url
    , '/'

  lastGalleryUrl: ->
    maxId = 0
    allHto = true
    url = @reduce (galleryUrl, item) ->
      allHto = false unless item.isHTO()
      itemId = item.get('id') or 0
      itemUrl = item.get('product_url') or '/'
      if itemId > maxId and itemUrl.search(/\/(eyeglasses|sunglasses)\//) is 0
        galleryUrl = _.take(itemUrl.split('/'), 3).join '/'
        maxId = itemId
      galleryUrl
    , '/'

    if allHto and url isnt '/' then "#{url}?availability=hto" else url

  hasOutOfStockItem: -> @outOfStockCount() isnt 0

  hasMultipleFits: ->
    frames = @filter (item) -> item.get('option_type') not in ['giftcard', 'hto']
    lowBridgeFrames = _.filter frames, (frame) -> frame.isLowBridgeFit()
    lowBridgeFrames.length and lowBridgeFrames.length isnt frames.length

  hasRx: ->
    @some (item) -> item.get('option_type') is 'rx'

  nonHtoCount: -> @length - @htoCount()

  htoRemaining: -> Math.max 0, @HTO_LIMIT - @htoCount()

  htoFull: ->  @htoRemaining() <= 0

  htoCount: ->
    htoCounter = (count, item) ->
      if item.isHTO() then count + 1 else count
    @reduce htoCounter, 0

  outOfStockCount: ->
    @outOfStockCountHto() + @outOfStockCountPurchase()

  outOfStockCountHto: ->
    @reduce (count, item) ->
      count++ if not item.get('in_stock') and item.isHTO()
      count
    , 0

  outOfStockCountPurchase: ->
    @reduce (count, item) ->
      count++ if not item.get('in_stock') and not item.isHTO()
      count
    , 0

  subtotal: ->
    subtotaler = (sum, item) -> sum + item.get('amount_cents')
    @reduce subtotaler, 0

  comparator: (item) ->
    # Mainly, we want to show HTO's at the bottom. The rest can be grouped
    # together by type. We also use the id to preserve item order within
    # groups.

    switch item.get('option_type')
      when 'rx' then prefix = 600
      when 'progressives rx' then prefix = 700
      when 'giftcard' then prefix = 800
      when 'hto' then prefix = 900
      else prefix = 100

    # New items without an id should sort to the bottom of their group.
    id = item.get('id') || "Z"

    "#{prefix}#{id}"

module.exports = CartItemsCollection
