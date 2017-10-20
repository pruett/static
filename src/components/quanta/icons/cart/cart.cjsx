React = require 'react/addons'
Rsvg = require 'components/quanta/rsvg/rsvg'
Mixins = require 'components/mixins/mixins'

require './cart.scss'

module.exports = React.createClass

  mixins: [
    Mixins.classes
  ]

  SVG:
    class: 'c-icon--cart'
    width: 30
    height: 23

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string
    hasItemsInCart: React.PropTypes.bool

  getDefaultProps: ->
    cssUtility: 'u-icon'
    cssModifier: ''
    title: 'Cart'
    hasItemsInCart: false

  getStaticClasses: ->
    group: "
      #{@SVG.class}__group
    "

    path: "
      #{@SVG.class}__path
    "

    fill: "
      #{@SVG.class}__fill
    "

  render: ->
    classes = @getStaticClasses()
    stroke = strokeLinecap: 'round', strokeLinejoin: 'round'

    <Rsvg {...@props} SVG={@SVG}>
      <g className=classes.group>
        <path {...stroke} className=classes.path d="M.396.407h2.91c.883 0 1.783.71 2.002 1.58l.102.41c.22.87.575 2.29.794 3.158l2.324 9.264c.22.868 1.12 1.578 2.002 1.578h12.643c.883 0 1.872-.682 2.197-1.515l3.633-9.294C29.328 4.755 28.883 4 28 4H6" />
        <rect className=classes.fill x="12" y="8" width="16" height="1" rx=".5"/>
        <path className=classes.fill d="M13.947 20.472c0 .675-.54 1.222-1.204 1.222-.665 0-1.204-.547-1.204-1.222 0-.674.538-1.222 1.203-1.222s1.204.548 1.204 1.222M22.777 20.472c0 .675-.54 1.222-1.204 1.222-.665 0-1.204-.547-1.204-1.222 0-.674.538-1.222 1.203-1.222.664 0 1.204.548 1.204 1.222" />
      </g>
    </Rsvg>
