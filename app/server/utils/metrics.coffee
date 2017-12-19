[
  _
  StatsD

  Logger
  Timing
] = [
  require 'lodash'
  require 'node-statsd'

  require 'hedeia/server/logger'
  require 'hedeia/server/utils/timing'
]

suppressLogs = not Config.get('server.logging.metrics')

log = Logger.get('Metrics', file: __filename, quiet: suppressLogs).log

statsd = new StatsD(
  host: Config.get('server.statsd.host')
  port: Config.get('server.statsd.port')
  mock: if Config.get('environment.test') then true else false
  prefix: "#{Config.get('server.statsd.prefix')}"
)

statsd.socket.on 'error', (error) -> log error

escapeName = (name) ->
  # Format statsd names by removing leading slashes so that paths like
  # `/account/orders/123456` look like `account-orders-123456` instead of
  # `--account--orders--123456`.
  "#{name}"
    .replace /(\/\*)|\*/, ''   # No asterisks.
    .replace /\.(\/)\./, '.-.' # ./. => .-.
    .replace /\.\//g, '.'      # Leading slashes at . boundaries.
    .replace /\//g, '-'        # / => -

module.exports =
  timing: (name, value, sampleRate, tags, callback) ->
    value = Math.round(value)
    name = escapeName(name)
    log "[#{name}] in", "#{value} ms"
    statsd.timing(name, value, sampleRate, tags, callback)
    return

  timingSince: (name, value, sampleRate, tags, callback) ->
    value = Math.round Timing.since(value)
    name = escapeName(name)
    log "[#{name}] in", "#{value} ms"
    statsd.timing(name, value, sampleRate, tags, callback)
    return

  increment: (name, value, sampleRate, tags, callback) ->
    name = escapeName(name)
    log "[#{name}] increment"
    statsd.increment(name, value, sampleRate, tags, callback)
    return

  decrement: (name, value, sampleRate, tags, callback) ->
    statsd.decrement(escapeName(name), value, sampleRate, tags, callback)
    return

  gauge: (name, value, sampleRate, tags, callback) ->
    name = escapeName(name)
    log "[#{name}] gauge", value
    statsd.gauge(name, value, sampleRate, tags, callback)
    return

  unique: (name, value, sampleRate, tags, callback) ->
    statsd.unique(escapeName(name), value, sampleRate, tags, callback)
    return

  getTime: -> Timing.start()
