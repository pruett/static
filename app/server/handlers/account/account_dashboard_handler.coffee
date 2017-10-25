[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

class AccountDashboardHandler extends BaseHandler
  name: -> 'AccountDashboard'

  prefetch: -> [
    '/api/v2/account',
    '/api/v2/region_sets/all',
    '/api/v2/favorite'
  ]

  loginRequired: -> true

  cacheMaxAge: -> 60 * 1000  # 1 minute.

module.exports = AccountDashboardHandler
