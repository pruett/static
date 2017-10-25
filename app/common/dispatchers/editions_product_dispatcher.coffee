_ = require 'lodash'
Backbone = require '../backbone/backbone'
BaseDispatcher = require './base_dispatcher'

REGEX_PATH = /^\/editions\/.*$/

class EditionsProductDispatcher extends BaseDispatcher
  channel: -> 'editionsProduct'

  mixins: -> [
    'cms'
  ]

  events: ->
    'sync editionsProduct': @onSyncComplete
    'sync editionsDetails': @onSyncComplete

  models: ->
    editionsProduct:
      fetchOnWake: true
      class: Backbone.BaseModel.extend(
        url: "/api/v2/products#{@currentLocation().pathname}"
      )

  collections: ->
    path = '/editions-details'
    editionsDetails:
      fetchOnWake: true
      class: Backbone.BaseCollection.extend(
        url: "/api/v2/variations#{path}#{@getVariationQueryString path}"
        parse: (resp) => @getContentVariation resp.variations
      )

  onSyncComplete: ->
    @__updateTitleAndTrack()
    @replaceStore @buildStoreData()

  getInitialStore: -> @buildStoreData()

  buildStoreData: ->
    editionsData = @data('editionsProduct')
    details = @data('editionsDetails')

    productsWithDetails = _.map editionsData['products'], (product) =>
      _.assign product, details: @__getProductDetails(product.path, details)

    _.assign editionsData,
      __fetched: @model('editionsProduct').isFetched()
      activeIndex: @__getActiveIndex(editionsData)
      products: productsWithDetails

  initialize: ->
    @__updateTitleAndTrack()

  __isOnEditions: ->
    @currentLocation().pathname.match(REGEX_PATH)

  __updateTitleAndTrack: (product) ->
    if @__isOnEditions() and @store.__fetched
      unless product
        product = _.find @store.products, @__isProductPathMatch

      if product
        @setPageTitle REGEX_PATH, product.display_name
        @trackProductDetailEvent product

  trackProductDetailEvent: (product = null) ->
    if product
      list = _.compact(['Edition', 'Unisex', product.display_name]).join '_'

      @commandDispatcher 'analytics', 'pushProductEvent',
        type: 'productDetail'
        products: product
        eventMetadata:
          list: list

      if product.recommendations
        @commandDispatcher 'analytics', 'pushProductEvent',
          type: 'productImpression'
          products: product.recommendations
          eventMetadata:
            list: list

  __getProductDetails: (path, data) ->
    # Matches path against details path
    matches = data.filter (obj) -> path.indexOf(obj.path) is 0

    # Sort largest to smallest
    # i.e. /path/foo/bar > /path/foo
    matchesSorted = matches.sort (a, b) -> a.path < b.path
    if matchesSorted.length then matchesSorted[0].details else []

  __getActiveIndex: (data) ->
    Math.max 0, _.findIndex(data.products, @__isProductPathMatch)

  __isProductPathMatch: (product) =>
    "/#{product.path}" is @currentLocation().pathname

  commands:
    changeActiveVariant: (activeIndex = 0) ->
      product = @store.products[activeIndex] or {}

      @__updateTitleAndTrack(product)

      if product.path
        @commandDispatcher 'routing', 'replaceState', "/#{product.path}"

      @setStore
        activeIndex: activeIndex

module.exports = EditionsProductDispatcher
