React = require 'react/addons'
_ = require 'lodash'

Img = require 'components/atoms/images/img/img'
CopyBox = require 'components/molecules/collections/tyler_oakley/copy_box/copy_box'
Hero = require 'components/molecules/collections/tyler_oakley/hero/hero'
Video = require 'components/molecules/collections/tyler_oakley/video/video'
FrameCarousel = require 'components/molecules/landing/frame/carousel/carousel'
Mosaic = require 'components/molecules/collections/tyler_oakley/mosaic/mosaic'

Mixins = require 'components/mixins/mixins'

require './tyler_oakley.scss'


module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.dispatcher
  ]

  BLOCK_CLASS: 'c-tyler-oakley'

  DESKTOP_MINIMUM_WIDTH: 900

  getDefaultProps: ->
    hero: {}
    mosaic: {}
    frame_groups: {}
    __data: {}

  propTypes:
    hero: React.PropTypes.object
    mosaic: React.PropTypes.object
    frame_groups: React.PropTypes.object
    __data: React.PropTypes.object

  getInitialState: ->
    mobile: true
    windowChecked: false
    mobileGIFLoaded: false

  componentDidMount: ->
    @handleProductImpressions()
    @checkWindowWidth()
    @throttledCheckWindowWidth = _.throttle @checkWindowWidth, 100
    window.addEventListener('resize', @throttledCheckWindowWidth)

  componentWillUnmount: ->
    window.removeEventListener 'resize', @throttledCheckWindowWidth

  handleProductImpressions: ->
    # create array of product ids (maintain order for GA position variable)
    frame_ids = []
    for position, group of @props.frame_groups
      group.map (id) -> frame_ids.push id

    # splice in product information from callouts
    frame_ids.splice(0, 0, @getCalloutID("one"))
    frame_ids.splice(3, 0, @getCalloutID("two"))
    frame_ids.splice(6, 0, @getCalloutID("three"))

    @buildProductImpressions(frame_ids)

  getCalloutID: (number) ->
    videos = @props.videos or {}
    return videos[number].product_id

  buildProductImpressions: (ids=[]) ->
    products = _.get @props, '__data.products'

    baseImpression =
      list: 'tylerOakley'
      brand: 'Warby Parker'
      category: 'Frame'

    impressions = ids.map (id) ->
      matchedFrame = _.find(products, product_id: parseInt(id)) or {}
      return false unless matchedFrame
      return (matchedFrame.gendered_details or []).map (details) ->
        finalImpression = _.clone baseImpression
        genderedData =
          id: details.product_id
          name: matchedFrame.display_name
          color: matchedFrame.color
        _.merge finalImpression, genderedData

    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productImpression'
      products: _.flatten impressions

  checkWindowWidth: ->
    windowWidth = window.innerWidth or _.get(document, 'documentElement.clientWidth')
    @setState windowChecked: true
    if windowWidth > @DESKTOP_MINIMUM_WIDTH
      @setState mobile: false
    else if windowWidth < @DESKTOP_MINIMUM_WIDTH
      @setState mobile: true

  getStaticClasses: ->
    block: "#{@BLOCK_CLASS} u-pb48 u-pb0--900"
    gridWrapper: 'u-grid -maxed u-mla u-mra u-tac'
    cssModifierBeforeFrames: 'u-mb120--900 u-mb18 u-mb24--600'
    cssModifierVideoLast: '
      u-mb120--900 u-mb18 u-mb24--600 u-mt36 u-mt48--600 u-mb0--600 u-mtn24--900
    '
    cssModifierVideoMiddle: "
      u-mb120--900 u-mb18 u-mb24--600 u-mt48--600
      #{@BLOCK_CLASS}__middle-video
    "
    frameNameModifier: 'u-color--black'
    frameColorModifier: 'u-color--black'
    mobileHeroWrapper: 'u-pr u-tac'
    mobileGIF: 'u-w12c'
    mobileLogo: "
      u-w10c u-mla u-mra u-mt36 u-mb36
      #{@BLOCK_CLASS}__mobile-logo u-pa u-t0 u-l0
    "
    mobileGIFWrapper: 'u-h0 u-pb1x1'
    placeHolder: "#{@BLOCK_CLASS}__placeholder"
    mobilePlaceholder: 'u-w12c'

  classesWillUpdate: ->
    mobileGIF:
      'u-dib': @state.mobileGIFLoaded
      'u-dn': not @state.mobileGIFLoaded
    mobilePlaceholder:
      'u-dn': @state.mobileGIFLoaded
      'u-dib': not @state.mobileGIFLoaded

  prepareFrames: (section) ->
    frameData = _.get @props, '__data.products'
    frameIDs = _.get @props, "frame_groups.#{section}"

    groupedFrames = frameIDs.map (id) ->
      if frameData["#{id}"]
        return [frameData["#{id}"]]

    _.compact groupedFrames

  renderFramesGrid: (section, gaStartingPosition) ->
    frames = @prepareFrames(section)

    frames.map (frame, i) =>
      <FrameCarousel
        gaList='tylerOakley'
        columnModifier=2
        useTextColors=true
        cssModifierFrameName=@classes.frameNameModifier
        cssModifierLink=@classes.shopLinkModifier
        cssModifierFrameColor=@classes.frameColorModifier
        gaPosition={gaStartingPosition + i}
        products=frame
        key=i />

  getMobileLogoProps: (hero) ->
    url: hero.logo
    widths: @getImageWidths 300, 600, 4

  mobileLogoSizes: [
    breakpoint: 0
    width: '80vw'
  ,
    breakpoint: 600
    width: '60vw'
  ]

  loadedMobileGif: ->
    @setState mobileGIFLoaded: true

  renderMobileHero: (hero={}) ->
    logoSrcSet = @getSrcSet @getMobileLogoProps(hero)
    logoSizes = @getImgSizes @mobileLogoSizes

    <div className=@classes.mobileHeroWrapper>
      <div className=@classes.mobileGIFWrapper>
        <img src=hero.mobile_gif
          className=@classes.mobileGIF
          onLoad=@loadedMobileGif
          alt='Warby Parker and Tyler Oakley' />
        <img src=hero.mobile_placeholder
          className=@classes.mobilePlaceholder
          alt='Warby Parker and Tyler Oakley' />
      </div>
      <Img srcSet=logoSrcSet sizes=logoSizes
           alt='Warby Parker and Tyler Oakley'
           cssModifier=@classes.mobileLogo />
    </div>

  render: ->
    @classes = @getClasses()

    if not @state.windowChecked
      #  Push the footer if the window hasn't been checked yet
      <div className=@classes.placeHolder />
    else if @state.windowChecked

      hero = @props.hero or {}
      videoOne = _.get @props, 'videos.one', {}
      videoTwo = _.get @props, 'videos.two', {}
      videoThree = _.get @props, 'videos.three', {}
      copy = @props.copy_box or {}

      <div className=@classes.block>
        {
          if not @state.mobile
            <Hero mobile=@state.mobile {...hero} />
          else
            @renderMobileHero(hero)
        }
        <CopyBox {...copy} mobile=@state.mobile />
        <Video {...videoOne} cssModifier=@classes.cssModifierBeforeFrames mobile=@state.mobile />
        <div className=@classes.gridWrapper children={@renderFramesGrid('one', 2)} />
        <Mosaic {...@props.mosaic} />
        <Video {...videoTwo} cssModifier=@classes.cssModifierVideoMiddle mobile=@state.mobile />
        <div className=@classes.gridWrapper children={@renderFramesGrid('two', 5)} />
        <Video {...videoThree} cssModifier=@classes.cssModifierVideoLast mobile=@state.mobile />
        <div className=@classes.gridWrapper children={@renderFramesGrid('three', 7)} />
      </div>
