Backbone = require '../backbone'

class CartToEstimate extends Backbone.BaseModel
  url: -> @apiBaseUrl('estimate/cart')

  parse: (resp) -> resp.estimate

module.exports = CartToEstimate
