[
  _

  BaseCollectionHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_collection_handler'
]

class Spring2016Handler extends BaseCollectionHandler
  name: -> 'Spring2016'

  prefetch: -> [
    '/api/v2/variations/spring-2016'
  ]

module.exports = Spring2016Handler
