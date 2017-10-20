_     = require 'lodash'
React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

require './left_line_arrow.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--left-line-arrow'
    width: 20
    height: 14

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string


  getDefaultProps: ->
    cssUtility: 'u-icon u-stroke--dark-gray'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG} title='Left line arrow'>
      <path d='M20 7H1m6 7L1 7l6-7' fill='none' />
    </Rsvg>
