Backbone = require '../backbone'

class FavoriteModel extends Backbone.BaseModel
  urlRoot: -> @apiBaseUrl('favorite')

module.exports = FavoriteModel
