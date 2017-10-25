[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

class AccountPrescriptionsHandler extends BaseHandler
  name: -> 'AccountPrescriptions'

  prefetch: -> ['/api/v2/account']

  loginRequired: -> true

  cacheMaxAge: -> 60 * 1000  # 1 minute.

module.exports = AccountPrescriptionsHandler
