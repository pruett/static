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
  require 'components/molecules/products/color_swatches_deprecated/color_swatches_deprecated'
  require 'components/molecules/collections/shop_links/shop_links'


  require 'components/mixins/mixins'

  require '../../products/gallery_frame/gallery_frame.scss'
]

module.exports = React.createClass
  #deprecating this component as it contains legacy analytics
  BLOCK_CLASS: 'c-gallery-frame'

  mixins: [
    Mixins.classes
  ]

  getInitialState: ->
    activeIndex: 0
    showCtas: false
    singleCta: false # For a fans version with only one gendered variant

  getDefaultProps: ->
    cssModifier: ''
    gaCategory: 'Landing-Page'
    products: []
    useTextColors: false
    version: 'm'
    hidden: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS} #{@props.cssModifier}
    "
    cta_container: "
      #{@BLOCK_CLASS}__cta-container
    "
    images_container: "
      #{@BLOCK_CLASS}__images-container
    "
    image_link: [
      "#{@BLOCK_CLASS}__image-link"
      'js-ga-click'
    ]
    image: "
      #{@BLOCK_CLASS}__image
    "
    details: "
      #{@BLOCK_CLASS}__details
    "
    name: "
      #{@BLOCK_CLASS}__name
    "
    colorName: "
      #{@BLOCK_CLASS}__color-name
      u-reset u-fs16 u-ffs u-fsi u-ttc
    "
    colorSwatches: "
      #{@BLOCK_CLASS}__color-swatches
    "

  classesWillUpdate: ->
    classes =
      block:
        '-hidden': @props.hidden

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
    _.findIndex products, (product) -> not product.hidden

  handleColorChange: (newIndex) ->
    @setState activeIndex: newIndex

  handleToggleCtas: (evt) ->
    evt.preventDefault()
    @setState showCtas: not @state.showCtas

  getLinkProps: (assemblies, product, i) ->
    classes = @getClasses()
    isFans = @props.version is 'fans'

    linkProps =
      key: product.sku
      className: [
        classes.image_link
        '-active' if i is @state.activeIndex
        '-block' if i is 0
        '-show-ctas' if @state.showCtas
        '-single-cta' if _.get product, 'gendered_details.length', 0
      ].join ' '

    if isFans
      linkProps.onClick = @handleToggleCtas
    else
      path = _.get assemblies, "#{@props.version}[0].path", ''
      linkProps.href = "/#{path}"

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
    gaCategory: @props.gaCategory

  getProductImages: ->
    isFans = @props.version is 'fans'
    classes = @getClasses()

    _.map @props.products, (product, i) =>
      if isFans
        # For the fans version, we need to generate props for the Shop Links CTAs.
        assemblies = _.groupBy product.gendered_details, (detail) -> detail.gender

        ctaContainerProps =
          className: [
            classes.cta_container
            '-active' if i is @state.activeIndex
            '-show-ctas' if @state.showCtas
            '-single-cta' if _.get product, 'gendered_details.length', 0
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

      imageSet = _.get product, 'images.clip.front'

      if imageSet
        imgProps.srcSet = imageSet.join(',')
        imgProps.src = _.first imageSet
      else if product.image_url?
        imgProps.src = product.image_url

      <div>
        <a {...linkProps}>
          <Img {...imgProps} />
        </a>
        {if isFans
          <div {...ctaContainerProps} >
            <ShopLinks {...shopLinksProps} />
          </div>}
      </div>

  render: ->
    classes = @getClasses()
    productImages = @getProductImages()

    # @props.useTextColors only supports showing one color right now, and therefore
    # implicitly disables color switching.
    <div className=classes.block>
      <div
        children={if @props.useTextColors then [_.first productImages] else productImages}
        className=classes.images_container />
      <div className=classes.details>
        <h3 className=classes.name children=@props.products[0].name />
        {if @props.useTextColors
          <span className=classes.colorName children=@props.products[0].color />
        else
          <ColorSwatches
            activeFrameAssemblyIndex=@state.activeIndex
            cssModifier=classes.colorSwatches
            handleColorChange=@handleColorChange
            frameAssemblies=@props.products
            gaCategory=@props.gaCategory
            version=@props.version />
        }
      </div>
    </div>
