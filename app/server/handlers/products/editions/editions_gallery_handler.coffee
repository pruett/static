_ = require 'lodash'

BaseStaticHandler = require 'hedeia/server/handlers/base_static_handler'


class EditionsGalleryHandler extends BaseStaticHandler
  name: -> 'EditionsGallery'

  prefetch: -> [
    "/api/v2/variations/landing-page/editions"
  ]

module.exports = EditionsGalleryHandler
