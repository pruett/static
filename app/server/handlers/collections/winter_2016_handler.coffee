BaseCollectionHandler = require 'hedeia/server/handlers/base_collection_handler'

class Winter2016Handler extends BaseCollectionHandler

  name: -> 'Winter2016'

  prefetch: -> [
    '/api/v2/variations/landing-page/winter-2016'
  ]


  getSuffix: ->
    expMens = @getExperimentState('winterLandingPageSegmentationMen')
    expWomens = @getExperimentState('winterLandingPageSegmentationW')
    suffix = ''
    if expMens.participant && expMens.variant
      suffix = "#{suffix}:#{expMens.variant}"
    if expWomens.participant && expWomens.variant
      suffix = "#{suffix}:#{expWomens.variant}"
    suffix

  cacheKey: ->
    "#{@path}#{@getSuffix()}"

module.exports = Winter2016Handler
