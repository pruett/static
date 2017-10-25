[
  BaseDispatcher
  Logger
] = [
  require './base_dispatcher'
  require '../logger'
]

log = Logger.get('ConfigDispatcher').log

class ConfigDispatcher extends BaseDispatcher
  channel: -> 'config'

  getInitialStore: -> _.get @appState, 'config'

  requests:
    get: (name) -> _.get @store, name

module.exports = ConfigDispatcher
