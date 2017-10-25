Backbone = require '../../backbone'

class EstimateDiscountModel extends Backbone.BaseModel

  url: -> @apiBaseUrl('estimate/discount')

  destroy: (options={}) ->
    Backbone.sync 'delete', @,
      _.assign options,
        url: @apiBaseUrl("estimate/discount/#{@toJSON().code}")

module.exports = EstimateDiscountModel
