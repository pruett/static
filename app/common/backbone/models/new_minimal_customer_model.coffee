Backbone = require '../backbone'

class NewMinimalCustomerModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('account/customer')

  defaults: ->
    first_name: ''
    last_name: ''

  permittedAttributes: -> [
    'email'
    'password'
    'id'
    'wants_marketing_emails'
    'minimal'
    'origin'
  ]

  validation: ->
    email:
      required: true
      pattern: 'email'
      msg: 'Email address must be valid.'

    password: required: true
    origin: required: false

module.exports = NewMinimalCustomerModel
