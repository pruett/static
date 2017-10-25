[
  _

  BaseCollectionHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_collection_handler'
]

class Winter2015Handler extends BaseCollectionHandler
  name: -> 'Winter2015'

  prefetch: -> [
    '/api/v2/variations/winter-2015'
  ]

module.exports = Winter2015Handler
