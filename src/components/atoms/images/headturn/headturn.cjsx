[
  _
  React

  Img
  Picture

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'
  require 'components/atoms/images/picture/picture'

  require 'components/mixins/mixins'

  require './headturn.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-headturn'

  MAX_GAMMA: 18

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  propTypes:
    alt: React.PropTypes.string
    cssModifier: React.PropTypes.string
    offsetLeft: React.PropTypes.number
    offsetWidth: React.PropTypes.number
    srcs: React.PropTypes.array

  getDefaultProps: ->
    cssModifier: ''

  getInitialState: ->
    allSourcesLoaded: false
    numSourcesLoaded: 0
    offsetLeft: 0
    offsetWidth: 0

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS} #{@props.cssModifier}
      u-h0 u-oh u-pr
      u-pb4x3 u-pb2x1--900
      u-bss u-btw0 u-blw0 u-bbw1 u-bbw0--900 u-brw0 u-bc--light-gray-alt-1
    "
    image: "
      #{@BLOCK_CLASS}__image
      u-h100p u-pa u-ma
      u-t0 u-l0
    "

  classesWillUpdate: ->
    image:
      '-active': @state.firstRender

  componentWillMount: ->
    if @props.srcs
      @prepareSrcs()

  componentDidMount: ->
    if @state.firstRender
      # Source images are already prepared, so switch flag to allow all images
      # to load.
      @setFirstRenderFalse()
    else
      # Prepare the source images, then switch flag to allow all images to load.
      @prepareSrcs @setFirstRenderFalse

    @setLayout()
    window.addEventListener 'resize', @setLayout

    containerEl = @getContainerEl()
    if containerEl
      if @touchDeviceWithOrientationEvents()
        window.addEventListener 'deviceorientation', @handleDeviceOrientation
      else
        containerEl.addEventListener 'mousemove', @handleMouseMove

  componentWillUnmount: ->
    window.removeEventListener 'resize', @setLayout

    containerEl = @getContainerEl()
    if containerEl
      if @touchDeviceWithOrientationEvents()
        window.removeEventListener 'deviceorientation', @handleDeviceOrientation
      else
        containerEl.removeEventListener 'mousemove', @handleMouseMove

  prepareSrcs: (cb = ->) ->
    srcCount = _.get(@props, 'srcs[0].image', []).length

    # For first render, use this flag to render only the middle image.
    @setState(
      firstRender: true
      frameCount: srcCount
      position: Math.floor srcCount / 2
    , cb)

  setFirstRenderFalse: ->
    @setState firstRender: false

  setLayout: ->
    el = @getContainerEl()

    @setState(
      offsetLeft: el.getBoundingClientRect().left
      offsetWidth: el.offsetWidth
    )

  getContainerEl: ->
    React.findDOMNode @refs.container

  componentWillReceiveProps: (nextProps) ->
    if nextProps.offsetWidth and nextProps.offsetWidth isnt @props.offsetWidth
      @setState offsetWidth: nextProps.offsetWidth

    if nextProps.offsetLeft and nextProps.offsetLeft isnt @props.offsetLeft
      @setState offsetLeft: nextProps.offsetLeft

  touchDeviceWithOrientationEvents: ->
    # Borrow from Modernizr tests for device orientation and touch events.
    window.DeviceOrientationEvent? and (
      'ontouchstart' of window or (
        window.DocumentTouch and document instanceof DocumentTouch
      )
    )

  handleDeviceOrientation: (evt) ->
    if @state.allSourcesLoaded
      @moveModel 0.5 + (0.5 * (evt.gamma / @MAX_GAMMA))

  handleMouseMove: (evt) ->
    if @state.allSourcesLoaded
      @moveModel (evt.pageX - @state.offsetLeft) / @state.offsetWidth

  moveModel: (percentAcross) ->
    percentAcross = Math.max 0, Math.min(1, percentAcross)
    position = Math.round percentAcross * (@state.frameCount - 1)
    unless @state.position is position
      @setState nextPosition: position

  componentDidUpdate: ->
    if not @state.allSourcesLoaded and @state.numSourcesLoaded is @state.frameCount
        @setState allSourcesLoaded: true

    if @state.nextPosition? and
      @state.nextPosition isnt @state.position
        position = unless @state.position?
            @state.nextPosition
          else if @state.position < @state.nextPosition
            @state.position + 1
          else if @state.position > @state.nextPosition
            @state.position - 1

        requestAnimationFrame (-> @setState position: position).bind @

  handleImgLoad: (evt) ->
    @setState (prevState) ->
      numSourcesLoaded: prevState.numSourcesLoaded + 1

  getPictureAttrs: (headturnIndex) ->
    classes = @getClasses()
    sources: [
      url: @getImageBySize(@props.srcs, 'l')[headturnIndex]
      widths: [900, 1024, 1200, 1440, 1800, 2000, 2200, 2400]
      mediaQuery: '(min-width: 900px)'
      sizes: '(min-width: 1440px) 1440px, 100vw'
    ,
      url: @getImageBySize(@props.srcs, 'm')[headturnIndex]
      widths: _.range 600, 1800, 200
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(@props.srcs, 's')[headturnIndex]
      widths: _.range 400, 1200, 200
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: @props.alt or ''
      className: "#{classes.image}
        #{if not @state.firstRender and headturnIndex is @state.position then '-active' else ''}"
      onLoad: @handleImgLoad

  renderImages: (classes) ->
    if @state.firstRender
      <Picture key='first' children={@getPictureChildren @getPictureAttrs(@state.position)} />
    else
      [0..@state.frameCount-1].map (i) ->
        <Picture key=i children={@getPictureChildren @getPictureAttrs(i)} />
      , @

  render: ->
    classes = @getClasses()

    return false if _.isEmpty(@props.srcs)

    <div children=@renderImages(classes)
      className=classes.block
      ref='container'
    />
