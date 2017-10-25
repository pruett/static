[
  BaseStaticHandler
] = [
  require 'hedeia/server/handlers/base_static_handler'
]

class AccessibilityHandler extends BaseStaticHandler
  name: -> 'Accessibility'

  prefetch: -> [
    '/api/v2/variations/accessibility'
  ]

module.exports = AccessibilityHandler
