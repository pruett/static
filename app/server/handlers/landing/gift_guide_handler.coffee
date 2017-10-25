

BaseCollectionHandler = require 'hedeia/server/handlers/base_collection_handler'

class GiftGuideHandler extends BaseCollectionHandler
  name: -> 'GiftGuide'

  prefetch: -> [
    '/api/v2/variations/gift-guide'
  ]

module.exports = GiftGuideHandler
