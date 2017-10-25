[
  _

  BaseCollectionHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_collection_handler'
]

class Summer2016Handler extends BaseCollectionHandler
  name: -> 'Summer2016'

  prefetch: -> [
    '/api/v2/variations/summer-2016'
  ]

module.exports = Summer2016Handler
