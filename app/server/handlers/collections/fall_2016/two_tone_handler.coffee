[

  BaseCollectionHandler
] = [

  require 'hedeia/server/handlers/base_collection_handler'
]

class Fall2016TwoToneHandler extends BaseCollectionHandler
  name: -> 'Fall2016TwoToneHandler'


  # Note: Last minute branding change, renamed prefetch endpoints
  # from 'two-tone' to 'two-tones'

  prefetch: -> [
    '/api/v2/variations/landing-page/fall-2016/two-tones'
  ]

module.exports = Fall2016TwoToneHandler
