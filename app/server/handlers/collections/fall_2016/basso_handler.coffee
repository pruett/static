[

  BaseCollectionHandler
] = [

  require 'hedeia/server/handlers/base_collection_handler'
]

class Fall2016BassoHandler extends BaseCollectionHandler
  name: -> 'Fall2016BassoHandler'

  prefetch: -> [
    '/api/v2/variations/landing-page/fall-2016/basso'
  ]

module.exports = Fall2016BassoHandler
