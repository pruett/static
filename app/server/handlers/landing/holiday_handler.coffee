[
  _

  BaseStaticHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_static_handler'
]

class HolidayHandler extends BaseStaticHandler
  name: -> 'Holiday'

  prefetch: -> [
    '/api/v2/variations/holiday'
  ]

module.exports = HolidayHandler
