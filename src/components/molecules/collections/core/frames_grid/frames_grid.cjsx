[
  _
  React

  CoreFrame

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/collections/core/frame/frame'

  require 'components/mixins/mixins'

  require './frames_grid.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-collection-core-frames-grid'

  mixins: [
    Mixins.classes
    Mixins.context
    Mixins.scrolling
  ]

  getDefaultProps: ->
    version: 'fans'
    cssModifier: ''
    cssModifierColorName: ''
    cssModifierFrameName: ''
    gaListModifier: ''


  getInitialState: ->
    counter: 0

  componentDidMount: ->
    @addScrollListener @onViewportChange, 100

    # periodically call this function to account for things pushed into the viewport
    # by images loading late
    @timer = setInterval ( () =>
      @onViewportChange()
     ), 500


  onViewportChange: ->
    numberRefs = _.keys(@refs).length

    _.forEach @refs, (ref, name) =>
      if name.indexOf('fadeWrapper') is 0 and not _.get @state, "fadingInitialized_#{name}"
        if @elementIsInViewport(React.findDOMNode ref)
          @setState counter: @state.counter += 1
          @setState "fadingInitialized_#{name}": true
          @fadeRef(name)

    #if all refs have been faded in, clear the interval
    if @state.counter >= numberRefs
      clearInterval @timer

  fadeRef: (name) ->
    setTimeout ( () =>
      @setState "faded_#{name}": true
    ), Math.random() * 300

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-tac
    "
    container: "
      #{@BLOCK_CLASS}__container u-grid
    "
    gridRow: "
      u-grid__row
    "
  renderFrameModifiers: (faded) ->
    [
      "#{@BLOCK_CLASS}__fade-wrapper"
      if faded then "-faded-in" else "-not-yet-faded-in"
    ].join ' '

  render: ->
    classes = @getClasses()
    # CoreFrame uses abbreviations for men's and women's versions
    frameVersion = {men: 'm', women: 'w', fans: 'fans'}[@props.version]
    collectionFrames = _.map @props.frames, (frame, i) =>

      faded = _.get @state, "faded_fadeWrapper_#{frame.section}_#{i}"

      frameProps =
        key: i
        useTextColors: @props.useTextColors
        listModifier: @props.listModifier
        position: @props.defaultPosition + i
        ref: "fadeWrapper_#{frame.section}_#{i}"
        products: frame.products
        version: frameVersion
        cssModifier: @renderFrameModifiers(faded)
        cssModifierFrameName: @props.cssModifierFrameName
        cssModifierColorName: @props.cssModifierColorName
        gaListModifier: @props.gaListModifier

      <CoreFrame {...frameProps} />

    <div className=classes.container>
      <div className=classes.gridRow>
        <div className=classes.block children=collectionFrames />
      </div>
    </div>
