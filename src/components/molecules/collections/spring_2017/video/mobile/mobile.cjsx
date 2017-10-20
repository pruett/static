React = require 'react/addons'
_ = require 'lodash'

Picture = require 'components/atoms/images/picture/picture'
Mixins = require 'components/mixins/mixins'

require './mobile.scss'


module.exports = React.createClass

  mixins: [
    Mixins.dispatcher
    Mixins.classes
    Mixins.context
    Mixins.image
  ]

  BLOCK_CLASS: 'c-spring-2017-mobile-video'

  BUTTON_SRC: 'https://i.warbycdn.com/v/c/assets/spring-2017/image/play-button/0/6d5033a043.png'


  getInitialState: ->
    mobileVideoPlaying: false

  componentDidMount: ->
    @inlineVideo()

  getStaticClasses: ->
    block: '
      u-mw1440
      u-mla u-mra
    '
    videoDesktop: '
      u-w11c
    '
    mobileVideo: "
      #{@props.cssModifierVideo}
      u-w12c u-w11c--600
      u-pr
    "
    mobileVideoWrapper: '
      u-pr
    '
    button: "
      #{@BLOCK_CLASS}__button
      u-pa u-center
      u-w3c u-w4c--600
    "
    image: '
      u-w12c u-w11c--600
    '

  classesWillUpdate: ->
    button:
      '-hide': @state.mobileVideoPlaying
      'u-dn': @props.isHero

  handleMobileVideoClick: ->
    mobileVideo = React.findDOMNode @refs.mobileVideo
    if not @state.mobileVideoPlaying
      @setState mobileVideoPlaying: true
      mobileVideo.play()

  getMobilePoster: ->
    video = @props.video
    if @props.viewport is 'mobile'
      video.video_poster_mobile
    else
      video.video_poster_desktop

  getPictureAttrs: (images = []) ->
    sources: [
      url: @getImageBySize(images, 'desktop-sd')
      quality: @getQualityBySize(images, 'desktop-sd')
      widths: @getImageWidths 900, 2200, 5
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 'tablet')
      quality: @getQualityBySize(images, 'tablet')
      widths: _.range 700, 1400, 200
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'mobile')
      quality: @getQualityBySize(images, 'mobile')
      widths: @getImageWidths 300, 800, 5
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Warby Parker Spring 2017 Collection'
      className: @classes.image

  renderMobileVideo: ->
    <div className=@classes.mobileVideoWrapper>
      <video
        muted=true
        autoPlay={if @props.isHero then 'autoplay' else false}
        ref='mobileVideo'
        loop='true'
        className=@classes.mobileVideo
        src=@props.src
        poster={@getMobilePoster()} />
      <img
        src=@BUTTON_SRC
        onClick=@handleMobileVideoClick
        className=@classes.button />
    </div>

  renderStaticImages: ->
    # Don't use video for two-up layout
    pictureAttrs = @getPictureAttrs(@props.images)
    <Picture children={@getPictureChildren(pictureAttrs)} />


  inlineVideo: ->
    mobileVideo = React.findDOMNode @refs.mobileVideo
    if mobileVideo
      mobileVideo.setAttribute 'playsinline', true

  render: ->
    @classes = @getClasses()
    <div className=@classes.block>
      <div className=@classes.wrapper>
        {
          if @props.twoUp
            @renderStaticImages()
          else
            @renderMobileVideo()
        }
      </div>
    </div>
