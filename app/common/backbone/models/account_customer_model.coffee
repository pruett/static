[
  Backbone

  Logger
] = [
  require '../backbone'

  require '../../logger'
]

log = Logger.get('AccountCustomerModel').log

class AccountCustomerModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('account/customer')

  permittedAttributes: -> [
    'first_name'
    'last_name'
    'full_name'
    'email'
    'sms_opt_in'
  ]

  validation:
    first_name:
      required: true
    last_name:
      required: true

module.exports = AccountCustomerModel
