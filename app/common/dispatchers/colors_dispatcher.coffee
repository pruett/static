[
  _
  Backbone

  Logger
  BaseDispatcher
  ColorsCollection
] = [
  require 'lodash'
  require '../backbone/backbone'

  require '../logger'
  require './base_dispatcher'
  require '../backbone/collections/colors_collection'
]

log = Logger.get('ColorsDispatcher').log

class ColorsDispatcher extends BaseDispatcher

  channel: -> 'colors'

  collections: ->
    colors:
      class: ColorsCollection
      fetchOnWake: true

  events: ->
    'sync colors': @onColorsSync

  onColorsSync: ->
    @setStore __fetched: @collection('colors').isFetched(),
      swatches: @data('colors')


module.exports = new ColorsDispatcher
