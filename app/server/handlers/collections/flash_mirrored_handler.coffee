

BaseCollectionHandler = require 'hedeia/server/handlers/base_collection_handler'

class FlashMirroredHandler extends BaseCollectionHandler
  name: -> 'FlashMirrored'

  prefetch: -> [
    '/api/v2/variations/flash-mirrored'
  ]

module.exports = FlashMirroredHandler
