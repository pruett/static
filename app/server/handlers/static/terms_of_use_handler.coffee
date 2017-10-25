[
  BaseStaticHandler
] = [
  require 'hedeia/server/handlers/base_static_handler'
]

class TermsOfUseHandler extends BaseStaticHandler
  name: -> 'TermsOfUse'

  prefetch: -> [
    '/api/v2/variations/terms-of-use'
  ]

module.exports = TermsOfUseHandler
