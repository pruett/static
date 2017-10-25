[
  BaseStaticHandler
] = [
  require 'hedeia/server/handlers/base_static_handler'
]

class SunglassesHandler extends BaseStaticHandler
  name: -> 'Sunglassses'

  prefetch: -> [
    '/api/v2/variations/sunglasses-responsive'
  ]

module.exports = SunglassesHandler
