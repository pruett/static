[
  _

  BaseCollectionHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_collection_handler'
]

class Fall2015Handler extends BaseCollectionHandler
  name: -> 'Fall2015'

  prefetch: ->
    pathSuffix = if @request.params['version']
      "/#{@request.params['version']}"
    else
      ''

    ["/api/v2/variations/fall-2015#{pathSuffix}"]

module.exports = Fall2015Handler
