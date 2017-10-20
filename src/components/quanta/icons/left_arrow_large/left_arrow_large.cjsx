[
  React

  Rsvg
] = [
  require 'react/addons'

  require 'components/quanta/rsvg/rsvg'

  require './left_arrow_large.scss'
]

module.exports = React.createClass

  SVG:
    class: 'c-icon--left-arrow-large'
    width: 20
    height: 32

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG}>
      <path d='M16.1,32l3.9-3.9L7.9,16L20,3.9L16.1,0L0,16L16.1,32z M17.1,3.9L5,
        16l12.1,12.1l-1.1,1.1L2.9,16L16.1,2.9L17.1,3.9z' />
    </Rsvg>
