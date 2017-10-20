_     = require 'lodash'
React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

require './x.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--x'
    width: 12
    height: 12

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon u-fill--dark-gray'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG} title='Close'>
      <path d='M.66 10.012l-.66.66 1.322 1.324.662-.66 9.355-9.352.66-.66L10.678 0l-.662.66L.66 10.013z'/>
      <path d='M10.016 11.335l.662.66L12 10.674l-.66-.66L1.983.66 1.322 0 0 1.323l.66.66 9.356 9.352z'/>
    </Rsvg>
