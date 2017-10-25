[
  _
  Catbox
  CatboxRedis
  CatboxRedisMasterSlave
  Zlib

  Benchmark
  CircuitBreaker
  Logger
  Metrics
] = [
  require 'lodash'
  require 'catbox'
  require 'catbox-redis'
  require 'catbox-redis-master-slave'
  require 'zlib'

  require 'hedeia/common/utils/benchmark'
  require 'hedeia/server/utils/circuit_breaker'
  require 'hedeia/server/logger'
  require 'hedeia/server/utils/metrics'
]

CACHE_SEGMENT = 'cache'
METRICS_PREFIX = 'services.cache'
NOOP = ->

log = Logger.get('CacheService', file: __filename).log
benchmark = Benchmark.time name: METRICS_PREFIX, endWithChildren: true

class CacheService
  constructor: (@name, @engineFactory, @options = {}) ->
    @pool = []
    @gzipEnabled = _.get @options, 'gzip_enabled', false
    @circuit = new CircuitBreaker 'redis', @__action.bind(@)

  addInstanceToPool: (callback) ->
    client = @engineFactory @options
    self = @

    Metrics.increment "#{METRICS_PREFIX}.#{@name}.add"
    log "adding instance to #{@name} cache pool"

    client.start (error) ->
      if error
        log "error adding instance to #{self.name} cache pool", error
        callback error, null if _.isFunction(callback)
      else
        self.pool.push client
        callback null, client if _.isFunction(callback)

  modifyKey: (key) ->
    if @gzipEnabled
      "gzip:#{key}"
    else
      key

  getClient: (callback) ->
    # Get a client from a pool that `isReady`. If the first client plucked from
    # the pool is not `isReady`, we pull it out of the pool and add a new
    # instance.
    Metrics.increment "#{METRICS_PREFIX}.#{@name}.get"

    if _.size(@pool) is 0
      Metrics.increment "#{METRICS_PREFIX}.#{@name}.new"
      @addInstanceToPool callback
    else
      client = _.first @pool

      if client.isReady()
        Metrics.increment "#{METRICS_PREFIX}.#{@name}.ready"
        callback null, client
      else
        Metrics.increment "#{METRICS_PREFIX}.#{@name}.not-ready"
        @pool.shift()
        @addInstanceToPool callback

    return

  doGet: (key, callback) ->
    key = @modifyKey key

    @getClient (error, client) =>
      if !error
        client.get(id: key, segment: CACHE_SEGMENT, (err, cachedValue) =>
          if not err and cachedValue
            if @gzipEnabled
              gunzipped = Zlib.gunzipSync(new Buffer(cachedValue.item.data))
              cachedValue.item = JSON.parse(gunzipped)
            Metrics.increment "#{METRICS_PREFIX}.#{@name}.hit"
          else
            Metrics.increment "#{METRICS_PREFIX}.#{@name}.miss"
          callback err, cachedValue)
      else
        callback error

  doSet: (key, value, ttl, callback) ->
    key = @modifyKey key

    @getClient (error, client) =>
      if !error
        if @gzipEnabled
          json = JSON.stringify(value)
          buffer = Zlib.gzipSync(json, level: Zlib.Z_BEST_SPEED)
          value = buffer
        client.set({id: key, segment: CACHE_SEGMENT}, value, ttl, callback)
      else
        callback error

  doClear: (key, callback) ->
    @getClient (error, client) ->
      if !error
        client.drop id: key, segment: CACHE_SEGMENT, callback
      else
        callback error

  doGetLock: (key, ttl, callback) ->
    options = id: "#{key}-lock", segment: CACHE_SEGMENT

    @getClient (error, client) =>
      if !error
        client.get options, (err, cachedValue) =>
          if cachedValue
            Metrics.increment "#{METRICS_PREFIX}.#{@name}.lock-miss"
            callback null, false
          else
            client.set(
              options
              "#{Config.get('server.statsd.host')}-#{process.pid}"
              ttl
              (err) ->
                if not err
                  Metrics.increment "#{METRICS_PREFIX}.#{@name}.lock-success"
                  callback null, true
                else
                  Metrics.increment "#{METRICS_PREFIX}.#{@name}.lock-error"
                  callback err, false
            )
      else
        callback error

  doReleaseLock: (key, callback) ->
    @getClient (error, client) ->
      if !error
        client.drop id: "#{key}-lock", segment: CACHE_SEGMENT, callback
      else
        callback error

  # Private method. The circuit breaker for CacheService wraps this method. It fans out the cache
  # request.
  __action: () ->
    args = Array.prototype.slice.call arguments
    action_type = args.shift()

    switch action_type
      when 'get' then @doGet.apply(@, args)
      when 'set' then @doSet.apply(@, args)
      when 'clear' then @doClear.apply(@, args)
      when 'getLock' then @doGetLock.apply(@, args)
      when 'releaseLock' then @doReleaseLock.apply(@, args)
      else throw new Error('Unknown cache client action "' + action_type '"')

  # Public method. Gets a value from the cache. Fanned into the CacheService's circuit breaker.
  get: (key, callback) ->
    callback = NOOP unless _.isFunction(callback)
    @circuit.run 'get', key, callback

  # Public method. Sets a value in the cache. Fanned into the CacheService's circuit breaker.
  set: (key, value, ttl, callback) ->
    callback = NOOP unless _.isFunction(callback)
    @circuit.run 'set', key, value, ttl, callback

  # Public method. Clears a key from the cache. Fanned into the CacheService's circuit breaker.
  clear: (key, callback) ->
    callback = NOOP unless _.isFunction(callback)
    @circuit.run 'clear', key, callback

  # Public method. Gets a shared lock from the cache. Fanned into the CacheService's circuit
  # breaker.
  getLock: (key, ttl, callback) ->
    callback = NOOP unless _.isFunction(callback)
    @circuit.run 'getLock', key, ttl, callback

  # Public method. Releases a shared lock from the cache. Fanned into the CacheService's circuit
  # breaker.
  releaseLock: (key, callback) ->
    callback = NOOP unless _.isFunction(callback)
    @circuit.run 'releaseLock', key, callback

  isReady: ->
    _.some @pool, (client) -> client.isReady()


options = Config.get('server.redis')
options = _.extend options,
  poolCount: Config.get('server.redis.pool_size')

if Config.get('server.redis.master_slave_enabled')
  redisEngineFactory = (options) -> new Catbox.Client(CatboxRedisMasterSlave, options)
else
  redisEngineFactory = (options) -> new Catbox.Client(CatboxRedis, options)

cacheService = new CacheService('redis', redisEngineFactory, options)

_.times options.poolCount, ->
  cacheService.addInstanceToPool()

module.exports =
  isReady: ->
    cacheService.isReady.apply cacheService, arguments

  get: ->
    cacheService.get.apply cacheService, arguments

  releaseLock: ->
    cacheService.releaseLock.apply cacheService, arguments

  getLock: ->
    cacheService.getLock.apply cacheService, arguments

  set: ->
    cacheService.set.apply cacheService, arguments

  clear: ->
    cacheService.clear.apply cacheService, arguments

  CacheService: CacheService
