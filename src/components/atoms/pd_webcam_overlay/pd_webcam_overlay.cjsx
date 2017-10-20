[
  React
  Rsvg

  Mixins
] = [
  require 'react/addons'
  require 'components/quanta/rsvg/rsvg'

  require 'components/mixins/mixins'

  require './pd_webcam_overlay.scss'
]

module.exports = React.createClass

  SVG:
    class: 'c-pd-webcam-overlay'
    width: 354
    height: 481

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    cssUtility: 'u-dib u-valign--middle'
    cssModifier: ''

  getStaticClasses: ->
    card: "#{@SVG.class}__card"
    cardStripe: "#{@SVG.class}__card-stripe"
    face: "#{@SVG.class}__face"

  getInitialState: ->
    fadeIn: false

  render: ->
    classes = @getClasses()

    <Rsvg {...@props}
      cssModifier={
        [
          @props.cssModifier
          @props.cssUtility
        ].join ' '}
      key='logo'
      SVG={@SVG}>
      <g>
        <ellipse className=classes.face cx=175.5 cy=239.5 rx=175.5 ry=239.5 />
        <rect className=classes.card x=82 y=307 width=190 height=110 rx=9 />
        <rect className=classes.cardStripe x=81 y=325 width=191 height=27 />
      </g>
    </Rsvg>
