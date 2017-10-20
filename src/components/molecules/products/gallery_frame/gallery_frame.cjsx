[
  _
  React

  Img

  ColorSwatches
  FrameImage

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'

  require 'components/molecules/products/color_swatches_deprecated/color_swatches_deprecated'
  require 'components/molecules/products/gallery_frame_image/gallery_frame_image'

  require 'components/mixins/mixins'

  require './gallery_frame.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-gallery-frame'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
    Mixins.scrolling
  ]

  getInitialState: ->
    activeIndex: @getFirstVisibleProduct(@props.hiddenProducts)

  getDefaultProps: ->
    analyticsCategory: 'gallery'
    cssModifier: ''
    products: []
    useTextColors: false
    hidden: false
    hiddenProducts: ''
    productPosition: null
    imageSeenTrackingEvent: ""

  shouldComponentUpdate: (nextProps, nextState) ->
    return true if nextState.activeIndex isnt @state.activeIndex

    if _.get(@props, 'products[0].product_id') isnt _.get(nextProps, 'products[0].product_id')
      # For single-page app, check if product_id changed.
      return true

    if @props.hidden is nextProps.hidden
      return false if @props.hiddenProducts is nextProps.hiddenProducts
      return false if nextProps.hidden

    true

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-w100p
      #{@props.cssModifier}
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
      u-pr
    "
    name: "
      #{@BLOCK_CLASS}__name
      u-tac u-mla u-mra
      u-mt12 u-ml0 u-mr0 u-mb3
      u-fs20 u-fs24--1200
      u-fws u-ffs
    "
    colorName: "
      #{@BLOCK_CLASS}__color-name
      u-tac
      u-fs18 u-fs20--1200
      u-ffs u-fsi u-ttc u-color--dark-gray-alt-2
    "
    heartIcon: "
      #{@BLOCK_CLASS}__heart-icon
      u-pa u-dib u-mt10"

    colorSwatches: "
      #{@BLOCK_CLASS}__color-swatches
      u-mt12
    "

  classesWillUpdate: ->
    block:
      '-hidden': @props.hidden

  componentWillReceiveProps: (props) ->
    @setState activeIndex: @getFirstVisibleProduct(props.hiddenProducts)

  componentDidMount: ->
    unless _.isEmpty @props.imageSeenTrackingEvent
      @addScrollListener @trackIfImageSeen

  getFirstVisibleProduct: (hiddenProducts) ->
    i = 0
    i++ while hiddenProducts.indexOf(i) isnt -1
    i

  handleColorChange: (newIndex) ->
    @setState activeIndex: newIndex

  handleProductClick: (product, evt) ->
    @trackInteraction "#{@props.analyticsCategory}-clickProduct-\
      #{product.id or product.product_id}"
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      eventMetadata:
        list: @props.analyticsCategory
      products: product

  trackIfImageSeen: ->
    if @refIsInViewport(@refs.details) and not @state.imageSeen
      @trackInteraction @props.imageSeenTrackingEvent
      @setState imageSeen: true

  getProductImages: (classes) ->
    _.map @props.products, (product, i) =>
      linkProps =
        key: product.product_id
        href: "/#{product.path}"
        onClick: @handleProductClick.bind @, product
        className: [
          classes.image_link
          '-active' if i is @state.activeIndex
          '-block' if i is 0
        ].join ' '

      if product.images
        imgProps =
          cssModifier: classes.image
          alt: "#{product.display_name} in #{product.color}"
        imageSet = _.get product, 'images.clip.front'
        if imageSet
          imgProps.srcSet = imageSet.join(',')
          imgProps.src = _.first imageSet
        else if product.image_url?
          imgProps.src = product.image_url
        responsiveImage = <Img {...imgProps} />
      else if product.image
        imgProps =
          cssModifier: classes.image
          altText: "#{product.display_name} in #{product.color}"
          image: product.image
        responsiveImage = <FrameImage {...imgProps} />

      <a {...linkProps} children=responsiveImage />

  render: ->
    classes = @getClasses()
    productImages = @getProductImages(classes)

    # @props.useTextColors only supports showing one color right now, and therefore
    # implicitly disables color switching.
    <div className=classes.block>
      <div
        children={if @props.useTextColors then [_.first productImages] else productImages}
        className=classes.images_container />
      <div className=classes.details ref='details'>
        <h3 className=classes.name children=@props.products[0].display_name />
        {if @props.useTextColors
          <span className=classes.colorName children=@props.products[0].color />
        else
          <ColorSwatches
            activeFrameAssemblyIndex=@state.activeIndex
            cssModifier=classes.colorSwatches
            frameAssemblies=@props.products
            hiddenAssembiles=@props.hiddenProducts
            handleColorChange=@handleColorChange
            productPosition=@props.productPosition />}
      </div>
    </div>
