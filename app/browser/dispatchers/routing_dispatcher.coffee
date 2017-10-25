[
  _
  Radio

  Backbone
  BaseDispatcher
  Logger
  Router
  Url
] = [
  require 'lodash'
  require 'backbone.radio'

  require '../../common/backbone/backbone'
  require '../../common/dispatchers/base_dispatcher'
  require '../logger'
  require '../../common/utils/router'
  require '../../common/utils/url'
]

CACHE_TTL = 12 * 60 * 60 * 1000  # 12 hours.

class PrefetchedModel extends Backbone.BaseModel
  # This model persists in localStorage to prevent redundant prefetching of
  # bundles.
  initialize: ->
    @sessionStart(
      name: 'prefetch-bundles'
      ttl: CACHE_TTL
    )

class RoutingDispatcher extends BaseDispatcher
  log = Logger.get('RoutingDispatcher').log

  channel: -> 'routing'

  events: ->
    'sync routes': @onRoutesSync

  models: ->
    prefetched: new PrefetchedModel

  collections: ->
    environment = @environment or {}

    class RoutesCollection extends Backbone.BaseCollection
      url: ->
        if environment.debug
          "/assets/data/routes.json?v=#{environment.revision}"
        else
          "/assets/#{environment.revision}/data/routes.json"

    routes: { class: RoutesCollection }

  shouldAlwaysWake: -> true

  getInitialStore: ->
    isAvailable: false
    isLoading: true
    initial: _.get @appState, 'location'
    current: _.get @appState, 'location'
    prefetchRules: {}

  wake: ->
    return unless @isRoutingSupported()
    @collection('routes').fetch()

  removeListeners: ->
    window.document.removeEventListener 'click', @onDocumentClick
    window.removeEventListener 'popstate', @onPopState

  setupListeners: ->
    window.document.addEventListener 'click', @onDocumentClick
    window.addEventListener 'popstate', @onPopState

  handlePageTitleChange: ->
    @setStore(
      'current.location.title'
      _.get @appState, 'location.title'
      silent: true
    )

  handleLocationChange: ->
    prevLocation = @store.current
    nextLocation = _.get @appState, 'location'

    @getChannel().trigger 'locationWillChange', nextLocation, prevLocation
    @replaceStore current: _.get @appState, 'location', previous: @store.current
    @getChannel().trigger 'locationDidChange', nextLocation, prevLocation
    _.defer @prefetchBundles.bind(@)

  isRoutingSupported: ->
    return false unless window? and document? and location?
    return false unless window.addEventListener? and window.history?
    return false unless window.history.pushState?
    true

  setupRouter: (routes) -> @router = new Router(routes)

  prefetchBundles: ->
    # Each time the route changes, determine if any bundles should be
    # prefetched. Right now, this is only JavaScript, but in the future, we'll
    # also bundle our CSS.
    environment = @environment or {}
    currentPath = _.get @store, 'current.pathname', null
    prefetched = @model('prefetched')
    hostname = @getLocale('static_hostname')

    bundles = _.reduce @store.prefetchRules, (result, matchers, bundleName) ->
      _.each matchers, (matcher) ->
        if matcher.test(currentPath)
          if environment.debug
            src = "//#{hostname}/assets/js/bundles/#{bundleName}.js?v=#{environment.revision}"
          else
            src = "//#{hostname}/assets/#{environment.revision}/js/bundles/#{bundleName}.js"

          bundle =
            key: "#{bundleName}-#{environment.revision}"
            name: bundleName
            src: src
          if not prefetched.get(bundle.key)
            log 'prefetching bundle:', bundle.key
            result.push bundle
            false
      result
    , []

    _.each bundles, (bundle) =>
      prefetched.set "#{bundle.key}": new Date().getTime()
      @commandDispatcher 'scripts', 'load', bundle

  setupPrefetchRules: (routes) ->
    # Generates a list of matchers that are used to determine what bundles to
    # prefetch (if any) on a given route.
    @setStore prefetchRules: _.reduce routes, (result, route) ->
      return result if _.isEmpty(route.asyncPrefetch)
      _.each route.asyncPrefetch, (match) ->
        if _.isString(match)
          regExp = new RegExp(match)
        else if _.isRegExp(match)
          regExp = match
        else
          regExp = null
        result[route.bundleFile] or= []
        result[route.bundleFile].push regExp
      result
    , {}

  setupHistory: ->
    @history = [
      _.assign(@router.route(window.location.href), scrollTo: { x: 0, y: 0 })
    ]

  isPreviousRoute: (route) ->
    if @history.length > 1
      _.get(@history, '[1].url.href') is _.get(route, 'url.href')
    else
      false

  doNavigate: (route, options = {}) ->
    _.defaults options,
      pushState: true
      scrollTo: { x: 0, y: 0 }

    currentScrollTo = { x: window.scrollX, y: window.scrollY }

    log 'location change',
      path: route.url.href
      component: route.component
      route: route

    if history.state
      # Update scroll position.
      replaceState = _.assign history.state, scrollTo: currentScrollTo
      @history[0] = replaceState
      window.history.replaceState replaceState, null, window.location.href

    if options.pushState
      if @isPreviousRoute(route)
        # If we're heading to a previous route, restore the scroll position.
        options.scrollTo = @history[1].scrollTo

      state = _.assign route, scrollTo: options.scrollTo
      @history = [state].concat @history
      window.history.pushState state, null, route.url.href
    else
      @history = @history.slice(1)

    location = _.assign Url.parse(route.url.href), _.omit(route, 'url', 'path'),
      scrollTo: options.scrollTo
      method: 'get'
      route: route.path

    @changeLocation location

  changeLocation: (newLocation) ->
    @setAppState(location: _.assign newLocation, visibleBeforeMount: true)
    @handleLocationChange()

  onRoutesSync: ->
    routes =  @data('routes')

    @setupRouter(routes)
    @setupPrefetchRules(routes)
    @setupHistory()
    @setupListeners()
    _.defer @prefetchBundles.bind(@)
    @setStore isAvailable: true, isLoading: false

  onDocumentClick: (evt) =>
    # Because this click handler can conflict with click handlers at the
    # component level, we should plan to remove it in favor of the Link
    # component, especially when navigating within a bundle. The Link component
    # can use the `navigate` request below to achieve the same effect. Until we
    # can remove `document` click handler altogether, use the `data-link`
    # attribute on Link to signal to this handler to ignore it.
    target = evt.target

    # Crawl up the DOM until we find an href eligible element.
    until not target.parentNode? or target.tagName in ['BODY', 'A']
      target = target.parentNode

    if target.tagName is 'A' and target.href and not target.dataset?.link
      return if (evt.shiftKey or evt.altKey or evt.metaKey or evt.ctrlKey)

      routability = @router.checkRoutability(location.href, target.href)

      if routability.routable
        evt.preventDefault()
        @doNavigate(routability.target)
      else
        log 'not routing', target.href, '=>', reason: routability.reason

    return

  onPopState: (evt) =>
    route = @router.route(location.href)

    options = pushState: false

    if evt.state?.scrollTo?
      _.assign options, scrollTo: evt.state.scrollTo

    @doNavigate(route, options) if route?
    return

  requests:
    parse: (location) -> Url.parse location

    location: -> _.get @appState, 'location'

    queryString: (name) ->
      param = _.get Url.parse(document.location.href), "query.#{name}"
      if param? then decodeURIComponent(param) else null

  commands:
    navigate: (url, options = {}) ->
      if @router?
        # If @router doesn't exist, we haven't loaded routes.json yet.
        routability = @router.checkRoutability(location.href, url)

        if routability.identical
          return
        if routability.routable
          @doNavigate(routability.target)
          return

      # Fallback to not using pushState.
      location.href = url

    replaceState: (url) ->
      if history?.replaceState?
        history.replaceState {}, null, url

    stop: ->
      @removeListeners()

    showErrorPage: (options = {}) ->
      _.defer( =>
        # Wait until call stack clear
        # so it isn't called during `render`.
        @changeLocation(
          component: 'PagesError'
          error:
            message: options.message or 'Internal Server Error'
            statusCode: options.statusCode or 500
        )
      )

module.exports = RoutingDispatcher
