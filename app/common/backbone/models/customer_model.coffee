Backbone = require '../backbone'

class CustomerModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('account/customer')

  permittedAttributes: -> [
    'email'
    'first_name'
    'id'
    'last_name'
    'wants_marketing_emails'
    'sms_opt_in'
  ]

  validation: ->
    email:
      required: true
      pattern: 'email'
      msg: 'Email address must be valid'
    first_name: required: true
    last_name: required: true
    password:
      required: (val, attr, computed) -> not Boolean(computed.id)

module.exports = CustomerModel
