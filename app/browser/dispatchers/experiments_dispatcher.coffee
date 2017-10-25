[
  _

  Logger
  BaseDispatcher
] = [
  require 'lodash'

  require '../logger'
  require '../../common/dispatchers/base_dispatcher'
]

class ExperimentsDispatcher extends BaseDispatcher
  {log, error} = Logger.get('ExperimentsDispatcher')

  OPTIMIZELY_LOAD_TIMEOUT = 5000
  POLLING_INTERVAL = 40
  VALID_DESERIALIZED_VALUE = /^\w+$/i
  COOKIE_EXPERIMENTS_BUCKETED = 'wp-bucketed'

  channel: -> 'experiments'

  shouldAlwaysWake: -> true

  getInitialStore: -> _.get @appState, 'experiments', {}

  wake: ->
    window.optimizely or= []

    @queuedActions = []
    @checkTryCount = 0
    @__checkForOptimizelyAndFacebook()
    @__logExperimentParticipation()
    @__checkExperiments()

  locationDidChange: (nextLocation) -> @__checkExperiments(nextLocation)

  getExperimentState: (nameOrId) ->
    experimentId = _.get @store, "nameMapId.#{nameOrId}"
    experimentId = nameOrId if not experimentId
    _.get @store, "active.#{experimentId}.state", {}

  __testRegex: (str, regex) -> new RegExp(regex).test str

  __deserializeState: (encodedValue) ->
    # Transforms a base64 encoded value to an object only when the key/values
    # validate against the VALID_DESERIALIZED_VALUE regular expression.
    #
    # 1. NTUxNmJkMmU9Zm9vJjA5MmExNTIyPWJhcg==    # Base64 encoded.
    # 2. 5516bd2e=foo&092a1522=bar               # Query string.
    # 3. {"5516bd2e": "foo", "092a1522": "bar"}  # Object.
    return {} if _.isEmpty(encodedValue)

    try
      value = atob("#{encodedValue}")
    catch e
      return {}

    pairs = value.split('&')

    return _.reduce pairs, (acc, el) ->
      [experimentSeed, variantName] = el.split('=')
      if (VALID_DESERIALIZED_VALUE.test(experimentSeed) and
          VALID_DESERIALIZED_VALUE.test(variantName))
        acc[experimentSeed] = variantName
      acc
    , {}

  __logExperimentDataToFacebook: (slug, variant) ->
    try
      ###
      FB User Properties
        Key-value pairs representing user properties and their values.
        https://developers.facebook.com/docs/analytics/properties#the-user-properties-table

        - Values should be strings or numbers only.
        - Each key must be less than 40 characters in length, and the key can contain only
          - letters
          - numbers
          - whitespace
          - hyphens (-)
          - or underscores (_).
        - Each value must be less than 100 characters.
        - The total number of properties associated with your users cannot exceed 100.
      ###
      userProperties =
        "experiment_#{slug}": variant

      FB.AppEvents.updateUserProperties userProperties
    catch e
      error 'FB.AppEvents.updateUserProperties': e

  __serializeState: (state) ->
    # Transforms an object into a base64 encoded value when the key/values
    # validate against the VALID_DESERIALIZED_VALUE regular expression.
    #
    # We encode to base64 because it's portable as a cookie value.
    #
    # 1. {"5516bd2e": "foo", "092a1522": "bar"}  # Object.
    # 2. 5516bd2e=foo&092a1522=bar               # Query string.
    # 3. NTUxNmJkMmU9Zm9vJjA5MmExNTIyPWJhcg==    # Base64 encoded.
    queryString = (_.map state, (variantName, experimentSeed) ->
      if (VALID_DESERIALIZED_VALUE.test(experimentSeed) and
          VALID_DESERIALIZED_VALUE.test(variantName))
        "#{experimentSeed}=#{variantName}"
    ).join('&')

    return btoa(queryString)

  __checkExperiments: (currentLocation = @currentLocation()) ->
    # Check experiments to see if they should bucket.

    pathname = currentLocation.pathname
    hostname = currentLocation.host

    log '__checkExperiments', pathname: pathname, hostname: hostname

    # Automatic page bucketing by regex.
    for key, experiment of @store.active or {}
      { hosts, buckets } = experiment.attributes or {}
      if _.get(experiment, 'state.participant') and hosts and buckets
        if _.some hosts, @__testRegex.bind(@, hostname)
          if _.some buckets, @__testRegex.bind(@, pathname)
            @command 'bucket', experiment.name

  __checkForOptimizelyAndFacebook: ->
    elapsed = POLLING_INTERVAL * @checkTryCount
    if window.optimizely.data? and window.FB?.AppEvents?.getUserID()?
      log "Optimizely available after #{elapsed}ms"
      @__pushOptimizelyState()
      @__processActionQueue()
    else if elapsed >= OPTIMIZELY_LOAD_TIMEOUT
      log "Optimizely unavailable after #{elapsed}ms, giving up"
    else
      @checkTryCount += 1
      _.delay @__checkForOptimizelyAndFacebook.bind(@), POLLING_INTERVAL

  __logExperimentParticipation: ->
    log "#{_.size @store.active} active experiment(s) running"

    for name in _.keys(@store.nameMapId)
      state = @getExperimentState(name)
      if state.participant
        details = []
        details.push 'forced' if state.forced
        details.push 'bucketed' if state.bucketed
        details = if details then " (#{details.join(', ')})" else ''
        log "[#{name}] variant is \"#{state.variant}\"#{details}"
      else
        log "[#{name}] not a participant"

  __getBucketedState: ->
    # Retrieve and deserialize experiment variant state from cookie.
    @__deserializeState(
      @requestDispatcher('cookies', 'get', COOKIE_EXPERIMENTS_BUCKETED,
        skipPrefix: true
      )
    )

  __replaceBucketedState: (bucketedState) ->
    # Serialize and persist experiment variant state in a cookie.
    log "replace \"#{COOKIE_EXPERIMENTS_BUCKETED}\" cookie: #{JSON.stringify(bucketedState)}"
    @commandDispatcher('cookies', 'set', COOKIE_EXPERIMENTS_BUCKETED,
      @__serializeState(bucketedState)
      skipPrefix: true
      expires: 63072000000  # 2 years.
      secure: true
    )

  __pushOptimizelyState: ->
    _.each window.optimizely.activeExperiments, @__fireExperimentImpression.bind(@)

  __fireExperimentImpression: (optimizelyId) ->
    state = window.optimizely.data.state
    experiments = window.optimizely.data.experiments

    for variationId in state.variationIdsMap[optimizelyId]
      @commandDispatcher 'analytics', 'push', 'wp.experimentImpressions',
        experimentId: optimizelyId
        experimentName: experiments[optimizelyId].name
        variationId: variationId
        variationIndex: state.variationMap[optimizelyId]
        variationName: state.variationNamesMap[optimizelyId]

  __processActionQueue: ->
    # Queue actions that depend on scanning the optimizely state or data,
    # because Optimizely may not have loaded yet since it is loaded
    # asynchronously.
    if window.optimizely.data? and window.FB?.AppEvents?.getUserID()?
      _.each @queuedActions, @__handleAction.bind(@)
      @queuedActions = []

  __setExperimentBucketedState: (experimentName, experimentId, variant) ->
    bucketedState = @__getBucketedState()

    if bucketedState[experimentId] isnt variant
      # Update the bucket cookie so that the variant assignment persists.
      bucketedState[experimentId] = variant
      log "storing bucketing \"#{experimentName}\"=\"#{variant}\""
      @__replaceBucketedState bucketedState

  __handleAction: (queued) ->
    data = window.optimizely.data
    prefix = if @environment.production then '[LIVE]' else '[TEST]'

    experiments = data.experiments
    experimentId = _.get @store, "nameMapId.#{queued.name}"
    experimentState = @getExperimentState(queued.name)

    if queued.action is 'bucket'
      @__setExperimentBucketedState queued.name, experimentId, experimentState.variant

    optimizelyId = _.findKey experiments, (obj) ->
      obj.name.indexOf(prefix) > -1 and obj.name.indexOf(experimentId) > -1

    if not optimizelyId
      log "unable to #{queued.action} experiment \"#{queued.name}\": couldn't
        find a #{prefix} experiment with id \"#{experimentId}\""
      return

    if _.has data, "state.variationNamesMap['#{optimizelyId}']"
      log "will not #{queued.action} experiment \"#{queued.name}\":
        already bucketed"
      return

    experiment = experiments[optimizelyId]

    switch queued.action
      when 'activate'
        log "activating experiment ##{optimizelyId}, \"#{experiment.name}\""
        window.optimizely.push ['activate', optimizelyId]
        @__fireExperimentImpression optimizelyId

      when 'bucket'
        unless experimentState.participant and experimentState.variant
          log "not bucketing experiment \"#{experiment.name}\" because not a
            participant"
          return

        variantName = experimentState.variant.toLowerCase()
        variations = experiments[optimizelyId].variation_ids
        variantId = _.findKey variations, (id) ->
          variantName is data.variations[id].name.toLowerCase()

        if variantId
          log "bucketing experiment ##{optimizelyId}, \"#{experiment.name}\"
            into variant \"#{variantName}\""

          if experimentId in ['2453b175', 'c12b166c']
            # Temporarily hardcode the experiments we want to track in FB here.
            # Once this gets working, update experiments in the admin to store
            # if they should be FB tracked.
            @__logExperimentDataToFacebook(experimentId, variantName)

          # Experiments in Optimizely should be set manual activation. Bucketing
          # requires two steps: bucketVisitor and then activate. This is not
          # well documented by Optimizely.
          window.optimizely.push ['bucketVisitor', optimizelyId, variantId]
          window.optimizely.push ['activate', optimizelyId]

          @__fireExperimentImpression optimizelyId
        else
          log "unable find variant \"#{variantName}\" for experiment
            \"#{experiment.name}\""
    return

  commands:
    activate: (name) ->
      @queuedActions.push action: 'activate', name: name
      @__processActionQueue()

    bucket: (name) ->
      @queuedActions.push action: 'bucket', name: name
      @__processActionQueue()

module.exports = ExperimentsDispatcher
