[
  _
  BaseStaticHandler
] = [
  require 'lodash'
  require 'hedeia/server/handlers/base_static_handler'
]

class HomeTryOnHandler extends BaseStaticHandler
  name: -> 'HomeTryOn'

  prefetch: -> [
    '/api/v2/hto-starter-kits'
    '/api/v2/variations/landing-page/home-try-on'
  ]

  cacheKey: ->
    query = _.get @request, 'url.query', {}
    if query.gender and query.fit
      "#{@path}:#{query.gender}:#{query.fit}"
    else
      @path

  prepare: ->
    if not @getFeature('homeTryOn')
      @throwError statusCode: 404
      false

module.exports = HomeTryOnHandler
