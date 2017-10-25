[
  _

  Logger
  Benchmark
] = [
  require 'lodash'

  require './logger'
  require './utils/benchmark'
]

log = Logger.get("Dispatchers").log

module.exports =
  browser:
    # Browser only dispatchers.
    []

  common: [
    # Common dispatchers. These will be initialized on the server. If a
    # dispatcher's behavior is browser-specific, don't put it here.
    require './dispatchers/account_dispatcher'
    require './dispatchers/appointments_dispatcher'
    require './dispatchers/birthday_dispatcher'
    require './dispatchers/cart_dispatcher'
    require './dispatchers/checkout_dispatcher'
    require './dispatchers/config_dispatcher'
    require './dispatchers/content_dispatcher'
    require './dispatchers/editions_product_dispatcher'
    require './dispatchers/eligibility_survey_dispatcher'
    require './dispatchers/estimate_dispatcher'
    require './dispatchers/favorites_dispatcher'
    require './dispatchers/fetch_dispatcher'
    require './dispatchers/frame_gallery_dispatcher'
    require './dispatchers/frame_product_dispatcher'
    require './dispatchers/gift_card_dispatcher'
    require './dispatchers/home_try_on_dispatcher'
    require './dispatchers/jobs_dispatcher'
    require './dispatchers/landing_page_dispatcher'
    require './dispatchers/navigation_dispatcher'
    require './dispatchers/personalization_dispatcher'
    require './dispatchers/prescription_check_dispatcher'
    require './dispatchers/prescription_dispatcher'
    require './dispatchers/quiz_dispatcher'
    require './dispatchers/regions_dispatcher'
    require './dispatchers/retail_dispatcher'
    require './dispatchers/session_dispatcher'
    require './dispatchers/variations_dispatcher'
  ]

  initializeNext: ->
    DispatcherClass = @dispatchersList[@index]
    channelName = _.result(DispatcherClass.prototype, 'channel')

    instance = @benchmarkInitialize.async channelName, ->
      new DispatcherClass(@appState)
    , @

    @instances[channelName] = instance

    @index += 1

    if @index < _.size(@dispatchersList)
      if @noDefer
        @initializeNext()
      else
        _.defer @initializeNext.bind(@)
    else
      log 'initialized'
      @benchmarkInitialize.end()
      @benchmarkReady = @benchmark.time 'ready'
      @channels = _.keys(@instances)
      _.defer @readyNext.bind(@)

  readyNext: ->
    dispatcher = @instances[@channels.pop()]
    channelName = _.result(dispatcher, 'channel')
    @benchmarkReady.async channelName, -> dispatcher.ready()

    if _.size(@channels) is 0
      log 'ready'
      @benchmarkReady.end()
      @benchmark.end()
      @callback()
    else
      if @noDefer
        @readyNext()
      else
        _.defer @readyNext.bind(@)

  browserInitialize: (@appState, @noDefer, @callback) ->
    @benchmark = Benchmark.time name: 'dispatchers'
    @benchmarkInitialize = @benchmark.time name: 'initialize'

    @instances = {}
    @index = 0
    @dispatchersList = @browser.concat(@common)

    if @noDefer
      @initializeNext()
    else
      _.defer @initializeNext.bind(@)

    @instances

  serverInitialize: (appState, benchmark) ->
    benchmark = (benchmark or Benchmark).time 'dispatchers'
    instances = {}

    dispatchersList = @common
    stores = _.reduce _.get(appState, 'location.stores'), (result, name) ->
      result[name] = true
      result
    , {}

    _.each dispatchersList, (DispatcherClass) ->
      # Construct new instances of each dispatcher.
      shouldAlwaysWake = _.result(DispatcherClass.prototype, 'shouldAlwaysWake')
      channelName = _.result(DispatcherClass.prototype, 'channel')

      if shouldAlwaysWake or stores[channelName]
        dispatcherInstance = benchmark.time _.kebabCase(channelName), ->
          new DispatcherClass(appState)
        channelName = _.camelCase _.result(dispatcherInstance, 'channel')
        instances[channelName] = dispatcherInstance
      return

    benchmark.end()
    instances
