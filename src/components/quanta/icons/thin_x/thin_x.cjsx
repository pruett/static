React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

require './thin_x.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--thin-x'
    width: 14
    height: 14

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon u-stroke--dark-gray'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG} title='Close'>
      <path d='M13.23 12.8L1 1m12.02 0L1 13.02' fill='none' />
    </Rsvg>
