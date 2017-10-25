[
  _
] = [
  require 'lodash'
]

config =
  afterEnd: null

if process?.hrtime?
  # Return a node-specific high-resolution timestamp tuple.
  # https://nodejs.org/api/process.html#process_process_hrtime
  now = process.hrtime
  __timeStart__ = now()
else if _.isFunction(performance?.now)
  now = -> performance.now()
  __timeStart__ = 0
else
  now = -> new Date().getTime()
  __timeStart__ = global.__timing__start or now()

millisSince = (start) ->
  # Accepts a plain number assumed to be milliseconds or a node high-resolution
  # timestamp tuple. Returns the number of milliseconds 'since' the start
  # argument.
  if typeof(start) is 'number'
    ms = (now() - start).toFixed(3)
  else
    diff = process.hrtime(start)
    ms = (diff[0] * 1000 + diff[1] * 1e-6).toFixed(3)
  ms

class BenchmarkNode
  constructor: (@options = {}) ->
    _.defaults @options,
      async: false
      endWithChildren: false
      parent: null
      start: true

    @parent = @options.parent
    @currentNode = this
    @name = @options.name or null
    @children = []
    @reset()

    if @parent
      @parent.notify 'new', this
      @depth = @parent.depth + 1
    else
      @depth = 0

    @start() if @options.start

  identity: (delimiter = '.')->
    if @parent
      "#{@parent.identity(delimiter)}#{delimiter}#{@name}"
    else
      @name

  notify: (action, child) ->
    switch action
      when 'new' then @stats.children.count += 1
      when 'start' then @stats.children.started += 1
      when 'end'
        @stats.children.complete += 1
        @currentNode = this if child is @currentNode
        if @options.endWithChildren
          @end() if @stats.children.complete is @stats.children.started
    return

  reset: ->
    @stats =
      children:
        count: 0
        started: 0
        complete: 0

    @times =
      start: null
      duration: null
      elapsed: null
      result: {}

  start: ->
    if @isStarted()
      throw new Error 'Cannot start a Benchmark that\'s already started'

    @times.start = now()
    @parent.notify('start', this) if @parent

    return

  end: ->
    if not @isStarted()
      throw new Error 'Cannot end a Benchmark that\'s not started'
    else if @isComplete()
      throw new Error 'Cannot end a Benchmark that\'s already complete'

    @times.elapsed = millisSince __timeStart__
    @times.duration = millisSince @times.start
    @parent.notify('end', this) if @parent

    if _.isFunction(config.afterEnd)
      _.defer config.afterEnd.bind(undefined, this)

    return

  isStarted: -> Boolean(@times.start)

  isComplete: -> Boolean(@times.duration)

  async: (options = {}, func, context) ->
    options = name: options if _.isString(options)
    _.assign options, async: true
    @time(options, func, context)

  time: (options = {}, func, context) ->
    options = name: options if _.isString(options)

    child = new BenchmarkNode(_.assign options, parent: @currentNode)
    @children.push(child)
    @currentNode = child unless options.async

    if _.isFunction(func)
      result = func.call(context)
      child.end()
      result
    else
      child

  result: ->
    if not @isComplete()
      return ms: 'n/a', seconds: 'n/a'

    if _.isEmpty(@times.result)
      @times.result =
        ms: @times.duration
        seconds: @times.duration * 0.001
        elapsed: @times.elapsed

    @times.result

  report: (options = {}) ->
    _.defaults options, raw: false

    report = [
      depth: @depth
      ms: @result().ms
      name: @name
    ]

    _.each @children, (child) -> report = report.concat child.report(raw: true)

    if options.raw
      report
    else
      _.map(report, (entry) ->
        "#{_.repeat('-', entry.depth * 2)} #{_.padEnd("#{entry.ms} ms", 12)} #{entry.name}"
      ).join '\n'

module.exports =
  time: (options) ->
    if _.isString(options)
      new BenchmarkNode(name: options)
    else
      new BenchmarkNode(options)

  config: (options) -> _.assign config, _.pick(options, _.keys(config))
