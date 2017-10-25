[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

class BaseStaticHandler extends BaseHandler
  # Static pages should subclass this handler to get cacheTTL and cacheMaxAge
  # settings.

  name: -> 'BaseStatic'

  cacheTTL: -> 4 * 60 * 60 * 1000  # 4 hours.

  cacheMaxAge: -> 5 * 60 * 1000  # 5 minutes.

module.exports = BaseStaticHandler
