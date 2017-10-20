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

  BLOCK_CLASS: 'c-summer-2016-editorial-video-box'

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.analytics
  ]

  getVideoSrc: ->
    "https://www.youtube.com/embed/#{_.get @props, 'content.src'}?autoplay=1&controls=0&rel=0&showinfo=0"

  getStaticClasses: ->
    block: '
      u-pr
      u-mw1440
      u-mla u-mra
    '
    grid: '
      u-grid
    '
    row: '
      u-grid__row
      u-tac
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
    videoTitle: '
      u-summer-2016__video-header
      u-reset
      u-color--white
      u-mb18
    '
    picture: '
      u-pa
      u-w100p
    '
    playText: "
      #{@BLOCK_CLASS}__play-text
      u-fs16 u-fs24--900
      u-color--white
      u-fwb
      u-pr
    "
    playButton: "
      #{@BLOCK_CLASS}__play-button
    "
    buttonWrapper: '
      u-tac
      u-pt8
      u-mln36
    '
    videoControls: "
      #{@BLOCK_CLASS}__video-controls
      u-pa u-tac
    "
    videoDescription: '
      u-reset
      u-color--dark-gray
      u-summer-2016__body
      u-pb36 u-pt36
      u-pb72--600 u-pb120--900
      u-grid__col u-w12c -c-10--600 -c-8--900
    '
    videoContainer: '
      u-pr
      u-pb1x1 u-pb3x2--600 u-pb16x9--900
    '

  getPictureAttrs: ->
    images = _.get @props, 'content.overlay_image', []

    sources: [
      url: @getImageBySize(images, 'm')
      quality: @getQualityBySize(images, 'm')
      widths: _.range 900, 2200, 200
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 's')
      quality: @getQualityBySize(images, 's')
      widths: _.range 700, 1400, 200
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'xs')
      quality: @getQualityBySize(images, 'xs')
      widths: _.range 300, 700, 100
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Summer 2016 Editorial Video'
      className: @classes.picture

  classesWillUpdate: ->
    videoOverlayWrapper:
      '-hidden': @state.playVideo

  handleClickPlay: ->
    @trackInteraction("Videos-Play-#{_.get @props, 'content.ga_video_title'}")
    @setState playVideo:true

  getInitialState: ->
    playVideo: false

  render: ->
    @classes = @getClasses()
    @pictureAttrs = @getPictureAttrs()
    copy = _.get @props, 'content.copy', {}

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
              <h1 className=@classes.videoTitle children=copy.header />
              <div className=@classes.buttonWrapper>
                <img
                  src={@props.content.play_button}
                  className=@classes.playButton />
                <span children=copy.play_text className=@classes.playText />
              </div>
            </div>
          </div>
          <Picture children={@getPictureChildren(@pictureAttrs)} />
        </div>
      </div>
      <div className=@classes.grid>
        <div className=@classes.row>
          <p children=copy.description className=@classes.videoDescription />
        </div>
      </div>
    </section>
