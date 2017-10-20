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
  BLOCK_CLASS: 'c-collection-core-frame'

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
    gaCategory: 'Landing-Page'
    products: []
    useTextColors: false
    version: 'm'
    hidden: false
    gaListModifier: 'collection'
    sizes: [
      breakpoint: 0
      width: '100vw'
    ,
      breakpoint: 360
      width: '360px'
    ,
      breakpoint: 900
      width: '462px'
    ,
      breakpoint: 1200
      width: '606px'
  ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS} #{@props.cssModifier} u-grid__col u-w12c -c-6--600
    "
    cta_container: "
      #{@BLOCK_CLASS}__cta-container
    "
    images_container: "
      #{@BLOCK_CLASS}__images-container
    "
    image_link: "
      #{@BLOCK_CLASS}__image-link
    "
    image: "
      #{@BLOCK_CLASS}__image
    "
    details: "
      #{@BLOCK_CLASS}__details
    "
    name: "
      #{@BLOCK_CLASS}__name u-reset u-ffs u-fs20 u-fws
      #{@props.cssModifierFrameName}
    "
    colorName: "
      #{@BLOCK_CLASS}__color-name
      #{@props.cssModifierColorName}
    "
    colorSwatches: "
      #{@BLOCK_CLASS}__color-swatches
    "
    soldOut: "
      #{@BLOCK_CLASS}__sold-out
      u-fs16 u-fs18--900
    "

  classesWillUpdate: ->
    classes =
      soldOut:
        '-show': _.get @props, "products[#{@state.activeIndex}].sold_out"

    if @props.version is 'fans'
      # On mobile, the shop links buttons stack on top of each other, so we need to
      # know if there are one or two in order to apply the correct styles.
      ctaCounts = _.map @props.products, (product) -> _.get product, 'gendered_details.length', 0
      imagesContainerModifier =
        '-show-ctas': @state.showCtas
        '-single-cta': ctaCounts[@state.activeIndex] is 1

      classes.images_container = imagesContainerModifier

    return classes

  componentWillReceiveProps: (props) ->
    @setState activeIndex: @getFirstVisibleProduct(props.products)

  getFirstVisibleProduct: (products) ->
    Math.max 0, _.findIndex(products, (product) -> not product.hidden)

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
      url: details[0].path
      id: details[0].product_id

    wpImpression = "LandingPage-clickShop#{gender}-#{sku}"
    @trackInteraction(wpImpression)
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [prodClickData]

  getLinkProps: (assemblies, product, i) ->
    classes = @getClasses()
    isFans = @props.version is 'fans'

    productCount = _.get product, 'gendered_details.length', 2

    linkProps =
      key: product.sku
      className: [
        classes.image_link
        '-active' if i is @state.activeIndex
        '-block' if i is 0
        '-show-ctas' if (@state.showCtas and not product.sold_out)
        '-single-cta' if productCount is 1
      ].join ' '

    if isFans
      linkProps.onClick = @handleToggleCtas.bind @, product

    else
      path = _.get assemblies, "#{@props.version}[0].path", ''
      linkProps.href = "/#{path}"
      genderedDetails = assemblies[@props.version]
      sku = product.sku
      name = product.name
      linkProps.onClick = @handleGenderedData.bind @, genderedDetails, sku, name

    return linkProps

  getShopLinksProps: (assemblies, product) ->
    version: 'fans'
    frameAssembly:
      product_men_id: _.get assemblies, 'm[0].product_id'
      men_url: _.get assemblies, 'm[0].path'
      product_women_id: _.get assemblies, 'w[0].product_id'
      women_url: _.get assemblies, 'w[0].path'
      product_sku: product.sku
      sold_out: false
      name: product.name
    gaCategory: @props.gaCategory
    gaListModifier: @props.gaListModifier


  getProductImages: ->
    isFans = @props.version is 'fans'
    classes = @getClasses()

    _.map @props.products, (product, i) =>
      if isFans and not product.sold_out
        # For the fans version, we need to generate props for the Shop Links CTAs.
        assemblies = _.groupBy product.gendered_details, (detail) -> detail.gender
        productCount = _.get product, 'gendered_details.length', 2

        ctaContainerProps =
          className: [
            classes.cta_container
            '-active' if i is @state.activeIndex
            '-show-ctas' if @state.showCtas
            '-single-cta' if productCount is 1
          ].join ' '
        shopLinksProps = @getShopLinksProps(assemblies, product, i)
      else
        # Otherwise, get the correct gendered details.
        assemblies = {}
        assemblies[@props.version] = [_.find product.gendered_details,
          (detail) => return detail.gender is @props.version]

      linkProps = @getLinkProps(assemblies, product, i)
      imgProps = {
        ref: 'frame-image' if i is 0
        cssModifier: classes.image
      }

      imgProps.srcSet = @getSrcSet(
        url: product.image_url
        widths: [300, 400, 500, 600, 650]
        quality: 80
      )

      <div>
        {unless product.sold_out
          <a {...linkProps}>
            <Img {...imgProps} />
          </a>
        else
          <span {...linkProps}>
            <Img {...imgProps} />
          </span>}

        {if isFans and !product.sold_out
          <div {...ctaContainerProps} >
            <ShopLinks {...shopLinksProps} />
          </div>}
      </div>

  render: ->
    activeProduct = _.get @props, "products[#{@state.activeIndex}]", {}
    soldOut = activeProduct.sold_out
    classes = @getClasses()
    productImages = @getProductImages()
    <div className=classes.block>
      <div
        children={if @props.useTextColors then [_.first productImages] else productImages}
        className=classes.images_container />
      <div className=classes.details>
        <div
          className=classes.soldOut
          children=activeProduct.sold_out_text />
        <h3 className=classes.name children=@props.products[0].name />
        {if @props.useTextColors
          <span className=classes.colorName
            children=@props.products[0].color
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
