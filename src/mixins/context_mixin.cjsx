[
  _
  React
] = [
  require 'lodash'
  require 'react/addons'
]

module.exports =
  contextTypes:
    locale: React.PropTypes.object.isRequired
    experiments: React.PropTypes.object.isRequired
    modifiers: React.PropTypes.object.isRequired

  inExperiment: (name, variant) ->
    state = @getExperimentState name
    state.participant and state.variant is variant

  getExperimentDetails: (name) ->
    experiments = @context.experiments
    experimentId = _.get experiments, "nameMapId.#{name}"
    _.get experiments, "active.#{experimentId}", {}

  getExperimentState: (name) ->
    _.get @getExperimentDetails(name), 'state', {}

  getExperimentVariant: (name) ->
    state = @getExperimentState name
    if state.participant then state.variant else null

  getLocale: (item) ->
    locale = @context.locale
    if item then locale[item] else locale

  getFeature: (feature) ->
    _.get @context, "locale.features.#{feature}"

  modifier: (feature, defaultValue = false) ->
    _.get @context, "modifiers.#{feature}", defaultValue
