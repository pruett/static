[
  _
  Hapi

  Logger
  CacheService
] = [
  require 'lodash'
  require 'hapi'

  require 'hedeia/server/logger'
  require 'hedeia/server/services/cache_service'
]

isHealthy = (bool) -> if bool then 'OK' else 'BAD'

class HealthHandler
  constructor: (request, reply) ->
    cacheHealthy = CacheService.isReady()

    statusObject = {
        timestamp: Date.now()
        health: isHealthy(cacheHealthy)
        cache: isHealthy(cacheHealthy)
    }

    if not cacheHealthy
      Logger.get('HealthHandler').error(statusObject)

    reply(statusObject)


module.exports = HealthHandler
