[
  _
  Request

  Logger
  ApiCacheService
  Metrics
  CircuitBreaker
  TimeSpan
] = [
  require 'lodash'
  require 'request'

  require 'hedeia/server/logger'
  require 'hedeia/server/services/api_cache_service'
  require 'hedeia/server/utils/metrics'
  require 'hedeia/server/utils/circuit_breaker'
  require 'hedeia/server/helpers/time_span'
]

logger = Logger.get('ApiService', file: __filename)
NOOP = ->

cacheableRoutes = [
  # Obviously, we should only cache endpoints that **do not** contain user data.
  # `ttl` is how long the data can stay in the cache.
  # `cacheStale` is the age when an endpoint is refreshed asynchronously.
  { url: 'gift_cards',                   cacheStale: '4h', ttl: '12h' }
  { url: 'region_sets/*',                cacheStale: '4h', ttl: '12h' }
  { url: 'retail/locations/*',           cacheStale: '4h', ttl: '12h' }
  { url: 'recommendations/eyeglasses/*', cacheStale: '1h', ttl: '12h' }
  { url: 'recommendations/sunglasses/*', cacheStale: '1h', ttl: '12h' }
  { url: 'layouts/*',                    cacheStale: '1h', ttl: '12h' }
  { url: 'meta',                         cacheStale: '1h', ttl: '12h' }
  { url: 'frames/*',                     cacheStale: '5m', ttl: '12h' }
  { url: 'products/*',                   cacheStale: '5m', ttl: '12h' }
  { url: 'product-details/*',            cacheStale: '5m', ttl: '12h' }
  { url: 'content/*',                    cacheStale: '5m', ttl: '12h' }
  { url: 'variations/*',                 cacheStale: '5m', ttl: '12h' }
  { url: 'variation/*',                  cacheStale: '5m', ttl: '12h' }
  { url: 'experiments',                  cacheStale: '5m', ttl: '12h' }
  { url: 'salable/*',                    cacheStale: '1m', ttl: '12h' }
  { url: 'hto-starter-kits',             cacheStale: '1m', ttl: '12h' }
]

apiCacheService = new ApiCacheService(
  _.map cacheableRoutes, (route) ->
    url:"/api/v2/#{route.url}"
    ttl: TimeSpan.duration route.ttl
    cacheStale: TimeSpan.duration route.cacheStale
)

fallbackMessage = 'The API service is currently not available.'
fallbackError = new Error(fallbackMessage)

pathsToRecordTimings = new Set(['/api/v2/session'])

class ApiRequest
  constructor: (@path, @headers, @cookies, @method, @options) ->
    @options = _.defaults @options, cacheSkip: false, cacheFlush: false

    throw new Error 'Missing \'cookies\' argument' unless @cookies
    throw new Error 'Invalid \'method\' argument' unless _.includes ['sync', 'async'], @method
    @country = _.get(@options, 'locale.country', 'US')
    @server = Config.get "server.api.servers.#{@country.toLowerCase()}"

class ApiService
  constructor: (options = {}) ->
    Request = options.Request or Request
    @getCircuit = new CircuitBreaker(
      'frontend_store', @doGet.bind(@), {timeout: 15000, maxFailures: 50 }, @requestFallback)

  isCacheable: (path) -> apiCacheService.isCacheable(path)

  fetch: (path, cookies, headers, options = {}, callback) ->
    @doFetch new ApiRequest(path, headers, cookies, 'sync', _.cloneDeep(options)), callback

  doFetch: (apiRequest, callback) ->
    if not @isCacheable(apiRequest.path) or apiRequest.options.cacheSkip
      # Route isn't cacheable, just make the request.
      @doRequest apiRequest, callback
    else if apiRequest.options.cacheFlush
      # Cache flush requested, wait for it to clear.
      apiCacheService.clear(
        apiRequest.path, apiRequest.country, @onCacheClear.bind(@, apiRequest, callback)
      )
    else
      # Try to get from cache.
      apiCacheService.get(
        apiRequest.path, apiRequest.country, @onCacheGet.bind(@, apiRequest, callback)
      )

  asyncFetch: (apiRequest) ->
    _.defer @doAsyncFetch.bind(@, apiRequest)

  doAsyncFetch: (apiRequest) ->
    apiRequest.options = _.assign apiRequest.options, timeout: 10000, method: 'async'
    apiRequest.method = 'async'
    apiCacheService.getLock apiRequest.path, apiRequest.country, 15000, _.bind (err, lock) ->
      if lock
        @doRequest apiRequest, @onAsyncRequestComplete.bind(@)
    , @

  onAsyncRequestComplete: (apiRequest) ->
    apiCacheService.releaseLock apiRequest.path, apiRequest.country

  onCacheClear: (apiRequest, callback) ->
    @doRequest apiRequest, callback

  onCacheGet: (apiRequest, callback, err, cacheResult) ->
    if not err and cacheResult
      @asyncFetch(apiRequest) if cacheResult.isStale
      cacheValue = cacheResult.value
      @onCacheHit apiRequest, callback, cacheValue.response, cacheValue.body
    else
      @onCacheMiss apiRequest, callback

  onCacheHit: (apiRequest, callback, response, body) ->
    callback apiRequest.path, statusCode: 200, headers: {}, JSON.parse(body)

  onCacheMiss: (apiRequest, callback) ->
    @doRequest apiRequest, callback

  __requestStatus: (error, response) ->
    _.get error, 'code', _.get(response, 'statusCode', 'UNKNOWN')

  # This is the entrypoint into the internal logic of placing a request via the API Service. This
  # method runs the request through the service's circuit breaker to "fail fast" on function calls
  # when error rates are too high in order to prevent cascading failures.
  doRequest: (apiRequest, callback) ->
    requestCallback = @requestCallback.bind(@, apiRequest, callback)
    @getCircuit.run apiRequest, requestCallback

  requestFallback: (apiRequest, callback) ->
    callback null, {statusCode: 299}, fallbackMessage

  requestCallback: (apiRequest, callback, error, response, body) ->
    if not error and response?
      if response.statusCode >= 200 and response.statusCode <= 298
        @onRequestSuccess apiRequest, callback, response, body
        return
    reason = @__requestStatus error, response
    logger.error "prefetch error #{apiRequest.server.host} for \"#{apiRequest.path}\": #{reason}"
    @onRequestError apiRequest, callback, error, response, body

  onRequestError: (apiRequest, callback, error, response, body) ->
    if apiRequest.method is 'sync' and error in ['ETIMEDOUT', 'ECONNREFUSED']
      @asyncFetch apiRequest if apiCacheService.isCacheable(apiRequest.path)
    callback apiRequest.path, response, null

  onRequestSuccess: (apiRequest, callback, response, body) ->
    if apiRequest.method is 'sync'
      apiRequest.cookies.addResponse response.headers['set-cookie']

    if _.startsWith response.headers['content-type'], 'application/json'
      if not apiRequest.options.cacheSkip
        apiCacheService.set(
          apiRequest.path
          apiRequest.country
          response: response, body: body
        )
      callback apiRequest.path, response, JSON.parse(body)
    else
      callback apiRequest.path, response, body

  doGet: ->
    @get.apply(@, arguments)

  get: (apiRequest, callback) ->
    url = "#{apiRequest.server.protocol}://#{apiRequest.server.host}:#{apiRequest.server.port}#{apiRequest.path}"
    options = timeout: apiRequest.options.timeout, headers: apiRequest.headers, url: url, gzip: true

    apiRequest.startTime = Metrics.getTime()
    Request options, @metricsCallback.bind(@, apiRequest, callback)

  metricsCallback: (apiRequest, callback, error, response, body) ->
    Metrics.increment "services.api.#{apiRequest.method}"

    pathWithoutQueryParams = _.first apiRequest.path.split("?")

    if pathsToRecordTimings.has(pathWithoutQueryParams)
      status = @__requestStatus error, response
      Metrics.timingSince(
        "services.api.completed.#{apiRequest.method}.#{pathWithoutQueryParams}.get.#{apiRequest.status}"
        apiRequest.startTime
      )

    callback error, response, body

apiService = new ApiService()

module.exports =
  fetch: () ->
    apiService.fetch.apply(apiService, arguments)

  isCacheable: () ->
    apiService.isCacheable.apply(apiService, arguments)

  ApiService: ApiService
