[
  _
  Boom

  Logger
  Cookies
  ApiService
  BaseHandler
] = [
  require 'lodash'
  require 'boom'

  require 'hedeia/server/logger'
  require 'hedeia/server/utils/cookies'
  require 'hedeia/server/services/api_service'
  require 'hedeia/server/handlers/base_handler'
]

class CachedApiHandler extends BaseHandler
  # This handler is basically a proxy of ApiService which is used by node store
  # to fetch API endpoints from cache (fast) or upstream when not cached (slower
  # and possibly very slow).
  #
  # While we _should_ make all of our API endpoints fast, this handler gives us
  # coverage until we can do so (after product catalog work).
  #
  # It's meant to service the mobile app only.
  #
  # Example:
  #
  # https://www.warbyparker.com/api/v2/cached?path=/api/v2/frames/eyeglasses/men
  #
  constructor: (request, reply, options = {}) ->
    host = request.headers.host.toLowerCase()
    path = request.query.path

    cookies = new Cookies(request: request.state)

    if ApiService.isCacheable(path)
      ApiService.fetch(
        path,
        cookies,
        request.headers,
        _.assign locale: @__getLocaleFromHost(host), timeout: 60000, options
        (path, response, body) ->
          if response? and response.statusCode >= 200 and response.statusCode < 300
            reply(body)
          else
            response = response or { statusCode: 500 }
            reply _.assign(
              Boom.create(response.statusCode)
              json: true
            )
      )
    else
      reply _.assign(
        Boom.create(404, "'Invalid or not a cacheable path")
        json: true
      )

module.exports = CachedApiHandler
