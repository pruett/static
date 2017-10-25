[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

class CheckoutHandler extends BaseHandler
  name: -> 'Checkout'

  cachePrivacy: -> 'private'

  prepare: ->
    if not @getCookie('estimate_id')
      # Must have a estimate id cookie or this checkout isn't going to work.
      @redirectWithParams '/checkout'
      false

  prefetch: -> [
    '/api/v2/estimate'
    '/api/v2/region_sets/all'
    '/api/v2/checkout/account'
    '/api/v2/variations/checkout/confirmation'
    '/api/v2/variations/checkout/footer'
    '/api/v2/variations/delivery-times'
  ]

  prefetchOptions: ->
    timeout: 10000

module.exports = CheckoutHandler
