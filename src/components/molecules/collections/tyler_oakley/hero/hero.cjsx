React = require 'react/addons'
_ = require 'lodash'

Mixins = require 'components/mixins/mixins'

Img = require 'components/atoms/images/img/img'

require './hero.scss'


module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  BLOCK_CLASS: 'c-tyler-oakley-hero'

  propTypes:
    mobile_gif: React.PropTypes.string
    overlay: React.PropTypes.string
    video: React.PropTypes.string
    logo: React.PropTypes.string

  getDefaultProps: ->
    logo: ''
    video: ''
    overlay: ''
    mobile_gif: ''

  getInitialState: ->
    videoLoaded: false

  videoLoaded: ->
    @setState videoLoaded: true

  componentDidMount: ->
    #  Unable to pass a synthetic loaded data event down, therefore grabbing dom
    #  node directly
    video = React.findDOMNode @refs.video
    video.addEventListener 'loadeddata', @videoLoaded

  componentWillUnmount: ->
    video = React.findDOMNode @refs.video
    video.removeEventListener 'loadeddata', @videoLoaded

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-mw1440 u-mla u-mra
      u-color-bg--black
    "
    mediaWrapper: '
      u-pr
    '
    video: '
      u-w12c
    '
    videoWrapper: '
      u-h0 u-pb2x1
    '
    overLay: "
      u-pa u-t0 u-l0
      u-center-x
      #{@BLOCK_CLASS}__overlay
    "
    logo: "
      u-pa u-t0
      u-w5c u-center
      #{@BLOCK_CLASS}__logo
    "

  classesWillUpdate: ->
    overLay:
      '-faded': @state.videoLoaded
    logo:
      '-nudge': @state.videoLoaded

  logoSizes: [
    breakpoint: 900
    width: '40vw'
  ,
    breakpoint: 1200
    width: '30vw'
  ]

  getLogoProps: ->
    url: @props.logo
    widths: @getImageWidths 300, 600, 4

  render: ->
    classes = @getClasses()

    logoSrcSet = @getSrcSet @getLogoProps()
    logoSizes = @getImgSizes @logoSizes

    <div className=classes.block>
      <div className=classes.mediaWrapper>
        <div classes=classes.videoWrapper>
          <video autoPlay='autoplay'
            ref='video'
            src=@props.video
            muted=true loop='loop'
            className=classes.video />
        </div>
        <Img srcSet=logoSrcSet sizes=logoSizes
             alt='Warby Parker and Tyler Oakley'
             cssModifier=classes.logo />
      </div>
      <img src=@props.overlay className=classes.overLay />
    </div>
