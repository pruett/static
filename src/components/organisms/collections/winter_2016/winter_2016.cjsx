React = require 'react/addons'
_ = require 'lodash'

Hero = require 'components/molecules/collections/winter_2016/hero/hero'
FrameCarousel = require 'components/molecules/landing/frame/carousel/carousel'
Callout = require 'components/molecules/collections/winter_2016/callout/callout'

Mixins = require 'components/mixins/mixins'

require './winter_2016.scss'


module.exports = React.createClass

  mixins: [
    Mixins.dispatcher
    Mixins.classes
    Mixins.context
  ]

  BLOCK_CLASS: 'c-winter-2016'

  getStaticClasses: ->
    block: '
      u-mw1440
      u-mla u-mra
    '
    grid: '
      u-grid
    '
    frameNameModifier: '
      u-color-winter-2016--blue
    '
    shopLinkModifier: '
      c-winter-2016-link
    '
    hto: '
      u-color-bg--winter-2016
      u-tac
      u-mt36 u-mtn60--1200
    '
    htoCopyWrapper: '
      u-w10c u-w9c--600
      u-color--white
      u-mla u-mra
      u-pt48 u-pb48
    '
    htoEyebrow: '
      u-reset
      u-fs12
      u-ls2
      u-fwb
      u-mb18
    '
    htoHeader: '
      u-reset
      u-fs24 u-fs36--900
      u-ffs u-fws
      u-mb18
    '
    htoBody: '
      u-reset
      u-fs16 u-fs18--900
      u-mb24 u-mb30--900
      u-w9c u-w8c--900 u-w6c--1200 u-mla u-mra
    '
    frameColorModifier: '
      u-color-winter-2016--blue
    '
    copyBlock: '
      u-tac
      u-mla u-mra
      u-fs24 u-fs36--900
      u-color-winter-2016--blue
      c-winter-2016-body-copy
      u-lh34 u-lh46--900
      u-reset
      u-mb24 u-mb60--600 u-mb72--900
      u-w11c u-w8c--900
      u-fws u-ffs
      u-mt24 u-mtn60--1200
    '
    htoIcon: '
      c-winter-2016-hto-icon
    '

  componentDidMount: ->
    @handleProductImpressions()

  getInjectedFrames: (frameGroups=[]) ->
    #  Replace product ids in frame groups with frame data
    frameData = _.get @props, '__data.products', {}

    injected = frameGroups.map (frameGroup) ->
      matchedFrames = frameGroup.map (frameID) ->
        return frameData["#{frameID}"]
      return matchedFrames

    injected

  handleProductImpressions: ->
    frames = _.get @props, "frame_groups[#{@props.version}]", {}

    ids = []

    #  Loop over all frame rows, grabbing first product id for each grouped product
    for row, frameIDGroups of frames
      frameIDGroups.forEach (frameIDs) ->
        ids.push frameIDs[0]

    @injectImpressionData(ids)

  injectImpressionData: (ids = []) ->
    #  Create an array of product data from frame ids
    frameData = _.get @props, '__data.products', {}
    injected =  _.map ids, (id) ->
      return frameData["#{id}"]

    @dispatchImpressions(injected)

  dispatchImpressions: (frameData = []) ->

    impressions = []

    if @props.version isnt 'fans'
      frameData.forEach (product, i) ->

        impression =
          brand: 'Warby Parker'
          category: 'Frame'
          list: 'Collection-Winter2016'
          color: product.color
          name: product.display_name
          position: i + 1
          id: product.product_id

        impressions.push impression

    else
      # we need to grab two impressions per frame here, to account for both genders
      frameData.forEach (product, i) ->
        product.gendered_details.forEach (detail) ->

          impression =
            brand: 'Warby Parker'
            category: 'Frame'
            list: 'Collection-Winter2016'
            color: product.color
            name: product.display_name
            position: i + 1
            id: detail.product_id

          impressions.push impression

    unless _.isEmpty impressions
      @commandDispatcher 'analytics', 'pushProductEvent',
        type: 'productImpression'
        products: impressions

  injectCalloutData: (callout={}) ->
    #  Inject frame data into callout data from CMS
    frameData = _.get @props, '__data.products', {}
    injectedCallout = callout["#{@props.version}"]

    for side, frame of injectedCallout
      if side in ['left', 'right']
        frame.frame_data = _.find frameData, product_id: frame.frame_id

    injectedCallout

  renderFramesGrid: (injectedFrameData = [], gaStartingPosition=0) ->
    classes = @getStaticClasses()

    <section className=classes.grid>
    {
      injectedFrameData.map (frameGroup, i) =>
        <FrameCarousel
          gaList='winter2016'
          columnModifier=2
          useTextColors={if @props.version is 'm' then true else false}
          cssModifierFrameName=classes.frameNameModifier
          cssModifierLink=classes.shopLinkModifier
          cssModifierFrameColor=classes.frameColorModifier
          version=@props.version
          gaPosition={gaStartingPosition + i}
          products=frameGroup
          key=i />
    }
    </section>

  getGAStartingPosition: (position) ->
    #  Used to lookup the starting position of a given on the frame for GA reporting
    positions =
      m:
        first: 1
        second: 3
        third: 5
        fourth: 7
      f:
        first: 1
        second: 3
        third: 7
        fourth: 9
      fans:
        first: 1
        second: 3
        third: 7

    return positions[@props.version][position]


  renderHTO: ->
    calloutHTO = @props.hto_callout or {}
    classes = @getClasses()

    <section className=classes.hto>
      <div className=classes.htoCopyWrapper>
        <p children=calloutHTO.eyebrow className=classes.htoEyebrow />
        <p children=calloutHTO.header className=classes.htoHeader />
        <p children=calloutHTO.body className=classes.htoBody />
        <img src=calloutHTO.icon className=classes.htoIcon />
      </div>
    </section>

  render: ->
    classes = @getClasses()
    frameGroups = _.get @props, "frame_groups[#{@props.version}]", {}
    hero = @props.hero or {}
    calloutOne = @props.callout_one or {}
    calloutTwo = @props.callout_two or {}
    calloutThree = @props.callout_three or {}

    <div className=classes.block>
      <Hero {...hero} version=@props.version heroVariant=@props.heroVariant />
      {@renderFramesGrid(@getInjectedFrames(frameGroups.first),@getGAStartingPosition("first"))}
      <Callout version=@props.version {...@injectCalloutData(calloutOne)} />
      {@renderFramesGrid(@getInjectedFrames(frameGroups.second),@getGAStartingPosition("second"))}
      <p children=@props.copy_block className=classes.copyBlock />
      <Callout version=@props.version {...@injectCalloutData(calloutTwo)} />
      {@renderFramesGrid(@getInjectedFrames(frameGroups.third),@getGAStartingPosition("third"))}
      {
        if @props.version isnt 'fans'
          <div>
            <Callout version=@props.version {...@injectCalloutData(calloutThree)} />
            {@renderFramesGrid(@getInjectedFrames(frameGroups.fourth), @getGAStartingPosition("fourth"))}
          </div>
      }
      {
        if @getFeature('homeTryOn')
          @renderHTO()
      }
    </div>
