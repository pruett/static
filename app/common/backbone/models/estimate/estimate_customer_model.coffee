CustomerModel = require '../customer_model'

class EstimateCustomerModel extends CustomerModel

  url: -> @apiBaseUrl('estimate/customer')

  permittedAttributes: -> [
    'id'
    'full_name'
    'first_name'
    'last_name'
    'email'
    'password'
    'sms_opt_in'
    'apple_pay'
  ]

module.exports = EstimateCustomerModel
