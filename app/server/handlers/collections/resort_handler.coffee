
BaseCollectionHandler = require 'hedeia/server/handlers/base_collection_handler'

class ResortHandler extends BaseCollectionHandler
  name: -> 'Resort'

  prefetch: -> [
    '/api/v2/variations/landing-page/resort'
  ]

module.exports = ResortHandler
