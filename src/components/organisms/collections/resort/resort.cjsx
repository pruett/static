React = require 'react/addons'
_ = require 'lodash'

Mixins = require 'components/mixins/mixins'

FrameCarousel = require 'components/molecules/landing/frame/carousel/carousel'
Picture = require 'components/atoms/images/picture/picture'
Hero = require 'components/molecules/collections/resort/hero/hero'
TypeKit = require 'components/atoms/scripts/typekit/typekit'

require './resort.scss'

module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.analytics
    Mixins.dispatcher
  ]

  BLOCK_CLASS: 'c-resort'

  componentDidMount: ->
    @handleProductImpressions()

  handleProductImpressions: ->
    impressionIds = @props.ga_impression_ids or []
    frames = _.get @props, '__data.products', {}
    baseImpression =
      list: 'resortCollection'
      brand: 'Warby Parker'
      category: 'Frame'

    impressions = impressionIds.map (id, i) ->
      frame = _.find frames, product_id: id
      return false unless frame
      finalImpression = _.assign (_.clone baseImpression),
        color: frame.color
        id: frame.product_id
        name: frame.display_name
        position: i + 1

    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productImpression'
      products: _.flatten impressions

  getStaticClasses: ->
    block: @BLOCK_CLASS
    callout: '
      u-pr
      u-mw2000
      u-mla u-mra
    '
    labelWrapper: "
      #{@BLOCK_CLASS}__label-wrapper
      u-pa u-b0 u-r0
      u-pr24 u-pb24
      u-pr36--600 u-pb36--600
    "
    labelName: '
      u-fws
    '
    frameLabels: "
      #{@BLOCK_CLASS}__label
      u-color--white
      u-fs16
      u-bbss--900 u-bbw1 u-bbw0--900 u-bc--white
      u-pb6 u-fs16 u-fs18--900 u-wsnw
    "
    calloutImage: '
      u-w12c
    '
    bottomCopy: "
      #{@BLOCK_CLASS}__copy
      u-tac
      u-color--dark-gray
      u-reset
      u-mla u-mra
      u-ffs
      u-w10c
      u-w9c--600
      u-w10c--900
      u-pb72 u-pt72
      u-pb84--600 u-pt0--1200
      u-pb120--1200
      u-fs20 u-fs24--900 u-lh30
    "
    topCopy: "
      #{@BLOCK_CLASS}__copy
      #{@BLOCK_CLASS}__copy-top
      u-tac
      u-color--dark-gray
      u-ffs
      u-reset
      u-mla u-mra
      u-w10c
      u-pb72 u-pt48
      u-pb84--600 u-pt60--600 u-pt0--900
      u-pb120--900
    "
    gridWrapper: '
      u-grid -maxed u-mla u-mra
      u-pr
      u-color-bg--white
    '
    frameNameModifier: "
      #{@BLOCK_CLASS}__frame-name-modifier
      u-color--dark-gray
      u-fws u-ffss
      u-fs18
    "
    frameColorModifier: "
      #{@BLOCK_CLASS}__frame-color-modifier
      u-color--dark-gray
      u-ffss
    "
    shopLinkModifier: "
      #{@BLOCK_CLASS}__shop-link-modifier
      u-bbss u-bbw1 u-bbw0--900 u-bc--white
    "
    cssModifierCalloutOne: '
      u-mb120--1200
      u-mb24 u-mb36--600
    '
    cssModifierCalloutTwo: '
      u-mb120--1200
      u-mt60 u-mtn36--900
      u-mb24 u-mb36--600
    '
    cssModifierCalloutThree: '
      u-mb120--1200
      u-mt60 u-mtn36--900
    '
    cssModifierCalloutFour: '
      u-mbn12 u-mb48--1200
    '
    cssModifierCarouselBlock: "
      #{@BLOCK_CLASS}__css-modifier-carousel-block
      u-pt48--900
    "
    labelLeadText: '
      u-fsi u-color--white u-fws u-fs16 u-fs18--900
    '


  # Helpers
  getPictureAttrs: (images = []) ->
    sources: [
      url: @getImageBySize(images, 'desktop-sd')
      quality: @getQualityBySize(images, 'desktop-sd')
      widths: @getImageWidths 900, 2200, 5
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 'tablet')
      quality: @getQualityBySize(images, 'tablet')
      widths: _.range 700, 1400, 200
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'mobile')
      quality: @getQualityBySize(images, 'mobile')
      widths: @getImageWidths 300, 800, 5
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Warby Parker Resort Collection'
      className: @classes.calloutImage

  prepareFrames: (section) ->
    frameData = _.get @props, '__data.products'
    frameIDs = _.get @props, "frame_groups.#{section}"

    groupedFrames = frameIDs.map (id) ->
      unless _.isEmpty frameData["#{id}"]
        return [frameData["#{id}"]]
      else
        return false

    _.compact groupedFrames

  getCalloutClasses: (callout) ->
    position = callout.position

    modifierLookup =
      'one': @classes.cssModifierCalloutOne
      'two': @classes.cssModifierCalloutTwo
      'three': @classes.cssModifierCalloutThree
      'four': @classes.cssModifierCalloutFour

    modifierLookup[position]


  # Handlers
  handleLabelClick: (label) ->
    ga = label.ga or {}

    @trackInteraction "LandingPage-clickShopWomenCallout-#{ga.sku}"

    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [
        brand: 'Warby Parker'
        category: 'Eyeglasses'
        list: 'Resort'
        id: ga.product_id
        name: label.name
        position: ga.position
        sku: ga.sku
        url: label.path
      ]


  # Renders
  renderFramesGrid: (section, gaStartingPosition) ->
    frames = @prepareFrames(section)
    frames.map (frame, i) =>
      <FrameCarousel
        gaList='resort'
        oneLineFrameDetail=true
        columnModifier=2
        useTextColors=true
        cssModifierFrameName=@classes.frameNameModifier
        cssModifierLink=@classes.shopLinkModifier
        cssModifierFrameColor=@classes.frameColorModifier
        cssModifierFrameDetails='u-fs18'
        cssModifierBlock={if section is 'one' then @classes.cssModifierCarouselBlock else ''}
        gaPosition={gaStartingPosition + i + 1}
        genderNeutralLinks=true
        products=frame
        key=i />

  renderLabels: (labels = []) ->
    labels.map (label, i) =>
      <span>
        <span children={"#{label.lead_text or ''} "} className=@classes.labelLeadText />
        <a key=i
           href=label.path
           onClick={@handleLabelClick.bind @, label}
           className=@classes.frameLabels>
          <span children=label.name className=@classes.labelName />
          <span children={" in #{label.color}"} className=@classes.labelColor />
        </a>
      </span>

  renderCallout: (position) ->
    callout =  _.find @props.__callouts or [], position: position
    return false unless callout
    pictureAttrs = @getPictureAttrs(callout.image)
    <div className={"#{@classes.callout} #{@getCalloutClasses(callout)}"}>
      <Picture children={@getPictureChildren(pictureAttrs)} />
      <div
        className={if position isnt 'four' then @classes.labelWrapper else "#{@classes.labelWrapper} -final"}
        children={@renderLabels(callout.frame_labels)} />
    </div>

  render: ->
    @classes = @getClasses()
    hero = @props.hero or {}

    <div>
      <TypeKit typeKitModifier='jsl1ymy' />
      <Hero renderLabels=@renderLabels {...hero} />
      <div className=@classes.gridWrapper children={@renderFramesGrid('one', 1)} id='firstGrid' />
      <p className=@classes.topCopy children=@props.copy_one ref='topCopy' />
      {@renderCallout('one')}
      <div className=@classes.gridWrapper children={@renderFramesGrid('two', 4)} />
      {@renderCallout('two')}
      <div className=@classes.gridWrapper children={@renderFramesGrid('three', 7)} />
      {@renderCallout('three')}
      <p className=@classes.bottomCopy children=@props.copy_two />
      {@renderCallout('four')}
    </div>

