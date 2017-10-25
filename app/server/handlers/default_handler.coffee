[
  BaseHandler
] = [
  require 'hedeia/server/handlers/base_handler'
]

class DefaultHandler extends BaseHandler
  # Use for generic pages that don't have prefetching requirements.
  name: -> 'Default'

module.exports = DefaultHandler
