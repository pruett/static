[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

class PdHandler extends BaseHandler
  name: -> 'PD'

module.exports = PdHandler
