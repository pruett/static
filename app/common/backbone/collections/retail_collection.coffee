Backbone = require '../../backbone/backbone'

class RetailCollection extends Backbone.BaseCollection
  url: -> @apiBaseUrl 'retail/locations'

  parse: (resp) -> resp.locations

module.exports = RetailCollection
