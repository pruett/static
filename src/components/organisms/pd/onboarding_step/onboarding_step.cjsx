[
  _
  React

  Picture
  CTA
  StepNumber

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/picture/picture'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/step_number/step_number'

  require 'components/mixins/mixins'

  require './onboarding_step.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-onboarding-step'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
    Mixins.scrolling
  ]

  getDefaultProps: ->
    cssModifier: ''
    cssUtility: ''
    onClick: ->
    isActive: false
    isDesktop: true
    isTablet: false

  getStaticClasses: ->
    block: "#{@BLOCK_CLASS} u-tac u-grid -maxed #{@props.cssModifier} #{@props.cssUtility}"
    header: "#{@BLOCK_CLASS}__header u-ffss u-fws u-fs18
      u-fs20--900 u-color--dark-gray u-mt24 u-mt0--900 u-mb12 u-mb8--900"
    description: "#{@BLOCK_CLASS}__description u-fs16 u-fs18--900
      u-ffss u-color--dark-gray-alt-3 u-mt0 u-mb36 u-mb0--900"
    columnFullText: "#{@BLOCK_CLASS}__column-full-text u-grid__col
      u-w12c u-w6c--900 u-pr--900 u-l25p--900 u-cursor--pointer"
    columnFullImage: "#{@BLOCK_CLASS}__column-full-image u-grid__col
      u-w12c u-w6c--900 u-pa--900 u-t0--900 u-l0--900"
    fullText: "#{@BLOCK_CLASS}__full-text u-w12c u-tal--900 u-p24--900 u-bw1 u-bss u-bc--white"
    rowCenter: 'u-grid__row -center'
    video: "#{@BLOCK_CLASS}__video"
    image: "#{@BLOCK_CLASS}__image"

  componentDidMount: ->
    if @refs.video
      # since React doesn't support the `playsinline` attribute,
      # we must add it manually for videos to play on mobile
      @refs.video.setAttribute 'playsinline', true

      @refs.video.addEventListener 'ended', @onVideoEnd

      # play videos in viewport in lieu of clicks on mobile
      if !@props.isDesktop and !@props.isTablet
        @refs.video.setAttribute 'autoplay', true

        @onScroll = _.throttle @onVideoInViewport, 250
        window.addEventListener 'scroll', @onScroll

  componentWillUnmount: ->
    if @refs.video
      @refs.video.removeEventListener 'ended', @onVideoEnd

      if !@props.isDesktop and !@props.isTablet
        window.removeEventListener 'scroll', @onScroll

  componentWillUpdate: (nextProps, nextState) ->
    if @refs.video
      if nextProps.isActive
        @refs.video.play()
      else
        @refs.video.pause()
        @refs.video.currentTime = 0

  classesWillUpdate: ->
    block:
      '-active': @props.isActive

  onClick: (index) ->
    if @refs.video
      # this stops subsequent videos from playing after click
      @refs.video.removeEventListener 'ended', @onVideoEnd

    if _.isFunction(@props.onClick)
      stepIndex = index || @props.stepIndex
      @props.onClick(stepIndex)

  onVideoEnd: ->
    @props.onChange()

  onVideoInViewport: ->
    if @isInViewport(@refs.video)
      if @refs.video.currentTime <= 0
        @props.onChange()

  isInViewport: (el) ->
    return false unless _.isElement el

    rect = el.getBoundingClientRect()
    windowHeight = window.innerHeight or _.get(document, 'documentElement.clientHeight')

    return 0 < rect.top < windowHeight &&
           0 < rect.bottom < windowHeight

  render: ->
    classes = @getClasses()

    if @props.isDesktop
      video = _.get @props, 'video.desktop'
    else if @props.isTablet
      video = _.get @props, 'video.tablet'
    else
      video = _.get @props, 'video.mobile'

    <div {...@props} className=classes.block>
      <div className=classes.rowCenter>
        <div className=classes.columnFullImage>
          <video className=classes.video poster=video.poster ref="video" width="100%" height="100%" preload="auto" muted>
            <source src=video.source type="video/mp4" />
            <Picture>
              {_.map @props.image, (image, i) ->
                <source key=i {...image} />
              }
              <img {..._.last(@props.image)} className=classes.image width="100%" height="100%" />
            </Picture>
          </video>
        </div>
        <div className=classes.columnFullText onClick={@onClick.bind(@, @props.stepIndex)}>
          <div className=classes.fullText>
            <h3 className=classes.header children=@props.header />
            <p className=classes.description children=@props.description />
          </div>
        </div>
      </div>
      {@props.children}
    </div>
