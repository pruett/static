# Don't require .scss/.elm files in components.
# require.extensions['.scss'] = ->
# require.extensions['.elm'] = ->

# Use minified React for better performance.
require.cache[require.resolve('react/addons')].exports =
  require 'react/dist/react-with-addons.min.js'

[
  _
  React

  Logger
  Benchmark
  Metrics
  Timing
  Stringify
  # Components
  ContentCacheService
  Dispatchers
  RootComponent
] = [
  require 'lodash'
  require 'react/addons'

  require 'hedeia/server/logger'
  require 'hedeia/common/utils/benchmark'
  require 'hedeia/server/utils/metrics'
  require 'hedeia/server/utils/timing'
  require 'hedeia/common/utils/stringify'
  # require 'components/components'
  require 'hedeia/server/services/content_cache_service'
  require 'hedeia/common/dispatchers'
  require 'hedeia/common/components/root'
]

logger = Logger.get('BaseLayout')

class BaseLayout
  constructor: (@appState, @options = {}) ->
    layoutName = _.result @, 'name'

    if not _.isString(layoutName)
      throw new Error('Layout must define a name')

    _.defaults @options,
      cache: {}
      disableTags: {}
      error: false
      metaTags: []
      render: true

    @benchmark = (@options.benchmark or Benchmark).time(
      name: "layouts.#{_.kebabCase layoutName}"
      start: false
    )

    @cache = _.defaults @options.cache,
      cacheable: false
      value: null

    @metaTags = @options.metaTags

    @throttleDelay = @__getThrottleDelay()

  name: ->
    # The name of the layout, used for metrics.
    'base'

  bodyAttrs: ->
    # Attributes you want to add to the body element.
    {}

  getRevisionDirectory: ->
    environment = _.get @appState, 'config.environment', {}
    if environment.debug then '' else "/#{environment.revision}"

  scriptPath: ->
    # The common path to prepend to all scripts.
    "/assets#{@getRevisionDirectory()}/js/"

  stylesheetPath: ->
    # The common path to prepend to all stylesheets.
    "/assets#{@getRevisionDirectory()}/css/"

  asyncScripts: ->
    # A list of script names to load asynchronously. The key acts as a the
    # callback you can use in other scripts to know when script dependencies
    # have loaded.
    #
    # Example:
    #
    # { 'bundle-main': ['main'] }
    # => <script>$script("/assets/js/main.js', 'bundle-main');</script>
    {}

  stylesheets: ->
    # A list of plain stylesheets names to add to the DOM.
    #
    []

  afterBodyOpen: ->
    # Any DOM element(s) to be inserted immediately after the <body>.
    null

  beforeBodyClose: ->
    # Any DOM element(s) to be inserted immediately before the </body>.
    null

  headScripts: ->
    # A list of React.DOM.script tags to add to the <head>.
    null

  __getThrottleDelay: ->
    experimentName = 'throttleSpeed'

    id = _.get @appState, "experiments.nameMapId.#{experimentName}", null
    variant = _.get @appState, "experiments.active.#{id}.state.variant", null
    Number(variant) || 0

  throttle: ->
    ###
    WARB-3038 : Testing how performance affects conversion

    We are simulating different load times by initially hiding the DOM
    with CSS and then showing it after an arbitrary setTimout delay
    ###

    return null unless @throttleDelay

    [
      # Hide everything via <style> tag
      React.DOM.style(
        key: 'throttle-style'
        id: 'throttle'
        dangerouslySetInnerHTML:
          __html: "*{visibility:hidden;overflow:hidden;}"
      )

      # Remove above <style> tag after delay and show DOM
      React.DOM.script(
        key: 'throttle-script'
        dangerouslySetInnerHTML:
          __html: """
            (function(d){
              setTimeout(function(){
                var el = d.getElementById("throttle")
                return el.parentNode.removeChild(el)
              },#{@throttleDelay});
            }(document))
          """
      )
    ]

  head: ->
    # A list of React.DOM element to add to the <head>.
    null

  title: ->
    # The document <title>.
    title = _.get @appState, 'location.title'
    if not _.isEmpty(title)
      "#{title} | Warby Parker"
    else
      'Warby Parker'

  assetPath: (path, name, ext) ->
    ext = ".#{ext}" if not _.startsWith ext, '.'
    name = "#{name}#{ext}" unless _.endsWith name, ext

    if _.startsWith name, '/'
      # Don't prepend the path when name appears to include the path, so that
      # links like //cdnjs.cloudflare.com/backbone.js/1.1.2/backbone-min.js or
      # /non/default/path/to/script.js would work.
      "#{name}"
    else
      staticHostname = Config.get('server.config.static_hostname') or ''
      staticHostname = "//#{staticHostname}" if staticHostname

      environment = _.get @appState, 'config.environment', {}
      if environment.debug
        "#{staticHostname}#{path}#{name}?v=#{environment.revision}"
      else
        "#{staticHostname}#{path}#{name}"

  route: ->
    _.get @appState, 'location.route', 'unknown'

  isTagEnabled: (name) -> not @options.disableTags[name]

  path: ->
    # The relative path of this page.
    _.get @appState, 'location.pathname', ''

  __head: ->
    React.DOM.head key: 'head', [
      _.result @, 'meta'
      _.result @, 'head'
      _.result @, 'throttle'
      React.DOM.title key: 'title', _.result(@, 'title')
      _.result @, 'headScripts'
      _.result @, '__headStylesheets'
    ]

  __getAsyncScripts: ->
    scriptPath = _.result @, 'scriptPath'
    _.map _.result(@, 'asyncScripts', []), (scriptName) =>
      @assetPath(scriptPath, scriptName, 'js')

  __body: ->
    asyncScripts = _.result(@, '__getAsyncScripts', [])
    blockingScripts = _.result(@, '__blockingScripts', [])

    [
      _.result @, 'afterBodyOpen'
      React.DOM.div
        key: 'root-element'
        id: 'root-element'
        className: 'u-template'
        dangerouslySetInnerHTML:
          __html: if not @options.render
            ''
          else
            _.result(@, 'bodyContent', '')
      React.DOM.script
        key: 'scripts'
        dangerouslySetInnerHTML:
          __html: _.result @, 'applicationState'
      blockingScripts.map (src) -> React.DOM.script src: src
      asyncScripts.map (src) -> React.DOM.script src: src, async: true
      _.result @, 'beforeBodyClose'
    ]

  __blockingScripts: ->
    scriptPath = _.result @, 'scriptPath'
    _.map _.result(@, 'blockingScripts', []), (scriptName) =>
      @assetPath(scriptPath, scriptName, 'js')

  __headStylesheets: ->
    stylesheetPath = _.result @, 'stylesheetPath'
    _.map _.result(@, 'headStylesheets'), (name) =>
      path = @assetPath(stylesheetPath, name, 'css')
      React.DOM.link
        key: "stylesheet-#{path}"
        rel: 'stylesheet'
        type: 'text/css'
        href: path

  __renderBodyContent: (method = 'sync') ->
    component = _.get @appState, 'location.component'
    root = RootComponent.initialize(Components)
    @benchmark.time "component.#{method}.#{_.kebabCase component}", ->
      React.renderToStaticMarkup(
        # * TODO dynamically pass in RootComponent
        React.createElement(root, appState: @appState, staticComponent: require('components/pages/static/terms_of_use/terms_of_use.cjsx'))
      )
    , @

  __asyncRenderBodyContent: ->
    @initializeDispatchers()
    Metrics.increment("layouts.async-rendered.#{_.result(@, 'name')}")
    ContentCacheService.getLock @cache.key, 15 * 1000, _.bind (err, lock) ->
      if lock
        try
          bodyContent = @__renderBodyContent('async')
          ContentCacheService.set(
            @cache.key
            body: bodyContent, title: _.get(@appState, 'location.title')
            @cache.ttl
            @cache.cacheStale
          )
        catch err
          logger.error 'Async render error', err
        ContentCacheService.releaseLock(@cache.key)
    , @

  bodyContent: ->
    if @cache.cacheable and not _.isEmpty(@cache.value)
      bodyContent = @cache.value.body

      if @cache.isStale
        # If the cached value is stale, asynchronously regenerate the content to
        # keep the cache fresh.
        _.defer @__asyncRenderBodyContent.bind(@)
    else
      @initializeDispatchers()
      Metrics.increment("layouts.sync-rendered.#{_.result(@, 'name')}")
      bodyContent = @__renderBodyContent('sync')
      if @cache.cacheable
        ContentCacheService.set(
          @cache.key
          body: bodyContent, title: _.get(@appState, 'location.title')
          @cache.ttl
          @cache.cacheStale
        )

    bodyContent

  blockingScripts: -> []

  applicationState: ->
    "var WarbyParker = #{Stringify @appState};\n"

  initializeDispatchers: ->
    return if @options.error
    Dispatchers.serverInitialize(@appState, @benchmark)

  renderStateOnly: ->
    @initializeDispatchers()
    cache = _.assign {}, _.omit(@cache, 'value'), hit: Boolean(@cache.value)
    _.assign {}, @appState, cache: cache

  render: ->
    # Render the layout, combining head, script, stylesheet and body elements.
    # Layouts are structured like so:
    #
    # <html>
    #   <head>
    #     head
    #     meta
    #     title
    #     headScripts
    #     headStylesheets
    #   <body>
    #     afterBodyOpen
    #     bodyContent
    #     applicationState
    #     blockingScripts
    #     asyncScripts
    #     beforeBodyClose

    # Get body attributes, and preset key.
    bodyAttrs = _.defaults _.result(@, 'bodyAttrs', {}), key: 'body'

    @benchmark.start()
    # Body is rendered first, because page title is determined from either
    # initializing Dispatchers or retrieval from cache.
    body = React.DOM.body bodyAttrs, @__body()

    # Render head second, so that the page <title> is pulled from a updated
    # AppState.
    head = _.result @, '__head'

    html = React.renderToStaticMarkup(
      React.DOM.html(
        lang: _.get(@appState, 'locale.lang', 'en-us')
        className: 'no-js'
        [head, body]
      )
    )

    @benchmark.end()
    "<!doctype html>\n#{html}"

module.exports = BaseLayout
