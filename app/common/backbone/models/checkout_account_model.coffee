[
  _

  Backbone
  Logger
] = [
  require 'lodash'

  require '../backbone'
  require '../../logger'
]

log = Logger.get('CheckoutAccountModel').log

class CheckoutAccountModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('checkout/account')

  defaults: ->
    addresses: []
    customer: {}
    orders: []
    prescriptions: []

  parse: (resp) ->
    resp.addresses = _.filter resp.addresses, (address) ->
      # KLUDGE: Filter out any addresses that don't have a telephone number.
      _.some(address.telephone)
    resp

module.exports = CheckoutAccountModel
