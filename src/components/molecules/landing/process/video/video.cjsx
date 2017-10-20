[
  _
  React

  Picture

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/picture/picture'

  require 'components/mixins/mixins'

  require './video.scss'
]

module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.analytics
    Mixins.callout
  ]

  propTypes:
    header: React.PropTypes.string
    media: React.PropTypes.object
    css_utilities: React.PropTypes.object
    copy: React.PropTypes.array
    ga_target: React.PropTypes.string
    callout_type: React.PropTypes.string

  getInitialState: ->
    playVideo: false

  BLOCK_CLASS: 'c-landing-process-video'

  getStaticClasses: ->
    copyModifier = _.get @props, 'media.video.copy.video_text_color', 'standard'

    block: "
      u-pr
      u-mw1440
      u-mla u-mra
      #{@props.css_utilities.block_margin_bottom}
    "
    grid: '
      u-grid
    '
    row: '
      u-grid__row u-tal
      u-pr u-r1c
    '
    video: '
      u-pa
      u-t0 u-l0
      u-w100p
      u-h100p
    '
    videoOverlayWrapper: "
      #{@BLOCK_CLASS}__video-overlay-wrapper
      u-w100p
      u-t0 u-l0
    "
    picture: '
      u-pa
      u-w100p
    '
    playButton: "
      #{@BLOCK_CLASS}__play-button
    "
    buttonWrapper: "
      u-tar
      u-grid__col u-w3c u-w2c--600 -col-middle
      u-pr
      #{@BLOCK_CLASS}__button-wrapper
    "
    videoControls: "
      #{@BLOCK_CLASS}__video-controls
      u-pa u-tac
      u-w100p
      u-b0
      u-pb12 u-pb36--600
    "
    videoContainer: '
      u-pr
      u-pb1x1 u-pb3x2--600 u-pb16x9--900
    '
    videoHeader: '
      u-fs16 u-fs18--900
      u-reset u-fwb
    '
    videoSubHeader: '
      u-fs14 u-fs16--900
      u-reset
    '
    videoCopyWrapper: "
      u-grid__col u-w6c -col-middle
      u-tal
      #{@COLOR_LOOKUP[copyModifier]}
      #{@BLOCK_CLASS}__video-copy-wrapper
    "

  classesWillUpdate: ->
    videoOverlayWrapper:
      '-hidden': @state.playVideo

  getVideoSrc: ->
    "https://www.youtube.com/embed/#{_.get @props, 'media.video.src'}?autoplay=1&controls=0&rel=0&showinfo=0"

  handleClickPlay: ->
    @trackInteraction("Videos-Play-#{_.get @props, 'content.ga_video_title'}")
    @setState playVideo:true

  getPictureAttrs: ->
    images = _.get @props, 'media.video.overlay_image', {}

    sources: [
      url: @getImageBySize(images, 'desktop')
      quality: @getQualityBySize(images, 'desktop')
      widths: _.range 1000, 2200, 200
      mediaQuery: '(min-width: 960px)'
    ,
      url: @getImageBySize(images, 'tablet')
      quality: @getQualityBySize(images, 'tablet')
      widths: _.range 700, 1400, 200
      mediaQuery: '(min-width: 640px)'
    ,
      url: @getImageBySize(images, 'mobile')
      quality: @getQualityBySize(images, 'mobile')
      widths: _.range 300, 700, 100
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'TBD'
      className: @classes.picture

  render: ->
    @classes = @getClasses()
    pictureAttrs = @getPictureAttrs()
    playButton = _.get @props, 'media.video.play_image',
    copy = _.get @props, 'media.video.copy', {}

    <section className=@classes.block id="video">
      <div className=@classes.videoContainer>
        {
          if @state.playVideo
            <iframe className=@classes.video
                    src={@getVideoSrc()}
                    frameBorder='0' allowFullScreen>
            </iframe>
        }
        <div className=@classes.videoOverlayWrapper onClick={@handleClickPlay} >
          <div>
            <div className=@classes.videoControls>
              <div className=@classes.grid>
                <div className=@classes.row>
                  <div className=@classes.buttonWrapper>
                    <img
                      src=playButton
                      className=@classes.playButton />
                  </div>
                  <div className=@classes.videoCopyWrapper>
                    <p className=@classes.videoHeader children=copy.header />
                    <p className=@classes.videoSubHeader children=copy.subheader />
                  </div>
                </div>
              </div>
            </div>
          </div>
          <Picture children={@getPictureChildren(pictureAttrs)} />
        </div>
      </div>
    </section>
