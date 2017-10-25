[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

class BaseCollectionHandler extends BaseHandler
  # Collection pages should subclass this handler to get cacheTTL and
  # cacheMaxAge settings.

  name: -> 'BaseCollection'

  cacheTTL: -> 2 * 60 * 60 * 1000  # 2 hours.

  cacheMaxAge: -> 5 * 60 * 1000  # 5 minutes.

module.exports = BaseCollectionHandler
