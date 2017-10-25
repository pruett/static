[
  BaseStaticHandler
] = [
  require 'hedeia/server/handlers/base_static_handler'
]

class PrivacyPolicyHandler extends BaseStaticHandler
  name: -> 'PrivacyPolicy'

  prefetch: -> [
    '/api/v2/variations/privacy-policy'
  ]

module.exports = PrivacyPolicyHandler
