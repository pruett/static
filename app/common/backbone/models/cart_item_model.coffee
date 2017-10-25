[
  _
  Backbone

  ImageSet
] = [
  require 'lodash'
  require '../backbone'

  require '../../utils/image_set'
]

class CartItemModel extends Backbone.BaseModel
  url: ->
    url = @apiBaseUrl("cart/items")
    if @has('id') then "#{url}/#{@get('id')}" else url

  defaults: ->
    qty: 1
    in_stock: true

  parse: (resp) ->
    if _.isObject(resp.image_set)
      if resp.image_set.images
        resp.image_url = _.first resp.image_set.images
      else
        resp.image_set = ImageSet.unpack(resp.image_set)
    resp

  isHTO: -> @get('option_type') is 'hto'

  isGiftCard: -> @get('option_type') is 'giftcard'

  isLowBridgeFit: ->
    collections = @get 'collections', []
    _.some collections, slug: 'low-bridge-fit'

module.exports = CartItemModel
