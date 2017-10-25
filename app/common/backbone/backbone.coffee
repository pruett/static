[
  _
  Backbone
  Backbone.ajax
  Backbone.DeepModel
  Backbone.Validation

  Backbone.Labels
  Backbone.Cache
] = [
  require 'lodash'
  require 'exoskeleton'
  require 'backbone.nativeajax'
  require 'backbone-deep-model'
  require 'backbone-validation'

  require './labels'
  require './cache'
]

class BaseModel extends Backbone.DeepModel
  # Shared functionality across our Backbone Models.
  isFetched: -> Boolean(@fetched)

  constructor: (attrs, options = {}) ->
    super()
    permittedAttributes = _.result(@, 'permittedAttributes')
    if permittedAttributes and not options.permitAllAttributes
      attrs = _.pick attrs, permittedAttributes
    _.assign @, Backbone.Validation.mixin
    super(attrs, options)

  permittedAttributes: ->
    # Whitelist attributes on the model by returning an array of attribute
    # names.
    null

  toJSON: (options = {}) ->
    _.defaults options, onlyPermitted: true

    attrs = _.clone(@attributes or options.attrs)

    if options.onlyPermitted
      permittedAttributes = _.result(@, 'permittedAttributes')

      if permittedAttributes
        attrs = _.pick attrs, permittedAttributes

    attrs

  replace: (key, val, options = {}) ->
    # The difference between `replace` and `set` is subtle, because the default
    # behavior of `set` is actually to **merge**.
    #
    # Using `set`:
    #
    # class Person extends Backbone.BaseModel
    #
    # person = new Person(name: { first: 'Foo' })
    # person.set name: { last: 'Bar' }
    # person.toJSON() => name: { first: 'Foo', last: 'Bar' }
    #
    # Using `replace`:
    #
    # person = new Person(name: { first: 'Foo', last: 'Bar' })
    # person.replace name: { full_name: 'Foo Bar' }
    # person.toJSON() => name: { full_name: 'Foo Bar' }
    #
    if _.isObject(key)
      attrs = key
      options = val or {}
    else
      (attrs = {})[key] = val

    for attr, value of attrs
      @set attr, null, silent: true

    @set attrs, options

class BaseCollection extends Backbone.Collection
  # Shared functionality across our Backbone Collections.
  isFetched: -> Boolean(@fetched)

  cachePrefix: ->
    # If you need to namespace your cached data.
    'collections'

mixins =
  api:
    apiHost: -> ''
    apiPath: -> 'api/v2'
    apiBaseUrl: (path='') -> [
      _.result(@, 'apiHost')
      _.result(@, 'apiPath')
      path
    ].join('/')

  session:
    # Session
    # =======
    sessionKey: ->
      # A unique key for cache retrieval, you should not have to overload
      # this method unless you know what you're doing.
      "#{@__sessionDetails.prefix}[#{@__sessionDetails.name}]"

    sessionClear: ->
      Backbone.Cache.clear @sessionKey()

    sessionStart: (options = {}) ->
      # Return if no name supplied or TTL less than 0.
      return if _.isEmpty options.name or not _.gt(options.ttl, 0)

      @__sessionDetails = _.defaults options,
        # If you need to namespace your cached data.
        prefix: 'session'
        # Anything retrieved from the cache must match this version, or it
        # will be discarded.
        version: 0

      key = @sessionKey()
      {name, prefix, version, ttl} = @__sessionDetails

      @set Backbone.Cache.get(key, version)

      @on 'change', (model) ->
        Backbone.Cache.set(key, version, model.toJSON(), ttl)

  cacheable:
    # Caching
    # =======
    #
    # It's helpful to be able to bypass the delay and overhead
    # involved with making XHR's to the server for unchanged data.
    #
    cacheTTL: ->
      # If cacheTTL is greater than 0, localStorage will be used to
      # cache the request for this amount of milliseconds.
      #
      # In most cases, this is the only function the subclass needs
      # to implement.
      0

    cachePrefix: ->
      # If you need to namespace your cached data.
      'models'

    cacheMethod: ->
      # The method of caching, either localStorage or sessionStorage.
      'local' # local|session

    cacheVersion: ->
      # Anything retrieved from the cache must match this version, or it
      # will be discarded. Useful for changes in the request/response
      # format or for forcing cache-busting across all clients.
      0

    cacheKey: ->
      # A unique key for cache retrieval, you should not have to overload
      # this method unless you know what you're doing.
      "#{_.result(@, 'cachePrefix')}[#{_.result(@, 'url')}]"

    sync: (method, object, options = {}) ->
      # Overload the `sync` method and check Backbone.Cache for cached data.
      _.defaults options, cache: true

      ttl = _.result(object, 'cacheTTL') or 0

      if options.cache and method is 'read' and ttl > 0
        url = _.result(object, 'url') or options.url
        type = _.result(object, 'cacheMethod')
        key = _.result(object, 'cacheKey')
        version = _.result(object, 'cacheVersion')

        unless options.forceReload
          cachedResponse = Backbone.Cache.get(key, version)

          if cachedResponse
            _.defer ->
              object.trigger('request', object, {}, options)
              options.success(cachedResponse)
            return

        delete options.forceReload

        options = if options then _.clone(options) else {}
        missSuccess = options.success
        options.success = (resp) ->
          object.fetched = true
          object.fetchedAt = Date.now()
          Backbone.Cache.set(key, version, resp, ttl)
          missSuccess(resp) if missSuccess
          return

      if XMLHttpRequest?
        # On the server, there's no XMLHttpRequest, so don't do this.
        options = if options then _.clone(options) else {}
        success = options.success
        options.success = (resp) ->
          object.fetched = true
          object.fetchedAt = Date.now()
          success(resp) if success
          return
        Backbone.sync.call(@, method, object, options)

      return

_.assign BaseModel.prototype,
  mixins.cacheable
  mixins.api
  mixins.session

_.assign BaseCollection.prototype,
  mixins.cacheable
  mixins.api
  cachePrefix: 'collections'

Backbone.BaseCollection = BaseCollection
Backbone.BaseModel = BaseModel

module.exports = Backbone
