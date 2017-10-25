

BaseCollectionHandler = require 'hedeia/server/handlers/base_collection_handler'

class LeithClarkHandler extends BaseCollectionHandler
  name: -> 'LeithClark'

  prefetch: -> [
    '/api/v2/variations/landing-page/leith-clark'
  ]

module.exports = LeithClarkHandler
