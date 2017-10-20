[
  _
  React

  Hero
  FramesGrid
  LayoutDefault

  FrameHandlingMixin
  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/landing/hero/hero'
  require 'components/molecules/landing/frames_grid/frames_grid'
  require 'components/layouts/layout_default/layout_default'


  require 'components/mixins/collections/frame_handling_mixin'
  require 'components/mixins/mixins'

]

module.exports = React.createClass

  BLOCK_CLASS: 'c-collections-flash-mirrored'

  mixins: [
    Mixins.classes
    FrameHandlingMixin
    Mixins.dispatcher
    Mixins.analytics
  ]

  GA_LIST_MODIFIER: 'FlashMirroredLenses'

  componentDidMount: ->
    @getFansImpressions(@frames)

  getDefaultProps: ->
    gaListModifier: 'Collection-FlashMirroredLenses'

  getStaticClasses: ->
    block: @BLOCK_CLASS
    cssModifierFramesGrid: 'u-mt60 u-mt96--900'

  render: ->
    classes = @getClasses()
    @frames = @props.frames or []
    hero = @props.hero or {}

    <section className=classes.block>
      <Hero {...hero} />
      <FramesGrid
        gaListModifier=@GA_LIST_MODIFIER
        frames=@frames
        version=@props.version
        cssModifier=classes.cssModifierFramesGrid
        defaultPosition=1
        columnModifier=3 />
    </section>
