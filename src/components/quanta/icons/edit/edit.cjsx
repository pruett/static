_     = require 'lodash'
React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

require './edit.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--edit'
    width: 12
    height: 12

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon u-fill--dark-gray'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG} title='Edit'>
      <g transform="rotate(45 5.5 7) translate(3 -1)">
        <path d="M1.005 12.57h3l-1.5 3-1.5-3zM1 3h3v8.6H1z"/>
        <rect x="1" width="3" height="2" rx=".3"/>
        <path d="M1 1h3v1H1z"/>
      </g>
    </Rsvg>
