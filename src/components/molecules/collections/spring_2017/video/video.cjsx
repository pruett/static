React = require 'react/addons'
_ = require 'lodash'

Picture = require 'components/atoms/images/picture/picture'
Mixins = require 'components/mixins/mixins'
MobileVideo = require 'components/molecules/collections/spring_2017/video/mobile/mobile'

require './video.scss'


module.exports = React.createClass

  mixins: [
    Mixins.dispatcher
    Mixins.classes
    Mixins.context
    Mixins.image
  ]

  propTypes:
    ctas: React.PropTypes.array
    placeholder_images: React.PropTypes.array
    dual_ctas: React.PropTypes.bool
    is_video: React.PropTypes.bool
    orientation: React.PropTypes.string
    static_image_src: React.PropTypes.string
    dual_ctas: React.PropTypes.bool
    is_video: React.PropTypes.bool
    tabletVideo: React.PropTypes.bool
    cta_id: React.PropTypes.number
    frame_id: React.PropTypes.number
    video: React.PropTypes.object

  getDefaultProps: ->
    cta_id: 0
    ctas: []
    dual_ctas: true
    frame_id: 0
    images: []
    is_video: true
    orientation: ''
    placeholder_images: []
    static_image_src: ''
    video: {}
    tabletVideo: false

  BLOCK_CLASS: 'c-spring-2017-video'

  DESKTOP_MINIMUM_WIDTH: 900

  TABLET_MINIMUM_WIDTH: 600

  getInitialState: ->
    viewport: 'mobile'
    viewportChecked: false
    desktopDataLoaded:false

  componentDidMount: ->
    @checkWindowWidth()
    @throttledCheckWindowWidth = _.throttle @checkWindowWidth, 100
    window.addEventListener('resize', @throttledCheckWindowWidth)

  checkWindowWidth: ->
    windowWidth = window.innerWidth or _.get(document, 'documentElement.clientWidth')
    if windowWidth <= @TABLET_MINIMUM_WIDTH
      @setState viewport: 'mobile'
    else if windowWidth > @TABLET_MINIMUM_WIDTH and windowWidth <= @DESKTOP_MINIMUM_WIDTH
      @setState viewport: 'tablet'
    else if windowWidth > @DESKTOP_MINIMUM_WIDTH
      @setState viewport: 'desktop'

    @setState viewportChecked: true

  getStaticClasses: ->
    block: '
      u-mw1440
      u-mla u-mra
      u-pr
    '
    videoDesktop: "
      #{@props.cssModifierVideo}
      u-w11c
    "
    mobileVideo: '
      u-w12c u-w11c--600
    '
    mobileVideoWrapper: '
      u-pr
    '
    button: '
      u-pa u-center
    '
    image: "
      #{@BLOCK_CLASS}__image
      u-w12c u-w11c--600
    "
    wrapper: "
      #{@BLOCK_CLASS}__wrapper
      #{@props.cssModifierVideoWrapper}
      u-h0
    "
    loader: "
      #{@BLOCK_CLASS}__loader
      u-pa u-t0
      u-w12c
      u-color-bg--light-gray
    "

  classesWillUpdate: ->
    wrapper:
      '-faded': @state.desktopDataLoaded or
      (@state.viewportChecked and @state.viewport is 'mobile') or
      (@state.viewportChecked and @state.viewport is 'tablet')
    loader:
      '-fade': @state.desktopDataLoaded

  renderDesktopVideo: ->
    video = @props.video
    <div>
      <video
        autoPlay='autoplay'
        muted=true
        loop='loop'
        className=@classes.videoDesktop
        ref='desktopVideo' >
        <source src=video.video_src_desktop type='video/mp4' />
      </video>
    </div>

  addDataListener: ->
    desktopVideo = React.findDOMNode @refs.desktopVideo
    if desktopVideo
      desktopVideo.addEventListener 'loadeddata', @handleLoadedData

  handleLoadedData: ->
    @setState desktopDataLoaded: true

  componentDidUpdate: ->
    @addDataListener()

  getMobileSrc: ->
    video = @props.video
    if @state.viewport is 'mobile'
      video.video_src_mobile
    else if @state.viewport is 'tablet'
      if @props.tabletVideo
        video.video_src_tablet
      else
        video.video_src_desktop

  renderLoader: ->
    return false unless @props.isHero
    <div className=@classes.loader />

  render: ->
    @classes = @getClasses()
    <div className=@classes.block>
      {@renderLoader()}
      <div className=@classes.wrapper>
      {
        if @state.viewportChecked
          if @state.viewport is 'mobile' or @state.viewport is 'tablet'
            <MobileVideo
              cssModifierVideo=@props.cssModifierVideo
              video=@props.video
              isHero=@props.isHero
              images=@props.images
              twoUp=@props.two_up
              src={@getMobileSrc()}
              viewport=@state.viewport />
          else if @state.viewport is 'desktop'
            @renderDesktopVideo()
      }
      </div>
    </div>
