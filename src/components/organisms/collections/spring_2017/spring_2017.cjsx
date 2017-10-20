React = require 'react/addons'
_ = require 'lodash'

FrameCarousel = require 'components/molecules/landing/frame/carousel/carousel'
Hero = require 'components/molecules/collections/spring_2017/hero/hero'
ShoppableGrid = require 'components/molecules/collections/spring_2017/shoppable_grid/shoppable_grid'
TypeKit = require 'components/atoms/scripts/typekit/typekit'

Mixins = require 'components/mixins/mixins'


ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

require './spring_2017.scss'


module.exports = React.createClass

  mixins: [
    Mixins.dispatcher
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.scrolling
  ]

  # Constants
  BLOCK_CLASS: 'c-spring-2017'

  TOP_OFFSET: 30

  FRAME_SECTIONS:
    fans: [
      'bold tortoises'
    ,
      'true blues'
    ,
      'blush tones'
    ,
      'flat brows'
    ]
    f: [
      'bold tortoises'
    ,
      'blush tones'
    ,
      'true blues'
    ,
      'flat brows'
    ]

  ID_LOOKUP:
    # Match sticky menu labels to anchor tags
    'bold tortoises': 'bold'
    'true blues': 'blue'
    'blush tones': 'blush'
    'flat brows': 'flat'

  # Component State
  componentDidMount: ->
    # No need for scroll listening on mens page
    unless @props.version is 'm'
      @addScrollListener @checkRefs, 1000
      @addScrollListener @checkScroll, 1000
    @getProductImpressions()

  getInitialState: ->
    activeSection: 'bold tortoises'
    hasScrolled: false;


  # Helpers
  getProductImpressions: ->
    frames = _.get @props, '__data.products', {}
    productIDs = _.get @props, "product_impressions[#{@props.version}]"

    unless @props.version is 'fans'
      impressions = productIDs.map (id, i) =>
        matchedFrame = frames[id] or {}
        impression =
          list: 'spring2017Collection'
          brand: 'Warby Parker'
          category: 'Frame'
          color: matchedFrame.color
          name: matchedFrame.display_name
          id: matchedFrame.product_id
          gender: @props.version
          collections: [
            slug: 'spring-2017'
          ]
          position: i + 1
      @dispatchImpressions(impressions)
    else
      impressions = productIDs.map (id, i) ->
        matchedFrame = frames[id] or {}
        genderedDetails = matchedFrame.gendered_details or []
        genderedDetails.map (detail) ->
          baseImpression =
            list: 'spring2017Collection'
            collections: [
              slug: 'spring-2017'
            ]
            brand: 'Warby Parker'
            category: 'Frame'
            color: matchedFrame.color
            gender: detail.gender
            name: matchedFrame.display_name
            id: detail.product_id
            position: i + 1
      @dispatchImpressions(impressions)

  dispatchImpressions: (impressions) ->
    return false unless impressions
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productImpression'
      products: _.flatten impressions

  getStaticClasses: ->
    block: '
      u-mw1440
      u-mla u-mra
    '
    navWrapperSticky: "
      #{@BLOCK_CLASS}__nav-wrapper-sticky
      u-btss u-btw1 u-btw0--600 u-bc--light-gray
      u-w12c u-mla u-mra u-tac
      u-pt18 u-pb18
      u-pl6 u-pl0--600
    "
    navWrapperStatic: "
      #{@BLOCK_CLASS}__nav-wrapper-static
      u-w11c--600 u-w9c--900 u-mla u-mra u-tac
      u-btss u-btw1 u-btw0--600 u-bc--light-gray
      u-pt24 u-pt18--600 u-pb24 u-pb36--900
      u-pl6 u-pl0--600
    "
    navWrapper: "
      #{@BLOCK_CLASS}__nav-wrapper
    "
    cssModifierNavLink: "
      #{@BLOCK_CLASS}__nav-link-modifier
      u-fs14 u-fs20--900 u-ffss
      u-fws
    "
    navLinkWrapper: '
      u-dib u-w3c u-w2c--600 u-ffs
    '
    navPreText: '
      u-fs20 u-fs18--600 u-fs20--900
      u-dib--600
      u-mb12 u-mb0--600
      u-ffs
    '
    transitionGroup: "
      #{@BLOCK_CLASS}__transition-group
    "
    htoWrapper: '
      u-tac
      u-btss u-btw1
      u-bc--light-gray
      u-w10c u-mla u-mra
      u-pt48 u-pt60--900
    '
    htoEyebrow: '
      u-fs12 u-ffss u-fwb
      u-color--dark-gray
      u-reset
      u-mb12
      u-ls2
    '
    htoHeader: '
      u-fs24 u-ffs u-fws
      u-color--blue
      u-reset
      u-mb18
    '
    htoBody: '
      u-fs18 u-ffss
      u-mla u-mra
      u-reset
      u-mb60 u-mb96--900
      u-w9c--600 u-w6c--900
    '

  getSectionClass: (section) ->
    if @state.activeSection is section
      "#{@classes.cssModifierNavLink} -active"
    else
      @classes.cssModifierNavLink

  getStickyNavChildren: (sections) ->
    <div key='stickychildren'>
      <div children='This year I want to wear:' className=@classes.navPreText key='sticky' />
      {
        sections.map (section, i) =>
          <div className=@classes.navLinkWrapper key=i>
            <a className={@getSectionClass(section)} children=section onClick={@handleScrollTo.bind @, section}  />
          </div>
      }
    </div>

  mergeFrames: (ids = []) ->
    frameData = _.get @props, '__data.products', {}

    frames = ids.reduce (acc, id) ->
      matchedFrame = frameData[id]
      if matchedFrame
        matchedFrame.product_id = id
        acc.push matchedFrame
      return acc
    , []

    return frames

  # Handlers
  checkScroll: ->
    navNode = React.findDOMNode @refs.staticNav
    # Get px difference between top of viewport and top of nav div
    topDiff = navNode.getBoundingClientRect().top
    if not @state.hasScrolled and topDiff <= @TOP_OFFSET
      @setState hasScrolled: true
    if @state.hasScrolled and topDiff > @TOP_OFFSET
      # Unstick filter if user scrolls back to top
      @setState hasScrolled: false

  checkRefs: ->
    for ref, node of @refs
      if @refIsInViewport @refs[ref]
        @setState activeSection: ref

  handleScrollTo: (ref, e) ->
    e.preventDefault()
    @trackInteraction "LandingPage-clickLink-#{_.camelCase ref}"
    ref = @refs[ref]
    node = React.findDOMNode ref
    @scrollToNode node, {time: 800, offset: -100}


  # Renders
  renderShoppableGrid: (key, ref, cssModifier='') ->
    grid = _.find @props.shoppable_grids, key: key
    return false unless grid
    grid.frameData = @mergeFrames(grid.frame_ids)
    <ShoppableGrid
      {...grid}
      ref=ref
      cssModifierBlock=cssModifier
      version=@props.version
      women_only_ids=@props.women_only_ids
      id={@ID_LOOKUP[ref]} />

  renderHTO: ->
    hto = @props.hto or {}
    <div className=@classes.htoWrapper>
      <h3 children=hto.eyebrow className=@classes.htoEyebrow />
      <h2 children=hto.header className=@classes.htoHeader />
      <p children=hto.body className=@classes.htoBody />
    </div>

  renderNav: ->
    # TODO use anchors/IDs to handle before JS hooks up
    # Don't render nav for mens page
    return false unless @props.version is 'f' or @props.version is 'fans'
    sections = @FRAME_SECTIONS[@props.version]
    <div className=@classes.navWrapper ref='staticNav'>
      {
        if @state.hasScrolled
          @renderStickyNav(sections)
        else
          @renderStaticNav(sections)
      }
    </div>

  renderStickyNav: (sections) ->
    <div className=@classes.navWrapperSticky>
      <ReactCSSTransitionGroup
        transitionName={"#{@BLOCK_CLASS}__transition-group"}
        transitionAppear=true
        >
          {@getStickyNavChildren(sections)}
      </ReactCSSTransitionGroup>
    </div>

  renderStaticNav: (sections) ->
    <div className=@classes.navWrapperStatic>
      <div children='This year I want to wear:' className=@classes.navPreText />
      {
        sections.map (section, i) =>
          <div className=@classes.navLinkWrapper key=i>
            <a className={@getSectionClass(section)}
              children=section onClick={@handleScrollTo.bind @, section}  />
          </div>
      }
    </div>

  render: ->
    @classes = @getClasses()
    hero = _.find @props.hero, key: @props.version

    <div className=@classes.block>
      <TypeKit typeKitModifier='jsl1ymy' />
      <Hero {...hero} version=@props.version />
      {@renderNav()}
      {@renderShoppableGrid("#{@props.version}_first", 'bold tortoises', 'u-pt96')}
      {
        if @props.version is 'fans'
          @renderShoppableGrid("#{@props.version}_second", 'true blues')
        else
          @renderShoppableGrid("#{@props.version}_second", 'blush tones')
      }
      {
        if @props.version is 'fans'
          @renderShoppableGrid("#{@props.version}_third", 'blush tones')
        else if @props.version is 'f'
          @renderShoppableGrid("#{@props.version}_third", 'true blues')
      }
      {
        unless @props.version is 'm'
          @renderShoppableGrid("#{@props.version}_fourth", 'flat brows')
      }
      {
        if @getFeature('homeTryOn')
          @renderHTO()
      }
    </div>
