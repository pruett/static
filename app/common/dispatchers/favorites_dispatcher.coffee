[
  _
  Backbone

  BaseDispatcher
  Logger

  FavoriteModel
  FavoritesCollection
] = [
  require 'lodash'
  require '../backbone/backbone'

  require './base_dispatcher'
  require '../logger'

  require '../backbone/models/favorite_model'
  require '../backbone/collections/favorites_collection'
]

log = Logger.get('FavoritesDispatcher').log

class FavoritesDispatcher extends BaseDispatcher
  channel: -> 'favorites'

  collections: ->
    url = @currentLocation()

    if url.pathname is '/account/favorites'
      FavoritesCollection::url = "/api/v2/favorite?verbose=1"
    else
      FavoritesCollection::url = "/api/v2/favorite"

    favorites:
      class: FavoritesCollection

  wake: ->
    @favoritesQueue = []

    if @requestDispatcher 'session', 'isLoggedIn'
      @collection('favorites').fetch()

  events: ->
    'sync favorites': @onSyncComplete

  onSyncComplete: -> @replaceStore @buildStoreData()

  processFavorites: ->
    @collection('favorites').fetch
      success: @processQueue.bind(@, true)

  processQueue: (force = false) ->
    if @requestDispatcher('session', 'isLoggedIn') or force
      while @favoritesQueue.length
        id = @favoritesQueue.pop()
        fav = new FavoriteModel product_id: id
        fav.save()
        @collection('favorites').push(fav)
        @pushEvent "favorite-add-#{id}"
    else
      id = _.first(@favoritesQueue) or 'N/A'
      @pushEvent "favorite-click-#{id}"
      @replaceStore showLogin: true

  getInitialStore: -> @buildStoreData()

  buildStoreData: ->
    @data('favorites').reduce (acc, fav) ->
      acc.favoritedProducts.push(fav.product_id)
      acc.detailedFavorites.push(fav) if fav.detailed
      acc
    ,
      favoritedProducts: []
      detailedFavorites: []
      showLogin: false
      __fetched: @collection('favorites').isFetched()

  isProductIdInStore: (id) ->
    @store.favoritedProducts.indexOf(id) > -1

  favoriteProduct: (id) ->
    @replaceStore favoritedProducts: @store.favoritedProducts.concat id
    @favoritesQueue.push id
    @processQueue()

  unfavoriteProduct: (id) ->
    @replaceStore
      favoritedProducts: _.without @store.favoritedProducts, id
      detailedFavorites: _.reject(@store.detailedFavorites, product_id: id)

    fav = @collection('favorites').findWhere(product_id: id)
    fav?.destroy()
    @pushEvent "favorite-remove-#{id}"

  commands:
    closeLogin: ->
      @favoritesQueue = []
      @replaceStore
        favoritedProducts: []
        showLogin: false
      @commandDispatcher 'layout', 'hideTakeover'

    toggleFavorite: (id) ->
      if @isProductIdInStore id then @unfavoriteProduct id else @favoriteProduct id

    processFavorites: ->
      @replaceStore showLogin: false
      @commandDispatcher 'layout', 'hideTakeover'
      @processFavorites()

module.exports = FavoritesDispatcher
