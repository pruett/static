[
  _
  React

  Logger
  Radio
] = [
  require 'lodash'
  require 'react/addons'

  require '../logger'
  require '../radio'
]

log = Logger.get('RootComponent').log

module.exports =
  initialize: (components) ->
    React.createClass
      displayName: 'RootComponent'

      childContextTypes:
        locale: React.PropTypes.object.isRequired
        experiments: React.PropTypes.object.isRequired
        modifiers: React.PropTypes.object.isRequired

      getChildContext: ->
        locale: @state.locale
        experiments: @state.experiments
        modifiers: @state.modifiers

      getInitialState: ->
        @props.appState

      componentDidMount: ->
        log 'componentDidMount'
        document.body.className += ' react-mounted'
        _.result @props, 'benchmarks.rootMount.end'
        Radio.channel('appState').on 'change', @handleChange

      componentDidUpdate: (prevProps, prevState) ->
        log 'componentDidUpdate'
        if _.get(prevState, 'location.pathname') isnt _.get(@state, 'location.pathname')
          scrollTo = _.get @props.appState, 'location.scrollTo', { x: 0, y: 0 }
          window.scrollTo(scrollTo.x, scrollTo.y)

      handleChange: ->
        location = _.get @props.appState, 'location'
        log 'handleChange', location

        title = if _.isEmpty(location.title)
          'Warby Parker'
        else
          "#{location.title} | Warby Parker"

        document.title = title

        @setState location: location

      render: ->
        componentName = _.get @state, 'location.component'
        component = @props.staticComponent or components[componentName]

        log 'render', componentName

        if component
          React.createElement component,
            appState: @state
            benchmarks: @props.benchmarks
        else
          # Something's gone wrong, don't handle further routing.
          log 'render', 'PagesError'
          Radio.channel('routing').request 'stop'
          React.createElement require('components/pages/error/error.cjsx'),
            appState: _.assign {}, @state,
              location:
                error:
                  message: 'Not Implemented'
                  statusCode: 501
