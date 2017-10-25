Backbone = require '../backbone'

class NewCustomerModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('account/customer')

  defaults: ->
    first_name: ''
    last_name: ''

  permittedAttributes: -> [
    'email'
    'password'
    'first_name'
    'id'
    'last_name'
    'wants_marketing_emails'
    'origin'
  ]

  validation: ->
    email:
      required: true
      pattern: 'email'
      msg: 'Email address must be valid.'
    first_name: required: true
    last_name: required: true
    password: required: true
    origin: required: false

module.exports = NewCustomerModel
