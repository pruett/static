React = require 'react/addons'
_ = require 'lodash'

TypeKit = require 'components/atoms/scripts/typekit/typekit'
Img = require 'components/atoms/images/img/img'
Frame = require 'components/molecules/collections/amanda_de_cadenet/frame/frame'
Markdown = require 'components/molecules/markdown/markdown'
Mixins = require 'components/mixins/mixins'

require './amanda_de_cadenet.scss'

module.exports = React.createClass

  # Constants
  BLOCK_CLASS: 'c-amanda-de-cadenet'

  TYPEKIT_ID: 'gzy0ocr'

  IMAGE_REFS: [
    'amanda'
  ,
    'atlanta'
  ,
    'toryMobile'
  ,
    'toryDesktop'
  ,
    'flowerLight'
  ,
    'flowerPink'
  ,
    'joy'
  ,
    'paloma'
  ,
    'ella'
  ,
    'silvan'
  ,
    'atlantaStripes'
  ,
    'atlantaDesktop'
  ,
    'atlantaMobile'
  ]

  BACKGROUND_IMAGE_SIZES: [
    breakpoint: 0
    width: '80vw'
  ,
    breakpoint: 600
    width: '60vw'
  ]

  LIFESTYLE_IMAGE_SIZES: [
    breakpoint: 0
    width: '80vw'
  ,
    breakpoint: 600
    width: '60vw'
  ,
    breakpoint: 900
    width: '70vw'
  ]

  mixins: [
    Mixins.image
    Mixins.classes
    Mixins.scrolling
    Mixins.dispatcher
  ]

  propTypes:
    content: React.PropTypes.object

  getDefaultProps: ->
    content: {}

  getInitialState: ->
    fadedImageRefs: []

  componentDidMount: ->
    @handleProductImpressions()
    @addScrollListener @fadeRefs
    setTimeout ( () =>
      @fadeRefs()
    ), 500

  componentDidUpdate: ->
    if @state.fadedImageRefs.length >= @IMAGE_REFS.length
      @__cleanUpEventListeners()

  handleProductImpressions: ->
    frames = @props.frames or []

    impressions = frames.map (frame) ->
      ga = frame.ga or {}
      brand: 'Warby Parker'
      name: ga.display_name
      category: ga.type
      color: ga.color
      id: ga.product_id
      position: ga.position
      list: 'AmandaDeCadenet'
      gender: 'f',
      collections: [
        slug: 'AmandaDeCadenet'
      ]

    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productImpression'
      products: impressions

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-mw1440
      u-mla u-mra
    "
    # Hero
    hero: "
      #{@BLOCK_CLASS}__hero
      u-mw1440 u-mla u-mra
      u-pr
      u-h0
      u-mb60--900
    "
    heroLogo: '
      u-w8c u-w5c--600 u-w3c--900
      u-pa
      u-center
    '
    arrow: "
      #{@BLOCK_CLASS}__arrow
      u-cursor--pointer
      u-center-x
      u-pa
    "
    # GirlGaze
    girlGazeCallout: "
      #{@BLOCK_CLASS}__girl-gaze-callout
      u-mw1440 u-mla u-mra
      u-mb84
      u-h0 u-pr
    "
    girlGazeBodyCopy: "
      #{@BLOCK_CLASS}__girl-gaze-callout__body-copy
      u-color--black
      u-fs16 u-fs24--1200
      u-lh24
      u-mla u-mra
      u-w9c
      u-tac
    "
    girlGazeLogoWrapper: '
      u-mla u-mra
      u-tac
      u-pt54 u-mb42
      u-pt72--600
    '
    girlGazeLogo: '
      u-w4c u-w2c--600
      u-vam
    '
    girlGazeLeadText: "
      #{@BLOCK_CLASS}__girl-gaze-callout__lead-text
      u-vam
      u-color--black
      u-mr12 u-fwb
      u-fwb
      u-type-amanda-de-cadenet
      u-fs14 u-fs24--900
    "
    star: "
      #{@BLOCK_CLASS}__girl-gaze-callout__star
      u-pa
      u-center-x
      u-w2c
      u-b0
    "
    # Mosaics
    mosaicHeader: "
      #{@BLOCK_CLASS}__mosaic-header
      u-type-amanda-de-cadenet
      u-fwb
      u-color--black u-fs14 u-fs24--900
      u-reset u-mb24
      u-mla u-mra
    "
    mosaicBody: "
      #{@BLOCK_CLASS}__mosaic-body
      u-color--black u-fs16 u-fs24--900
      u-lh24 u-lh30--900
      u-reset
    "
    topMosaic: '
      u-pr
      u-w10c--600
      u-mla u-mra
      u-pt60
    '
    topMosaicCopyWrapperMobile: '
      u-tac u-mla u-mra
      u-mb48
      u-dn--600
      u-w10c
    '
    topMosaicCopyWrapperDesktop: '
      u-tac u-mla u-mra
      u-mb48 u-mb60--900 u-mb72--1200
      u-w10c
    '
    topMosiacColumnLeft: "
      u-dn u-dib--600 u-w6c--600
    "
    topMosiacColumnRight: "
      #{@BLOCK_CLASS}__top-mosaic-column-right
      u-pr u-tac
      u-dib u-w6c--600
    "
    bottomMosaic: '
      u-mt48--600 u-mt120--900
      u-pr
      u-w10c--600
      u-mla u-mra
    '
    bottomMosaicColumnLeft: "
      #{@BLOCK_CLASS}__bottom-mosaic-column-left
      u-pr
      u-dib u-w6c--600
      u-vat
    "
    bottomMosaicColumnRight: '
      u-dn u-dib--600 u-w6c
    '
    bottomMosaicCopyWrapperMobile: '
      u-tac u-mla u-mra
      u-mb48
      u-w10c
      u-dn--600
    '
    bottomMosaicCopyWrapperDesktop: '
      u-dn u-db--600
      u-tac u-mla u-mra u-w10c
      u-pt36 u-pb48 u-pb60--900
    '
    finalMosaic:'
      u-mb8 u-mb60--600 u-mb120--900
      u-mt48--600 u-mt120--900
      u-pr
      u-w11c u-w10c--600
      u-mla u-mra
    '
    finalMosaicColumnLeft: "
      #{@BLOCK_CLASS}__final-mosaic-column-left
      u-w5c--600 u-dib--600
      u-vat
      u-mb36
    "
    finalMosaicColumnRight: "
      #{@BLOCK_CLASS}__final-mosaic-column-right
      u-w7c--600 u-dib--600
      u-vat
    "
    ImageWrapper: "
      #{@BLOCK_CLASS}__image-wrapper
      u-tac
      u-pr
      u-mla u-mra
    "
    img: "
      u-w12c
    "
    backgroundImage: '
      u-w11c u-w12c--600
    '
    lifestyleImage: "
      #{@BLOCK_CLASS}__lifestyle-image
      u-pa u-center
      u-w8c u-w9c--600
    "
    # Lifestyle Images
    amanda: '
      u-mb36
    '
    paloma: '
      u-mb36
    '
    ella: '
      u-mb36
    '
    atlantaMobile: '
      u-dn--600
    '
    toryMobile: '
      u-dn u-db--600
    '
    toryDesktop: '
      u-dn u-db--600
    '
    joy: '
      u-mb36
    '
    # CSS Modifiers
    cssModifierFirstFrame: '
      u-mt12 u-mt0--600
      u-mb96--600 u-mb0--900
    '
    cssModifierSecondFrame: '
      u-mb72 u-mt12
      u-mt36--600
      u-mb108--600
      u-mb120--900
    '
    cssModifierThirdFrame: '
      u-mb60 u-mb108--600
      u-mb120--900
      u-pt48--600 u-pt36--900
    '


  # Handlers
  handleScroll: (e) ->
    e.preventDefault()
    @scrollToNode React.findDOMNode(@refs.topMosaic)

  fadeRefs: ->
    fadedImageRefs = @state.fadedImageRefs.slice(0)
    @IMAGE_REFS.forEach (ref) =>
      if @refIsInViewport @refs["#{ref}"]
        refFaded = @isRefFaded(ref)
        unless refFaded
          fadedImageRefs.push ref
    if fadedImageRefs.length > @state.fadedImageRefs.length
      @setState fadedImageRefs: fadedImageRefs


  # Helpers
  getLifestyleImageProps: (image) ->
    url:  image or ''
    widths: @getImageWidths 400, 1000, 5

  getBackgroundImageProps: (image) ->
    url:  image or ''
    widths: @getImageWidths 300, 1200, 6
    quality: 100

  getRefModifier: (ref) ->
    if @state.fadedImageRefs.indexOf(ref) >= 0
      '-faded'
    else
      ''

  isRefFaded: (ref) ->
    @state.fadedImageRefs.indexOf(ref) >= 0

  # Renders
  renderImage: (name) ->
    image = _.find @props.images, name: name
    return false unless image

    key = image.name or ''

    backgroundImgSrcSet = @getSrcSet(@getBackgroundImageProps(image.background))
    backgroundImgSizes = @getImgSizes @BACKGROUND_IMAGE_SIZES

    lifestyleImgSrcSet = @getSrcSet(@getLifestyleImageProps(image.lifestyle))
    lifestyleImgSizes = @getImgSizes @LIFESTYLE_IMAGE_SIZES

    <div className={"#{@classes.ImageWrapper} #{image.css_modifier}"}>
      <div className={@classes["#{key}"]}>
        <Img srcSet=backgroundImgSrcSet sizes=backgroundImgSizes
             alt='Warby Parker and Amanda de Cadenet'
             cssModifier=@classes.backgroundImage />
        <Img srcSet=lifestyleImgSrcSet sizes=lifestyleImgSizes
             alt='Warby Parker and Amanda de Cadenet'
             ref=name
             cssModifier={"#{@classes.lifestyleImage} #{image.css_modifier} #{@getRefModifier(name)}"} />
      </div>
    </div>

  renderHero: ->
    logoSizes = [
      breakpoint: 0
      width: '80vw'
    ,
      breakpoint: 600
      width: '60vw'
    ]

    logoProps =
      url:  @props.hero_image_src or ''
      widths: @getImageWidths 300, 800, 6

    logoSrcSet = @getSrcSet logoProps

    logoSizes = @getImgSizes logoSizes

    <section className=@classes.hero>
      <Img srcSet=logoSrcSet sizes=logoSizes
           alt='Warby Parker and Amanda de Cadenet'
           cssModifier=@classes.heroLogo />
      <a href='#topMosaic' onClick=@handleScroll>
        <img
          src=@props.arrow_src
          className=@classes.arrow
          alt='Down Arrow' />
          <span className='u-hide--visual'
            children='Scroll down to Amanda de Cadenet biography' />
      </a>
    </section>

  renderTopMosaic: ->
    copy = @props.copy_amanda or {}
    <section className=@classes.topMosaic ref='topMosaic' id='topMosaic'>
      <div className=@classes.topMosiacColumnLeft>
        <div className=@classes.topMosaicCopyWrapperDesktop>
          <h3 children=copy.header className=@classes.mosaicHeader />
          <Markdown
            rawMarkdown=copy.body
            className=@classes.mosaicBody
            cssBlock='u-reset' />
        </div>
        {@renderImage('paloma')}
        {@renderImage('joy')}
      </div>
      <div className=@classes.topMosiacColumnRight>
        <div className=@classes.topMosaicCopyWrapperMobile>
          <h3 children=copy.header className=@classes.mosaicHeader />
          <p children=copy.body className=@classes.mosaicBody />
        </div>
        {@renderImage('amanda')}
        {@renderImage('silvan')}
      </div>
    </section>

  renderGirlGazeCallout: ->
    callout = @props.girl_gaze_callout or {}
    <section className=@classes.girlGazeCallout>
      <div className=@classes.girlGazeLogoWrapper>
        <span>
          <span children=callout.lead_text className=@classes.girlGazeLeadText />
          <img src=callout.girl_gaze_src className=@classes.girlGazeLogo />
        </span>
      </div>
      <p children=callout.body className=@classes.girlGazeBodyCopy />
      <img src=callout.star_src className=@classes.star />
    </section>

  renderBottomMosaic: ->
    copy = @props.copy_frames or {}
    <section className=@classes.bottomMosaic>
      <div className=@classes.bottomMosaicColumnLeft>
        <div className=@classes.bottomMosaicCopyWrapperMobile>
          <h3 children=copy.header className=@classes.mosaicHeader />
          <p children=copy.body className=@classes.mosaicBody />
        </div>
        {@renderImage('ella')}
        {@renderImage('atlantaMobile')}
        {@renderImage('toryDesktop')}
      </div>
      <div className=@classes.bottomMosaicColumnRight>
        {@renderImage('atlantaDesktop')}
        <div className=@classes.bottomMosaicCopyWrapperDesktop>
          <h3 children=copy.header className=@classes.mosaicHeader />
          <p children=copy.body className=@classes.mosaicBody />
        </div>
        {@renderImage('flowerLight')}
      </div>
    </section>

  renderFinalMosaic: ->
    <section className=@classes.finalMosaic>
      <div className=@classes.finalMosaicColumnLeft>
        {@renderImage('flowerPink')}
      </div>
      <div className=@classes.finalMosaicColumnRight>
        {@renderImage('atlantaStripes')}
      </div>
    </section>

  render: ->
    @classes = @getClasses()
    silvanOptical = _.find @props.frames, product_key: 'silvan_optical'
    silvanSun = _.find @props.frames, product_key: 'silvan_sun'
    ella = _.find @props.frames, product_key: 'ella'

    <div className=@classes.block>
      <TypeKit typeKitModifier=@TYPEKIT_ID />
      {@renderHero()}
      {@renderTopMosaic()}
      <Frame {...silvanOptical}
        cssModifier=@classes.cssModifierFirstFrame
        hasSeparator=true
        ref='firstFrame' />
      {@renderBottomMosaic()}
      <Frame {...ella} separator=false cssModifier=@classes.cssModifierSecondFrame />
      {@renderGirlGazeCallout()}
    </div>
