[
  _
  Logger
] = [
  require 'lodash'
  require '../../logger'
]

module.exports =

  __initLogs: (path, logs = {}) ->
    # Logger isn't within mixin scope, recreate dispatcher name from channel.
    # Create individual loggers based on provided keys.
    channel = _.upperFirst _.result(@, 'channel', '')
    log = Logger.get("#{channel}Dispatcher").log
    _.mapValues logs, (value) -> (msg) -> log "[#{path}] CMS #{value} #{msg}"

  __checkExperiment: (path, arr, experiment) ->
    # Must be an active participant with valid variant.
    # Get active experiments who have content_variations that match path.
    regExps = _.get experiment, 'attributes.content_variations'

    arr.push(experiment) if not _.isEmpty(regExps) and
      _.get(experiment, 'state.participant') and
      _.get(experiment, 'state.variant') and
      _.some regExps, (regExp) -> new RegExp(regExp).test path

    arr

  getContentVariationKey: (content = {}, path, variantKey) ->
    # Get variation key from content based on supplied key or
    # experiment running on content path.

    # Safely get path from `contentPath` if not set.
    path ?= _.result @, 'contentPath', ''

    {logVar, logExp} = @__initLogs path, logVar: 'Variant', logExp: 'Experiment'

    if variantKey
      # If variantKey forced and available, skip experiments.
      hasVariant = _.has content, variantKey
      logVar "'#{variantKey}' forced"
      logVar "'#{variantKey}' #{if hasVariant then 'used' else 'missing'}"
      return variantKey if hasVariant

    # Get active experiments and reduce to experiments on content path.
    experimentsObj = _.get @appState, 'experiments.active'
    experiments = _.transform experimentsObj, @__checkExperiment.bind(@, path), []

    unless _.isEmpty experiments
      # Experiments found, first match supplies variant.
      expVariantKey = _.get experiments, '[0].state.variant'
      hasExpVariant = _.has content, expVariantKey

      logExp "'#{_.get experiments, '[0].name'}' chosen"
      logExp "'#{exp.name}' not chosen" for exp in _.tail experiments
      logVar "'#{expVariantKey}' #{if hasExpVariant then 'used' else 'missing'}"

      # Only return variant if exists.
      return expVariantKey if hasExpVariant

    # Return default.
    logVar '\'default\' used'
    return 'default'

  getContentVariation: (content = {}, path, variantKey) ->
    _.get content, @getContentVariationKey(content, path, variantKey)
