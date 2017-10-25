[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

class AccountFavoritesHandler extends BaseHandler
  name: -> 'AccountFavorites'

  prefetch: -> [
    '/api/v2/favorite?verbose=1'
  ]

  loginRequired: -> true

  cacheMaxAge: -> 60 * 1000  # 1 minute.

module.exports = AccountFavoritesHandler
