[
  _

  Backbone
  ImageSet
  Logger
] = [
  require 'lodash'

  require '../backbone'
  require '../../utils/image_set'
  require '../../logger'
]

log = Logger.get('AccountModel').log

class AccountModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('account')

  defaults: ->
    addresses: []
    bookmarks: []
    counts:
      addresses: 0
      bookmarks: 0
      orders: 0
      prescriptions: 0
    customer: {}
    orders: []
    prescriptions: []

  parse: (resp) ->
    resp.orders = _.map resp.orders, (order) ->
      order.line_items = _.map order.line_items, (line_item) ->
        if line_item.image_set?
          line_item.image_set = ImageSet.unpack(line_item.image_set)
        line_item
      order

    resp


module.exports = AccountModel
