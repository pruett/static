[
  _
  React

  FramesGrid
  Carousel
  Callout
  Hero
  Markdown

  FrameHandlingMixin
  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/landing/frames_grid/frames_grid'
  require 'components/molecules/landing/low_bridge_fit/carousel/carousel'
  require 'components/molecules/landing/low_bridge_fit/callout/callout'
  require 'components/molecules/landing/low_bridge_fit/hero/hero'
  require 'components/molecules/markdown/markdown'

  require 'components/mixins/collections/frame_handling_mixin'
  require 'components/mixins/mixins'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-callout--labels'

  GA_LIST_MODIFIER: 'lowBridgeFit'

  mixins: [
    Mixins.classes
    Mixins.callout
    Mixins.dispatcher
    FrameHandlingMixin
  ]

  getDefaultProps: ->
    gaListModifier: 'lowBridgeFit'

  componentDidMount: ->
    frames = _.get @props, 'frames', {}
    unless @props.version is 'fans'
      @getVersionedImpressions(frames, @props.version, 'f')
    else
      @getFansImpressions(frames)

  getStaticClasses: ->
    block: @BLOCK_CLASS
    grid: '
      u-grid -maxed
      u-mb24 u-mb36--600 u-mb60--900
      u-ma
    '
    row: '
      u-grid__row u-tac
    '
    column: '
      u-grid__col u-w12c u-w10c--900
    '
    calloutIntroHeader: '
      u-heading-md
      u-reset
      u-mb8 u-mb12--600
    '
    calloutIntroBody: '
      u-fs18 u-fs20--900 u-reset
      u-lh30
    '
    reset: '
      u-reset
    '
    gridFramesHeader: '
      u-grid -maxed u-ma
    '
    columnFramesHeader: '
      u-grid__col u-w12c u-w8c--600 u-w7c--900
      u-mb30 u-mb36--600 u-mb60--900 u-mb96--1200"
    '
    framesGridHeader: '
      u-heading-md
      u-reset
    '
    gridCarousel: '
      u-grid -maxed
      u-mla u-mra
      u-mb42 u-mb48--600 u-mb72--900 u-mb120--1200
    '
    rowCarousel: '
      u-tac
      u-mb12 u-mb48--600 u-mb0--900
    '

  renderCalloutIntro: ->
    content = _.get @props, 'content.callout_intro', {}
    <div className=@classes.grid>
      <div className=@classes.row>
        <div className=@classes.column>
          <h2 children=content.head className=@classes.calloutIntroHeader />
          <Markdown
            rawMarkdown=content.body
            className=@classes.calloutIntroBody
            cssBlock=@classes.reset />
        </div>
      </div>
    </div>

  renderCallouts: ->
    callouts = _.get @props, 'content.callouts', []
    _.map callouts, (callout, i) -> <Callout key=i {...callout} />

  render: ->
    @classes = @getClasses()
    carousel = _.get @props, 'content.carousel', {}

    <section className=@classes.block>
      <Hero hero={_.get @props, 'content.hero'} version=@props.version />
      {@renderCalloutIntro()}
      {@renderCallouts()}
      <div className=@classes.gridCarousel>
        <div className=@classes.rowCarousel>
          <Carousel {...carousel} version=@props.version />
        </div>
      </div>
      <div className=@classes.gridFramesHeader>
        <div className=@classes.row>
          <div className=@classes.columnFramesHeader>
            <h2
              children={_.get @props, 'content.frames_grid_header'}
              className=@classes.framesGridHeader />
          </div>
        </div>
      </div>
      <FramesGrid
        defaultPosition=1
        version=@props.version
        gaListModifier=@props.gaListModifier
        frames=@props.frames />
    </section>
