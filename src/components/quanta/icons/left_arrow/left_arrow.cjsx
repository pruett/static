_     = require 'lodash'
React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

require './left_arrow.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--left-arrow'
    width: 8
    height: 12

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG}>
      <path d='M5.7,12L0,6l5.7-6L8,2.4L4.6,6L8,9.6L5.7,12z M1.2,6l4.5,4.7l1.1-1.2L3.4,6l3.4-3.6L5.7,1.3L1.2,6z' />
    </Rsvg>
