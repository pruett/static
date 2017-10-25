[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

class LoginHandler extends BaseHandler
  # Route: /login

  name: -> 'Login'

  prepare: ->
    if @isLoggedIn()
      # If you're logged-in, you shouldn't see this page.
      @redirectWithParams '/account'
      return false


module.exports = LoginHandler
