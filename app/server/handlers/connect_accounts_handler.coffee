[
  BaseHandler
] = [
  require 'hedeia/server/handlers/base_handler'
]

class ConnectAccountsHandler extends BaseHandler
  name: -> 'ConnectAccounts'

  prepare: ->
    if @isLoggedIn()
      # If you're logged-in, you shouldn't see this page.
      @redirectWithParams '/account'
      return false


module.exports = ConnectAccountsHandler
