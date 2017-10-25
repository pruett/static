[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

class AccountAddressesHandler extends BaseHandler
  name: -> 'AccountAddresses'

  prefetch: -> ['/api/v2/account', '/api/v2/region_sets/all']

  loginRequired: -> true

  cacheMaxAge: -> 60 * 1000  # 1 minute.

module.exports = AccountAddressesHandler
