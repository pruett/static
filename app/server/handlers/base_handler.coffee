[
  _
  Boom
  KeyMirror
  Request
  UAParser

  ApiService
  Benchmark
  ContentCacheService
  Cookies
  Experiments
  Layouts
  Logger
  Metrics
  Stringify
  Timing
  Url
  Personalization
] = [
  require 'lodash'
  require 'boom'
  require 'keymirror'
  require 'request'
  require 'ua-parser-js'

  require 'hedeia/server/services/api_service'
  require 'hedeia/common/utils/benchmark'
  require 'hedeia/server/services/content_cache_service'
  require 'hedeia/server/utils/cookies'
  require 'hedeia/common/utils/experiments'
  require 'hedeia/server/layouts/layouts'
  require 'hedeia/server/logger'
  require 'hedeia/server/utils/metrics'
  require 'hedeia/common/utils/stringify'
  require 'hedeia/server/utils/timing'
  require 'hedeia/common/utils/url'
  require 'hedeia/common/utils/personalization'
]

ALLOWED_METHODS = KeyMirror(
  get: null,  post: null,  put: null,  delete: null,  options: null,  head: null
)

COOKIE_EXPERIMENTS_SEED = 'wp-seed'
COOKIE_EXPERIMENTS_BUCKETED = 'wp-bucketed'

falsy = (value) -> "#{value}".toLowerCase() in ['false', '0', 'no', 'off']
truthy = (value) -> "#{value}".toLowerCase() in ['true', '1', 'yes', 'on']

class BaseHandler
  logDescription: -> "#{@request.method.toUpperCase()} #{@path}"

  constructor: (@request, @reply, options = {}) ->
    handlerName = _.result(@, 'name')

    if not _.isString(handlerName)
      throw new Error('Handler must define a name')

    @log = Logger.get("#{handlerName}Handler", file: __filename).log
    @benchmark = Benchmark.time "handlers.#{_.kebabCase handlerName}"
    @contentCache = false
    @path = @request.path
    @host = @request.headers.host.toLowerCase()
    @locale = @__getLocaleFromHost(@host)
    @modifiers = @__getModifiers()
    @isApplePayCapable = false
    @isNativeAppCapable = false
    @options = _.defaults options,
      prefetch: true  # Toggle API prefetching (doesn't affect global prefetch).
      renderAppStateOnly: false  # Dump server-side application state.
      render: true
      cacheFlush: false
      cacheSkip: false
      title: ''
      testMode: false
      stores: []
      visibleBeforeMount: false
      disableTags: []
      prefetchOptions: _.assign(
        timeout: 2000
        _.result(@, 'prefetchOptions', {})
      )

    if @options.testMode
      @options.prefetchOptions = timeout: 250
      @options.cacheSkip = true

    if Config.debug
      # Product Catalog seems slow in resource constrained environments, so
      # I'm bumping up the timeout.
      @options.prefetchOptions.timeout = 60000

    # Rendering options for inspection and performance testing.
    if truthy(@request.query['app.stateOnly'])
      @options.renderAppStateOnly = true
    if falsy(@request.query['app.prefetch'])
      @options.prefetch = false
    if falsy(@request.query['app.render'])
      @options.render = false
    if truthy(@request.query['app.cacheFlush'])
      @options.cacheFlush = true
    if truthy(@request.query['app.cacheSkip']) or @request.query['cms_preview']
      @options.cacheSkip = true
    if @request.query['app.disableTags']
      # Allow third-party tags and features to be disabled for performance
      # testing.
      disableTags = @request.query['app.disableTags'].toLowerCase()
      @options.disableTags = _.reduce disableTags.split(','), (result, tag) ->
        result[tag] = true
        result
      , {}


    @cookies = new Cookies(request: @request.state)

    @preferences =
      country: @__getCountryFromRequest(@request) or ''

    @requestLocale = @__getSupportedLocale(@preferences.country)

    @offline = (@host == @requestLocale.offline_host)

    @shouldDetectHost =
      # If a country preference cannot be detected from the request
      # (see __getCountryFromRequest), we need to fetch /api/v2/host/detect
      # in order to determine the correct host.
      not Config.isDev and _.isEmpty(@preferences.country) and not @offline

    @shouldFetchPersonalization = not Personalization.isPathBlacklisted(@path)

    @experimentSeed = _.get @request.state, COOKIE_EXPERIMENTS_SEED
    @experimentBucketedState = Experiments.deserializeState(
      _.get @request.state, COOKIE_EXPERIMENTS_BUCKETED
    )

    if not Experiments.isValidSeed(@experimentSeed)
      @experimentSeed = Experiments.newSeed()
      @cookies.add(
        name: COOKIE_EXPERIMENTS_SEED
        value: @experimentSeed
        ttl: 63072000000  # 2 years.
        domain: Config.get('server.config.cookie_domain')
        path: '/'
        isSecure: true
      )

    @prefetchCount = 0
    @prefetched = {}
    @prefetchErrors = {}
    @prefetchBenchmark = @benchmark.time 'prefetch'
    @prefetchTiming = {}
    @requestUrl = "https://#{@host}#{@path}#{@request.url.search or ''}"

    @initialize() if _.isFunction(@initialize)

    if not Config.isDev and not @shouldDetectHost
      # The client has country preferences set, enforce that they are on
      # the correct host.
      @log "requestLocale", @requestLocale

      unless @host in [@requestLocale.host, @requestLocale.offline_host, @requestLocale.mobile_host]
        subdomain = @host.split('.')[0]
        if _.includes(subdomain, 'mobile') or _.includes(['m', 'ca-m'], subdomain)
          # Matches m, mobile-, ca-m, mobile-stage, ca-mobile-stage,
          # mobile, ca-mobile, mobile-{adhoc-slug}.
          @hostRedirect @requestLocale.mobile_host
        else if _.includes(subdomain, 'offline')
          @hostRedirect @requestLocale.offline_host
        else
          @hostRedirect @requestLocale.host
        return

    if _.result(@, 'loginRequired')
      # On routes that require login, we fetch the session first, so that we can
      # short circuit (and skip additional prefetches) in the event that the
      # user isn't logged-in.
      @__doSessionPrefetch()
    else
      @__doPrefetch()

  __getModifiers: ->
      # Modifiers are like features, but can be changed per-request or per
      # page.
      #
      # They can be any JavaScript type, but should whitelisted here with
      # a limited set of values so that the rendered page can be cached
      # and the possible cache-keys is finite.
      isMobileAppRequest: (
        Boolean(@request.headers['warbyparkermobileapp'] or _.get(@request.query, "modifiers.isMobileAppRequest"))
      )

  __getSupportedLocale: (code) ->
    locale = Config.get('server.locales')[code.toLowerCase()]
    if locale
      locale
    else
      Config.get('server.locales.us')

  __addPrefetchedResponse: (path, response, body) ->
    # Collect prefetched responses, any set-cookie directives and timing
    # metrics.
    @prefetchTiming[path].end()
    @prefetchCount += 1

    response = response or {}

    if response.statusCode >= 200 and response.statusCode <= 298
      @cookies.addResponse response.headers['set-cookie'] if response.headers?

      if _.startsWith(path, '/api/v2/meta?')
        @metaTags = _.get body, 'meta', []
      else if path is '/api/v2/experiments'
        @experiments = body
      else
        @prefetched[path] = body
    else if response.statusCode == 299
      @prefetched[path] = ''
    else
      @prefetchErrors[path] = response.statusCode or 'UNKNOWN'

    return

  __doFetch: (path, fetchOptions, callback) ->
    fetchOptions = _.assign fetchOptions, locale: @locale, timeout: 5000
    ApiService.fetch path, @cookies, @request.headers, fetchOptions, callback

  __doSessionPrefetch: ->
    prefetchRoutes = _.result(@, 'alwaysPrefetch', [])
    q = @request.query or {}
    for path in prefetchRoutes
      # Fetch the specified CMS revision, if requested
      if path is "/api/v2/variations/#{q['cms_preview']}"
        path = "#{path}?version=#{q['version']}&access_token=#{q['access_token']}"
      @prefetchTiming[path] = @prefetchBenchmark.async path
      @__doFetch path, {}, @__didSessionPrefetch.bind(@)

    @__doPrefetch() if prefetchRoutes.length is 0

  __isSessionPrefetchComplete: ->
    prefetches = _.result @, 'alwaysPrefetch', []
    @prefetchCount >= prefetches.length

  __didSessionPrefetch: (path, response, body) ->
    @__addPrefetchedResponse(path, response, body)
    @__doPrefetch() if @__isSessionPrefetchComplete()

  __allPrefetchRoutes: ->
    _.union(
      _.result @, 'alwaysPrefetch', []
      _.result @, 'prefetch', []
    )

  __getVariationPath: (path) ->
    # Replace api path with override.
    _.get @options, "apiRewrites[#{path}]", path

  __getPrefetchRoutes: ->
    if @options.prefetch
      if @options.apiRewrites
        prefetchRoutes = _.map _.result(@, 'prefetch', []), @__getVariationPath.bind(@)
      else
        prefetchRoutes = _.result(@, 'prefetch', [])
    else
      prefetchRoutes = []

    return [] if prefetchRoutes is false  # Subclass may set `prefetch: false`.

    if not _.result(@, 'loginRequired')
      prefetchRoutes = _.union(
        _.result @, 'alwaysPrefetch', []
        prefetchRoutes
      )

    if (@getExperimentVariant('globalSearch') or '').indexOf('global') is 0
      prefetchRoutes.push('/api/v2/frames')

    prefetchRoutes

  __doPrefetch: ->
    # For any GET requests, asynchronously gather responses from the API so the
    # data can be used to render server-side. The prefetched data will also be
    # included in the application state.
    if _.result(@, 'loginRequired') and not @isLoggedIn()
      return @__preRequest()

    @__prefetchStartTime = Timing.start()
    prefetchRoutes = @__getPrefetchRoutes()

    if prefetchRoutes.length is 0 or _.result(@, 'skipPrefetch')
      @log 'prefetch [skipping]', prefetchRoutes

      @__preRequest()
    else
      @log 'prefetch', prefetchRoutes

      opts = _.assign(locale: @locale,
        @options.prefetchOptions,
        _.pick(@options, ['cacheFlush', 'cacheSkip'])
      )
      q = @request.query or {}
      for path in prefetchRoutes
        # Fetch the specified CMS revision, if requested
        if path is "/api/v2/variations/#{q['cms_preview']}"
          path = "#{path}?version=#{q['version']}&access_token=#{q['access_token']}"
        @prefetchTiming[path] = @prefetchBenchmark.async path
        @__doFetch path, opts, @__didPrefetch.bind(@)

  __isPrefetchComplete: ->
    prefetches = @__getPrefetchRoutes()
    if _.result(@, 'loginRequired')
      alwaysPrefetches = _.result @, 'alwaysPrefetch', []
      @prefetchCount >= prefetches.length + alwaysPrefetches.length
    else
      @prefetchCount >= prefetches.length

  __didPrefetch: (path, response, body) ->
    @__addPrefetchedResponse(path, response, body, @__prefetchStartTime)
    @__preRequest() if @__isPrefetchComplete()

  __preRequest: ->
    @prefetchBenchmark.end()

    if @shouldDetectHost
      # Redirect if the expected host doesn't match the request host.
      expectedHost = _.get @prefetched['/api/v2/host/detect'], 'host', @host

      if @host isnt expectedHost
        @hostRedirect expectedHost
        return

    if not _.isEmpty(@experimentBucketedState) and not _.isEmpty(@experiments)
      # As experiments are deactivated, sweep any stale bucket data to prevent
      # the cookie value from increasing in size forever.
      sweepResult = Experiments.sweepState(@experimentBucketedState, @experiments)
      if sweepResult.changed
        @cookies.add(
          name: COOKIE_EXPERIMENTS_BUCKETED
          value: Experiments.serializeState(sweepResult.state)
          ttl: 63072000000  # 2 years.
          domain: Config.get('server.config.cookie_domain')
          path: '/'
          isSecure: true
        )

    # If we get to this point, we haven't redirected and the client is on the
    # correct host.
    @__enforcePreferences()

    @__initializeAppState()

    @appStateDidInitialize() if _.isFunction @appStateDidInitialize

    # Get or clear the page-level cache.
    cache = @__cacheSettings()

    if cache.cacheable
      if @options.cacheFlush
        ContentCacheService.clear cache.key
      else
        if not @options.cacheSkip
          @benchmarkCache = @benchmark.time "content-cache.fetch"
          ContentCacheService.get cache.key, @__didReceiveCacheContent.bind(@)
          return

    @__doRequest()

  __initializeAppState: ->
    @benchmark.time 'app-state', ->
      @appState =
        client: @__clientDetails()
        config: Config.toBrowserJSON()
        modifiers: @modifiers
        locale: @locale
        location: _.assign Url.parse(@requestUrl),
          description: (_.find(@metaTags, property: "og:description") or {}).content
          route: @request.route.path
          method: @request.route.method
          params: @request.params
          visibleBeforeMount: @options.visibleBeforeMount or @__cacheSettings().cacheable
        requestCookies: @__getRequestCookies()
        api:
          prefetched: @prefetched
          timing: _.mapValues @prefetchTiming, (benchmark) ->
            "#{benchmark.result().ms} ms"
          errors: @prefetchErrors
        experiments: Experiments.computeState(
          @experimentSeed
          @experiments
          {
            disableAll: _.get(@request.state, 'wp-disable-experiments')
            force:
              experiment: @request.query.experiment
              variant: @request.query.variant
            session: @prefetched['/api/v2/session']
            personalization: @prefetched['/api/v2/personalization']
            bucketState: @experimentBucketedState
          }
        )
    , @

  __getRequestCookies: ->
    cookiesWhitelist = [
      'wp_id'
      @__prefixedCookieName 'htoMode'
      @__prefixedCookieName 'hasQuizResults'
      @__prefixedCookieName 'smartBannerClosed'
    ]
    _.reduce cookiesWhitelist, (result, cookie) =>
      result[cookie] = _.get @cookies.requestCookies, cookie
      result
    , {}

  __enforcePreferences: ->
    # Set cookies to keep the client on the current host unless they are already
    # correctly set.
    if @getCookie('country', 'wp-') isnt @locale.country
      # Ensure each client has a valid `country` cookie.
      @cookies.add(
        name: 'wp-country'
        value: @locale.country
        domain: Config.get('server.config.cookie_domain')
        path: '/'
        ttl: 365 * 24 * 60 * 60 * 1000
        isSecure: true
      )

  __didReceiveCacheContent: (err, content) ->
    @benchmarkCache.end()
    @contentCache = content if not err and content
    @__doRequest()

  __doRequest: ->
    if @prepare() isnt false
      # Enforce allowed methods in case `@request.method` returns arbitrary
      # strings.
      @[ALLOWED_METHODS[@request.method]].call(@)

    @benchmark.end()
    @finish()

  __prefixedCookieName: (name) -> "#{@locale.cookie_prefix}#{name}"

  __getCountryFromRequest: (request) ->
    # Get the country code from a request in this order of precedence:
    #   1. User preference as denoted in the wp-country cookie.
    #   2. CF-IPCountry header.
    #   3. null - A country could not be determined.
    country = @getCookie('country', 'wp-')
    if country
      @log 'country found in cookie', country
      return country

    @log 'headers', request.headers
    country = _.get request.headers, 'cf-ipcountry', 'XX'
    if country isnt 'XX'
      @log 'country found in header', country
      return country

    @log 'country not found in request'
    return null

  __getLocaleFromHost: (host) ->
    if _.startsWith host, 'ca'
      Config.get('server.locales.ca')
    else
      Config.get('server.locales.us')

  __cacheSettings: ->
    ttl = _.result(@, 'cacheTTL', 0)
    cacheStale = _.result(@, 'cacheStale', 0)
    cacheVariants = []
    cacheable = ttl > 0 and not @options.cacheSkip and _.isEmpty(@prefetchErrors)
    cacheKeyParts = [
      @locale.country
      if @isLoggedIn() then 'auth' else 'noauth'
      if @isNativeAppCapable and not @getCookie('smartBannerClosed') then 'sb' else ''
      _.result(@, 'cacheKey')
      _.reduce(
        @modifiers
        (result, val, key) ->
          result.push "#{key}=#{val}"
          result
        []
      ).sort().join(':')
    ]

    if cacheable and _.isObject(@experiments)
      for id, experiment of @experiments

        # Get cache_variants and append deprecated cache key.
        pathRegExps = _.clone _.get(experiment, 'attributes.cache_variants', [])
        pathRegExps.push(experiment.cache) if experiment.cache

        # Test regexes against path.
        for pathRegExp in pathRegExps
          if new RegExp(pathRegExp).test(@request.path)
            state = @getExperimentState(experiment.name)
            cacheKey = "#{id}=#{state.variant}"
            if state.participant and cacheVariants.indexOf(cacheKey) is -1
              cacheVariants.push cacheKey

    cacheKeyParts.push cacheVariants.sort().join(':')

    cacheable: cacheable
    cacheStale: cacheStale
    key: cacheKeyParts.join '-'
    ttl: ttl

  __doRender: (options = {}) ->
    _.defaults options, layout: 'default', component: 'blank'

    if @lastVisited() > @aDayAgo() or @modifier('isMobileAppRequest')
      @options.disableTags['typekit-async'] = true

    cache = _.assign value: null, @__cacheSettings(), @contentCache

    _.merge @appState, location: options

    if cache.cacheable and not _.isEmpty(cache.value)
      _.set @appState, 'location.title', cache.value.title

    layout = new Layouts[options.layout] @appState,
      cache: cache
      metaTags: @metaTags
      render: @options.render
      disableTags: @options.disableTags
      error: options.error
      benchmark: @benchmark

    if @options.renderAppStateOnly
      layout.renderStateOnly()
    else
      layout.render()

  __clientDetails: () ->
    details = UAParser("#{_.get(@request.headers, 'user-agent', '')}")

    browserName = _.get details, 'browser.name', ''
    isSafari = /Safari/i.test browserName
    majorVersion = parseInt _.get(details, 'browser.major')
    @isApplePayCapable = isSafari and majorVersion >= 10
    details.isApplePayCapable = @isApplePayCapable

    # Devices that support our native mobile app(s). This may expand in the
    # future to iPad or Android, for example.
    device = _.get details, 'device.model', ''
    @isNativeAppCapable = /^(iPhone|iPod)/i.test device
    details.isNativeAppCapable = @isNativeAppCapable

    details

  lastVisited: () ->
    parseInt @getCookie('visited'), 10

  aDayAgo: () ->
    Date.now() - 86400 * 1000

  getExperimentId: (name) ->
    _.get @appState, "experiments.nameMapId.#{name}"

  getExperimentDetails: (name) ->
    _.get @appState, "experiments.active.#{@getExperimentId(name)}", {}

  getExperimentState: (name) ->
    _.get @getExperimentDetails(name), 'state', {}

  getExperimentVariant: (name) ->
    state = @getExperimentState name
    if state.participant then state.variant else null

  setExperimentState: (name, settings) ->
    path = "experiments.active['#{@getExperimentId(name)}'].state"
    _.set(@appState, "#{path}.#{key}", value) for key, value of settings

  inExperiment: (name, variant) ->
    state = @getExperimentState(name)
    state.participant and state.variant is variant

  modifier: (feature, defaultValue = false) ->
    _.get @appState, "modifiers.#{feature}", defaultValue

  cacheKey: -> @path

  cacheTTL: -> 0

  cacheStale: -> 90 * 1000  # 90 seconds.

  cacheMaxAge: ->
    # The time, in milliseconds, that the browser can cache the page.
    # Used for `max-age` attribute of the `cache-control` header.
    # See `getCacheControl`.
    0

  cachePrivacy: ->
    # Used for the private/public flag of the `cache-control` header.
    # See `getCacheControl`.
    if @isLoggedOut() then 'public' else 'private'

  getFeature: (feature) ->
    _.get @locale, "features.#{feature}"

  getCacheControl: (statusCode) ->
    cacheMaxAge = _.result(@, 'cacheMaxAge', 0)
    cacheMaxAgeSeconds = Math.floor(cacheMaxAge / 1000)
    privacy = _.result(@, 'cachePrivacy', 'private')

    if cacheMaxAge is 0 or statusCode isnt 200 or _.some(@prefetchErrors)
      # Don't cache if there were any prefetch errors, or if this request is an
      # error.
      "max-age=0, no-cache, no-store, #{privacy}"
    else
      "max-age=#{cacheMaxAgeSeconds}, #{privacy}"

  alwaysPrefetch: ->
    # API endpoints that are fetched on every request.
    endpoints = [
      "/api/v2/meta?path=#{encodeURIComponent(@path)}"
      '/api/v2/variations/navigation'
      '/api/v2/variations/footer'
      '/api/v2/experiments'
      '/api/v2/session'
    ]

    endpoints.push '/api/v2/host/detect' if @shouldDetectHost
    endpoints.push '/api/v2/personalization' if @shouldFetchPersonalization
    endpoints

  layout: ->
    # Name of the layout to use.
    'default'

  prefetch: ->
    # API endpoints that are fetched on the current request.
    []

  loginRequired: -> false

  initialize: ->
    # Called after constructor, but before prefetching.

  prepare: ->
    # Called after prefetching, but before HTTP action method.
    # Return false to bypass HTTP action method.

  getCookie: (name, prefix) ->
    key = if prefix then "#{prefix}#{name}" else @__prefixedCookieName(name)
    cookie = _.get @request.state, key

    if _.isArray cookie
      # Hapi returns an array if multiple cookies with same name.
      # This can be forced through console or spoofed headers.
      # If multiple, return undefined and unset the cookie.
      @log 'getCookie [isArray]', key, cookie
      @reply.unstate(key)
      return undefined
    else
      return cookie

  get: ->
    if @options.component?
      @benchmark.time 'render', ->
        @render(
          bundle: @options.bundle
          bundleFile: @options.bundleFile
          component: @options.component
          apiRewrites: @options.apiRewrites
          disableTags: @options.disableTags
          layout: _.result(@, 'layout')
          stores: @options.stores
          title: @options.title
        )
      , @
    else
      @render nothing: true

  post: ->

  put: ->

  delete: ->

  head: -> @render nothing: true

  options: ->

  finish: ->

  throwError: (options = {}) ->
    if options.isBoom
      @reply options
    else if _.isString options
      @reply Boom.create(500, options)
    else if _.isNumber options
      @reply Boom.create(options)
    else
      _.defaults options, statusCode: 500
      @reply Boom.create(options.statusCode, options.message, options.data)

  isLoggedOut: ->
    # No soft or authenticated login.
    _.isEmpty _.get(@prefetched['/api/v2/session'], 'customer')

  isLoggedIn: ->
    # Only an authenticated login.
    _.get @prefetched['/api/v2/session'], 'customer.authenticated', false

  hostRedirect: (newHost) ->
    # Change hosts, but preserve path and query parameters.
    @redirect("https://#{newHost}#{@path}#{@request.url.search or ''}")

  redirect: (url) ->
    response = @reply.redirect url
    @setCookies(response)

  redirectWithParams: (path, options = {}) ->
    # Redirects to a new path while preserving the current request's query
    # params.
    _.defaults options, statusCode: 302
    path = _.trimEnd(path, '?')
    query = @request.url.search or ''
    response = @reply.redirect "#{path}#{query}"
    response.code(options.statusCode)
    @setCookies(response)

  setCookies: (response) ->
    for cookie in @cookies.cookies
      response.state cookie.name, cookie.value, _.omit(cookie, 'name', 'value')

  render: (options) ->
    if _.isString(options)
      options = { body: options }

    _.defaults options, statusCode: 200

    if _.result(@, 'loginRequired') and not @isLoggedIn()
      nextUrl = @path
      query = _.map @request.query, (val, key) ->
        "#{encodeURIComponent(key)}=#{encodeURIComponent(val)}"
      nextUrl = "#{nextUrl}?#{query}" if _.some(query)
      @redirect "/login?next=#{encodeURIComponent(nextUrl)}"
    else
      if options.component?
        renderedContent = @__doRender(_.pick options,
          'apiRewrites'
          'bundle'
          'bundleFile'
          'component'
          'error'
          'layout'
          'stores'
          'title'
        )
        response = @reply renderedContent
      else if options.nothing
        response = @reply ''
      else if options.body
        response = @reply(options.body)
      else
        response = @reply(Stringify(options))
        response.type 'application/json'

      @setCookies(response)

      response.headers['cache-control'] = @getCacheControl(options.statusCode)
      response.code(options.statusCode)

module.exports = BaseHandler
