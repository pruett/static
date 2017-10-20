React = require 'react/addons'
_ = require 'lodash'

Mixins = require 'components/mixins/mixins'

require './video.scss'


module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.analytics
    Mixins.dispatcher
  ]

  BLOCK_CLASS: 'c-tyler-oakley-video'

  PLAY_BUTTON_SRC: 'https://i.warbycdn.com/v/c/assets/tyler-oakley/image/play_button/1/c762b76a74.png'

  PAUSE_BUTTON_SRC: 'https://i.warbycdn.com/v/c/assets/tyler-oakley/image/pause_button/1/105b7dc834.png'

  propTypes:
    cssModifier: React.PropTypes.string
    mobile: React.PropTypes.bool
    video: React.PropTypes.object
    video_category: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''
    mobile: true
    video: {}
    video_category: 'tylerDancing'

  getInitialState: ->
    videoHovered: false
    mobileVideoPlaying: false
    posterFaded: false
    mobileVideoEnded: true

  componentDidMount: ->
    #  React doesn't support the `playsinline` attribute, so add this manually
    #  to mobile videos. Additionally, add a vanilla event listener for when
    #  the video has ended.
    if not @props.mobile
      @desktopVideo = React.findDOMNode @refs.desktopVideo
      @desktopVideo.addEventListener 'loadeddata', @desktopVideoLoaded

    if @props.mobile
      @mobileVideo = React.findDOMNode @refs.mobileVideo
      @mobileVideo.setAttribute 'playsinline', true
      @mobileVideo.addEventListener 'ended', @mobileVideoEnded

  componentWillUnmount: ->
    if not @props.mobile
      @desktopVideo.removeEventListener 'loadeddata', @desktopVideoLoaded
    if @props.mobile
      @mobileVideo.removeEventListener 'ended', @mobileVideoEnded

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
    "
    grid: '
      u-grid -maxed u-mla u-mra
    '
    mediaWrapper: '
      u-mla u-mra u-tac u-mw1440 u-pr
      u-pb2x1 u-h0
    '
    coverImage: '
      u-pa u-pt0 u-l0 u-w100p
    '
    videoDesktop: '
      u-w12c u-pa u-t0 u-l0
    '
    frameInfoWrapper: '
      u-w12c u-tac
    '
    frameName: '
      u-fs22 u-fs24--900
      u-ffs
      u-fws
      u-fsb
      u-mb4
      u-color--black
      u-reset
    '
    frameColor: '
      u-fs16 u-fs18--900
      u-fsi
      u-ffs
      u-color--black
      u-ml2
      u-reset
    '
    frameInfoMobile: '
      u-dn--900
      u-mb12 u-mb18--600
    '
    frameInfoDesktop: '
      u-dn u-dib--900
      u-pt36
      u-mb18
    '
    link: "
      u-bbss u-bbw2 u-bbw0--900
      u-pb6
      u-fws
      u-fs16 u-fs18--900
      u-wsnw
      u-color--blue
      #{@BLOCK_CLASS}__link
    "
    column: '
      u-grid__col u-w12c
    '
    mobileButton: "
      u-pa u-w3c u-w2c--600
      #{@BLOCK_CLASS}__mobile-button
    "
    mobileVideo: '
      u-w12c u-pr
    '
    mobileVideoWrapper: '
      u-pr u-mb36
      u-pr48--600 u-pl48--600
      u-mr18--600 u-ml18--600
    '
    playButton: '
      u-w12c
    '
    pauseButton: '
      u-w12c
    '
    poster: "
      #{@BLOCK_CLASS}__poster
      u-pa u-t0 u-l0
      u-pr48--600 u-pl48--600
    "

  classesWillUpdate: ->
    coverImage:
      'u-dn': @state.videoHovered
    playButton:
      'u-dn': @state.mobileVideoPlaying
      'u-dib': not @state.mobileVideoPlaying
    pauseButton:
      'u-dn': not @state.mobileVideoPlaying
      'u-dib': @state.mobileVideoPlaying
    poster:
      '-faded': @state.posterFaded
      '-covered': @state.mobileVideoEnded

  handleVideoHoverOn: ->
    @setState videoHovered: true

  handleVideoHoverOff: ->
    @setState videoHovered: false

  renderFansLinks: (link, i) ->
    return false unless link

    <a
      className=@classes.link
      onClick={@handleLinkClick.bind @, link}
      key=i
      href=link.path
      children={if link.gender is 'm' then 'Shop Men' else 'Shop Women'} />

  handleLinkClick: (link) ->
    genderLookup =
      m: 'Men'
      f: 'Women'
    frameInfo = @props.frame_info or {}
    @trackInteraction "LandingPage-clickShop#{genderLookup[link.gender]}Callout-#{frameInfo.sku}"

    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [
        brand: 'Warby Parker'
        category: 'Eyeglasses'
        list: 'tylerOakley'
        id: link.product_id
        name: frameInfo.name
        position: frameInfo.position
        sku: frameInfo.sku
        url: link.path
      ]

  renderFrameInfo: ->
    links = _.get @props, 'frame_info.gendered_details', []
    info = @props.frame_info or {}

    <div className=@classes.frameInfoWrapper>
      <div className=@classes.frameInfoMobile>
        <h3 children=info.name className=@classes.frameName />
        <h4 children=info.color className=@classes.frameColor />
      </div>
      <div className=@classes.frameInfoDesktop>
        <span children=info.name className=@classes.frameName />
        <span children={" in #{info.color}"} className=@classes.frameColor />
      </div>
      <div>
        {links.map (link, i) => @renderFansLinks(link, i)}
      </div>
    </div>

  mobileVideoEnded: ->
    @setState mobileVideoPlaying: false
    @setState mobileVideoEnded: true
    @handleGAVideoInteraction('end')

  handleGAVideoInteraction: (interaction) ->
    @trackInteraction "#{@props.video_category}-#{interaction}-tylerOakley"

  handlePlayClick: ->
    if not @state.mobileVideoPlaying
      @handleGAVideoInteraction('play')
      @mobileVideo.play()
      @setState mobileVideoPlaying: true
      if not @state.posterFaded
        @setState posterFaded: true
      if @state.mobileVideoEnded
        @setState mobileVideoEnded: false
    else if @state.mobileVideoPlaying
      @handleGAVideoInteraction('pause')
      @mobileVideo.pause()
      @setState mobileVideoPlaying: false

  render: ->
    @classes = @getClasses()

    <div className=@classes.block>
      {
        if not @props.mobile
          video = _.get @props, 'video.desktop'
          <div className=@classes.grid>
            <div className=@classes.column>
              <div className=@classes.mediaWrapper onMouseEnter=@handleVideoHoverOn onMouseLeave=@handleVideoHoverOff >
                <video autoPlay='autoplay' ref='desktopVideo' muted=true loop='loop' className=@classes.videoDesktop poster=video.poster>
                  <source src=video.source type='video/mp4' />
                </video>
                <img src=video.poster className=@classes.coverImage />
              </div>
            </div>
          </div>
        else
          video = _.get @props, 'video.mobile'
          <div className=@classes.mobileVideoWrapper>
            <video ref='mobileVideo' muted=true className=@classes.mobileVideo poster=video.poster >
              <source src=video.source type='video/mp4' />
            </video>
            <img src=video.poster className=@classes.poster />
              <button onClick=@handlePlayClick className=@classes.mobileButton >
                <img alt='play' src=@PLAY_BUTTON_SRC className=@classes.playButton />
                <img alt='pause' src=@PAUSE_BUTTON_SRC className=@classes.pauseButton />
              </button>
          </div>
      }
      {@renderFrameInfo()}
    </div>
