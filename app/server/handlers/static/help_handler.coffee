[
  BaseStaticHandler
] = [
  require 'hedeia/server/handlers/base_static_handler'
]

class HelpHandler extends BaseStaticHandler
  name: -> 'Help'

  prefetch: -> [
    '/api/v2/variations/responsive/help'
  ]

  cacheKey: ->
    url = @request.url or {}
    query = url.query or {}
    if query.topic and @modifier('isMobileAppRequest')
      # Allow query caching for FAQs.
      "#{@path}:#{query.topic}"
    else
      @path

module.exports = HelpHandler
