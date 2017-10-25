[
  BaseStaticHandler
] = [
  require 'hedeia/server/handlers/base_static_handler'
]

class KillScreenKioskHandler extends BaseStaticHandler
  name: -> 'KillScreenKiosk'

  layout: -> 'killScreenKiosk'

module.exports = KillScreenKioskHandler
