[
  _

  Backbone
  Logger
  ImageSet
] = [
  require 'lodash'

  require '../../backbone'
  require '../../../logger'
  require '../../../utils/image_set'
]

class EstimateModel extends Backbone.BaseModel
  log = Logger.get('EstimateModel').log

  url: -> @apiBaseUrl('estimate')

  parse: (resp) ->
    if _.get(resp.estimate, 'items', false)
      resp.estimate.items = _.map resp.estimate.items, (item) ->
        if item.image_set?
          item.image_set = ImageSet.unpack(item.image_set)
        item
    resp.estimate

  toDecimals: (amount) ->
    parseFloat (amount * 0.01).toFixed(2)

  applePayShippingMethods: ->
    if @get('is_expedited_shipping_available')
      [
        label: 'Standard',
        detail: 'Standard Shipping',
        amount: 0,
        identifier: "#{@get('shipping_methods.standard.method_id')}"
      ,
        label: 'Expedited',
        detail: 'Expedited Shipping',
        amount: @toDecimals @get('shipping_methods.expedited.method_cost')
        identifier: "#{@get('shipping_methods.expedited.method_id')}"
      ]
    else
      []

  applePayTotal: ->
    type = if @isFetched() then 'final' else 'pending'

    if @get('is_hto_only')
      # Apple Pay requires a total > 0, so we add a line item for
      # a fake authorization hold at $1.00.
      total = 1.00
    else
      if @get('totals.total_cents')?
        total = @toDecimals @get('totals.total_cents')
      else
        # Total must be greater than zero.
        total = 0.01

    return {
      label: 'Warby Parker'
      type: type
      amount: total
    }

  applePayLineItems: ->
    type = if @isFetched() then 'final' else 'pending'

    lineItems = [
      type: type
      label: 'Shipping'
      amount: @toDecimals(@get('totals.shipping_cents') or 0)
    ,
      type: type
      label: 'Tax'
      amount: @toDecimals(@get('totals.tax_cents') or 0)
    ]

    if @get('is_hto_only')
      # Apple Pay requires a total > 0, so we add a line item for
      # a fake authorization hold at $1.00.
      lineItems.unshift(
        type: type
        label: 'Authorization Hold'
        amount: 1.00
      )

    lineItems

module.exports = EstimateModel
