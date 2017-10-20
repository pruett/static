_ = require 'lodash'
React = require 'react/addons'
FrameImage = require 'components/molecules/products/gallery_frame_image/gallery_frame_image'
QuickAddButton = require 'components/molecules/products/quick_add_button/quick_add_button'
MessageBadge = require 'components/atoms/message_badge/message_badge'
AddToFavorites = require 'components/atoms/products/add_to_favorites/add_to_favorites'
Mixins = require 'components/mixins/mixins'

module.exports = React.createClass
  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
    Mixins.product
  ]

  getDefaultProps: ->
    analyticsCategory: ''
    canHto: true
    canFavorite: true
    cart: {}
    cssModifier: ''
    isFavorite: true
    onGrid: true
    oosMessage: ''
    product: {}
    showQuickAddTooltip: false

  getInitialState: ->
    htoInCart: @isHtoInCart(@props.cart)
    showMessageBadge: false

  shouldComponentUpdate: (nextProps, nextState) ->
    return true if @props.product.product_id isnt nextProps.product.product_id
    return true if @props.canHto isnt nextProps.canHto
    return true if @props.canFavorite isnt nextProps.canFavorite
    return true if @state.htoInCart isnt nextState.htoInCart
    return true if @state.showMessageBadge isnt nextState.showMessageBadge
    return true if @props.isFavorite isnt nextProps.isFavorite
    return true if @props.showQuickAddTooltip isnt nextProps.showQuickAddTooltip
    false

  componentWillReceiveProps: (nextProps) ->
    if _.get(@props, 'cart.hto_quantity') isnt _.get(nextProps, 'cart.hto_quantity')
      @setState htoInCart: @isHtoInCart(nextProps.cart)

  getStaticClasses: ->
    block: "
      #{@props.cssModifier}
      u-dib u-pr
      u-w12c
      u-mb60
      u-tac
    "
    imageContainer: '
      u-pr
    '
    content: '
      u-pr u-mt18
      u-ml12 u-mr12
      u-pl36 u-pr36
    '
    name: '
      u-mt0 u-mb4
      u-fs20 u-fs24--1200
      u-fws u-ffs
    '
    color: '
      u-fs16 u-fs18--1200
      u-ffs u-fsi u-color--dark-gray-alt-2
    '
    favorite: '
      u-pa u-r0 u-center-y
    '
    quickAdd: '
      u-pa u-l0 u-center-y
    '
    oosMessage: '
      u-ffss u-fs14
      u-mt18 u-mb0
      u-color--red
    '

  classesWillUpdate: ->
    block:
      'u-grid__col -col-bottom u-w6c--600 u-w4c--1200': @props.onGrid

  isHtoInCart: (cart) ->
    cartItems = _.get cart, 'items', []
    _.findIndex(cartItems, @getHtoItem()) isnt -1

  getHtoItem: ->
    product_id: @props.product.product_id
    variant_id: @props.product.hto_variant_id or @props.product.variant_id

  handleProductClick: ->
    @trackInteraction "#{@props.analyticsCategory}-clickProduct-#{@props.product.product_id}"
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      eventMetadata:
        list: @props.analyticsCategory
      products: @props.product

  handleClickAddToHto: (evt) ->
    return if @state.showMessageBadge # To prevent mashing the button

    adding = not @state.htoInCart
    if adding then @addHtoToCart() else @removeHtoFromCart()

    @setState
      htoInCart: adding and not _.get(@props, 'cart.hto_limit_reached')
      showMessageBadge: true
      messageBadgeText: @getMessageBadgeText adding

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
      @trackInteraction "#{@props.analyticsCategory}-click-htoFull"
    else
      item = @getHtoItem()
      item.added_via = @props.addedVia if @props.addedVia
      item.option_type = 'hto'
      @commandDispatcher 'cart', 'addItem', item
      @trackInteraction "#{@props.analyticsCategory}-click-hto"

  removeHtoFromCart: ->
    cartItems = _.get @props.cart, 'items', []
    item = _.find cartItems, @getHtoItem()
    if item
      item.option_type = 'hto'
      @commandDispatcher 'cart', 'removeItem', item
      @trackInteraction "#{@props.analyticsCategory}-click-removeHto"

  renderProductImage: ->
    linkProps =
      key: @props.product.product_id
      href: if @props.product.path then "/#{@props.product.path}" else @props.product.product_url
      onClick: @handleProductClick
    imgProps =
      altText: "#{@props.product.display_name or @props.product.name} in #{@getColorDisplayName @props.product}"
      image: @props.product.image or @props.product.image_url
    responsiveImage = <FrameImage {...imgProps} />

    <a {...linkProps} children=responsiveImage />

  render: ->
    classes = @getClasses()

    <div className=classes.block>

      <div className=classes.imageContainer>
        {@renderProductImage()}
        <MessageBadge
          active=@state.showMessageBadge
          text=@state.messageBadgeText />
      </div>

      <div className=classes.content>
        <div className=classes.details>
          <h3 className=classes.name children={@props.product.display_name or @props.product.name} />
          <span className=classes.color children={@getColorDisplayName @props.product} />
        </div>

        {if @props.canHto
          <QuickAddButton
            cssModifier=classes.quickAdd
            handleClick=@handleClickAddToHto
            inCart=@state.htoInCart
            showTooltip=@props.showQuickAddTooltip />}

        {if @props.canFavorite
          <AddToFavorites
            cssModifier=classes.favorite
            product_id=@props.product.product_id
            isFavorited=@props.isFavorite />}

      </div>
      {if @props.oosMessage
        <p className=classes.oosMessage children=@props.oosMessage />}
    </div>
