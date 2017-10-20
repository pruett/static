[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-callout__video'

  THROTTLE_MS: 100

  PERCENTAGES: [0, 0.25, 0.5, 0.75, 1]

  PERCENTAGE_OFFSET: 0.025

  propTypes:
    videos: React.PropTypes.array
    name: React.PropTypes.string

  mixins: [
    Mixins.analytics
    Mixins.callout
  ]

  getDefaultProps: ->
    videos: []
    name: ''

  getInitialState: ->
    videoIndex: 0

  shouldDeferVideoLoad: ->
    # Wait for React if multiple videos or loading at specific breakpoint.
    @props.videos.length > 1 or _.get(@props, 'videos[0].size') isnt 'mobile'

  handleTimeUpdate: (evt) ->
    video = evt.target or {}

    return unless video.duration

    if video.currentTime / video.duration > @PERCENTAGES[0] - @PERCENTAGE_OFFSET
      # Check against lowest number, remove, and push interaction.
      percentage  = @PERCENTAGES.shift() * 100
      name = _.camelCase "homepageVideo-#{@props.name}"
      @trackInteraction "#{name}-progress-#{percentage}%"

    unless @PERCENTAGES.length
      # Remove listener if no more videos.
      video.removeEventListener 'timeupdate', @handleTimeUpdate

  componentDidUpdate: (prevProps, prevState) ->
    if prevProps.videos.length isnt @props.videos.length or
      prevState.videoIndex isnt @state.videoIndex
        @addPlaysInline() # Only re-add if changing videos

  componentDidMount: ->
    @addPlaysInline()

    if @shouldDeferVideoLoad()
      # Add throttled window resize listener to pick video.
      handleResize = => @setState videoIndex: @getVideoIndex()
      @__resizeVideoListener = _.throttle handleResize, @THROTTLE_MS
      window.addEventListener 'resize', @__resizeVideoListener

  addPlaysInline: ->
    video = React.findDOMNode(@refs['video'])
    if video?
      # Our current version of React doesn't accept `playsinline` in JSX.
      # Remove listener in case it has been set already.
      video.setAttribute 'playsinline', true

      if @PERCENTAGES.length
        video.removeEventListener 'timeupdate', @handleTimeUpdate
        video.addEventListener 'timeupdate', @handleTimeUpdate

  componentWillUnmount: ->
    window.removeEventListener 'resize', @__resizeVideoListener

  doesSizeMatchMedia: (size) ->
    window.matchMedia("(min-width: #{size.widthMin}px)").matches

  getVideoIndex: ->
    # Find video index based on sizing information.
    # Default to 0 if no matching video.
    size = _.find @SIZES, @doesSizeMatchMedia
    return 0 unless size

    index = _.findIndex @props.videos, size: size.name
    Math.max index, 0

  getAutoPlay: ->
    # Only play if mounted to prevent re-start.
    if window? then 'autoplay' else ''

  render: ->
    return false unless @props.videos.length # Hide video if none available.
    return false if @shouldDeferVideoLoad() and not window? # Must mount to choose.

    video = _.get @props, "videos[#{@state.videoIndex}]", {}

    return false unless video.url # Don't render video if not supplied.
    <div className=@BLOCK_CLASS>
      <img src=video.poster className='u-pa u-center u-h100p u-mwnone' />
      <video ref='video'
        preload='auto'
        autoPlay={@getAutoPlay()}
        muted=true
        loop='loop'
        className='u-pa u-center u-h100p'
        poster=video.poster
        src=video.url />
    </div>
