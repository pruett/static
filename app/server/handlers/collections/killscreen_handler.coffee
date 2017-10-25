[

  BaseCollectionHandler
] = [

  require 'hedeia/server/handlers/base_collection_handler'
]

class KillscreenHandler extends BaseCollectionHandler
  name: -> 'KillscreenHandler'

  prefetch: -> [
    '/api/v2/variations/killscreen'
  ]

module.exports = KillscreenHandler
