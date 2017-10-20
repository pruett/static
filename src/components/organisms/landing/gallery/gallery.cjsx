[
  _
  React

  Hero
  FramesGrid
  GalleryPromo
  Promo

  Mixins
  FrameHandlingMixin

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/landing/hero/hero'
  require 'components/molecules/landing/frames_grid/frames_grid'
  require 'components/atoms/landing/gallery_promo/gallery_promo'
  require 'components/molecules/landing/promo/promo'

  require 'components/mixins/mixins'
  require 'components/mixins/collections/frame_handling_mixin'
]

module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.dispatcher
    FrameHandlingMixin
  ]

  getStaticClasses: ->
    block: '
      u-mbn48 u-mbn64--600 u-mbn84--900
    '
    section: '
      u-pt60--900 u-pt72--1200
    '

  getDefaultProps: ->
    gaListModifier: 'LandingPage'

  componentDidMount: ->
    # Build promo impressions for each frame
    # getFansImpressions comes from the FrameHandlingMixin
    frames = _.get @props, 'content.frames', []
    @getFansImpressions(frames)

  renderFramesGrid: (frames, i, topBorder) ->
    <FramesGrid frames=frames useTextColors={not @props.content.show_swatches} topBorder=topBorder key=i />

  renderPromo: (promo, i) ->
    if promo.shade_background
      <GalleryPromo {...promo} key=i />
    else
      <Promo {...promo} key=i />

  groupFrames: ->
    # Frames come grouped by assemblies but should be expanded if color swatches are not shown
    if @props.content.show_swatches
      _.chunk (_.get @props, 'content.frames', []), 6
    else
      # Chunk 6 frames at a time instead of 6 frame groups
      ungrouped = _.flatten (
        _.map (_.get @props, 'content.frames', []), (f) -> _.map f.products, (p) -> { 'products': [p] }
      )
      _.chunk ungrouped, 6

  buildComponents: ->
    # Merge promos into groups of 6 frames based on the promo position
    frameGroups = @groupFrames()
    promos = _.sortBy (_.get @props, 'content.promos', []), (p) -> p.position
    frames = frameGroups.shift()
    promo = promos.shift()
    position = 1
    components = []
    prevIsShaded = true
    prevIsFrames = false
    while frames or promo
      if promo and promo.position <= position
        promo['topBorder'] = not prevIsShaded and not promo.shade_background
        prevIsShaded = promo.shade_background
        prevIsFrames = false
        components.push (@renderPromo promo, position)
        promo = promos.shift()
        if frames
          position = position + 1
        else if promo
          position = promo.position
      else if frames
        topBorder = not prevIsShaded and not prevIsFrames
        prevIsShaded = false
        prevIsFrames = true
        components.push (@renderFramesGrid frames, position, topBorder)
        position = position + 1
        frames = frameGroups.shift()
    components

  render: ->
    classes = @getClasses()
    hero = _.get @props, 'content.hero'

    <div className=classes.block>
      <Hero {...hero} />
      <section className=classes.section children={@buildComponents()} />
    </div>
