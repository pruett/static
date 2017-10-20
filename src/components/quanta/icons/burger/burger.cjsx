_     = require 'lodash'
React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

require './burger.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--burger'
    width: 16
    height: 16

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon u-fill--dark-gray'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG}>
      <g transform="translate(0 2)">
        <path d='M0 0h16v2H0z'/>
        <path d='M0 5h16v2H0z'/>
        <path d='M0 10h16v2H0z'/>
      </g>
    </Rsvg>
