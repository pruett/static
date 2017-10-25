[
  _

  Logger
  Metrics
  CacheService
  WildcardTrie
] = [
  require 'lodash'

  require 'hedeia/server/logger'
  require 'hedeia/server/utils/metrics'
  require 'hedeia/server/services/cache_service'
  require 'hedeia/server/utils/wildcard_trie'
]

log = Logger.get('ApiCacheService', file: __filename).log

CACHE_VERSION = 4
CACHE_SEGMENT = 'api-prefetch'
CACHE_PREFIX = "#{CACHE_SEGMENT}-#{CACHE_VERSION}"
NOOP = ->

class ApiCacheService
  constructor: (routes = []) ->
    @trie = new WildcardTrie
    @trie.add(route.url, route) for route in routes
    log 'created with', routes.length, 'cacheable paths'

  getCacheability: (path) ->
    _.first(@trie.matches(path)) or null

  isCacheable: (path) ->
    @getCacheability(path) isnt null

  key: (path, country, feature = 'content') ->
    "#{CACHE_PREFIX}-#{country}-#{path}-#{feature}"

  clear: (path, country = 'US', callback) ->
    callback = NOOP unless _.isFunction(callback)

    if @isCacheable(path)
      CacheService.clear(@key(path, country), callback)
    else
      callback(null, null)

  releaseLock: (path, country = 'US', callback) ->
    CacheService.releaseLock @key(path, country), callback

  getLock: (path, country = 'US', ttl, callback) ->
    CacheService.getLock @key(path, country), ttl, callback

  get: (path, country = 'US', callback) ->
    cacheability = @getCacheability(path)

    if not cacheability
      callback(null, null)
      return

    cacheId = cacheability.url

    CacheService.get @key(path, country), (err, cacheResult) ->
      if cacheResult?
        cacheItem = cacheResult.item
        isStale = Date.now() >= cacheItem.staleAfter
        freshOrStale = if isStale then 'stale' else 'fresh'
        Metrics.increment "services.api-cache.#{country}.#{cacheId}.hit"
        Metrics.increment "services.api-cache.#{country}.#{cacheId}.#{freshOrStale}"
        callback null,
          value: cacheItem.value,
          cachedAt: cacheResult.stored
          isStale: isStale
      else
        Metrics.increment "services.api-cache.#{country}.#{cacheId}.miss"
        callback null, null

  set: (path, country = 'US', value, callback) ->
    callback = NOOP unless _.isFunction(callback)
    cacheability = @getCacheability(path)

    if cacheability
      key = @key(path, country)

      cacheValue =
        value: value
        cacheStale: cacheability.cacheStale
        staleAfter: Date.now() + cacheability.cacheStale

      CacheService.set(key, cacheValue, cacheability.ttl, callback)
      true
    else
      callback(null)
      false

module.exports = ApiCacheService
