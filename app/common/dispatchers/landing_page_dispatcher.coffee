[
  _

  BaseDispatcher
  Logger

  Backbone
] = [
  require 'lodash'

  require './base_dispatcher'
  require '../logger'

  require '../backbone/backbone'
]

log = Logger.get('LandingPageDispatcher').log

URL_VALIDATOR = new RegExp(/^\/landing-page\/(eyeglasses|sunglasses|process)\/(?!women|men).*/)

class VariationsEndpoint extends Backbone.BaseModel

class LandingPageDispatcher extends BaseDispatcher

  channel: -> 'landing'

  mixins: -> [
    'cms'
  ]

  contentPath: ->
    @getVariationPath("/landing-page#{@currentLocation().pathname}")

  isValidPath: ->
    URL_VALIDATOR.test @contentPath()

  models: ->
    return {} unless @isValidPath()
    path = @contentPath()
    VariationsEndpoint::url = "/api/v2/variations#{path}#{@getVariationQueryString path}"
    variations:
      class: VariationsEndpoint
      fetchOnWake: true

  events: -> 'sync variations': @onVariationsSync

  getInitialStore: -> @buildStoreData()

  buildStoreData: ->
    return {} unless @isValidPath()
    content = @getContent()
    @updatePageTitle(content?.pageTitle)
    __fetched: @model('variations').isFetched()
    pageTitle: content?.pageTitle
    content: content

  storeDidChange: (store) -> @updatePageTitle(store.pageTitle) if store.changed.pageTitle

  updatePageTitle: (title) ->
    @setPageTitle(@currentLocation().pathname, title) if title and @isValidPath()

  getContent: ->
    endpoint = @model('variations')
    return {} unless endpoint.isFetched()
    variations = _.get endpoint, 'attributes.variations', {}
    @getContentVariation(variations)

  onVariationsSync: -> @replaceStore @buildStoreData()

module.exports = LandingPageDispatcher
