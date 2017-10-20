React = require 'react/addons'
Rsvg = require 'components/quanta/rsvg/rsvg'
Mixins = require 'components/mixins/mixins'

require './menu.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--menu'
    width: 20
    height: 32

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon'
    cssModifier: ''

  getStaticClasses: ->
    group: "
      #{@SVG.class}__group
    "

  render: ->
    classes = @getStaticClasses()
    rectDimensions = width: '24', height: '1', rx: '.5'

    <Rsvg {...@props} SVG={@SVG}>
      <g className=classes.group>
        <rect {...rectDimensions} />
        <rect y="8" {...rectDimensions} />
        <rect y="16" {...rectDimensions} />
      </g>
    </Rsvg>
