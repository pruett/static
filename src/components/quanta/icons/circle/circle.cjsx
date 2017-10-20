_     = require 'lodash'
React = require 'react/addons'

require './circle.scss'

module.exports = React.createClass

  getDefaultProps: ->
    cssModifier: ''

  render: ->
    <span className="c-icon-circle #{@props.cssModifier}" />
