[
  _

  BaseDispatcher
  Logger
  CheckoutAccountModel
] = [
  require 'lodash'

  require './base_dispatcher'
  require '../logger'
  require '../backbone/models/checkout_account_model'
]

class CheckoutDispatcher extends BaseDispatcher
  log = Logger.get('CheckoutDispatcher').log

  channel: -> 'checkout'

  mixins: -> [
    'modals'
  ]

  models: ->
    account:
      class: CheckoutAccountModel
      fetchOnWake: true

  events: ->
    'sync account': @onSync

  getStoreChangeHandlers: ->
    estimate: 'handleEstimateStoreChange'

  handleEstimateStoreChange: (nextStore, prevStore) ->
    currentStep = _.first _.kebabCase(nextStore.currentStep).split('-')
    previousStep = _.first _.kebabCase(nextStore.previousStep).split('-')

    if previousStep and currentStep isnt previousStep
      @command 'clearNotification'

  onSync: ->
    @replaceStore @buildStoreData()

  getInitialStore: -> @buildStoreData()

  buildStoreData: ->
    _.assign __fetched: @model('account').isFetched(),
      account: @data('account')

  commands:
    showNotification: (attrs) ->
      @replaceStore notification: attrs

    clearNotification: ->
      @replaceStore notification: {}


module.exports = CheckoutDispatcher
