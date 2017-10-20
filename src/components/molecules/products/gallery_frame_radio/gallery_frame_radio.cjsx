[
  _
  React

  FrameImage
  QuickAddButton
  Link
  MessageBadge
  AddToFavorites
  GalleryCallout
  ProductSchema
  ImageObjectSchema

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/products/gallery_frame_image/gallery_frame_image'
  require 'components/molecules/products/quick_add_button/quick_add_button'
  require 'components/atoms/link/link'
  require 'components/atoms/message_badge/message_badge'
  require 'components/atoms/products/add_to_favorites/add_to_favorites'
  require 'components/atoms/products/gallery_callout/gallery_callout'
  require 'components/atoms/structured_data/product/product'
  require 'components/atoms/structured_data/image_object/image_object'

  require 'components/mixins/mixins'

  require './gallery_frame_radio.scss'
  require '../gallery_frame/gallery_frame.scss'
  require '../color_swatches/color_swatches.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-gallery-frame-radio'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
    Mixins.scrolling
  ]

  getInitialState: ->
    activeIndex = @getFirstVisibleProduct @props.hiddenProducts

    activeIndex: activeIndex
    inView: @props.productPosition < 10
    htoInCart: @isHtoInCart @props.cart, activeIndex
    showMessageBadge: false

  getDefaultProps: ->
    addedVia: 'plp-quick-add'
    analyticsCategory: 'gallery'
    atcAnalyticsCategory: 'addButtonsPlpQuick'
    cssModifier: ''
    defaultImages:
      optical: '//i.warbycdn.com/v/c/assets/gallery/image/placeholder-optical/3/19610096e7.jpg'
      sun: '//i.warbycdn.com/v/c/assets/gallery/image/placeholder-sun/2/2b4f45a631.jpg'
    hiddenProducts: ''
    firstFrame: false
    maxFrameWidth: 0
    productPosition: null
    products: []
    showHtoQuickAdd: false
    showFavorites: false
    smallSwatch: false
    isLowBridgeFit: false

  shouldComponentUpdate: (nextProps, nextState) ->
    return true if nextState.activeIndex isnt @state.activeIndex
    return true if nextState.inView isnt @state.inView
    return true if nextState.htoInCart isnt @state.htoInCart
    return true if nextState.showMessageBadge isnt @state.showMessageBadge
    return true if nextProps.showFavorites isnt @props.showFavorites
    return true if nextProps.showHtoQuickAdd isnt @props.showHtoQuickAdd

    if !!@props.index is !!nextProps.index
      if _.size(nextProps.favorites) isnt _.size(@props.favorites)
        favoriteDidChange = _.some @props.products, (prod) =>
          @props.favorites.indexOf(prod.product_id) isnt nextProps.favorites.indexOf(prod.product_id)
        return true if favoriteDidChange
      return false if @props.hiddenProducts is nextProps.hiddenProducts
      return false if not nextProps.index
    true

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-reset
      u-grid__col
      u-w12c u-w6c--600 u-w4c--1200
      u-mb78 u-mb66--600 u-mb90--900 u-mb78--1200
      u-tac
      u-pr
      u-dib
    "
    images: "
      #{@BLOCK_CLASS}__images
      u-pr
    "
    imageLink: "
      #{@BLOCK_CLASS}__image-link
      u-vh
      u-db
    "
    image: '
      u-w100p
      u-pr6--600 u-pl6--600 u-pr36--900 u-pl36--900 u-pr6--1200 u-pl6--1200
    '
    name: '
      u-ffs u-fws
      u-fs22 u-fs24--600
      u-mb6
    '
    swatchRow: "
      #{@BLOCK_CLASS}__swatch-row
      u-pr
      u-ml18 u-ml12--600 u-ml36--900 u-ml24--1200
      u-mr18 u-mr12--600 u-mr36--900 u-mr24--1200
      u-pl30 u-pr30
    "
    favorite: '
      u-pa u-r0 u-center-y
    '
    quickAdd: '
      u-pa u-l0 u-center-y
    '
    lbfWrapper: '
      u-pa u-center-x
    '
    lbfLabel: '
      u-reset u-fws u-ffss
      u-fs12 u-ls2_5
      u-color--dark-gray-alt-3
      u-mt18
    '
    swatch: 'c-color-swatches'

  classesWillUpdate: ->
    block:
      '-hidden': !@props.index
    name:
      'u-mt30': !@props.isLowBridgeFit
      'u-mt42': @props.isLowBridgeFit

  componentWillReceiveProps: (props) ->
    # We only want to perform the following setState if it's
    # a result of filtering (i.e. affecting hiddenProducts),
    # or the cart updating
    newIndex = @getFirstVisibleProduct props.hiddenProducts
    wasInCart = @isHtoInCart @props.cart, @state.activeIndex
    isInCart = @isHtoInCart props.cart, newIndex

    if newIndex isnt @state.activeIndex or wasInCart isnt isInCart
      @setState
        activeIndex: newIndex
        htoInCart: isInCart

  componentDidMount: ->
    return unless window?
    @throttledElementInView = _.throttle @handleElementInView, 100
    window.addEventListener 'scroll', @throttledElementInView
    @handleElementInView()

  componentWillUnmount: ->
    window.removeEventListener 'scroll', @throttledElementInView

  handleElementInView: ->
    if @elementIsInViewport React.findDOMNode(@), 1.5
      @setState inView: true
      window.removeEventListener 'scroll', @throttledElementInView

  getActiveColorProductId: ->
    _.get @props.products[@state.activeIndex], 'product_id'

  isActiveColorFavorited: ->
    @props.favorites.indexOf(@getActiveColorProductId()) > -1

  isHtoInCart: (cart, activeIndex) ->
    product = @props.products[activeIndex]
    return false unless _.get product, 'hto_variant_id'

    cartItems = _.get cart, 'items', []
    _.findIndex(cartItems, @getHtoItem product) isnt -1

  getHtoItem: (product) ->
    product_id: product.product_id
    variant_id: product.hto_variant_id

  getFirstVisibleProduct: (hiddenProducts) ->
    i = 0
    i++ while hiddenProducts.indexOf(i) isnt -1
    i

  calculateFramePadding: (width) ->
    return 0 if not width or not @props.maxFrameWidth
    paddingRatio = width / @props.maxFrameWidth
    paddingPercent = 100 * (1 - paddingRatio) / 2
    "0 #{paddingPercent.toFixed(2)}%"

  handleClickSwatch: (newIndex, product, evt) ->
    @setState
      activeIndex: newIndex
      htoInCart: @isHtoInCart @props.cart, newIndex

    visibleIndex = @getVisibleIndex newIndex

    impressionProduct = if _.isFinite(@props.productPosition)
        _.assign {}, product, position: @props.productPosition
      else
        product
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productImpression'
      products: [impressionProduct]
    @trackInteraction "colorSwatch-click-#{product.product_id}-pos#{visibleIndex}", evt

  getVisibleIndex: (i) ->
    index = i + 1
    _.map @props.hiddenProducts.split(''), (h) -> index-- if parseInt(h) < i
    index

  handleClickAddToHto: (evt) ->
    return if @state.showMessageBadge # To prevent mashing the button

    adding = not @state.htoInCart
    if adding then @addHtoToCart() else @removeHtoFromCart()
    showBadge = not (
      adding and
      not @props.cart.hto_limit_reached and
      _.includes @getExperimentVariant('htoDrawer'), 'enabled'
    )

    @setState
      htoInCart: adding and not _.get(@props, 'cart.hto_limit_reached')
      showMessageBadge: showBadge
      messageBadgeText: @getMessageBadgeText adding
    if showBadge
      setTimeout @hideMessageBadge, if adding then 3000 else 2000

  hideMessageBadge: ->
   @setState showMessageBadge: false

  getMessageBadgeText: (adding) ->
    cart = @props.cart or {}
    if adding
      if cart.hto_limit_reached
        'Your Home Try-On is full'
      else
        "Added to your Home Try-On! (#{_.get(cart, 'hto_quantity', 0) + 1} of 5)"
    else
      'Poof! Removed from your Home Try-On'

  addHtoToCart: ->
    cart = @props.cart or {}
    if cart.hto_limit_reached
      @trackInteraction "#{@props.atcAnalyticsCategory}-click-htoFull"
    else
      item = @getHtoItem @props.products[@state.activeIndex]
      item.added_via = @props.addedVia
      item.option_type = 'hto'
      @commandDispatcher 'cart', 'addItem', item
      @trackInteraction "#{@props.atcAnalyticsCategory}-click-hto"

  removeHtoFromCart: ->
    cartItems = _.get @props.cart, 'items', []
    item = _.find cartItems, @getHtoItem(@props.products[@state.activeIndex])
    if item
      item.option_type = 'hto'
      @commandDispatcher 'cart', 'removeItem', item
      @trackInteraction "#{@props.atcAnalyticsCategory}-click-removeHto"

  handleKeyPressLabel: (newIndex, product, evt) ->
    if evt.key is 'Enter'
      @handleClickSwatch newIndex, product, evt

  handleClickProduct: (product, evt) ->
    id = product.id or product.product_id
    analyticsList = 'PLP'
    analyticsListFragments = _.get(product, 'path', '').split('/').slice 0, 2
    if analyticsListFragments.length is 2
      valueMap =
        eyeglasses: 'optical'
        men: 'mens'
        sunglasses: 'sunwear'
        women: 'womens'
      analyticsList = _.compact([
        analyticsList,
        valueMap[analyticsListFragments[1]],
        valueMap[analyticsListFragments[0]]
      ]).join '_'

    slug = "#{@props.analyticsCategory}-clickProduct-#{id}"
    # If frame is featured, add state to the slug
    if _.some(@props.products, {'gallery_feature': true})
      slug = "#{slug}-featured"

    @trackInteraction slug, evt
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      eventMetadata:
        list: analyticsList
      products: product

  renderProductImage: (product, i) ->
    linkProps =
      href: "/#{product.path}"
      onClick: @handleClickProduct.bind @, product
      style:
        padding: @calculateFramePadding product.width
      className: [
        @classes.imageLink
        "#{@BLOCK_CLASS}__image-link--#{i}"
        'u-pr u-w100p' if i is 0
        'u-pa u-t0 u-l0' if i isnt 0
      ].join ' '

    altText = "#{product.display_name} in #{product.color}"
    imageUrl = product.image

    if i is @state.activeIndex or @state.inView
      img =
        <FrameImage
          cssModifier=@classes.image
          image=imageUrl
          altText=altText />
    else
      cat = if product.list.indexOf('optical') > -1 then 'optical' else 'sun'
      imageUrl = @props.defaultImages[cat]
      img =
        <img
          className=@classes.image
          src=imageUrl
          alt=altText />

    <div key=product.product_id>
      <Link {...linkProps} children=img />
      <ImageObjectSchema contentUrl={imageUrl} description={altText} />
    </div>

  renderSwatchInput: (product, i) ->
    <input
      key="input-#{product.product_id}"
      id="swatch-#{product.product_id}"
      type='radio'
      className="#{@classes.swatch}__input #{@classes.swatch}__input-#{i}"
      name="swatches-#{product.display_name}"
      checked={i is @state.activeIndex}
      onChange={@handleClickSwatch.bind @, i, product} />

  renderSwatchLabel: (product, i) ->
    labelProps =
      key: "label-#{product.product_id}"
      htmlFor: "swatch-#{product.product_id}"
      className: [
        "#{@classes.swatch}__swatch"
        "#{@classes.swatch}__label-#{i}"
        "-#{_.kebabCase _.last _.keys product.attributes.color}"
        '-hidden' if @props.hiddenProducts.indexOf(i) isnt -1
        '-small' if @props.smallSwatch
      ].join ' '
      onKeyPress: @handleKeyPressLabel.bind @, i, product
      tabIndex: 0
      title: product.color
    if @state.inView and product.swatch_url
      labelProps.style = backgroundImage: "url(#{product.swatch_url})"

    <label {...labelProps}>
      <span className="u-hide--visual">
        {"Toggle #{product.color}"}
      </span>
    </label>

  showCallout: ->
    _.some @props.products, 'gallery_feature': true

  render: ->
    @classes = @getClasses()
    name = @props.products[0].display_name

    <fieldset className=@classes.block>
      <legend className="u-hide--visual">{"Toggle #{name} swatches"}</legend>
      {<GalleryCallout /> if @showCallout()}

      { _.map @props.products, @renderSwatchInput }

      <div className=@classes.images>
        { _.map @props.products, @renderProductImage }
        <MessageBadge
          active=@state.showMessageBadge
          text=@state.messageBadgeText />
      </div>

      {
        if @props.isLowBridgeFit
          <div className=@classes.lbfWrapper>
            <h3 className=@classes.lbfLabel children='LOW BRIDGE FIT' />
          </div>
      }
      <h2 className=@classes.name children=name />

      <div className=@classes.swatchRow>
        {if @props.showHtoQuickAdd
          <QuickAddButton
            cssModifier=@classes.quickAdd
            handleClick=@handleClickAddToHto
            inCart=@state.htoInCart
            showTooltip=@props.firstFrame />}

        { _.map @props.products, @renderSwatchLabel }

        {if @props.showFavorites
          <AddToFavorites
            cssModifier=@classes.favorite
            product_id=@getActiveColorProductId()
            isFavorited=@isActiveColorFavorited() />}
      </div>

      <ProductSchema product={@props.products[0]} colors={@props.products} />
    </fieldset>
