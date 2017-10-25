Backbone = require '../../backbone'

class EstimatePaymentModel extends Backbone.BaseModel

  url: -> @apiBaseUrl('estimate/payment/credit-card')

  defaults:
    payment_type: 'credit_card'

  permittedAttributes: -> [
    'cc_id'
    'cc_type_id'
    'cc_last_four'
    'cc_expires_month'
    'cc_expires_year'
    'cc_token'
    'payment_type'
    'credit_card_token_id'
  ]

  validation:
    cc_type_id:
      required: true
      msg: 'Credit card number must be valid'
    cc_last_four:
      required: true
      msg: 'Credit card number must be valid'
    cc_expires_month:
      required: true
      msg: 'Expiration date must be valid'
    cc_expires_year:
      required: true
      msg: 'Expiration date must be valid'

module.exports = EstimatePaymentModel
