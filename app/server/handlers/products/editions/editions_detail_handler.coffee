_ = require 'lodash'

BaseHandler = require 'hedeia/server/handlers/base_handler'


class EditionsDetailHandler extends BaseHandler
  name: -> 'EditionsDetail'

  prefetch: -> [
    @getEditionEndpoint()
    "/api/v2/variations/editions-details"
  ]

  getEditionEndpoint: ->
    "/api/v2/products#{@path}"

  cacheTTL: -> 2 * 60 * 60 * 1000  # 2 hours.

  cachePrivacy: -> 'private'

  cacheKey: ->
    # We render and cache a slightly different page for Apple Pay capable browsers.
    "#{if @isApplePayCapable then 'apw:' else ''}#{@path}"

  prefetchOptions: ->
    timeout: 10000

  prepare: ->
    statusCode = @prefetchErrors[@getEditionEndpoint()]
    if _.isNumber statusCode
      @throwError statusCode
      false
    else
      true

module.exports = EditionsDetailHandler
