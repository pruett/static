# Active experiments
# photoCopy
[
  _
  React

  PopoverContainer
  PopoverContainerApplePay
  PopoverPurchase
  PopoverPurchaseApplePay
  PopoverHto
  CTA

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/popover_container/popover_container'
  require 'components/molecules/popover_container_apple_pay/popover_container_apple_pay'
  require 'components/molecules/products/popovers/purchase/purchase'
  require 'components/molecules/products/popovers/purchase_apple_pay/purchase_apple_pay'
  require 'components/molecules/products/popovers/hto/hto'
  require 'components/atoms/buttons/cta/cta'

  require 'components/mixins/mixins'

  require './add_button.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-products-add-button'

  COPY:
    header: 'Choose your lens type'
    add_to_cart:
      initial: 'Add to cart'
      success: 'Added!'
    variants:
      eyeglasses:
        rx:
          title: 'Single-vision prescription'
          description: 'For one field of vision (near or distance) or readers'
        prog_rx:
          title: 'Progressive prescription'
          description: 'For reading, distance, and in between'
      clipons:
        rx:
          title: 'Single-vision with clip-on'
          description: 'For one field of vision (near or distance) or readers'
        prog_rx:
          title: 'Progressive with clip-on'
          description: 'For reading, distance, and in between'
      sunglasses:
        non_rx:
          title: 'Sunglasses'
        rx:
          title: 'Prescription sunglasses'
          description: 'For one field of vision (near or distance)'
        prog_rx:
          title: 'Progressive prescription'
          description: 'For reading, distance, and in between'

  mixins: [
    Mixins.classes
    Mixins.context
    Mixins.conversion
    Mixins.dispatcher
    Mixins.keyEvent
  ]

  propTypes:
    addedVia:           React.PropTypes.string
    analyticsCategory:  React.PropTypes.string
    applePay:           React.PropTypes.object
    assembly_type:      React.PropTypes.string
    cart:               React.PropTypes.object
    clip_on:            React.PropTypes.bool
    color:              React.PropTypes.string
    cssModifier:        React.PropTypes.string
    display_name:       React.PropTypes.string
    eligibleForPopover: React.PropTypes.bool
    gender:             React.PropTypes.string
    handleClose:        React.PropTypes.func
    id:                 React.PropTypes.number
    size:               React.PropTypes.oneOf ['small', 'medium', 'large']
    variants:           React.PropTypes.object
    visible:            React.PropTypes.bool

  getDefaultProps: ->
    addedVia: ''
    analyticsCategory: ''
    applePay: {}
    cssModifier: 'u-pr u-dib'
    eligibleForPopover: true
    primary: false
    size: 'small'
    variantTypes:
      eyeglasses: ['rx', 'prog_rx']
      sunglasses: ['non_rx', 'rx', 'prog_rx']

  getInitialState: ->
    activePopover: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
    "
    cta: "
      #{@BLOCK_CLASS}__cta
      u-button
    "

  classesWillUpdate: ->
    buttonColor = @getButtonColor()

    cta:
      'u-cursor--default':    @state.activePopover
      '-button-small u-fs12': @props.size is 'small'
      '-button-medium
        u-fs16':              @props.size is 'medium'
      '-button-large u-fs16': @props.size is 'large'
      '-button-blue u-fwb':   buttonColor is 'blue'
      '-button-white u-fws':  buttonColor is 'white'
      '-button-gray u-fws':   buttonColor is 'gray'
      '-disabled':            not @props.visible or not @isInStock() or (
                                @isHto() and
                                @cantAddToHto() and
                                not @state.activePopover)

  componentDidMount: ->
    window.addEventListener 'keydown', @handleKeyDown

  componentWillUnmount: ->
    window.removeEventListener 'keydown', @handleKeyDown

  getButtonColor: ->
    if @state.activePopover
      'gray'
    else if @props.primary
      'blue'
    else if @isHto() and @cantAddToHto()
      'gray'
    else
      'white'

  openPopover: ->
    if @isHto() and _.includes @getExperimentVariant('htoDrawer'), 'enabled'
      if @isHtoFull()
        @commandDispatcher 'cart', 'showHtoDrawer'
      else unless @isInStock()
        @setState activePopover: true
      else
        @commandDispatcher 'cart', 'showHtoDrawer'
    else
      @setState activePopover: true
    if _.get(@props, 'applePay.isApplePayCapable') and not @isHto()
      @commandDispatcher('layout', 'showTakeover')

  closePopover: ->
    @setState activePopover: false
    if _.get(@props, 'applePay.isApplePayCapable') and not @isHto()
      @commandDispatcher('layout', 'hideTakeover')

  isInStock: ->
    _.some @getActiveVariants(), { in_stock: true, active: true }

  isHto: ->
    @props.variantTypes is 'hto'

  getActiveVariants: ->
    if @isHto()
      _.pick @props.variants, 'hto'
    else
      _.pick @props.variants, _.get(@props.variantTypes, @props.assembly_type, [])

  findInStockVariant: (variant) ->
    _.get @props.variants, "#{variant}.in_stock"

  getInitialSelectedVariant: ->
    variantTypes = _.get @props.variantTypes, @props.assembly_type, []
    _.find variantTypes, @findInStockVariant

  getProductVariant: (variantType) ->
    variant_id = _.get @props.variants, "#{variantType}.variant_id"

    product_id: @props.id
    variant_id: variant_id

  isInCart: (variantType) ->
    items = _.get @props.cart, 'items', []
    _.findIndex(items, @getProductVariant(variantType)) isnt -1

  isHtoFull: ->
    _.get @props.cart, 'hto_limit_reached', false

  cantAddToHto: ->
    not @isInStock() or @isInCart('hto') or @isHtoFull()

  manageAddItem: (attrs) ->
    if @props.addedVia
      attrs.added_via = @props.addedVia
    if @isHto()
      attrs.option_type = 'hto'
    @commandDispatcher 'cart', 'addItem', attrs

  manageApplePay: (attrs) ->
    @commandDispatcher 'applePay', 'checkout', 'frameProduct', attrs

  manageRemoveItem: (attrs) ->
    @commandDispatcher 'cart', 'removeItem', attrs

  getPopoverProps: ->
    popoverProps = _.omit @props, 'size', 'variants', 'variantTypes'
    popoverProps['variants'] = @getActiveVariants()
    popoverProps['handleClose'] = @closePopover
    popoverProps

  handleEscapeKey: (evt) ->
    if @state.activePopover
      @closePopover()

  handleCtaClick: ->
    # Skip popover action if handler passed down.
    return @props.handleCtaClick() if @props.handleCtaClick

    isUS = (@getLocale()).country is 'US'
    unless @isHto()
      if isUS
        @commandDispatcher('experiments', 'bucket', 'photoCopy')
      @openPopover()
    else
      if @state.activePopover
        @closePopover()
      else
        unless @cantAddToHto()
          @manageAddItem(
            @getProductVariant 'hto'
            if _.get(@props.cart, 'hto_quantity_remaining') is 1 then '/cart' else false
          )
        @bucketQuizLinkTest()
        @openPopover()

  bucketQuizLinkTest: ->
    if (
      @requestDispatcher('cookies', 'get', 'hasQuizResults') and
      _.get(@props.cart, 'hto_quantity_remaining') > 1 and
      not @isInCart 'hto'
    )
      @commandDispatcher 'experiments', 'bucket', 'linkPdpToQuizResults'

  getCtaText: ->
    if @isHto()
      if @isHtoFull() and @isInStock()
        'Home Try-On is full'
      else if @isInCart 'hto'
        'In your Home Try-On'
      else
        'Try at home for free'
    else
      if not @props.visible or not @isInStock()
        'Out of stock'
      else if @props.text
        @props.text
      else
        lowestVariant = _.minBy @getActiveVariants(), 'price_cents'
        lowestPrice = _.get lowestVariant, 'price_cents'
        if isNaN(lowestPrice)
          'Add to cart' # Default to non-price text if invalid price
        else
          "Buy from $#{parseInt @convert('cents', 'dollars', lowestPrice)}"

  getCtaSlug: ->
    if @isHto()
      if @isHtoFull() and @isInStock()
        'click-htoFull'
      else if @isInCart 'hto'
        'click-htoInCart'
      else if @cantAddToHto()
        'click-htoOutOfStock'
      else
        'click-hto'
    else
      if @props.visible and @isInStock()
        'click-buyNow'
      else
        'click-buyNowOutOfStock'

  renderPopoverContents: ->
    if @isHto()
      # Render HTO Button.
      <PopoverHto key='hto'
        {...@getPopoverProps()}
        copy=@COPY
        manageRemoveItem=@manageRemoveItem />
    else
      # Render Add to cart button.
      <PopoverPurchase key='purchase'
        {...@getPopoverProps()}
        copy=@COPY
        version={if @props.text then 2 else 1}
        initialSelectedVariant={@getInitialSelectedVariant()}
        manageAddItem=@manageAddItem />

  renderPopover: ->
    if @props.eligibleForPopover and @isInStock() and not @isHto()
      # Render ApplePay button, if in stock and not HTO.
      <PopoverContainerApplePay
        key='apple'
        applePay=@props.applePay
        analyticsCategory=@props.analyticsCategory
        handleClose=@closePopover>
          <PopoverPurchaseApplePay {...@getPopoverProps()}
            initialSelectedVariant={@getInitialSelectedVariant()}
            showApplePayButton={_.get(@props, 'applePay.isApplePayCapable')}
            manageAddItem=@manageAddItem
            manageApplePay=@manageApplePay />
      </PopoverContainerApplePay>
    else
      <PopoverContainer key='v2'
        isHto=@isHto()
        handleClose=@closePopover
        children=@renderPopoverContents() />

  render: ->
    classes = @getClasses()
    id = "pdp__button--open-#{if @isHto() then 'hto' else 'purchase'}-popover"

    <div className=classes.block>
      <ReactCSSTransitionGroup
        transitionName='-transition'
        transitionAppear=true
        children={@renderPopover() if @state.activePopover} />
      <CTA
        analyticsSlug="#{@props.analyticsCategory}-#{@getCtaSlug()}"
        type='button'
        tagName='button'
        children=@getCtaText()
        onClick=@handleCtaClick
        cssModifier=classes.cta
        id=id
        variation='minimal' />
    </div>
