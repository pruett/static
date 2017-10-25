[
  BaseHandler
] = [
  require 'hedeia/server/handlers/base_handler'
]

class CheckoutConnectAccountsHandler extends BaseHandler
  name: -> 'CheckoutConnectAccounts'

  prefetch: -> [
    '/api/v2/estimate'
    '/api/v2/checkout/account'
  ]

  cachePrivacy: -> 'private'

  prepare: ->
    if @isLoggedIn()
      # If you're logged-in, you shouldn't see this page.
      @redirectWithParams '/checkout/step/information'
      return false

module.exports = CheckoutConnectAccountsHandler
