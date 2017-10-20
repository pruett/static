_     = require 'lodash'
React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

require './right_arrow.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--right-arrow'
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
      <path d='M0 10l2 2 6-6-6-6-2 2 4 4-4 4z' />
    </Rsvg>
