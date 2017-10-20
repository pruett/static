[
  _
  React

  Img
  ColorSwatches

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'
  require 'components/molecules/products/color_swatches/color_swatches'


  require 'components/mixins/mixins'

  require './carousel.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-landing-carousel'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
    Mixins.image
  ]

  getInitialState: ->
    activeIndex: 0

  getDefaultProps: ->
    gaPosition: 0
    gaList: 'Warby Parker'
    cssModifierBlock: ''
    cssModifier: ''
    cssModifierFrameName: ''
    cssModifierImagesContainer: ''
    cssModifierFrameColor: ''
    cssModifierLink: ''
    cssModifierFrameDetails: ''
    gaCategory: 'Landing-Page'
    products: []
    product: {}
    useTextColors: false
    columnModifier: 1
    gaListModifier: 'LandingPageGallery'
    version: 'fans'
    imageLinks: true
    isStatic: false
    women_only_ids: [60575, 60604, 60633, 60661, 60804, 60833, 60862, 60891, 60518]


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
    block: "
      u-pr
      u-grid__col
      u-w100p u-tac
      u-pb36 u-pb24--900
      #{@props.cssModifierBlock}
    "
    images_container: "
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
      u-mb24
      u-pr6--600 u-pl6--600 u-pr36--900 u-pl36--900 u-pr6--1200 u-pl6--1200
    '
    name: "
      u-fs22 u-fs24--900
      u-ffs
      u-fws
      u-fsb
      u-mb4
      u-reset
      #{@props.cssModifierFrameName}
    "
    colorName: "
      u-fs16 u-fs18--900
      u-fsi
      u-ffs
      #{@props.cssModifierFrameColor}
    "
    colorSwatches: '
      u-mt12
    '
    hr: '
      u-bc--light-gray u-bw0 u-bbw1 u-bss
      u-mb48 u-mb64--600 u-mb84--900
    '
    shopLink: "
      #{@BLOCK_CLASS}__link
      #{@props.cssModifierLink}
      u-color--blue u-bbss u-bbw2 u-bbw0--900 u-bc--blue
      u-pb6 u-fws u-fs16 u-fs18--900 u-wsnw
    "
    shopLinkLeft: "
      #{@BLOCK_CLASS}__link
      #{@props.cssModifierLink}
      u-mr24
      u-color--blue u-bbss u-bbw2 u-bbw0--900 u-bc--blue
      u-pb6 u-fws u-fs16 u-fs18--900 u-wsnw
    "
    linkWrapper: '
      u-pt8
      u-mb24
    '
    details: "
      #{@props.cssModifierFrameDetails}
    "

  classesWillUpdate: ->
    block:
      'u-mb12 u-mb60--900 u-w10c--600 u-w8c--900
      u-l1c--600 u-l2c--900': @props.columnModifier is 1 and not @props.full
      'u-mb48--900 u-mb120--1200 u-w6c--600': @props.columnModifier is 2
      'u-mb60--900 u-w4c--1200': @props.columnModifier is 3
      'u-w12': @props.full
    soldOut:
      '-show': _.get @props, "products[#{@state.activeIndex}].sold_out"
    details:
      '-animate': @state.showCtas
      '-single-cta': _.get(@props, 'product.gendered_details.length') is 1
    image:
      'u-l0 u-b0 u-pa': not @props.isStatic
    imageLink:
      '-fixed': not @props.isStatic

  handleColorChange: (newIndex) ->
    @setState activeIndex: newIndex

  getLinkProps: (assemblies, product, i) ->
    classes = @getClasses()
    linkProps =
      key: product.sku
      className: [
        classes.imageLink
        '-active' if i is @state.activeIndex
        'u-pr u-db' if i is 0
      ].join ' '

  getImgProps: (product, i) ->
    classes = @getClasses()

    imgProps =
      cssModifier: classes.image
      sizes: @getImgSizes @sizes
      alt: "#{product.name}"

    imgProps.srcSet = @getSrcSet(
      url: product.image
      widths: [320, 360, 462, 606, 640, 720, 924, 1212]
      quality: 80
    )
    imgProps

  getProductImages: ->
    classes = @getClasses()

    @props.products.map (product, i) =>
      assemblies = _.groupBy product.gendered_details, 'gender'

      linkProps = @getLinkProps assemblies, product, i
      imgProps = @getImgProps product, i


      if @props.version is 'fans'
        <span {...linkProps} key=i>
          <Img {...imgProps} />
        </span>
      else
        details = _.find product.gendered_details, gender: @props.version
        return false unless details
        #  Wrap image in a link if we're on a gendered version of the page.
        <a onClick={@handleProductClick.bind @, details.gender} key=i href={"/#{details.path}"}>
          <span {...linkProps} >
            <Img {...imgProps} />
          </span>
        </a>

  isWomenOnly: (activeProduct = {}) ->
    activeProduct.product_id in @props.women_only_ids

  renderLinks: (activeProduct, classes) ->
    genderCopyLookup =
      m: 'Shop Men'
      f: 'Shop Women'

    if @props.version is 'fans' and not @isWomenOnly(activeProduct)
      _.map activeProduct.gendered_details, (link, i) =>
        <a href=link.path
          key=i
          onClick={@handleProductClick.bind @, link.gender}
          children={if not @props.genderNeutralLinks then genderCopyLookup["#{link.gender}"] else 'Shop now'}
          className={if i is 0 and activeProduct.gendered_details.length > 1
          then classes.shopLinkLeft else classes.shopLink} />
    else if @props.version is 'fans' and @isWomenOnly(activeProduct)
      womenLink = _.find activeProduct.gendered_details, gender: 'f'
      <a href=womenLink.path
        onClick={@handleProductClick.bind @, womenLink.gender}
        children='Shop women'
        className=classes.shopLink />
    else
      details = _.find activeProduct.gendered_details, gender: @props.version
      return false unless details
      <a href=details.path
        onClick=@handleProductClick
        children='Shop now'
        className=classes.shopLink />

  handleProductClick: (gender='') ->
    product = _.get @props, "products[#{@state.activeIndex}]", {}

    genderLookUp =
      m: "Men"
      f: "Women"

    wpEventSlug = "LandingPage-clickShop#{genderLookUp[gender]}-#{product.sku}"

    @trackInteraction wpEventSlug

    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [
        brand: 'Warby Parker'
        category: 'Eyeglasses'
        list: @props.gaList
        id: product.product_id
        color: product.color
        gender: gender
        collections: [
          slug: @props.collectionSlug
        ]
        name: product.display_name
        position: @props.gaPosition
        sku: product.sku
        url: product.path
      ]

  render: ->
    activeProduct = _.get @props, "products[#{@state.activeIndex}]", {}
    classes = @getClasses()

    <section className=classes.block>
      <div
        children=@getProductImages()
        className=classes.images_container />
      <div className=classes.details>
        {
          if not @props.oneLineFrameDetail
            <h3 className=classes.name children={activeProduct.display_name} />
          else
            <span className=classes.name children={activeProduct.display_name} />
        }
        <span children={if @props.oneLineFrameDetail then ' in ' else ''} />
        {
          if @props.useTextColors
            <span className=classes.colorName
              children={activeProduct.color}
              key='colorName' />
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
        {
          if @props.version is 'fans'
            <div
              className=classes.linkWrapper
              children={@renderLinks(activeProduct, classes)} />
        }
      </div>
    </section>
