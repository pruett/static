[
  _

  BaseStaticHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_static_handler'
]

class SeeSummerBetterHandler extends BaseStaticHandler
  name: -> 'SeeSummerBetter'

  prefetch: -> [
    '/api/v2/variations/see-summer-better'
  ]

module.exports = SeeSummerBetterHandler
