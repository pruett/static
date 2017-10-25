[

  BaseCollectionHandler
] = [

  require 'hedeia/server/handlers/base_collection_handler'
]

class Fall2016SunHandler extends BaseCollectionHandler
  name: -> 'Fall2016SunHandler'

  prefetch: -> [
    '/api/v2/variations/landing-page/fall-2016/sun'
  ]

module.exports = Fall2016SunHandler
