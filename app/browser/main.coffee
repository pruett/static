global._                  = require 'lodash'
global.$script            = require 'scriptjs'
global.Backbone           = require 'exoskeleton'
global.Backbone.ajax      = require 'backbone.nativeajax'
global.Backbone.DeepModel = require 'backbone-deep-model'
global.Backbone.Radio     = require '../common/radio'
global.Benchmark          = require '../common/utils/benchmark'
global.Cookies            = require 'cookies-js'
global.Logger             = require './logger'
global.picturefill        = require 'picturefill'
global.React              = require 'react/addons'

[
  _
  Benchmark
  React
  Channels
  Dispatchers
  Radio
  RootComponent
  UUID
] = [
  global._
  global.Benchmark
  global.React
  require './channels'
  require './dispatchers'
  require '../common/radio'
  require '../common/components/root'
  require './uuid'
]

inExperiment = (name, variant) ->
  experiments = _.get global, 'WarbyParker.experiments'
  experimentId = _.get experiments, "nameMapId.#{name}"
  state = _.get experiments, "active.#{experimentId}.state", {}
  state.participant and state.variant is variant

if BOOMR?
  # When mPulse/boomerang is available, globally set timing stats.
  Benchmark.config(
    afterEnd: (benchmark) ->
      try
        id = benchmark.identity().replace(/\./g, '_')
        result = benchmark.result()
        # Timing stat variables look like `__timing__root_component_mount`.
        global["__timing__#{id}_complete"] = parseInt result.elapsed, 10
        global["__timing__#{id}_duration"] = parseInt result.ms, 10
      return
  )

noDefer = inExperiment 'deferDispatchers', 'noDefer'

benchmarks =
  # Benchmarks passed down to root component.
  if noDefer
    rootMount: Benchmark.time 'root.component.mount.noDefer'
    cartVisible: Benchmark.time 'cart.component.visible.noDefer'
  else
    rootMount: Benchmark.time 'root.component.mount'
    cartVisible: Benchmark.time 'cart.component.visible'

# Application state is passed from the server to the browser via the
# `WarbyParker` global. It includes data like prefetched API requests.
appState = _.merge global.WarbyParker,
  config:
    environment:
      server: false
      browser: true

if _.get(appState, 'config.environment.debug')
  # Configure the logger for debug mode if we're in a supported environment.
  Logger.setup level: 'log'
  Logger.get('Logger').log(debug: true)

globalComponents =
  'PagesError': require 'components/pages/error/error'

global.Components = {} if not global.Components

for name, component of globalComponents
  global.Components[name] = component

# We want to check and set a UUID as early as possible, so subsequent
# requests include the UUID cookie.
UUID.check()

Radio.freezeChannels()

global.AppState = appState
global.Channels = Channels
global.Radio = Radio
global.Dispatchers = Dispatchers.browserInitialize appState, noDefer, ->
  # After Dispatchers are initialized, render the current page. It will
  # already have been rendered by the server, so in most cases, this just
  # allows React to synchronize with the DOM and handle subsequent state
  # changes.

  # In the browser environment, the necessary components for the page/bundle
  # will be available in the global Components object.
  root = RootComponent.initialize(global.Components)

  React.render(
    React.createElement root, { appState: appState, benchmarks: benchmarks }
    document.getElementById 'root-element'
  )
