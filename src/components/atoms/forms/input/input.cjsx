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
    Mixins.dispatcher
  ]

  propTypes:
    checked: React.PropTypes.bool
    disabled: React.PropTypes.bool
    readOnly: React.PropTypes.bool
    isTextarea: React.PropTypes.bool

  getDefaultProps: ->
    checked: false
    disabled: false
    readOnly: false
    isTextarea: false

  handleChange: (evt) ->
    @commandDispatcher 'analytics', 'pushFormEvent', evt
    @props.valueLink.requestChange(evt.target.value) if @props.valueLink?
    @props.onChange(evt) if _.isFunction(@props.onChange)

  handleFocus: (evt) ->
    @commandDispatcher 'analytics', 'pushFormEvent', evt
    @props.onFocus(evt) if _.isFunction(@props.onFocus)

  handleBlur: (evt) ->
    @commandDispatcher 'analytics', 'pushFormEvent', evt
    @props.valueLink.requestChange(evt.target.value) if @props.valueLink?
    @props.onBlur(evt) if _.isFunction(@props.onBlur)

  render: ->
    defaultValue = if @props.valueLink?
        @props.valueLink.value
      else
        @props.defaultValue

    props = _.assign _.omit(@props, 'onChange', 'valueLink'),
      onChange: @handleChange
      onBlur: @handleBlur
      onFocus: @handleFocus
      defaultValue: defaultValue

    props = _.defaults props, type: 'text'

    if @props.isTextarea
      <textarea {...props} />
    else
      <input {...props} />
