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
  BLOCK_CLASS: 'c-input--radio'

  mixins: [
    Mixins.dispatcher
  ]

  propTypes:
    checked: React.PropTypes.bool
    disabled: React.PropTypes.bool
    readOnly: React.PropTypes.bool

  getDefaultProps: ->
    checked: false
    disabled: false
    readOnly: false

  handleChange: (evt) ->
    @commandDispatcher 'analytics', 'pushFormEvent', evt
    @props.onChange(evt) if _.isFunction(@props.onChange)

  render: ->
    <input {...@props} onChange=@handleChange type='radio' className=@BLOCK_CLASS />
