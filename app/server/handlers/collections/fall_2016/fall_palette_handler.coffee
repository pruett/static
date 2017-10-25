[

  BaseCollectionHandler
] = [

  require 'hedeia/server/handlers/base_collection_handler'
]

class Fall2016FallPaletteHandler extends BaseCollectionHandler
  name: -> 'Fall2016FallPaletteHandler'

  prefetch: -> [
    '/api/v2/variations/landing-page/fall-2016/fall-palette'
  ]

module.exports = Fall2016FallPaletteHandler
