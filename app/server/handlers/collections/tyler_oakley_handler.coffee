

BaseCollectionHandler = require 'hedeia/server/handlers/base_collection_handler'

class TylerOakleyHandler extends BaseCollectionHandler
  name: -> 'TylerOakley'

  prefetch: -> [
    '/api/v2/variations/landing-page/tyler-oakley'
  ]

module.exports = TylerOakleyHandler
