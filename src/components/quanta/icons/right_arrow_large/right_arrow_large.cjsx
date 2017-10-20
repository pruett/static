[
  React

  Rsvg
] = [
  require 'react/addons'

  require 'components/quanta/rsvg/rsvg'

  require './right_arrow_large.scss'
]

module.exports = React.createClass

  SVG:
    class: 'c-icon--right-arrow-large'
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
      <path d='M3.9,0L0,3.9L12.1,16L0,28.1L3.9,32L20,16L3.9,0z M2.9,28.1L15,
        16L2.9,3.9l1.1-1.1L17.1,16L3.9,29.1L2.9,28.1z' />
    </Rsvg>
