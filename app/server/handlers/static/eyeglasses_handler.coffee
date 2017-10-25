[
  BaseStaticHandler
] = [
  require 'hedeia/server/handlers/base_static_handler'
]

class EyeglassesHandler extends BaseStaticHandler
  name: -> 'Eyeglassses'

  prefetch: -> [
    '/api/v2/variations/eyeglasses-responsive'
  ]

module.exports = EyeglassesHandler
