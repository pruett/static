[
  _
  React

  Img
  ColorSwatches
  ShopLinks

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'
  require 'components/molecules/products/color_swatches/color_swatches'
  require 'components/molecules/collections/core/shop_links/shop_links'


  require 'components/mixins/mixins'

  require './frame.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-landing-frame'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
    Mixins.image
  ]

  getInitialState: ->
    activeIndex: 0
    showCtas: false
    singleCta: false # For a fans version with only one gendered variant

  getDefaultProps: ->
    cssModifier: ''
    cssModifierFrameName: ''
    cssModifierImagesContainer: ''
    cssModifierShopLinks: ''
    gaCategory: 'Landing-Page'
    products: []
    useTextColors: false
    columnModifier: 3
    version: 'm'
    hidden: false
    gaListModifier: 'LandingPageGallery'
    sizes: [
      breakpoint: 0
      width: '100vw'
    ,
      breakpoint: 600
      width: '40vw'
    ,
      breakpoint: 1200
      width: '50vw'
  ]

  getStaticClasses: ->
    block: '
      u-pr
      u-grid__col u-w12c u-w6c--600
      u-w100p u-tac
    '
    ctaContainer: "
      #{@BLOCK_CLASS}__cta-container
      u-vh
      u-h0
      u-tac
      u-pa
      u-l0 u-r0
      u-pt18--600 u-pt0--900
      u-mb12
    "
    ctaLink: "
      #{@BLOCK_CLASS}__cta-link
      u-fs14 u-fs16--900
      -cta-pair
    "
    images_container: "
      #{@BLOCK_CLASS}__images-container
      #{@props.cssModifierImagesContainer}
      u-pr
    "
    imageLink: "
      #{@BLOCK_CLASS}__image-link
      u-pa
      u-w100p
      u-t0
      u-l0
      u-vh
    "
    image: '
      u-w100p
      u-pa
      u-b0
      u-mb24
      u-l0
      u-pr6--600 u-pl6--600 u-pr36--900 u-pl36--900 u-pr6--1200 u-pl6--1200
    '
    details: "
      #{@BLOCK_CLASS}__details
      u-pr
    "
    name: "
      u-fs22 u-fs24--900
      u-ffs
      u-fws
      u-fsb
      u-mb4
      u-reset
      #{@props.cssModifierFrameName}
    "
    colorName: '
      u-fs16 u-fs18--900
      u-fsi
      u-ffs
    '
    colorSwatches: '
      u-mt12
    '
    soldOut: "
      #{@BLOCK_CLASS}__sold-out
      u-color--black
      u-pa
      u-w100p
    "

    hr: '
      u-bc--light-gray u-bw0 u-bbw1 u-bss
      u-mb48 u-mb64--600 u-mb84--900
    '

  classesWillUpdate: ->
    classes =
      block:
        'u-mb12 u-mb60--900  u-w10c--600 u-w8c--900': @props.columnModifier is 1
        'u-mb48 u-mb120--900': @props.columnModifier is 2
        'u-mb48 u-mb60--900  u-w4c--1200': @props.columnModifier is 3
      soldOut:
        '-show': _.get @props, "products[#{@state.activeIndex}].sold_out"
      details:
        '-animate': @state.showCtas
        '-single-cta': @props.products[0].gendered_details?.length is 1

    if @props.version is 'fans'
      imagesContainerModifier =
        '-show-ctas': @state.showCtas

      classes.images_container = imagesContainerModifier

    classes

  componentWillReceiveProps: (props) ->
    @setState activeIndex: @getFirstVisibleProduct(props.products)

  getFirstVisibleProduct: (products) ->
    Math.max 0, _.findIndex(products, hidden: false)

  handleColorChange: (newIndex) ->
    @setState activeIndex: newIndex

  handleToggleCtas: (product, evt) ->
    evt.preventDefault()
    unless product.sold_out
      highlightedProduct = @props.products[@state.activeIndex]
      analyticsSlug = "LandingPage-clickFrameExpand-#{highlightedProduct.sku}"
      @trackInteraction(analyticsSlug)
      @setState showCtas: not @state.showCtas

  handleGenderedData: (details, sku, name) ->
    gender = if @props.version is 'm' then 'Men' else 'Women'
    prodClickData =
      brand: 'Warby Parker'
      category: 'Frame'
      name: name
      sku: sku
      position: @props.position
      url: "/#{details[0].path}"
      id: details[0].product_id

    wpImpression = "LandingPage-clickShop#{gender}-#{sku}"
    @trackInteraction(wpImpression)
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [prodClickData]

  getLinkProps: (assemblies, product, i) ->
    classes = @getClasses()
    isFans = @props.version is 'fans'

    linkProps =
      key: product.sku
      className: [
        classes.imageLink
        '-active' if i is @state.activeIndex
        'u-pr u-db' if i is 0
        '-show-ctas' if (@state.showCtas and not product.sold_out)
      ].join ' '

    if isFans
      linkProps.onClick = @handleToggleCtas.bind @, product

    else
      path = _.get assemblies, "#{@props.version}[0].path", ''
      linkProps.href = "/#{path}"
      genderedDetails = assemblies[@props.version]
      sku = product.sku
      name = product.name or product.display_name
      linkProps.onClick = @handleGenderedData.bind @, genderedDetails, sku, name

    return linkProps

  getShopLinksProps: (assemblies, product) ->
    classes = @getClasses()
    menUrl = if assemblies?.m?[0] then "/#{assemblies.m[0].path}" else null
    womenUrl = if assemblies?.f?[0] then "/#{assemblies.f[0].path}" else null
    frameAssembly:
      product_men_id: _.get assemblies, 'm[0].product_id'
      men_url: menUrl
      product_women_id: _.get assemblies, 'f[0].product_id'
      women_url: womenUrl
      product_sku: product.sku
      sold_out: false
      name: product.name or product.display_name
    gaCategory: @props.gaCategory
    gaListModifier: @props.gaListModifier
    position: @props.position
    cssModifierLink: classes.ctaLink



  getImgProps: (product, i) ->
    classes = @getClasses()

    imgProps =
      cssModifier: classes.image
      sizes: @getImgSizes(@props.sizes)
      alt: "#{product.name}"

    imgProps.ref = 'frame-image' if i is 0

    imgProps.srcSet = @getSrcSet(
      url: product.image
      widths: [320, 360, 462, 606, 640, 720, 924, 1212]
      quality: 80
    )
    imgProps

  renderImg: (product, props, isFans) ->
    <div>
      {unless product.sold_out
        <a {...props.link}>
          <Img {...props.img} />
        </a>
      else
        <span {...props.link}>
          <Img {...props.img} />
        </span>}

      {if isFans and !product.sold_out
        <div {...props.ctaContainer} >
          <ShopLinks {...props.shopLinks} />
        </div>}
    </div>

  getProductImages: ->
    isFans = @props.version is 'fans'
    classes = @getClasses()

    _.map @props.products, (product, i) =>
      assemblies = _.groupBy product.gendered_details, 'gender'
      if isFans and not product.sold_out
        # For the fans version, we need to generate props for the Shop Links CTAs.
        ctaContainerProps =
          className: [
            classes.ctaContainer
            '-active' if i is @state.activeIndex
            '-show-ctas' if @state.showCtas
          ].join ' '
        shopLinksProps = @getShopLinksProps(assemblies, product, i)
      else
        # Otherwise, get the correct gendered details. We don't need shopLinks props here
        assemblies[@props.version] = [_.find product.gendered_details, gender: @props.version]

      linkProps = @getLinkProps(assemblies, product, i)
      imgProps = @getImgProps(product, i)

      props =
        link: linkProps
        img: imgProps
        ctaContainer: ctaContainerProps
        shopLinks: shopLinksProps

      @renderImg(product, props, isFans)

  render: ->
    activeProduct = _.get @props, "products[#{@state.activeIndex}]", {}
    classes = @getClasses()
    productImages = @getProductImages()
    frameColor = _.get @props, 'products[0].color'

    <div className=classes.block>
      <div
        children={if @props.useTextColors then [_.first productImages] else productImages}
        className=classes.images_container />
      <div className=classes.details>
        <div
          className=classes.soldOut
          children=activeProduct.sold_out_text />
        <h3 className=classes.name children=@props.products[0].display_name />
        {if @props.useTextColors
          <span className=classes.colorName
            children=frameColor
            key='color-name' />
        else
          <ColorSwatches
            activeFrameAssemblyIndex=@state.activeIndex
            cssModifier=classes.colorSwatches
            handleColorChange=@handleColorChange
            frameAssemblies=@props.products
            gaCategory=@props.gaCategory
            position=@props.position
            gaListModifier=@props.gaListModifier
            version=@props.version />
        }
      </div>
    </div>
