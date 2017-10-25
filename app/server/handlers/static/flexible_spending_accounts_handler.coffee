[
  BaseStaticHandler
] = [
  require 'hedeia/server/handlers/base_static_handler'
]

class FlexibleSpendingAccountsHandler extends BaseStaticHandler
  name: -> 'FlexibleSpendingAccounts'

  prefetch: -> [
    '/api/v2/variations/meta/flexible-spending-accounts'
    '/api/v2/variations/flexible-spending-accounts'
  ]

module.exports = FlexibleSpendingAccountsHandler
