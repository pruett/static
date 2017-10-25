[
  _
  BaseHandler
] = [
  require 'lodash'
  require 'hedeia/server/handlers/base_handler'
]

class LandingPageHandler extends BaseHandler
  name: -> 'LandingPage'

  cacheTTL: -> 2 * 60 * 60 * 1000  # 2 hours.

  cacheMaxAge: -> 5 * 60 * 1000  # 5 minutes.

  prefetchOptions: ->
    timeout: 10000

  prefetch: -> [
    @contentEndpoint()
  ]

  contentEndpoint: -> "/api/v2/variations/landing-page#{@path}"

  prepare: ->
    prefetchError = @prefetchErrors[@contentEndpoint()]
    unless prefetchError is 404
      true
    else
      @throwError prefetchError
      false


module.exports = LandingPageHandler
