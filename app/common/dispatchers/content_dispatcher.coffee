[
  _

  Backbone
  BaseDispatcher
  Logger
] = [
  require 'lodash'

  require '../backbone/backbone'
  require './base_dispatcher'
  require '../logger'
]

log = Logger.get('ContentDispatcher').log

class ContentModel extends Backbone.BaseModel
  initialize: (attrs, options) ->
    @contentType = options.contentType
    @path = options.path
    @url = "/api/v2/content/#{@contentType}#{@path.replace(/_/g, '-')}"

class ContentDispatcher extends BaseDispatcher
  channel: -> 'content'

  shouldAlwaysWake: -> true

  getInitialStore: ->
    fetching = {}
    store = {}

    _.each _.get(@appState, 'api.prefetched'), (resp, route) =>
      if _.startsWith(route, '/api/v2/content/')
        splitRoute = route.split('/')
        contentType = splitRoute[4]
        # Extract the path which starts at 5th index of split route, e.g.
        # ['', 'api', 'v2', 'content', 'module', 'checkout', 'faq'].
        path = "/#{splitRoute.slice(5).join('/')}"
        fetching = @markFetching(fetching, path, contentType)
        store[contentType] or= {}
        store[contentType][path] = _.get resp, "#{contentType}.content", {}

    store.fetching = fetching
    store

  markFetching: (fetching, path, contentType) ->
    fetching["#{contentType}__#{path}"] = new Date().getTime()
    fetching

  onContentFetched: (model) ->
    content = _.get(model.toJSON(), "#{model.contentType}.content", {})
    @setStore "#{model.contentType}": { "#{model.path}": content }

  commands:
    fetch: (path, contentType = 'page') ->
      if not _.get(@store, "fetching.#{contentType}__#{path}")
        # Don't fetch content if it's already fetching or fetched.
        contentPath = "#{contentType}#{path.replace(/_/g, '-')}"
        Logger.get('ContentDispatcher').warn "
          fetching: /api/v2/content/#{contentPath}, consider prefetching this endpoint
          in a handler
        "
        @setStore fetching: @markFetching(@store.fetching, path, contentType)
        contentModel = new ContentModel({}, path: path, contentType: contentType)
        contentModel.fetch success: @onContentFetched.bind(@)

module.exports = ContentDispatcher
