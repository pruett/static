[
  _
  Backbone
] = [
  require 'lodash'
  require '../backbone'
]

class NavigationModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('variations/navigation')

  parse: (resp) ->
    # Map through variations and set defaults.
    _.mapValues resp.variations, (variation) ->
      _.defaults variation,
        banner:
          show: false
          bannerAnimatedOnce: false

module.exports = NavigationModel
