Backbone = require '../../backbone/backbone'

class RegionsCollection extends Backbone.BaseCollection
  url: -> @apiBaseUrl 'region_sets/all'

  parse: (resp) -> resp.region_sets

module.exports = RegionsCollection
