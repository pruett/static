[
  BaseStaticHandler
] = [
  require 'hedeia/server/handlers/base_static_handler'
]

class JobsHandler extends BaseStaticHandler
  name: -> 'Jobs'

  prefetch: -> [
    '/api/v2/jobs'
    '/api/v2/content/page/jobs'
    '/api/v2/variations/jobs'
  ]

  prefetchOptions: ->
    timeout: 5000

module.exports = JobsHandler
