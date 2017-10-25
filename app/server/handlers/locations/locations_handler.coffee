[
  BaseStaticHandler
] = [
  require 'hedeia/server/handlers/base_static_handler'
]

class LocationsHandler extends BaseStaticHandler
  name: -> 'Locations'

  prefetch: -> [
    '/api/v2/retail/locations'
    '/api/v2/variations/retail/locations'
    '/api/v2/variations/retail/services'
    '/api/v2/variations/retail/shop-links'
  ]

  prefetchOptions: ->
    timeout: 5000

module.exports = LocationsHandler
