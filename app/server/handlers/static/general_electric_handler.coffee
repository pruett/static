[
  BaseStaticHandler
] = [
  require 'hedeia/server/handlers/base_static_handler'
]

class GeneralElectricHandler extends BaseStaticHandler
  name: -> 'GeneralElectric'

  prefetch: -> [
    '/api/v2/variations/ge'
  ]

module.exports = GeneralElectricHandler
