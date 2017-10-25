[
  _
  Boom

  Logger
  Radio
  Backbone
  Backbone.Cache

  Mixins
] = [
  require 'lodash'
  require 'boom'

  require '../logger'
  require '../radio'
  require '../backbone/backbone'
  require '../backbone/cache'

  require './mixins/mixins'
]

class Store extends Backbone.BaseModel

class BaseDispatcher
  log = Logger.get('BaseDispatcher').log

  constructor: (@appState) ->
    channelName = _.result @, 'channel'

    if not _.isString(channelName)
      throw new Error('Dispatcher must define a channel')

    @environment = _.get @appState, 'config.environment'

    @isAwake = false
    @storeListeners = 0

    return unless @shouldInitialize()

    @__applyMixins()

    @backboneWillInitialize() if _.isFunction(@backboneWillInitialize)

    @__models = _.mapValues(
      _.result(@, 'models') or {}
      @__getBackboneInstance.bind(@)
    )

    @__collections = _.mapValues(
      _.result(@, 'collections') or {}
      @__getBackboneInstance.bind(@)
    )

    @backboneDidInitialize() if _.isFunction(@backboneDidInitialize)

    @storeWillInitialize() if _.isFunction(@storeWillInitialize)

    @__store = new Store(_.result @, 'getInitialStore', null)

    if @environment.browser
      channel = @getChannel()
      debugChannels = false

      # Map requests to the dispatcher's channel.
      requests = _.result @, 'requests', {}
      _.each requests, (requestFunc, name) =>
        channel.reply name, ->
          if debugChannels
            Logger.get(@loggerContext()).log "request", name, arguments
          # All requests are wrapped here to ensure the Dispatcher was
          # woken up first.
          channel.request '__wakeOnRequest'
          requestFunc.apply @, arguments
        , @

      # Dispatchers should always reply to a 'store' request.
      channel.reply 'store', @__onRequestStore, @

      # Map commands to the dispatcher's channel when in the browser. Commands
      # are not used on the server.
      commands = _.result @, 'commands', {}
      _.each commands, (complyFunc, name) =>
        channel.reply name, ->
          if debugChannels
            Logger.get(@loggerContext()).log "command", name, arguments
          # All commands are wrapped here to ensure the Dispatcher was
          # woken up first.
          channel.request '__wakeOnCommand'
          complyFunc.apply @, arguments
        , @

      # Log available commands.
      commandList = _.keys(commands)
      if _.some(commandList)
        Logger.get(@loggerContext()).log(
          "registered #{_.size commandList} command(s)", commandList
        )

      channel.replyOnce '__wakeOnCommand', @__doWake.bind(@, command: true), @
      channel.replyOnce '__wakeOnRequest', @__doWake.bind(@, request: true), @
      channel.replyOnce '__wakeOnStore',   @__doWake.bind(@,   store: true), @

      @__store.on 'change', ->
        @storeWillChange.apply(@, arguments)
        @__handleStoreChange.apply(@, arguments)
        @storeDidChange.apply(@, arguments)
      , @

    @store = @getStoreData()

    @storeDidInitialize() if _.isFunction(@storeDidInitialize)

    if @environment.server
      # Push store data onto appState when on the server.
      _.set @appState, "stores.#{channelName}", @getStoreData()

    @initialize() if _.isFunction(@initialize)

  __getBackboneInstance: (options) ->
    return options unless _.isPlainObject(options)

    _.defaults options, alwaysFetch: false

    instance = new options.class()
    url = _.result instance, 'url', ''

    prefetched = _.get(@appState, 'api.prefetched', {})
    prefetchedData = prefetched[url]

    if _.startsWith url, '/api/v2/cached'
      # Use prefetched non-cached data if using cached endpoint.
      prefetchedData = prefetched[url.replace('/api/v2/cached', '/api/v2')]

    if prefetchedData?
      instance = new options.class(prefetchedData, parse: true)
      instance.fetched = true
      instance.fetchedAt = Date.now()
      ttl = _.result options, 'ttl'
      if ttl > 0
        instance.cacheTTL = -> ttl
    else if options.alwaysFetch
      instance.fetch()

    instance

  __applyMixins: ->
    mixins = _.result(@, 'mixins', [])
    _.each mixins, (name) =>
      mixin = Mixins[name]
      _.each mixin, (value, name) =>
        if _.isFunction(value)
          @[name] = value.bind(@)
        else
          @[name] = value
        return
      return

  __doWake: (options = {}) ->
    return if @isAwake
    @isAwake = true

    @__fetchOnWake()
    Logger.get(@loggerContext()).log 'waking up', "[#{_.first(_.keys(options))}]"

    # Allow dispatchers to subscribe to changes on other dispatchers.
    storeChangeHandlers = _.result @, 'getStoreChangeHandlers', {}
    _.each storeChangeHandlers, (funcs, channelName) =>
      funcs = [funcs] if not _.isArray(funcs)
      _.each funcs, (func) =>
        func = @[func].bind(@) if _.isString(func)
        Radio.channel(channelName).on 'change', func

    # Wake associated Dispatchers.
    _.each _.keys(storeChangeHandlers), (channelName) ->
      Radio.channel(channelName).request '__wakeOnStore'

    @wake(options)
    @__setupEvents()

    # Setup routing listeners.
    channelName = _.result @, 'channel'
    if channelName isnt 'routing'
      Radio.channel('routing').on 'locationWillChange', @locationWillChange, @
      Radio.channel('routing').on 'locationDidChange', @locationDidChange, @

  __onRequestStore: ->
    # When the store is requested from a component or dispatcher, ensure this
    # dispatcher is awake and then return the store.
    @getChannel().request '__wakeOnStore'
    @getStoreData()

  __fetchOnWake: ->
    # Fetch models and collections if `fetchOnWake` option is truthy.
    _.mapValues _.result(@, 'models') or {}, (options, name) =>
      route = _.get options.fetchOnWake, 'route'
      shouldFetch = options.fetchOnWake and not @model(name).isFetched()

      if route and route isnt @currentLocation().pathname
        shouldFetch = false

      if shouldFetch
        modal = _.get options.fetchOnWake, 'modal'
        if modal
          options = _.assign mode: 'loading', _.omit options.fetchOnWake, 'modal'
          @commandDispatcher 'modals', 'show', _.assign(id: modal, options)
        Logger.get(@loggerContext()).log 'fetchOnWake:', "'#{name}'", 'model'
        @model(name).fetch()
      return

    _.mapValues _.result(@, 'collections') or {}, (options, name) =>
      route = _.get options.fetchOnWake, 'route'
      shouldFetch = options.fetchOnWake and not @collection(name).isFetched()

      if route and route isnt @currentLocation().pathname
        shouldFetch = false

      if shouldFetch
        modal = _.get options.fetchOnWake, 'modal'
        if modal
          options = _.assign mode: 'loading', _.omit options.fetchOnWake, 'modal'
          @commandDispatcher 'modals', 'show', _.assign(id: modal, options)
        Logger.get(@loggerContext()).log 'fetchOnWake:', "'#{name}'", 'collection'
        @collection(name).fetch()
      return

  __setupEvents: ->
    # Bind event callbacks on models and collections to dispatcher functions.
    events = _.result(@, 'events') or {}

    _.each events, (method, key) =>
      method = @[method] if not _.isFunction(method)
      if method
        split = key.split(' ')
        eventNames = _.take(split, split.length - 1).join(' ')
        objectName = _.last(split)
        object = @__models[objectName] or @__collections[objectName]
        object.on eventNames, method, @
      return

    # Bind window events to dispatcher functions
    if @environment.browser
      windowEvents = _.result(@, 'windowEvents') or {}

      _.each windowEvents, (method, key) =>
        method = @[method] if not _.isFunction(method)
        if method
          window.addEventListener(key, method.bind(@))

  __handleStoreChange: ->
    oldStore = @store
    @store = @getStoreData(refresh: true)
    Logger.get(@loggerContext()).log 'storeChange', @store
    @getChannel().trigger 'change', @store, oldStore
    return

  wake: (options) ->
    # `wake` is called in the following ways, and only in the browser.
    #
    # 1. If `shouldAlwaysWake` is truthy.
    # 2. If another script (typically a dispatcher or a component)
    #    does a request over this dispatcher's radio channel.
    # 3. If another script issues a command over this dispatcher's radio
    #    channel.

  ready: ->
    if @environment.browser
      @__doWake(always: true) if _.result(@, 'shouldAlwaysWake', false)

  models: ->
    #
    # cart: { class: CartModel, fetchOnWake: { modal: 'fetchCart' } }
    #
    # session: { class: SessionModel, fetchOnWake: true }
    {}

  model: (name) ->
    @__models[name]

  collections: ->
    {}

  shouldInitialize: ->
    # Can be overridden to prevent the dispatcher from initializing on
    # pages it isn't used or needed on.
    true

  collection: (name) ->
    @__collections[name]

  data: (name, options) ->
    if @__models[name]?
      @__models[name].toJSON(options)
    else if @__collections[name]?
      @__collections[name].toJSON(options)

  getStoreData: (options = {}) ->
    _.defaults options, refresh: false
    if not @__storeData? or options.refresh
      @__storeData = @__store.toJSON()
    @__storeData

  getStore: (name) ->
    Radio.channel(name).request('store')

  setStore: (key, val, options) ->
    @__store.set key, val, options

  replaceStore: (key, val, options) ->
    @__store.replace key, val, options

  getChannel: (name) ->
    name = _.camelCase(_.result @, 'channel') if not name?
    Radio.channel(name)

  navigate: (path, options = {}) ->
    @commandDispatcher 'routing', 'navigate', path, options
    return

  matchesCurrentPath: (paths) ->
    paths = [paths] unless _.isArray(paths)
    currentPath = @currentLocation().pathname
    for path in paths
      return false unless path
      return true if currentPath.match(path)
    false

  setPageTitle: (validPaths, title) ->
    if @environment.browser
      @commandDispatcher 'layout', 'setPageTitle', validPaths, title
    else
      @setAppState('location.title', title) if @matchesCurrentPath(validPaths)

  inExperiment: (name, variant) ->
    state = @getExperimentState name
    state.participant and state.variant is variant

  getExperimentState: (name) ->
    experiments = _.get @appState, 'experiments'
    experimentId = _.get experiments, "nameMapId.#{name}"
    _.get experiments, "active.#{experimentId}.state", {}

  getExperimentVariant: (name) ->
    state = @getExperimentState name
    if state.participant then state.variant else null

  getVariationPath: (path) ->
    # Replace variation path with override if available.
    rewrite = _.get @appState, "location.apiRewrites[/api/v2/variations#{path}]"
    if rewrite? then rewrite.replace('/api/v2/variations', '') else path

  getLocale: (item) ->
    if item
      _.get @appState, "locale.#{item}"
    else
      _.get @appState, 'locale'

  modifier: (feature, defaultValue = false) ->
    _.get @appState, "modifiers.#{feature}", defaultValue

  currentLocation: ->
    # "hash": null,
    # "host": "www.warbyparker.com",
    # "hostname": "www.warbyparker.com",
    # "href": "https://www.warbyparker.com/account/orders/501718714?hello=1",
    # "pathname": "/account/orders/501718714",
    # "port": null,
    # "protocol": "https:",
    # "search": "?hello=1",
    # "domain": "warbyparker.com",
    # "query": {
    #   "hello": "1"
    # },
    # "route": "/account/orders/{order_id}",
    # "method": "get",
    # "params": {
    #   "order_id": "501718714"
    # },
    # "layout": "default",
    # "component": "PagesCustomerCenterOrdersOrderShow",
    # "title": "Your Order #501718714",
    # "stores": [
    #   "account"
    # ]
    if @environment.browser
      @requestDispatcher 'routing', 'location'
    else
      _.get @appState, 'location'

  loggerContext: ->
    "#{_.upperFirst _.camelCase(_.result @, 'channel')}Dispatcher"

  locationWillChange: (nextLocation, prevLocation) ->

  locationDidChange: (nextLocation, prevLocation) ->

  storeWillChange: (nextStore, prevStore) ->

  storeDidChange: (nextStore, prevStore) ->

  setAppState: (key, val) ->
    Logger.get(@loggerContext()).log 'setAppState', key, val

    if _.isObject(key)
      _.assign @appState, key
    else
      _.set @appState, key, val

    Radio.channel('appState').trigger('change') if @environment.browser
    return

  pushEvent: (options) ->
    # Convenience method for pushing a `wp.event` to Google Tag Manager through
    # the AnalyticsDispatcher.
    options = name: options if _.isString(options)
    Logger.get(@loggerContext()).log 'pushEvent', options
    @commandDispatcher 'analytics', 'pushEvent', options

  getFeature: (feature) ->
    _.get @getLocale(), "features.#{feature}"

  command: ->
    # Send a command to this dispatcher.
    # Deprecated in favor of requestÏ.
    this.request.apply(this, arguments)

  request: ->
    # Make a request to this dispatcher.
    channel = @getChannel()
    channel.request.apply channel, arguments

  commandDispatcher: (channelName) ->
    # Send a command to another dispatcher.
    # Deprecated in favor of requestDispatcher.
    this.requestDispatcher.apply(this, arguments)

  requestDispatcher: (channelName) ->
    # Make a request to another dispatcher.
    channel = Radio.channel(channelName)
    channel.request.apply channel, _.tail(arguments)

  throwError: (options = {}) ->
    _.defaults options, statusCode: 500

    if @environment.server
      throw Boom.create(options.statusCode, options.message)
    else
      Radio.channel('routing').request 'showErrorPage', options

  inHtoMode: ->
    if @environment.browser
      Boolean(@requestDispatcher 'cookies', 'get', 'htoMode')
    else
      Boolean(_.get @appState, "requestCookies.#{@getLocale 'cookie_prefix'}htoMode")

  getVariationQueryString: (path) ->
    q = @appState.location.query or {}
    # Fetch the specified CMS revision, if requested
    if path is "/#{q['cms_preview']}"
      "?version=#{q['version']}&access_token=#{q['access_token']}"
    else
      ''

  getCookie: (name) ->
    # For accessing cookies on both browser and server.
    # Cookie must be whitelisted in the base handler to get it in appState
    if @environment.browser
      @requestDispatcher 'cookies', 'get', name
    else
      _.get @appState, "requestCookies.#{@getLocale 'cookie_prefix'}#{name}"

module.exports = BaseDispatcher
