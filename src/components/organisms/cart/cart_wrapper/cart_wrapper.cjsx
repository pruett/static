[
  _
  React

  Alert

  CloseButton
  CTA
  LowBridgeWarning

  CartFooter
  CheckoutButtons

  CartSubgroup

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/alert/alert'

  require 'components/atoms/buttons/close/close'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/icons/low_bridge_warning/low_bridge_warning'

  require 'components/molecules/cart/cart_footer/cart_footer'
  require 'components/molecules/cart/checkout_buttons/checkout_buttons'

  require 'components/organisms/cart/cart_subgroup/cart_subgroup'

  require 'components/mixins/mixins'

  require './cart_wrapper.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-cart-wrapper'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
  ]

  getDefaultProps: ->
    manageRemoveItem: ->
    manageFillHomeTryOn: ->
    cms: {}
    cart:
      items: []
      lastGalleryUrl: '/'
      hasMultipleFits: false
      outOfStockCount: 0
      htoQuantity: 0
      htoLimit: 5

  getFooterTopContent: (disabled) ->
    if _.get(@props, 'cart.items.length', 0) > 4
      <CheckoutButtons
        applePay=@props.applePay
        cssModifier='-footer'
        disabled=disabled />
    else
      null

  getFooterBottomContent: (classes = {}) ->
    cms = @props.cms or {}
    [
      unless _.isEmpty cms.cta_continue
        <CTA
          analyticsSlug=cms.cta_continue_slug
          children=cms.cta_continue
          cssModifier=classes.cta
          href=@props.cart.lastGalleryUrl
          tagName='a'
          key='shopFrames'
          variation='secondary' />

      unless _.isEmpty cms.cta_secondary
        if cms.cta_secondary_route is '/gift-card' and @getFeature('giftCards')
          <CTA
            analyticsSlug=cms.cta_secondary_slug
            children=cms.cta_secondary
            cssModifier=classes.cta
            href=cms.cta_secondary_route
            tagName='a'
            key='secondary'
            variation='secondary' />
    ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-template__main-content
      "
    cartLabel: "
      #{@BLOCK_CLASS}__cart-label
      u-reset u-fs20 u-ffs u-fws
      "
    cartNote: "
      #{@BLOCK_CLASS}__cart-note
      u-reset u-fs16 u-ffs u-fsi
      "
    cartNoteSecondary: 'u-fr u-reset u-fs16 u-ffss'
    footer: "
      #{@BLOCK_CLASS}__footer
      "
    footerHeading: "
      #{@BLOCK_CLASS}__footer-heading
      u-reset u-fs20 u-ffs u-fws
      "
    footerSubheading: 'u-mt48 u-mb24 u-fs16 u-ffs'
    header: 'u-tac u-mln18 u-mrn18
      u-bss u-bw1 u-blw0 u-brw0 u-bc--light-gray
      u-color-bg--light-gray-alt-2
      u-p24 u-pb48
      '
    heading: 'u-mt24 u-fs24 u-ffs u-fws'
    headingMessage: "
      #{@BLOCK_CLASS}__heading-message
      u-mla u-mra u-mt12 u-mb30
      u-fs16 u-ffss u-color--dark-gray-alt-3
    "
    lowBridgeWarningContainer: 'u-mw960 u-m0a'
    lowBridgeWarningCopy: 'u-grid__col -col-middle u-w12c u-w10c--600 u-tac u-tal--600 u-ffss u-fs16'
    lowBridgeWarningIcon: 'u-fill--dark-gray'
    lowBridgeWarningIconContainer: "#{@BLOCK_CLASS}__low-bridge-icon u-m0a"
    lowBridgeWarningIconGrid: 'u-grid__col -col-middle u-tal u-w12c u-w2c--600'
    lowBridgeWarningSection: 'u-grid__row u-tac u-pt18 u-pb18 u-bbss u-bbw1 u-bc--light-gray'
    oonLink: 'u-fws u-dib u-ml6 u-mr6 u-link--hover'
    oonMessaging: 'u-mw960 u-fs14 u-p12 u-mt18 u-mla u-mra u-bss u-bw1 u-bc--light-gray u-tac u-lh20'
    oonTitle: 'u-fws'
    subheading: "
      #{@BLOCK_CLASS}__subheading
      u-fs14 u-mt18 u-ffs u-fsi
      u-color--dark-gray-alt-3
      "
    subtotal: "
      #{@BLOCK_CLASS}__subtotal
      u-fs24 u-ffs u-fwn
      "
    cta: "
      #{@BLOCK_CLASS}__cta
      -cta-pair -margin"
    applePayPromo: "
      #{@BLOCK_CLASS}__apple-pay-promo
      u-mb0 u-fs14 u-mla u-mra
    "
    banner: "
      #{@BLOCK_CLASS}__banner
      u-mln24 u-mrn24 u-mtn24 u-mb48
      u-p12 u-pl0--600 u-pr0--600
      u-bss u-bw1 u-blw0 u-brw0
    "
    bannerIcon: "
      #{@BLOCK_CLASS}__banner-icon
      u-icon u-fill--red
      u-mb6 u-mb0--600 u-mt2--600 u-mr12--600
    "
    bannerCopy: '
      u-dib--600 u-m0
    '
    bannerCta: "
      #{@BLOCK_CLASS}__banner-cta
      u-button-reset
      u-fs16 u-fws u-color--blue
      u-ml6--600
    "

  classesWillUpdate: ->
    header:
      'u-btw0': _.get @props, 'cart.outOfStockCount'
    oonMessaging:
      'u-dn': _.get @props, 'cart.hasMultipleFits'

  shouldShowOonMessaging: ->
    _.includes ['showCart', 'showBoth'], @getExperimentVariant('oonMessaging')

  handleClickRemoveUnavailable: (evt) ->
    @trackInteraction 'cart-click-removeUnavailable'
    @commandDispatcher 'cart', 'removeUnavailableItems'

  handleClickFSA: (evt) ->
    @trackInteraction 'cart-click-learnFsaHsa'

  handleClickReimbursement: (evt) ->
    @trackInteraction 'cart-click-learnReimbursement'

  renderApplePayPromo: (modifiers) ->
    classes = "#{@getClasses().applePayPromo} #{modifiers}"
    copy = _.get @props, 'cms.apple_pay_promo.copy', ''

    <p className=classes
      children=copy />

  renderOutOfStockBanner: (classes = {}) ->
    count = _.get @props, 'cart.outOfStockCount'
    itemString = if count is 1 then 'an item' else "#{count} items"
    oosString = "You have #{itemString} in your cart that
                 #{if count is 1 then 'is' else 'are'} out of stock."
    ctaString = "Remove unavailable item#{if count is 1 then '' else 's'}"

    <div className=classes.banner>
      <Alert cssUtility=classes.bannerIcon />
      <p className=classes.bannerCopy children=oosString />
      <button
        className=classes.bannerCta
        children=ctaString
        onClick=@handleClickRemoveUnavailable />
    </div>

  render: ->
    classes = @getClasses()
    cart = @props.cart or {}
    cms = @props.cms or {}

    applePayPromoEligible = _.get(cms, 'apple_pay_promo.show', false) and
        _.get(@props, 'applePay.isApplePayCapable', false) and
        cart.htoQuantity is 0

    return null unless cart.__fetched

    openHTOSlotCount = cart.htoLimit - cart.htoQuantity

    itemsInCart = cart.items
    itemQuantity =
      if not itemsInCart or itemsInCart.length is 0
        0
      else
        itemsInCart.reduce (acc, item) ->
          acc + item.qty
        , 0

    displaySubtotal = "$#{(cart.subtotal / 100).toFixed(2)}"

    htoMessaging = false

    if cart.purchaseItemQuantity
      cartHeadline = "You have #{itemQuantity} item#{if itemQuantity > 1 then 's' else ''}
        in your cart"
    else if cart.htoQuantity
      cartHeadline = "You have #{cart.htoQuantity}
        Home Try-On frame#{if cart.htoQuantity > 1 then 's' else ''} in your cart"
      htoMessaging = @inExperiment 'cartHtoMessaging', 'enabled'

    # The HTO and purchase carts simply take the unaltered cart object and figure out
    # internally which line items in it to show (and whether the cart should show up at all).
    <div className=classes.block>
      {if itemQuantity
        <div className=classes.header>

          {@renderOutOfStockBanner(classes) if cart.outOfStockCount}

          {if cart.purchaseItemQuantity > 1
            <div className=classes.heading>
              <span children="#{cartHeadline}: " />
              <span children=displaySubtotal className=classes.subtotal />
            </div>
          else
            <div children=cartHeadline className=classes.heading />}

          {if htoMessaging
            <p
              className=classes.headingMessage
              children='Try before you buy! We’ll mail you 5 frames for free. Take ’em for a spin
                        and send ’em back after 5 days. (Return shipping is also covered.)' />}

          {@renderApplePayPromo('u-dn u-dib--900') if applePayPromoEligible}

          <CheckoutButtons
            applePay=@props.applePay
            ctaCopy={if htoMessaging then 'Start my free trial' else 'Checkout'}
            disabled={cart.outOfStockCount > 0} />

          {@renderApplePayPromo('u-dn--900') if applePayPromoEligible}

          {unless htoMessaging
            <div
              children=cms.note_shipping
              className=classes.subheading />}
        </div>}

      {if cart.hasMultipleFits
        <div className=classes.lowBridgeWarningContainer>
          <div className=classes.lowBridgeWarningSection>

            <div className=classes.lowBridgeWarningIconGrid>
              <div className=classes.lowBridgeWarningIconContainer>
                <LowBridgeWarning cssUtility=classes.lowBridgeWarningIcon />
              </div>
            </div>

            <div
              className=classes.lowBridgeWarningCopy
              children='You’ve added frames with different nose bridge fits–a feature that greatly
                        impacts your comfort—to your cart. If you didn’t mean to select these, totally cool.
                        It’s not too late to make any changes to your order.' />

          </div>
        </div>}

      {if @shouldShowOonMessaging() and cart.hasRx
        <div className=classes.oonMessaging>
          <span className=classes.oonTitle children='Save on your prescription frames! ' />
          <span children='You can pay with an' />
          <a className=classes.oonLink
            onClick=@handleClickFSA
            href='/flexible-spending-accounts' target='_blank' children='FSA or HSA' />
          <span children='card at checkout, or apply for' />
          <a className=classes.oonLink
            onClick=@handleClickReimbursement
            href='/insurance' target='_blank' children='insurance reimbursement' />
          <span children='after purchasing.' />
        </div>}

      <CartSubgroup {...@props} cartType='purchase' />

      {if cart.htoQuantity > 0
        <CartSubgroup {...@props} cartType='hto'>
          <div children=cms.note_hto className=classes.cartNoteSecondary />
          <h3 children=cms.label_hto className=classes.cartLabel />
          <div
            children="#{cart.htoQuantity} of #{cart.htoLimit} frames chosen"
            className=classes.cartNote />
        </CartSubgroup>}

      {if itemQuantity
        <CartFooter
          bottomContent=@getFooterBottomContent(classes)
          showSubtotal={itemQuantity > 1}
          subheading=cms.subheading
          subtotal=displaySubtotal
          topContent={@getFooterTopContent(cart.outOfStockCount)} />}
    </div>
