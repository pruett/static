_     = require 'lodash'
React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

require './alert.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--alert'
    width: 16
    height: 16

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon u-fill--yellow'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG}>
      <path d='M16 8c0-4.418-3.582-8-8-8S0 3.582 0 8s3.582 8 8 8 8-3.582 8-8zM1 8c0-3.866 3.134-7 7-7s7 3.134 7 7-3.134 7-7 7-7-3.134-7-7z'/>
      <path d='M8.32 10L9 4c.056-.602-.25-1-1-1-.733 0-1.013.384-1 1l.67 6h.65zM9 12c.016-.57-.364-1-1-1-.603 0-1 .43-1 1 0 .62.397 1.033 1 1 .636.033 1-.38 1-1z'/>
    </Rsvg>
