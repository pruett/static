React = require 'react/addons'
_ = require 'lodash'

Img = require 'components/atoms/images/img/img'
Picture = require 'components/atoms/images/picture/picture'
Markdown = require 'components/molecules/markdown/markdown'
Video = require 'components/molecules/collections/spring_2017/video/video'
FrameCarousel = require 'components/molecules/landing/frame/carousel/carousel'

Mixins = require 'components/mixins/mixins'

require './shoppable_grid.scss'


module.exports = React.createClass

  mixins: [
    Mixins.dispatcher
    Mixins.classes
    Mixins.image
    Mixins.context
    Mixins.analytics
  ]

  BLOCK_CLASS: 'c-spring-2017-shoppable-grid'

  propTypes:
    media: React.PropTypes.array
    copy: React.PropTypes.string
    key: React.PropTypes.string
    grid_ids: React.PropTypes.array
    render_media: React.PropTypes.bool

  getDefaultProps: ->
    media: []
    copy: ''
    key: ''
    grid_ids: []
    render_media: true

  getStaticClasses: ->
    block: "
      #{@props.cssModifierBlock}
      u-pr36--600 u-pl36--600
      u-pr48--900 u-pl48--900
      u-pr60--1200 u-pl60--1200
      u-mw1440
      u-mla u-mra
      u-mb36
      u-tac
    "
    framesGridWrapper: '
      u-w12c u-tac
    '
    mediaWrapper: "
      #{@BLOCK_CLASS}__media-wrapper
      u-w12c u-w6c--600
      u-dib
      u-mb120--900
      u-tac
      u-vat
    "
    mediaWrapperTwoUp: "
      #{@BLOCK_CLASS}__media-wrapper
      u-w12c u-w6c--600
      u-dn
      u-dib--600
      u-mb120--900
      u-tac
      u-vat
    "
    copy: '
      u-fs24
      u-ffs
    '
    markdown: '
      u-reset
    '
    copyBlock: '
      u-grid -maxed
      u-spring-2017-header-copy
      u-mb36 u-mb60--600
      u-tac
      u-pt8 u-pt0--600
      u-mla u-mra
    '
    image: '
      u-w12c u-w11c--600
    '
    copyWrapper: '
      u-grid__col u-w11c u-w9c--900 u-tac
    '
    shopLinkModifier: "
      #{@BLOCK_CLASS}__shop-link-modifier
      u-pb6
      u-bbss u-bbw2 u-bbw0--900 u-bc--dark-gray
    "
    shopLinksWrapper: '
      u-mla u-mra
      u-w12c u-w11c--600
    '
    cta: "
      #{@BLOCK_CLASS}__shop-link-modifier
      #{@BLOCK_CLASS}__cta
      u-pb6
      u-fs18 u-fws
      u-bbss u-bbw1 u-bbw0--900 u-bc--dark-gray
    "
    ctaWrapperFans:'
      u-tac u-tal--900 u-w12c
      u-pt12 u-pt8--600 u-pt12--900
    '
    ctaWrapperGendered: '
      u-w12c u-tac u-tal--900
    '
    ctaDetails: '
      u-fs18 u-fws u-ffss
    '
    carouselWrapper: "
      #{@BLOCK_CLASS}__carousel-wrapper
    "
    flexWrapper: "
      #{@BLOCK_CLASS}__flex-wrapper
    "
    flexChild: "
      #{@BLOCK_CLASS}__flex-child
    "
    imageWrapper: '
      u-mb60
    '
    frameWrapper: '
      u-mb18
    '

  classesWillUpdate: ->
    copyWrapper:
      'u-mb36': not @props.render_media
    copy:
      'u-mb24--600': @props.version is 'm'
    block:
      'u-pt24': @props.version is 'm'

  # Handlers
  handleCTAClick: (color, ctaData, gender, gaPosition) ->
    genderLookup =
      m: 'Men'
      f: 'Women'

    @trackInteraction "LandingPage-clickShop#{genderLookup[gender]}Callout-#{ctaData.sku}"
    genderedData = _.find ctaData.gendered_details, gender: gender

    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [
        brand: 'Warby Parker'
        category: 'Eyeglasses'
        list: 'spring2017'
        id: genderedData.product_id
        name: ctaData.display_name
        collections: [
          slug: 'spring-2017'
        ]
        color: color
        gender: gender
        position: gaPosition
        sku: ctaData.sku
        url: genderedData.path
      ]


  # Helpers
  getMediaFrame: (section) ->
    frame = _.find @props.frameData, product_id: section.frame_id

    if frame then return [frame] else return false

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
      alt: 'Warby Parker Spring 2017 Collection'
      className: @classes.image

  getCTACopy: (cta) ->
    if cta.gender is 'f'
      'Shop Women'
    else
      'Shop Men'

  getCTAData: (cta) ->
    matchedCTA = _.find @props.frameData, product_id: cta.id
    if matchedCTA then return matchedCTA else return false

  getCTAHref: (gender, frameData) ->
    cta = _.find frameData.gendered_details, gender: gender
    if cta then return cta.path else return false

  # Renders
  renderCopy: ->
    return false unless @props.copy
    <div className=@classes.copyBlock>
      <div className=@classes.copyWrapper>
        <Markdown
          rawMarkdown=@props.copy
          className=@classes.copy
          cssBlock=@classes.markdown />
      </div>
    </div>

  renderShopLinks: (section) ->
    return false if not section.render_links
    isFans = @props.version is 'fans'
    ctas = section.ctas or []
    frameData = (_.find @props.frameData, product_id: section.cta_id) or {}
    frameColor = frameData.color or ''
    gaPosition = section.ga_position_media

    <div className=@classes.shopLinksWrapper>
      {
        if isFans
          <div>
            <div className=@classes.ctaWrapperFans>
              <span
                children={"#{frameData.display_name} in #{frameData.color}"}
                className=@classes.ctaDetails />
            </div>
            <div className=@classes.ctaWrapperFans>
              {
                ctas.map (cta, i) =>
                  ctaData = @getCTAData(cta)
                  <a
                    children={@getCTACopy(cta)}
                    href={@getCTAHref(cta.gender, ctaData)}
                    onClick={@handleCTAClick.bind @, frameColor, ctaData, cta.gender, gaPosition}
                    className=@classes.cta key=i />
              }
            </div>
          </div>
        else
          <div className=@classes.ctaWrapperGendered>
            {
              cta = _.find ctas, gender: @props.version
              ctaData = @getCTAData(cta)
              <a
                children={"Shop #{frameData.display_name} in #{frameData.color}"}
                href={@getCTAHref(cta.gender, ctaData)}
                onClick={@handleCTAClick.bind @, frameColor, ctaData, cta.gender}
                className=@classes.cta />
            }
          </div>
      }
    </div>

  renderFramesGrid: (frames) ->
    frames = (@props.grid_ids or []).map (id) =>
      matchedFrame = _.find @props.frameData, product_id: id

    frames = _.compact(frames)
    return false if _.isEmpty frames

    frames.map (frame, i) =>
      <FrameCarousel
        gaPosition={@props.ga_starting_position + i}
        gaList='Spring2017'
        oneLineFrameDetail=false
        isStatic=false
        columnModifier=2
        useTextColors=true
        version=@props.version
        collectionSlug='spring-2017'
        cssModifierFrameName=@classes.frameNameModifier
        cssModifierLink=@classes.shopLinkModifier
        cssModifierFrameColor=@classes.frameColorModifier
        cssModifierFrameDetails='u-fs18'
        genderNeutralLinks=false
        women_only_ids=@props.women_only_ids
        products=[frame]
        key=i />

  getMediaSectionKlass: (section, i) ->
    if not section.render_frame and i is 1
      @classes.mediaWrapperTwoUp
    else
      @classes.mediaWrapper

  renderMediaSection: ->
    return false unless @props.render_media
    media = @props.media
    imgSizes = @getImgSizes @IMG_SIZES
    media.map (section, i) =>
      isFrameFirst = section.frame_first
      isVideo = section.is_video
      pictureAttrs = @getPictureAttrs(section.images)
      <div className={@getMediaSectionKlass(section, i)} key=i >
        <div className=@classes.flexWrapper>
          <div className={"#{@classes.imageWrapper} #{@classes.flexChild} #{section.orientation}"}>
          {
            unless isVideo
              <div>
                <div className='u-mb24'>
                  <Picture children={@getPictureChildren(pictureAttrs)} />
                </div>
                {@renderShopLinks(section)}
              </div>
            else
              <div>
                <div className='u-mb24'>
                  <Video {...section} key=i />
                </div>
                {@renderShopLinks(section)}
              </div>
          }
          </div>
          {
            if section.render_frame
              # Render a frame unless it's a side-by-side video callout
              # Ensure that we have a media frame to render
              frameData = @getMediaFrame(section)
              if frameData
                <div className={"#{@classes.frameWrapper} #{@classes.flexChild} #{section.orientation}"}>
                  <FrameCarousel
                    gaList='Spring2017'
                    oneLineFrameDetail=false
                    gaPosition=section.ga_position_frame
                    columnModifier=1
                    useTextColors=true
                    isStatic=true
                    version=@props.version
                    full=true
                    cssModifierFrameName=@classes.frameNameModifier
                    collectionSlug='spring-2017'
                    cssModifierLink=@classes.shopLinkModifier
                    women_only_ids=@props.women_only_ids
                    cssModifierFrameColor=@classes.frameColorModifier
                    cssModifierFrameDetails='u-fs18'
                    cssModifierBlock={if isFrameFirst then @classes.frameModifierFirst else @classes.frameModifierSecond}
                    genderNeutralLinks=false
                    products=frameData />
                </div>
          }
        </div>
      </div>

  render: ->
    @classes = @getClasses()

    <div className=@classes.block id=@props.id>
      {@renderCopy()}
      {@renderMediaSection()}
      <div className=@classes.framesGridWrapper>
        {@renderFramesGrid()}
      </div>
    </div>
