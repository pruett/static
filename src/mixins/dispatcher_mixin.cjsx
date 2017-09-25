[
  _
  Radio
] = [
  require 'lodash'
  require 'backbone.radio'
]

module.exports =
  # We use a standard pattern for retrieving Store data from Dispatchers and
  # receiving Store data changes.
  #
  # 1. All Stores should be objects.
  # 2. The initial data for any store should be retrieved over the appropriate
  #    channel via a `Channel.request('store')` request.
  # 3. Updates to the store are dispatched on the same channel, via a
  #    `Channel.trigger('change')` event.
  #
  __handleStoreChange: (name, nextStore) ->
      stores = _.get @state, 'stores', {}
      stores[name] = nextStore
      @setState stores: stores

  __getVariationPath: (path) ->
    rewrite = _.get @props, "appState.location.apiRewrites[/api/v2/variations#{path}]"
    if rewrite? then rewrite.replace('/api/v2/variations', '') else path

  componentWillMount: ->
    # Keep a reference to channel listeners, so we can clean up when the
    # component unmounts.
    @__listeners = {}

    stores = {}
    inBrowser = window?

    # Allows a component receive store changes, which are applied to the
    # component state on the `stores` key.
    #
    # Usage:
    #
    # receiveStoreChanges: -> [
    #   'cart'
    #   'analytics'
    # ]
    #
    channels = _.result(@, 'receiveStoreChanges') or []
    variations = _.map _.result(@, 'fetchVariations', []), @__getVariationPath

    _.each variations, (path) =>
      channels.push 'variations'
      @commandDispatcher 'variations', 'fetch', path

    channels = _.uniq(channels)

    _.each channels, (name) =>
      @__listeners[name] = []
      @__listeners[name].push @__handleStoreChange.bind(@, name)

      if inBrowser
        stores[name] = @requestDispatcher(name, 'store')
      else
        # Preferentially get store data from top-level application state. This
        # is always how components on the server populate store data.
        stores[name] = _.get @props, "appState.stores.#{name}"

    if inBrowser
      storeChangeHandlers = _.result(@, 'getStoreChangeHandlers') or {}
      # Allows a component to setup one or more callbacks when a store changes.
      #
      # Usage:
      #
      # getStoreChangeHandlers: ->
      #   cart: 'handleChangeCart'
      #   kittens: ['awwHandler', @anotherCuteHandler]
      #
      _.each storeChangeHandlers, (funcs, name) =>
        @__listeners[name] ?= []
        funcs = [funcs] if not _.isArray(funcs)
        _.each funcs, (func) =>
          func = @[func] if _.isString(func)
          @__listeners[name].push func

      _.each @__listeners, (listeners, name) =>
        _.each listeners, (func) =>
          @onDispatcherEvent name, 'change', func, @

    @setState stores: stores

  componentWillUnmount: ->
    _.each @__listeners, (listeners, name) =>
      _.each listeners, (func) =>
        @offDispatcherEvent name, 'change', func, @
    delete @__listeners

  getStore: (name) ->
    # Convenience method so that you can guarantee you get an Object back when
    # working with store data.
    _.get @state, "stores.#{name}", {}

  onDispatcherEvent: (name) ->
    channel = Radio.channel(name)
    channel.on.apply channel, _.tail(arguments)

  offDispatcherEvent: (name) ->
    channel = Radio.channel(name)
    channel.off.apply channel, _.tail(arguments)

  commandDispatcher: (name) ->
    # Deprecated in favor of requestDispatcher.
    this.requestDispatcher.apply(this, arguments)

  requestDispatcher: (name) ->
    channel = Radio.channel(name)
    channel.request.apply channel, _.tail(arguments)

  getContentVariation: (path, variantKey) ->
    variants = @getAllVariants path

    return if _.isEmpty variants

    # Get fallback based on experiments running on page.
    fallback = _.get variants, variants.__fallbackKey, variants.default

    # Return variant if requested, else return fallback.
    unless variantKey then fallback else _.get variants, variantKey, fallback

  getAllVariants: (path) ->
    _.get @getStore('variations'), @__getVariationPath path
