[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

class CheckoutConfirmationHandler extends BaseHandler
  name: -> 'CheckoutConfirmation'

  prefetch: -> [
    '/api/v2/variations/checkout/confirmation'
    '/api/v2/variations/delivery-times'
  ]

  cachePrivacy: -> 'private'

  prepare: ->
    if not _.get(@request.query, 'orders')
      @redirectWithParams '/checkout'
      false

module.exports = CheckoutConfirmationHandler
