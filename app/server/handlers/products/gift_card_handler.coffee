[
  BaseHandler
] = [
  require 'hedeia/server/handlers/base_handler'
]

class GiftCardHandler extends BaseHandler
  name: -> 'GiftCard'

  prefetch: -> [
    '/api/v2/gift_cards'
    '/api/v2/variations/gift-card-responsive'
  ]

  prepare: ->
    if not @getFeature('giftCards')
      @throwError statusCode: 404
      false

  cacheTTL: -> 2 * 60 * 60 * 1000  # 2 hours.

  cacheMaxAge: -> 5 * 60 * 1000  # 5 minutes.

module.exports = GiftCardHandler
