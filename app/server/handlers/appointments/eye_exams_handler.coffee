[
  _

  BaseStaticHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_static_handler'
]

class EyeExamsHandler extends BaseStaticHandler
  name: -> 'EyeExams'

  prefetch: -> [
    '/api/v2/retail/locations'
    '/api/v2/variations/retail/eye-exams'
  ]

  prefetchOptions: ->
    timeout: 5000

module.exports = EyeExamsHandler
