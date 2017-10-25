[
  _

  Backbone
  Logger
] = [
  require 'lodash'

  require '../../backbone'
  require '../../../logger'
]

class EstimateAnalyticsModel extends Backbone.BaseModel
  log = Logger.get('EstimateAnalyticsModel').log

  parse: (estimate) ->
    us_cent_totals = _.get estimate.totals, 'in_usd', {}
    usd_totals = if _.isEmpty us_cent_totals then null else @parseTotals(us_cent_totals)

    estimate.totals = @parseTotals(_.omit estimate.totals, 'in_usd')

    if usd_totals
      _.assign estimate.totals, in_usd: usd_totals

    estimate

  parseTotals: (totals) ->
    revenue_cents = totals.subtotal_cents + totals.shipping_cents -
      totals.discount_cents - totals.gift_card_cents

    # Change totals from cents to dollars.
    _.each totals, (value, key) ->
      totals[key.replace(/_cents$/, '')] =
        if isNaN(value)
          "0.00"
        else
          "#{(value * 0.01).toFixed(2)}"

    _.assign {}, totals, revenue: "#{(revenue_cents * 0.01).toFixed(2)}"

module.exports = EstimateAnalyticsModel
