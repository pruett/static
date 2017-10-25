[
  _

  Logger
  BaseDispatcher
  RegionsCollection
] = [
  require 'lodash'

  require '../logger'
  require './base_dispatcher'
  require '../backbone/collections/regions_collection'
]

class RegionsDispatcher extends BaseDispatcher
  log = Logger.get('RegionsDispatcher').log

  channel: -> 'regions'

  collections: ->
    regions: { class: RegionsCollection, fetchOnWake: true }

  events: ->
    'sync regions': @onRegionsSync

  getInitialStore: -> @buildStoreData()

  onRegionsSync: -> @replaceStore @buildStoreData()

  buildStoreData: ->
    locales = {}
    countryOptions = []

    regionOptGroups = @collection('regions').map (regionSet) ->
      code = regionSet.get 'code'
      name = regionSet.get 'name'

      locales[code] or= countryOptions: [], regionOptGroups: []

      countryOption = label: name, value: code
      countryOptions.push countryOption
      locales[code].countryOptions.push countryOption

      label: name
      value: _.map regionSet.get('regions'), (region) ->
        option = label: region.name, value: region.code
        locales[code].regionOptGroups.push option
        option

    __fetched: @collection('regions').isFetched()
    regionOptGroups: regionOptGroups
    countryOptions: countryOptions
    locales: locales

module.exports = RegionsDispatcher
