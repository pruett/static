[
  React
] = [
  require 'react/addons'

  require './friendbuy.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-friendbuy'

  propTypes:
    widgetId: React.PropTypes.string
    isEnabled: React.PropTypes.bool

  render: ->
    <div className="#{@BLOCK_CLASS} friendbuy-#{@props.widgetId} friendbuy-#{@props.htoWidgetId}" />
