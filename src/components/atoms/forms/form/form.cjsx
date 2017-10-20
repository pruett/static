[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.scrolling
  ]

  propTypes:
    id: React.PropTypes.string
    name: React.PropTypes.string
    noValidate: React.PropTypes.bool
    validationErrors: React.PropTypes.object

  getDefaultProps: ->
    id: 'form'
    name: 'form'
    noValidate: true
    validationErrors: {}

  handleSubmit: (evt) ->
    @commandDispatcher 'analytics', 'pushFormEvent', evt
    @props.onSubmit(evt) if _.isFunction(@props.onSubmit)

  componentDidUpdate: (prevProps) ->
    if not @hasValidationErrors(prevProps) and @hasValidationErrors(@props)
        # Scroll to top of form on submit. Helps scan through errors.
        @scrollToNode(@getDOMNode(), { offset: -24 })

  hasValidationErrors: (props) ->
    not _.isEmpty _.omitBy(_.get(props, 'validationErrors'), _.isEmpty)

  componentWillReceiveProps: (nextProps) ->
    @commandDispatcher 'analytics',
      'pushFormValidationEvent',
      @props.validationErrors,
      nextProps.validationErrors,
      React.findDOMNode @

  render: ->
    props = _.omit @props, 'children'

    # Count non-empty errors.
    numErrors = _.size _.omitBy(@props.validationErrors, _.isEmpty)

    # Show count of errors, or just lead with generic.
    error =
      if _.get @props, 'validationErrors.generic'
        @props.validationErrors.generic
      else if numErrors is 1
        'Oops! You missed a spot below.'
      else if numErrors > 1
        'Oops! You missed a couple spots below.'

    <form {...props} onSubmit=@handleSubmit>

      {if error
        <div className='u-reset u-fs16 u-mb24 u-color--yellow' children=error />}

      {@props.children}

    </form>
