[
  _

  BaseHandler
] = [
  require 'lodash'

  require 'hedeia/server/handlers/base_handler'
]

class FrameGalleryHandler extends BaseHandler
  name: -> 'FrameGallery'

  prefetch: -> [
    "/api/v2/frames#{@path}"
    "/api/v2/variations/gallery-content#{@path}"
  ]

  cacheTTL: ->
    filters = _.pick(
      @request.url.query
      ['color', 'noseBridge', 'material', 'shape', 'width']
    )

    if _.isEmpty(filters)
      2 * 60 * 60 * 1000  # 2 hours.
    else
      0  # Don't cache when filters are applied.

  cacheMaxAge: -> 5 * 60 * 1000  # 5 minutes.

  hasQuizResultsPromo: ->
    quizGender = @getCookie 'hasQuizResults'
    quizResults = (
      _.includes(@path, '/women') and quizGender is 'f' or
      _.includes(@path, '/men') and quizGender is 'm'
    )

    @isHtoFiltered() and quizResults

  isHtoFiltered: ->
    _.get(@request, 'url.query.availability') is 'hto' or Boolean(@getCookie 'htoMode')

  cacheKey: ->
    [
      if @isHtoFiltered() then 'hto:' else ''
      if @hasQuizResultsPromo() then "quiz#{_.get(@prefetched['/api/v2/session'], 'cart.hto_quantity', 0)}:" else ''
      @path
    ].join ''

  prefetchOptions: ->
    timeout: 10000

module.exports = FrameGalleryHandler
