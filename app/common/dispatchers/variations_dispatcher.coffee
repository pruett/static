[
  _

  Backbone
  BaseDispatcher
  VariationsModel
  Logger

] = [
  require 'lodash'

  require '../backbone/backbone'
  require './base_dispatcher'
  require '../backbone/models/variations_model'

  require '../logger'
]

logger = Logger.get('VariationsDispatcher')

class VariationsDispatcher extends BaseDispatcher
  channel: -> 'variations'

  shouldAlwaysWake: -> true

  mixins: -> [
    'cms'
  ]

  buildStorePathData: (model) ->
    # Get model data and append fallback key.
    # Fallback key specifies variation to select if not specified.
    data = model.toJSON()
    data.__fallbackKey = @getContentVariationKey data, model.path

    pageTitle = _.get data, "#{data.__fallbackKey}.__page_title", {}
    if pageTitle.enabled
      # If enabled, try to set page title.
      @setPageTitle pageTitle.path, pageTitle.title

    data

  onContentFetched: (model) ->
    @setStore "#{model.path}": @buildStorePathData model

  transformVariationToStore: (store, variation) ->
    path = "/#{variation.path}"

    # Parse data like on fetch.
    model = new VariationsModel variation, { path: path, parse: true }

    store[path] = @buildStorePathData model
    store

  getInitialStore: ->
    # Use prefetched variations data to create initial store.
    prefetched = _.get @appState, 'api.prefetched'
    variations = _.pickBy prefetched, (resp) -> resp.variations

    _.transform variations, @transformVariationToStore.bind(@), {}

  commands:
    fetch: (path) ->
      unless _.get(@store, "#{path}.__fetching")
        # Don't fetch content if it's already fetching or fetched.
        logger.warn "
          fetching: /api/v2/variations#{path},
          consider prefetching this endpoint in a handler
        "
        variationsModel = new VariationsModel {}, path: path, query: @getVariationQueryString path
        variationsModel.fetch success: @onContentFetched.bind @


module.exports = VariationsDispatcher
