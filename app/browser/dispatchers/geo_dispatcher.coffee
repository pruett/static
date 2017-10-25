[
  _
  Backbone

  BaseDispatcher
  Logger
] = [
  require 'lodash'
  require '../../common//backbone/backbone'

  require '../../common/dispatchers/base_dispatcher'
  require '../logger'
]

log = Logger.get('GeoDispatcher').log

class NearbyStoreModel extends Backbone.BaseModel
  idAttribute: 'facility_id'

class NearbyStoresCollection extends Backbone.BaseCollection
  url: -> '/api/v2/nearby_stores?limit=3'

  model: NearbyStoreModel

  comparator: 'distance'

  parse: (resp) -> resp.nearby_stores

class GeoDispatcher extends BaseDispatcher
  channel: -> 'geo'

  collections: ->
    nearbyStores:
      class: NearbyStoresCollection
      fetchOnWake: true

  events: ->
    'sync nearbyStores': @onSync
    'error nearbyStores': @onError

  getInitialStore: -> @buildStoreData()

  buildStoreData: ->
    nearbyStores: @data('nearbyStores')

  onSync: -> @replaceStore @buildStoreData()

  onError: -> @replaceStore nearbyStores: []

  requests:

    inRetailRadius: ->
      nearbyStores = @collection('nearbyStores')
      if nearbyStores.isFetched()
        inRetailRadius = @collection('nearbyStores').size() > 0
        @commandDispatcher 'cookies', 'set', 'inRetailRadius', inRetailRadius,
          expires: (3600 * 12)
        return inRetailRadius
      else
        cookieValue = @requestDispatcher('cookies', 'get', 'inRetailRadius')
        if cookieValue then cookieValue is 'true'

module.exports = GeoDispatcher
