Backbone = require '../../backbone/backbone'

class ColorsCollection extends Backbone.BaseCollection
  url: -> @apiBaseUrl 'frames/colors'

  parse: (resp) -> resp.colors


module.exports = ColorsCollection
