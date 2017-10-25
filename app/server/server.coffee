[
  _
  Hapi
  Inert

  Logger
  Metrics
  Benchmark
  ErrorHandler
  HealthHandler
  CachedApiHandler
] = [
  require 'lodash'
  require 'hapi'
  require 'inert'

  require 'hedeia/server/logger'
  require 'hedeia/server/utils/metrics'
  require 'hedeia/common/utils/benchmark'
  require 'hedeia/server/handlers/error_handler'
  require 'hedeia/server/handlers/health_handler'
  require 'hedeia/server/handlers/cached_api_handler'
]

if Config.debug
  # If we're in a debug environment, output benchmarks to the logs only.
  Benchmark.config
    afterEnd: (benchmark) ->
      if benchmark.parent is null
        Logger.get('Benchmarks').log benchmark.report()
else
  Benchmark.config
    afterEnd: (benchmark) ->
      # Ensures that we don't create too many metric namespaces by omitting api
      # paths from the benchmark identity.
      identity =  if _.startsWith(benchmark.name, '/api/') and benchmark.parent
        "#{benchmark.parent.identity()}.api"
      else
        benchmark.identity()

      Metrics.timing identity, benchmark.result().ms

try
  Routes = require 'hedeia/server/routes.json'
catch
  throw new Error('Server cannot start because routes are missing.')

class Server
  log = Logger.get('Server').log

  handlers = {}
  routeCount = 0

  # The option `debug: false` is so we can handle logging of errors, otherwise
  # Hapi will `console.error` uncaught errors.
  server = new Hapi.Server(debug: false)

  createHandler: (route, count = true) ->
    requirePath = "hedeia/server/handlers/"
    HandlerClass = require "#{requirePath}#{route.handler}"

    server.route(
      method: route.method
      path: route.path
      handler: (request, reply) ->
        new HandlerClass(request, reply,
          bundle: route.bundle
          bundleFile: route.bundleFile
          component: route.component
          visibleBeforeMount: route.visibleBeforeMount
          stores: route.stores
          title: route.title
        )
    )

    routeCount += 1 if count

  onServerStart: (err) ->
    hostname = Config.get('server.config.hostname')
    port = Config.get('server.config.port')

    log(
      'started'
      environment: Config.get('environment')
      host: "http://#{hostname}:#{port}"
    )

    @benchmark.end()

  updateMemoryGauge: ->
    usage = process.memoryUsage()

    Metrics.gauge "processes.memory.resident-set-size", usage.rss
    Metrics.gauge "processes.memory.heap-total", usage.heapTotal
    Metrics.gauge "processes.memory.heap-used", usage.heapUsed

    if Config.get('server.memory.enforce') and Config.get('server.memory.limit')
      # Exit abnormally, so supervisor restarts the process.
      @stop(1) if usage.heapUsed > Config.get('server.memory.limit')

  setupConnection: ->
    server.connection
      host:    Config.get('server.config.hostname')
      address: Config.get('server.config.address')
      port:    Config.get('server.config.port')

  setupRoutes: ->
    # Serve assets locally if in dev env
    server.register Inert, () -> {}

    server.route(
     method: 'GET'
     path: '/assets/{param*}'
     handler:
       directory:
         path: 'public'
    )

    # Add health check route.
    server.route(
      method: 'GET'
      path: '/health-check'
      handler: (request, reply) -> new HealthHandler(request, reply)
    )

    # Add cached api endpoint handler.
    server.route(
      method: 'GET'
      path: '/api/v2/cached'
      handler: (request, reply) -> new CachedApiHandler(request, reply)
    )

    for route in Routes
      if _.startsWith(route.path, '/') and _.isString(route.handler)
        @createHandler route

    log "#{routeCount} route(s) registered"
    require('./proxy').init(server)

  setupErrorHandler: ->
    server.ext 'onPreResponse', (request, reply) ->

      getRoute = (path) ->
        # Get route for vanity lookup.
        _.find Routes, path: _.get(server.match('get', path), 'path', '')

      if request.response.isBoom
        new ErrorHandler(request, reply, getRoute: getRoute)
      else
        reply.continue()

  setupLoggingHandler: ->
    logContext = Logger.get('Requests')
    [log, warn, error]  = [logContext.log, logContext.warn, logContext.error]

    server.ext 'onRequest', (request, reply) ->
      method = request.method.toLowerCase()
      path = request.path
      route = request.route.path

      Metrics.increment "requests.started.#{route}.#{method}"

      reply.continue()

    server.ext 'onPostHandler', (request, reply) ->
      # Log request information and push timing metrics.
      response = request.response

      if response.isBoom
        statusCode = response.output.payload.statusCode
        stack = response.stack
      else
        statusCode = response.statusCode

      method = request.method
      path = request.path
      route = request.route.path

      message = [
        statusCode
        method.toUpperCase()
        request.path
        request.info.remoteAddress
        (new Date() - request.info.received) + 'ms'
      ].join ' '

      if statusCode >= 500
        error message, error: stack
      if statusCode >= 400
        warn message
      else
        log message

      reply.continue()

  setupMemoryGauge: ->
    setInterval(
      @updateMemoryGauge.bind(@)
      Config.get('server.memory.polling_interval') or 60000
    )

  stop: (code = 0) ->
    return if @__stopping
    @__stopping = true
    log 'stopping'
    stopTime = Metrics.getTime()
    server.stop timeout: 10000, ->
      Metrics.timingSince 'servers.stopped', stopTime
      _.delay ->
        # Give Metrics enough time to push the last timing call.
        process.exit(code)
      , 50

  run: ->
    log 'starting'
    @benchmark = Benchmark.time 'servers.start'
    @setupServer()

  setupServer: ->
    @benchmark.time 'connection', @setupConnection.bind(@)
    @benchmark.time 'routes', @setupRoutes.bind(@)
    @setupErrorHandler()
    @setupLoggingHandler()
    @setupMemoryGauge()

    server.start @onServerStart.bind(@)

module.exports = Server
