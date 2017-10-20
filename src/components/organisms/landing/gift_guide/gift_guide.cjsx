
_ = require 'lodash'
React = require 'react/addons'

Img = require 'components/atoms/images/img/img'
Picture = require 'components/atoms/images/picture/picture'
GiftCard = require 'components/molecules/landing/gift_guide/gift_card/gift_card'
Callout = require 'components/molecules/landing/gift_guide/callout/callout'
FullBleedCallout = require 'components/molecules/landing/frame/full/full'
Hero = require 'components/molecules/landing/gift_guide/hero/hero'

Mixins = require 'components/mixins/mixins'

require './gift_guide.scss'

require '../../collections/winter_2016/winter_2016.scss'


module.exports = React.createClass

  BLOCK_CLASS: 'c-gift-guide'

  getDefaultProps: ->
    footer: {}
    hero: {}
    products: []

  propTypes:
    hero: React.PropTypes.object
    footer: React.PropTypes.object
    products: React.PropTypes.array

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.dispatcher
    Mixins.analytics
  ]

  componentDidMount: ->
    @buildProductImpressions()

  buildProductImpressions: ->
    products = @props.products or []
    impressions = products.map (product, i) =>
      #  Build distinct impression objects per product type to avoid sending
      #  null values to GA.
      if product.ga_product_type is 'Frame'
        @buildFrameImpressions(product, i)
      else
        @buildBaseImpression(product, i)

    unless _.isEmpty impressions
      @commandDispatcher 'analytics', 'pushProductEvent',
        type: 'productImpression'
        products: _.flatten impressions

  buildFrameImpressions: (product,i ) ->
    ctas = product.ctas or []
    baseImpression = @buildBaseImpression(product, i)

    ctas.map (cta) ->
      genderedImpression = _.clone baseImpression
      genderedImpression.id = cta.id
      genderedImpression

  buildBaseImpression: (product, i) ->
    position: i + 1
    id: product.product_id
    brand: 'Warby Parker'
    list: 'Holiday 2016 Gift Guide'
    category: product.ga_product_type
    name: product.ga_name

  getStaticClasses: ->
    block: @BLOCK_CLASS
    footer: "
      #{@BLOCK_CLASS}__footer
      u-mt72
      u-mla u-mra
      u-mw1440
      u-h0
      u-pr
    "
    footerCopyWrapper: "
      #{@BLOCK_CLASS}__footer-copy-wrapper
      u-tac u-w10c
      u-mla u-mra
      u-pa--600 u-t0--600 u-l0--600
      u-center-y--600 u-w5c--600
      u-color-winter-2016--blue-alt-2
    "
    footerTitle: '
      u-fs24 u-fs30--900
      u-ffs
      u-reset
      u-fws
      u-mt24
      u-mb12
    '
    footerBody: '
      u-fs16 u-fs18--900
      u-reset
      u-lh24
    '
    spriteWrapper: '
      u-tac
      u-mb48
      u-w4c u-mla u-mra
    '
    sprite: '
      u-dn--600
    '
    cssUtilityFullBleedTitle: '
      u-reset u-fs20 u-fs26--900 u-fs30--1200
      u-ffs u-fws
      u-color-winter-2016--blue-alt-2
      u-mb6 u-mb2--900
    '
    cssUtilityFullBleedSubtitle: '
      u-reset u-fs18 u-fs20--900
      u-ffs u-fsi u-color--dark-gray-alt-3
      u-mb18 u-mb24--900
    '
    cssUtilityFullBleedLink: "
      #{@BLOCK_CLASS}__link
    "
    cssUtilityFullBleedPrice: '
      u-reset u-fs18 u-fs20--900
      u-ffs u-fws
      u-color-winter-2016--blue-alt-2
      u-mb6
    '

  IMAGE_SIZES_LOOKUP:
    # Convert sketch  -> t-shirt
    'mobile': 'xs'
    'tablet': 's'
    'desktop-sd': 'm'
    'desktop-hd': 'l'

  spriteSizes: [
    breakpoint: 0
    width: '60vw'
  ]

  getSpriteProps: (sprite) ->
    url: sprite
    widths: @getImageWidths 200, 600, 5

  getTextAlignment: (flip) ->
    if flip then 'right' else 'left'

  getProductImages: (images) ->
    # move image sizes from sketch syntax to t-shirt sizes
    images.map (image) =>
      image.size = @IMAGE_SIZES_LOOKUP[image.size]
      image

  getFullBleedProps: (product) ->
    #  Build an object that mocks the schema for the curated full callout
    show_price: true
    show_links: true
    text_align: @getTextAlignment(product.flip)
    image_overrides: @getProductImages(product.images or [])
    image_alt_text: product.image_alt_text
    product:
      gendered_details: product.ctas
      starting_price: product: product.pricing_text
      display_name: product.title_text
      subtitle: product.subtitle

  manageProductClick: (product = {}) ->
    # Passed down to FullBleed Callout
    # Track WP event and replace any dashes.
    @trackInteraction 'LandingPage-clickShop-9000_0310_BOK'

    # Hard-coding as this is only being used for the dog callout and there
    # won't be another full-bleed callout added.
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [
        brand: 'Warby Parker'
        id: product.id
        list: 'GiftGuide'
        name: 'dogToy'
        sku: '9000_0310_BOK'
        url: 'editions/sal-dog-toy'
      ]

  renderMobileSprite: (product, classes) ->
    <div className=classes.spriteWrapper>
      <Img
        srcSet={@getSrcSet @getSpriteProps(product.sprite_png)}
        sizes={@getImgSizes @spriteSizes}
        cssModifier={"#{classes.sprite} #{product.css_utility_sprite}"} />
    </div>

  renderProduct: (product={}, i) ->
    classes = @getClasses()
    if product.callout_type is 'no-background'
      if product.show_sprite
        <div key=i>
          <Callout {...product} gaPosition={i + 1} />
          {@renderMobileSprite(product, classes)}
        </div>
      else
        <Callout {...product} key=i gaPosition={i + 1} />
    else if product.callout_type is 'full-bleed'
      <FullBleedCallout
        {...@getFullBleedProps(product)}
        headerOverride=true
        css_utility_frame_name=classes.cssUtilityFullBleedTitle
        css_utility_frame_color=classes.cssUtilityFullBleedSubtitle
        css_utility_link=classes.cssUtilityFullBleedLink
        css_utility_price=classes.cssUtilityFullBleedPrice
        price_unformatted=true
        manageProductClick=@manageProductClick
        holiday_links=true
        key=i
        gaPosition={i + 1} />
    else if product.callout_type is 'giftcard'
      <GiftCard key=i gaPosition={i + 1} {...product} />

  renderFooter: (classes) ->
    footer = @props.footer or {}
    footerImages = @getFooterImages(classes, footer)
    <section className=classes.footer>
      <Picture children={@getPictureChildren(footerImages)} />
      <div className=classes.footerCopyWrapper>
        <h2 children=footer.header className=classes.footerTitle />
        <p children=footer.body className=classes.footerBody />
      </div>
    </section>

  getFooterImages: (classes, footer) ->
    images = footer.images or []

    sources: [
      quality: @getQualityBySize(images, 'desktop-sd')
      url: @getImageBySize(images, 'desktop-sd')
      widths: @getImageWidths 900, 1800, 4
      mediaQuery: '(min-width: 900px)'
      sizes: '(min-width: 1440px) 1440px, 100vw'
    ,
      quality: @getQualityBySize(images, 'tablet')
      url: @getImageBySize(images, 'tablet')
      widths: @getImageWidths 600, 900, 5
      mediaQuery: '(min-width: 600px)'
    ,
      quality: @getQualityBySize(images, 'mobile')
      url: @getImageBySize(images, 'mobile')
      widths: @getImageWidths 300, 600, 5
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Warby Parker Holiday Gift Guide'
      className: classes.image

  render: ->
    classes = @getClasses()
    products = @props.products or []

    <div className=classes.block>
      <Hero {...@props.hero} />
      {products.map @renderProduct}
      {@renderFooter(classes)}
    </div>
