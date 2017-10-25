[
  BaseStaticHandler
] = [
  require 'hedeia/server/handlers/base_static_handler'
]

class LegacyHandler extends BaseStaticHandler
  # Used for legacy pages that aren't hooked up to the CMS.
  name: -> 'Legacy'

module.exports = LegacyHandler
