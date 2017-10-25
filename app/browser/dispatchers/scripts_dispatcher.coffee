[
  _

  BaseDispatcher
  Logger
] = [
  require 'lodash'

  require '../../common/dispatchers/base_dispatcher'
  require '../logger'
]

class ScriptsDispatcher extends BaseDispatcher
  # Handles asynchronously loading JavaScript on demand.

  log = Logger.get('ScriptsDispatcher').log

  channel: -> 'scripts'

  injectScript: (options) ->
    return if @store[options.name]?
    options.timeoutId = setTimeout(
      @handleScriptTimeout.bind(@, options.name)
      options.timeout
    )
    @setStore options.name, options
    $script @addCacheBuster(options.src), @handleScriptLoaded.bind(@, options.name)

  addCacheBuster: (src) ->
    if @environment.debug and not src.match /^\/\//
      "#{src}?v=#{@environment.revision}"
    else
      src

  handleScriptTimeout: (name) ->
    @setStore "#{name}.timedOut", true

  handleScriptLoaded: (name) ->
    clearTimeout _.get(@store, "#{name}.timeoutId")
    @setStore "#{name}.loadComplete", Date.now(), silent: true
    @setStore "#{name}.loaded", true

  commands:
    load: (options) ->
      _.defaults options,
        timeout: 10000
        loaded: false
        timedOut: false
        loadStart: Date.now()

      for key in ['name', 'src']
        if not _.isString(options[key])
          return throw new Error("Missing argument `#{key}`")

      @injectScript(options)


module.exports = ScriptsDispatcher
