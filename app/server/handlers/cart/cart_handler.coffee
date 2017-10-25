[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

class CartHandler extends BaseHandler
  name: -> 'Cart'

  prefetch: -> [
    '/api/v2/cart/items'
    '/api/v2/variations/cart'
  ]

  cachePrivacy: -> 'private'

module.exports = CartHandler
