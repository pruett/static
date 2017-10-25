[
  Backbone
] = [
  require '../../backbone'
]

class EstimateShippingModel extends Backbone.BaseModel

  url: -> @apiBaseUrl('estimate/shipping')

module.exports = EstimateShippingModel
