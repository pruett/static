[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'
]

# This component borrows heavily from react-router's Link:
# https://github.com/reactjs/react-router/blob/master/modules/Link.js

module.exports = React.createClass
  mixins: [
    Mixins.dispatcher
  ]

  propTypes:
    'data-link': React.PropTypes.bool
    onClick: React.PropTypes.func
    target: React.PropTypes.string

  getDefaultProps: ->
    'data-link': true

  isLeftClickEvent: (evt) ->
    evt.button is 0

  isModifiedEvent: (evt) ->
    !!(evt.metaKey or evt.altKey or evt.ctrlKey or evt.shiftKey)

  handleClick: (evt) ->
    if _.isFunction @props.onClick
      @props.onClick evt

    if @isModifiedEvent(evt) or not @isLeftClickEvent(evt)
      # Ignore modified and non-left click events.
      return

    if @props.target
      # Ignore if a target is set (e.g. to "_blank").
      return

    evt.preventDefault()

    unless @props.role in ['button', 'presentation']
      @commandDispatcher 'routing', 'navigate', evt.currentTarget.href

  render: ->
    <a {...@props} onClick=@handleClick />
