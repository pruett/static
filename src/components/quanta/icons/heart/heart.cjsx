React = require 'react/addons'
Rsvg = require 'components/quanta/rsvg/rsvg'

require './heart.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--heart'
    width: 20
    height: 18

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string
    active: React.PropTypes.bool

  getDefaultProps: ->
    cssUtility: 'u-icon'
    cssModifier: ''
    active: false

  render: ->
    <Rsvg {...@props} SVG={@SVG} title='Heart'>
      <g transform="translate(1, -257)">
        <path className="c-icon--heart--path #{if @props.active then '-active' else ''}" d='M13.5 258c-2.7-0.1-4.5 3.7-4.5 3.7S7.2 258 4.5 258H4.4c-2.5 0-4.4 2.1-4.4 4.6v0.1c0 2.5 2.5 6 4.3 8 0.9 1 3.8 3.2 4.7 3.4 1-0.2 3.8-2.4 4.7-3.4 1.8-1.9 4.3-5.4 4.3-8v-0.1c0-2.5-1.9-4.6-4.4-4.6H13.5z'/>
      </g>
    </Rsvg>
