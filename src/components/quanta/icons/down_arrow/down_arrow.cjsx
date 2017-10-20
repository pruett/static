[
  _
  React

  Rsvg
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/rsvg/rsvg'

  require './down_arrow.scss'
]

module.exports = React.createClass

  SVG:
    class: 'c-icon--down-arrow'
    width: 12
    height: 8

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG}>
      <path d="M2,0L0,2l6,6l6-6l-2-2L6,4L2,0z"/>
    </Rsvg>
