[

  BaseCollectionHandler
] = [

  require 'hedeia/server/handlers/base_collection_handler'
]

class Fall2016MixedMediaHandler extends BaseCollectionHandler
  name: -> 'Fall2016MixedMediaHandler'

  # Note: Last minute branding change, renamed prefetch endpoints
  # from 'mixed-media' to 'mixed-materials'
  prefetch: -> [
    '/api/v2/variations/landing-page/fall-2016/mixed-materials'
  ]

module.exports = Fall2016MixedMediaHandler
