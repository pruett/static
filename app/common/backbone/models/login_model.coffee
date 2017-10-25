Backbone = require '../backbone'

class LoginModel extends Backbone.BaseModel

  url: -> @apiBaseUrl('account/login')

  permittedAttributes: -> [
    'email'
    'password'
  ]

  validation: ->
    email:
      required: true
      pattern: 'email'
      msg: 'Email address must be valid.'
    password:
      required: true


module.exports = LoginModel
