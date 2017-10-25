[
  _

  Backbone
  Logger
] = [
  require 'lodash'

  require '../backbone'
  require '../../logger'
]

log = Logger.get('LocationModel').log

class LocationModel extends Backbone.BaseModel

module.exports = LocationModel
