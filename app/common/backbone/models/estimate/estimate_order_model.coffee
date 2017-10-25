[
  Backbone
] = [
  require '../../backbone'
]

class EstimateOrderModel extends Backbone.BaseModel

  url: -> @apiBaseUrl('estimate/place')

module.exports = EstimateOrderModel
