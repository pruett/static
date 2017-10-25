[
  _

  Logger
  Backbone
  BaseDispatcher
] = [
  require 'lodash'

  require '../logger'
  require '../../common/backbone/backbone'
  require '../../common/dispatchers/base_dispatcher'
]

class PlacesDispatcher extends BaseDispatcher
  log = Logger.get('PlacesDispatcher').log

  SUGGEST_MIN_LENGTH: 1

  channel: -> 'places'

  getInitialStore: ->
    suggestions: []
    chosenAddress: null
    isServiceAvailable: true
    isLoading: true

  wake: ->
    if @getLocale('country') is 'US'
      @injectScript()
    else
      @handleUnavailable()

  handleUnavailable: ->
    # Handle the possibility where the service is not available.
    @setStore isServiceAvailable: false, isLoading: false

  injectScript: ->
    return if @getStore('scripts').googlePlaces
    window.__googlePlacesLoaded = @setupServices.bind(@)
    @commandDispatcher 'scripts', 'load',
      name: 'googlePlaces'
      src: '//maps.googleapis.com/maps/api/js?libraries=places&callback=__googlePlacesLoaded'

  setupServices: ->
    clearTimeout @__scriptTimeout
    if google?.maps?.Map?
      map = new google.maps.Map document.createElement('div')
      @autoCompleteService = new google.maps.places.AutocompleteService()
      @placesService = new google.maps.places.PlacesService(map)
      @setStore isServiceAvailable: true, isLoading: false
    else
      @handleUnavailable()

  thenUpdateResults: (suggestions) ->
    suggestions = _.filter suggestions, (suggestion) ->
      'street_address' in suggestion.types

    @setStore suggestions: suggestions

  thenSetChosenAddress: (data) ->
    return unless data?

    flattenComponents = (result, component, key) ->
      for type in component.types
        result[type] =
          short_name: component.short_name
          long_name: component.long_name
      result

    place = _.transform data.address_components, flattenComponents

    streetAddressArr = [
      place.street_number?.short_name
      place.route?.short_name
      place.premise?.short_name
    ]

    @replaceStore(
      suggestions: []
      chosenAddress:
        formatted_address: data.formatted_address
        street_address: _.compact(streetAddressArr).join ' '
        postal_code: place.postal_code?.long_name
        country_code: place.country?.short_name
        locality: place.locality?.long_name or place.sublocality_level_1?.long_name
        region: place.administrative_area_level_1?.short_name
    )

  getPlacePrediction: (input) ->
    return unless @autoCompleteService?
    @autoCompleteService.getPlacePredictions(
      input: input
      types: ['address']
      componentRestrictions:
        country: @getLocale('country').toLowerCase()
      @thenUpdateResults.bind(@)
    )

  commands:
    findSuggestions: (input) ->
      @injectScript()

      if input.length >= @SUGGEST_MIN_LENGTH
        @getPlacePrediction(input)
      else
        @command 'resetSuggestions'

    resetSuggestions: ->
      @setStore suggestions: []

    setChosenAddressByIndex: (index) ->
      return unless @placesService? and _.some(@store.suggestions)
      @placesService.getDetails(
        placeId: @store.suggestions[index].place_id
        @thenSetChosenAddress.bind(@)
      )

    resetChosenAddress: ->
      @setStore chosenAddress: null


module.exports = PlacesDispatcher
