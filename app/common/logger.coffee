class Logger
  # Logger
  # ======
  # Contextual logging, roughly based on ideas from
  # http://github.com/jonnyreeves/js-logger
  #
  # We want to encourage easy and verbose logging of front-end scripts
  # because it's easier to for others to debug and understand. Second,
  # it's easier to trace issues in production when logging is available,
  # but dark and unobstrusive by default.
  #
  # In non-development environments, activate Logger through a query
  # parameters like so:
  # ?logger=*              - matches all contexts
  # ?logger=Cart,Headturns - matches contexts like (^Cart*|^Headturns*)
  #
  # Or use `Logger.replay()` from the JavaScript console to replay
  # the history.
  #
  # Example usage:
  #
  # logger = Logger.get("ContextName", debug: true)
  # logger.log "event"
  # logger.log "object", thing: 1
  #
  # warning = { unexpected: 'thing' }
  # logger.warn "uh oh", warning
  #
  # Logger.stats()
  # => Object {contexts: Array[44], filters: Array[0], history:323}

  PADDING_TIME = 7     # How much padding we enforce when showTime: true.
  PADDING_CONTEXT = 20 # How much padding for the context name.
  LEVELS =
    off:   0
    error: 1
    warn:  2
    debug: 3
    info:  4
    table: 5
    log:   5

  history = []
  contexts = {}
  filterMap = {}
  startTime = null

  settings =
    filters: []
    level: 0
    padding: PADDING_CONTEXT
    quiet: false  # If true, logging contexts are quiet by default.
    showTime: true
    relativeTime: false
    style: 'justified'
    suppress: false
    historyMax: 500  # Maximum log entry history to store.

  if performance? and typeof(performance.now) is 'function'
    now = -> performance.now()
  else
    now = -> new Date().getTime()

  proxy =
    log: (options = {}) ->
      return if settings.suppress

      context = options.context
      args = options.args or []
      level = options.level
      forceShow = options.forceShow or false

      unless forceShow
        return unless LEVELS[level] and settings.level >= LEVELS[level]

        if filterMap[context]?
          show = filterMap[context]
        else
          if settings.filters.length
            show = not settings.quiet
            for filter in settings.filters
              if context.search(filter.exp) != -1
                show = filter.show
          else
            show = true
          filterMap[context] = show

        return unless show

      if settings.style is 'json'
        msgs = []
        for arg in args[1..]
          if typeof(arg) isnt 'object'
            msgs.push "#{arg}"
          else
            msgs.push JSON.stringify(arg, undefined, '')

        [date, time] = new Date().toISOString().split('T')
        time = time.substr(0, time.length - 1)
        time = "#{date} #{time}"

        message = {
          time: "#{time}"
          type: "#{level}".toUpperCase()
          module: "#{args[0]}"
          line: options.lineNumber
          file: options.file
          msg: msgs.join(' ')
        }

        console[level] JSON.stringify(message, undefined, '')
      else
        if level is 'table'
          console.groupCollapsed args[0]
          console.table.apply console, args[1..]
          console.groupEnd()
        else
          if(console[level].apply)
            console[level].apply console, args
          else
            message = Array.prototype.slice.apply(args).join(' ')
            console[level](message)

    getElapsed: -> "#{((now() - startTime) / 1000).toFixed(3)}s"

    invoke: (level, context, file, args) ->
      args = Array.prototype.slice.call(args)

      if settings.showTime and settings.relativeTime
        elapsed = @getElapsed()
        elapsed = " #{elapsed}" until elapsed.length >= PADDING_TIME
        elapsed = "#{elapsed} "
      else if settings.showTime and not settings.relativeTime
        elapsed = new Date().toJSON()
      else
        elapsed = ""

      if settings.style is 'justified'
        formattedContext = context
        until formattedContext.length >= settings.padding
          formattedContext = " #{formattedContext}"
        settings.padding = Math.max(settings.padding, formattedContext.length - 1)
        formattedContext =  "#{elapsed}#{formattedContext}"
      else
        formattedContext =  "#{elapsed} #{context}"

      if settings.style is 'json'
        args = [context].concat(args)
      else
        args = ["#{formattedContext} >"].concat(args)

      loggable = console?

      if settings.historyMax > 0
        history.push
          context: context
          level: level
          args: args
        history = history.slice(-settings.historyMax)

      @log(context: context, level: level, args: args, file: file) if loggable

  constructor: ->
    if performance? and typeof(performance.now) is 'function'
      startTime = 0
    else
      startTime = global.__timing__start or now()

    if window?
      filters = window.location.search.match(/[\?|\&]logger\=([^\&]+)/i)?[1]

    if filters is '*'
      @setLevel 'log'
    else if filters
      settings.quiet = true
      @setLevel 'log'
      filters = filters.split(',')
      for filter in filters
        @addFilter filter, show: true

    if filters
      @log "applying filter: #{filter}"

  history: ->
    # Return the raw history array.
    history

  stats: ->
    # Return stats about Logger. Useful for peeking at the contexts and
    # filters.
    console.log
      history: history.length
      contexts: Object.keys(contexts)
      filters: settings.filters
    return

  setLevel: (level) ->
    # Set the logging level. Pass a string: off|error|warn|debug|info|log
    # or integer-based logging level.
    if typeof(level) is 'string'
      settings.level = LEVELS[level]
    else
      settings.level = parseInt level, 10

  addFilter: (exp, options = {}) ->
    # Filters are a regular expression that either force a logging
    # context to show or be ignored. If you don't explicitly pass a
    # RegExp object, the :exp: param is converted to a RegExp
    filters = []
    if typeof(exp) is 'string'
      exp = exp.replace /[-\/\\^$*+?.()|[\]{}]/g, '\\$&'
      exp = new RegExp("^#{exp}", 'i')
    for filter in settings.filters
      filters.push(filter) if filter.exp != exp
    filters.push(exp: exp, show: options.show or false)
    settings.filters = filters
    filterMap = {}

  log: ->
    # Convenience methods for logging to the "Logger" context.
    @get('Logger').log.apply Logger, arguments

  replay: (options = {}) ->
    # Replay everything in the log history. Useful for debugging
    # in production when logs are silent, as the last `HISTORY_MAX`
    # log entries are always preserved.
    if typeof(options) is 'string'
      options = context: options

    context = options['context']
    level = options['level'] or 'log'

    for item in history
      if !context? or (context? and item['context'] is context)
        proxy.log(
          context: item['context']
          level: level
          args: item['args']
          forceShow: true
        )
    return

  setup: (options = {}) ->
    # Setup your Logger.
    if options.level?
      @setLevel options.level
    if options.filters?
      settings.filters = []
      for filter in settings.filters
        if typeof(filter) is 'string'
          settings.filters.push filter: filter, show: true
        else
          settings.filters.push filter

    allowedKeys = [
      'showTime'
      'quiet'
      'relativeTime'
      'style'
      'historyMax'
      'suppress'
    ]

    for key in allowedKeys
      settings[key] = options[key] if options[key]?

  get: (name, options = {}) ->
    # Get a logging context.
    # Use `debug: true` to exclusively log your context automatically.
    # Use `quiet: true` to silence a logging context by default.
    # Use `filter: true` to selectively filter your context.
    if typeof(name) != 'string'
      options = name
      name = options.name or 'Logger'

    filter = options.filter or false
    quiet = options.quiet or false
    debug = options.debug or false
    file = options.file or null

    exp = new RegExp("^#{name}$", 'i')

    if filter
      @addFilter exp, show: true
    else if debug
      settings.quiet = true
      @addFilter exp, show: true
    else if quiet
      @addFilter exp, show: false

    unless contexts[name]?
      context = {}
      Object.keys(LEVELS).forEach (level) ->
        unless LEVELS[level] is 0
          context[level] = ->
            proxy.invoke.call proxy, level, name, file, arguments
      contexts[name] = context

    contexts[name]


module.exports = new Logger
