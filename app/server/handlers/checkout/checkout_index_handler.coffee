[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

class CheckoutIndexHandler extends BaseHandler
  name: -> 'CheckoutIndex'

  cachePrivacy: -> 'private'

  prepare: ->
    if not @getCookie('cart_id')
      # Must have a cart id cookie or you're gonna have a bad time.
      @redirectWithParams '/cart'
      false

module.exports = CheckoutIndexHandler
