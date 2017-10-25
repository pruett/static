[
  _

  Logger
  CacheService
] = [
  require 'lodash'

  require 'hedeia/server/logger'
  require 'hedeia/server/services/cache_service'
]

log = Logger.get('ContentCacheService', file: __filename).log

CACHE_VERSION = 3
CACHE_SEGMENT = 'content'
CACHE_PREFIX = "#{CACHE_SEGMENT}-#{CACHE_VERSION}"
NOOP = ->

class ContentCacheService
  constructor: ->
    @cacheService = CacheService

  clear: (path, callback) ->
    callback = NOOP if not _.isFunction(callback)
    @cacheService.clear @key(path), callback

  key: (path, feature = 'content') ->
    "#{CACHE_PREFIX}-#{path}-#{feature}"

  releaseLock: (path, callback) ->
    @cacheService.releaseLock @key(path), callback

  getLock: (path, ttl, callback) ->
    callback = NOOP unless _.isFunction(callback)
    @cacheService.getLock @key(path), ttl, (err, lock) -> callback(err, lock)

  get: (path, callback) ->
    @cacheService.get @key(path), (err, cacheResult) ->
      if cacheResult?
        cacheItem = cacheResult.item
        isStale = Date.now() >= cacheItem.staleAfter
        callback null,
          value: cacheItem.value,
          cachedAt: cacheResult.stored
          isStale: isStale
      else
        callback null, null

  set: (path, value, ttl, cacheStale, callback) ->
    cacheValue =
      value: value
      cacheStale: cacheStale
      staleAfter: Date.now() + cacheStale

    @cacheService.set @key(path), cacheValue, ttl, callback

module.exports = new ContentCacheService
