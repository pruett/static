_ = require 'lodash'
Backbone = require '../backbone'
FavoriteModel = require '../models/favorite_model'

class FavoritesCollection extends Backbone.BaseCollection

  model: FavoriteModel

  parse: (res) ->
    res.favorites

module.exports = FavoritesCollection
