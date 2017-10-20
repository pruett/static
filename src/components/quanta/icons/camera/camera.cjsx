[
  _
  React

  Rsvg
  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/rsvg/rsvg'
  require 'components/mixins/mixins'

  require './camera.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-camera'

  SVG:
    class: 'c-icon--camera'
    width: 28
    height: 19

  mixins: [Mixins.classes]

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon'
    cssModifier: ''

  getStaticClasses: ->
    cameraBody: "#{@BLOCK_CLASS}__camera-body"
    flash: "#{@BLOCK_CLASS}__flash"
    lens: "#{@BLOCK_CLASS}__lens"
    lensReflection: "#{@BLOCK_CLASS}__lens-reflection"
    shutterButton: "#{@BLOCK_CLASS}__shutter-button"

  render: ->
    classes = @getClasses()

    <Rsvg {...@props} SVG={@SVG}>
      <rect className=classes.cameraBody x=0 y=2.2625 width=27 height=16 rx=1 />
      <circle className=classes.lens cx=13.5 cy=10.2625 r=6 />
      <rect className=classes.flash x=21 y=3.2625 width=4.5 height=3 />
      <rect className=classes.shutterButton x=3 y=0.2625 width=4.5 height=2 />
      <circle className=classes.lensReflection cx=11.25 cy=8.0125 r=0.75 />
    </Rsvg>
