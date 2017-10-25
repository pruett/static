[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

class AccountOrdersHandler extends BaseHandler
  name: -> 'AccountOrders'

  prefetch: -> ['/api/v2/account']

  loginRequired: -> true

  cacheMaxAge: -> 60 * 1000  # 1 minute.

module.exports = AccountOrdersHandler
