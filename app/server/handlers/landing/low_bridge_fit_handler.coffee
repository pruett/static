[

  BaseStaticHandler
] = [

  require 'hedeia/server/handlers/base_static_handler'
]

class LowBridgeFitHandler extends BaseStaticHandler
  name: -> 'LowBridgeFit'

  prefetch: -> [
    '/api/v2/variations/low-bridge-fit'
  ]

module.exports = LowBridgeFitHandler
