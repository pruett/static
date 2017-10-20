# Active experiments
# photoCopy

[
  _
  React

  Checkmark
  UpsellCheckbox
  CTA
  Radio
  Picture

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/checkmark/checkmark'
  require 'components/atoms/forms/upsell_checkbox/upsell_checkbox'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/radio/radio'
  require 'components/atoms/images/picture/picture'


  require 'components/mixins/mixins'

  require './purchase_apple_pay.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

COPY =
  header: 'Select prescription type'
  add_to_cart:
    initial: 'Add to cart'
    upsells: 'Add to cart:'
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
  upsellHeader:
    responsive: 'Light-responsive lenses'
    transition: 'Transitions'


module.exports = React.createClass
  BLOCK_CLASS: 'c-product-popover-purchase-apple-pay'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.conversion
    Mixins.image
  ]

  propTypes:
    analyticsCategory:                   React.PropTypes.string
    assembly_type:                       React.PropTypes.string
    clip_on:                             React.PropTypes.bool
    gender:                              React.PropTypes.string
    handleClose:                         React.PropTypes.func
    id:                                  React.PropTypes.number
    initialSelectedVariant:              React.PropTypes.string
    manageAddItem:                       React.PropTypes.func
    manageApplePay:                      React.PropTypes.func
    showApplePayButton:                  React.PropTypes.bool
    variants:                            React.PropTypes.object
    visible:                             React.PropTypes.bool
    photoEnabled:                        React.PropTypes.bool
    photoVariant:                        React.PropTypes.string

  getDefaultProps: ->
    manageApplePay: ->
    manageAddItem: ->
    showApplePayButton: true
    photoEnabled: false
    photoVariant: ''

  getInitialState: ->
    variantType: @props.initialSelectedVariant
    addingToCart: false
    upsellVariant: null
    upsellPrice: null
    upsell: null

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-tac u-mr18 u-ml18
    "
    header: '
      u-reset u-ffss u-fws u-fs16 u-fs20--900 u-color--white
      u-mb12 u-mb24--900
    '
    fieldset: "
      #{@BLOCK_CLASS}__fieldset
      u-reset u-tal u-oh u-mb24
    "
    label:'
      u-pr
    '
    select: "
      #{@BLOCK_CLASS}-variant__select
      u-color-bg--white u-100p u-db u-pt24 u-pb24 u-pl36 u-pr24
      u-bbss u-bw0 u-bbw1 u-bc--light-gray-alt-1 u-pr
      u-cursor--pointer
      u-pl42--900
    "
    radio: "
      #{@BLOCK_CLASS}-variant__radio
      u-hide--visual
    "
    dot: "
      #{@BLOCK_CLASS}-variant__dot
      u-pa u-mt30 u-ml10 u-ml18--600 u-t0 u-l0 u-db
      u-color-bg--light-gray-alt-1
    "
    variant: '
      u-db u-fws u-mb3
      u-fs16 u-fs18--600 u-fs20--900
    '
    price: '
      u-fws u-fr
      u-fs16 u-fs18--600 u-fs20--900
    '
    description: '
      u-db
      u-pr48
      u-fs14 u-fs16--600 u-fs18--900
      u-color--dark-gray-alt-1
    '
    addButton: "
      #{@BLOCK_CLASS}__btn
      u-button -button-blue
      u-fs16
      u-fs20--600 u-fwb
      u-mb12 u-mr12
      u-w6c
    "
    applePayButton: "
      #{@BLOCK_CLASS}__btn -apple-pay
      u-reset
      u-color-bg--white
      u-vam
      u-fs16 u-fws
      u-mb12
      u-w6c
      u-pr
      u-oh
      u-mw100p
    "
    picture: "
      #{@BLOCK_CLASS}__picture
      u-pa u-t50p u-l50p
      u-ttn50n50
    "
    img: '
      u-db u-ma
    '
    upsellHeader: '
      u-tac
      u-fs16 u-fs20--900
      u-color--white
      u-fws
      u-mb12 u-mb24--900
    '
    upsellContainer: "
      #{@BLOCK_CLASS}__upsell-container
      u-tac u-color-bg--white u-mb12
    "
    ATCPrice: "
      #{@BLOCK_CLASS}__atc-price
      u-fs16 u-fs20--600
      u-color--white
      u-fws
      u-pa
    "
    ctaTextUpsell: "
      #{@BLOCK_CLASS}__cta-text--upsell
      u-pr
    "

  classesWillUpdate: ->
    ctaText:
      'u-dn': @state.addingToCart
    ATCPrice:
      'u-dn': @state.addingToCart or @props.showApplePayButton
    addButton:
      '-full-width': not @props.showApplePayButton
      '-rounded': @props.showApplePayButton
    fieldset:
      '-rounded': @props.showApplePayButton
    applePayButton:
      '-rounded': @props.showApplePayButton
    upsellContainer:
      '-rounded': @props.showApplePayButton
    ctaTextUpsell:
      '-show-price': not @props.showApplePayButton

  handleChangeOption: (evt) ->
    value = evt.target.value
    @setState variantType: value
    @setState upsellVariant: null
    @trackInteraction @getAnalyticsSlug("variantOption-#{value}"), evt

    if _.isFunction @props.manageChangeSelectedVariantType
      # Stopgap to allow variant images to change on PDPs.
      _.defer => @props.manageChangeSelectedVariantType value

  handleAddItem: ->
    unless @state.addingToCart
      @setState addingToCart: true
      if not @state.upsellVariant
        @props.manageAddItem @getItemIds()
      else
        @props.manageAddItem @getUpsellIds()

  handleApplePay: (evt) ->
    if not @state.upsellVariant
      slug = "variantOption-#{@state.variantType}"
      @trackInteraction @getAnalyticsSlug(slug, 'applePayClick'), evt
      @props.manageApplePay(
        product_id: @props.id
        variant: _.get @props.variants, @state.variantType
        hto_in_stock: @getHtoVariantStockStatus()
      )
    else
      slug = "variantOption-#{@state.variantType}-Photo"
      @trackInteraction @getAnalyticsSlug(slug, 'applePayClick'), evt
      @props.manageApplePay(
        product_id: @props.id
        variant: @state.upsell
        hto_in_stock: @getHtoVariantStockStatus()
      )

  getAnalyticsSlug: (target, action = 'click', upsellModifier = '') ->
    target = "#{_.camelCase(target)}#{_.camelCase(upsellModifier)}" if @state.upsellVariant

    "#{@props.analyticsCategory}-#{action}-#{_.camelCase(target)}"


  getUpsellIds: ->
    product_id: @props.id
    variant_id: @state.upsellVariant
    hto_in_stock: @getHtoVariantStockStatus()

  getItemIds: ->
    product_id: @props.id
    variant_id: _.get @props.variants, "#{@state.variantType}.variant_id"
    hto_in_stock: @getHtoVariantStockStatus()

  getHtoVariantStockStatus: ->
    _.get @props.variants, 'hto.in_stock', false

  getVariantCopy: (variant) ->
    assembly = if @props.clip_on then 'clipons' else @props.assembly_type
    _.get COPY, "variants.#{assembly}.#{variant}", {}

  getGalleryUrl: ->
    genderDir = switch @props.gender
      when 'f'
        'women'
      when 'm'
        'men'

    if @props.assembly_type and genderDir
      "/#{@props.assembly_type}/#{genderDir}"
    else
      '/'

  getPictureAttrs: (klass) ->
    sources: [
      url: '//i.warbycdn.com/v/c/assets/apple-pay/image/apple-pay-white-tablet/1/8118c4e495.jpg'
      quality: 90
      widths: [ 180, 270, 360 ]
      sizes: '180px'
      mediaQuery: '(min-width: 600px)'
    ,
      url: '//i.warbycdn.com/v/c/assets/apple-pay/image/apple-pay-white-mobile/1/a5f6c1a7b7.jpg'
      quality: 90
      widths: [ 140, 210, 280 ]
      sizes: '140px'
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'ApplePay'
      className: klass

  manageCheckboxToggle: (variant) ->
    if not @state.upsellVariant
      @setState upsellVariant: variant.variant_id, upsellPrice: variant.price_cents, upsell: variant
      @trackInteraction "addButtonPdp-check-#{@state.variantType}_photo"

    else if @state.upsellVariant
      @setState upsellVariant: null, upsellPrice: null, upsell: null
      @trackInteraction "addButtonPdp-uncheck-#{@state.variantType}_photo"

  renderVariant: (classes, variant, key) ->
    copy = @getVariantCopy key
    price = "$#{parseInt @convert('cents', 'dollars', variant.price_cents)}"

    <label className=classes.label key=key>
      <input
        type='radio'
        name='variant'
        value=key
        className=classes.radio
        onChange=@handleChangeOption
        disabled={not variant.in_stock}
        defaultChecked={key is @state.variantType} />
      <span className=classes.dot />
      <div className=classes.select>
        <span className=classes.price children=price />
        <span className=classes.variant children=copy.title />
        <span className=classes.description children=copy.description />
      </div>
    </label>

  renderUpsell: (classes, variant) ->
    checkProps =
      onChange: @manageCheckboxToggle.bind(@, variant)
      checked: @state.upsellVariant
      photoVariant: @props.photoVariant

    <div className=classes.upsellContainer>
      <UpsellCheckbox {...checkProps} />
    </div>

  getPricing: (classes) ->
    if not @state.upsellVariant
      key = @state.variantType
      priceCents = @props.variants[@state.variantType].price_cents
    else
      key = @state.upsellPrice
      priceCents = @state.upsellPrice

    formattedPrice = "$#{parseInt @convert('cents', 'dollars', priceCents)}"
    <div key=key children=formattedPrice className=classes.ATCPrice />

  getUpsellCTACopy: ->
    if @props.showApplePayButton then COPY.add_to_cart.initial else COPY.add_to_cart.upsells

  render: ->
    classes = @getClasses()
    pictureSources = @getPictureAttrs(classes.img)

    activeUpsells = _.get @props, "variants[#{@state.variantType}].upsells"
    showUpsells = @props.photoEnabled and activeUpsells

    <section className=classes.block>

      <h3 className=classes.header children=COPY.header />

      <div className=classes.variants>

        <fieldset className=classes.fieldset
          children={_.map @props.variants, @renderVariant.bind(@, classes)} />
        {
          if showUpsells
            <div>
              <h6 children='Extra treatment' className=classes.upsellHeader />
              <div
                children={_.map activeUpsells, @renderUpsell.bind(@, classes)} />
            </div>
        }
        {
          if showUpsells
            <CTA
              cssUtility=''
              tagName='button'
              type='button'
              variation='minimal'
              analyticsSlug={@getAnalyticsSlug("variant-#{@state.variantType}", 'click', 'Photo')}
              cssModifier=classes.addButton
              id='pdp__button--purchase'
              onClick=@handleAddItem>

              <ReactCSSTransitionGroup
                transitionName='-transition-slide-up-fade'
                transitionAppear=true>
                  {
                    if @state.addingToCart
                      <span key='added' className='u-dib'>
                        <Checkmark isChecked hideBox />
                        {COPY.add_to_cart.success}
                      </span>
                  }
              </ReactCSSTransitionGroup>


              <span className=classes.ctaTextUpsell>
                <span children={@getUpsellCTACopy()} className=classes.ctaText />
                <div className="u-dib u-pr">
                  <ReactCSSTransitionGroup
                    transitionName='-transition-toggle'
                    children={@getPricing(classes)}
                    transitionAppear=true />
                </div>
              </span>
            </CTA>
          else
            <CTA
              cssUtility=''
              tagName='button'
              type='button'
              variation='minimal'
              analyticsSlug={@getAnalyticsSlug("variant-#{@state.variantType}", 'click')}
              cssModifier=classes.addButton
              id='pdp__button--purchase'
              onClick=@handleAddItem>

              <ReactCSSTransitionGroup
                transitionName='-transition-slide-up-fade'
                transitionAppear=true>
                  {
                    if @state.addingToCart
                      <span key='added' className='u-dib'>
                        <Checkmark isChecked hideBox />
                        {COPY.add_to_cart.success}
                      </span>
                  }
              </ReactCSSTransitionGroup>
              <span children=COPY.add_to_cart.initial className=classes.ctaText />

            </CTA>
        }

        {if @props.showApplePayButton
          <button className=classes.applePayButton
            id='pdp__button--apple-pay'
            type='button'
            onClick=@handleApplePay>
            <Picture
              cssModifier=classes.picture
              children={@getPictureChildren(pictureSources)}/>
          </button>
        }

      </div>
    </section>
