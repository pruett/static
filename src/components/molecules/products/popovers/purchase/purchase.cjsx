[
  _
  React

  Checkmark
  IconX
  CTA
  Radio

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/checkmark/checkmark'
  require 'components/quanta/icons/x/x'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/radio/radio'

  require 'components/mixins/mixins'

  require './purchase.scss'
  require 'components/organisms/formgroups/radio/radio.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

VARIANT_COPY =
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

module.exports = React.createClass
  BLOCK_CLASS: 'c-product-popover-purchase'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.conversion
  ]

  propTypes:
    analyticsCategory:      React.PropTypes.string
    assembly_type:          React.PropTypes.string
    clip_on:                React.PropTypes.bool
    gender:                 React.PropTypes.string
    handleClose:            React.PropTypes.func
    id:                     React.PropTypes.number
    initialSelectedVariant: React.PropTypes.string
    variants:               React.PropTypes.object
    visible:                React.PropTypes.bool

  getDefaultProps: ->
    version: 1

  getInitialState: ->
    selectedVariantType: @props.initialSelectedVariant
    addingToCart: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-tac
    "
    header: '
      u-pr
      u-bbss u-bw1 u-bc--light-gray
      u-clearfix
    '
    title: '
      u-fws u-fs16
      u-mt18 u-mb18 u-ml10
    '
    cancel: '
      u-pa
      u-center-y
      u-r0 u-mr10
      u-button-reset
      u-fws u-fs14
      u-color--blue
    '
    x: '
      u-pa
      u-r0 u-mr12
      u-t0 u-mt4
      u-button-reset
    '
    fieldset: '
      u-bw0
      u-m0
      u-pt24 u-pr18 u-pb0 u-pl18
      u-tal
    '
    variantLabel:'
      c-formgroup--radio-v2
      u-cursor--pointer
    '
    variantHiddenInput: '
      c-formgroup--radio-v2__input
      u-hide--visual
    '
    variantStyledInput: '
      c-formgroup--radio-v2__toggle
    '
    variantTitle: "
      #{@BLOCK_CLASS}__variant-title
      u-fws u-fs16
    "
    variantPrice: "
      #{@BLOCK_CLASS}__variant-price
      u-fws u-fs16 u-fr
    "
    variantDescription: "
      #{@BLOCK_CLASS}__variant-description
      u-db
      u-pr48
      u-fs14
      u-color--dark-gray-alt-1
    "
    purchaseButton: "
      #{@BLOCK_CLASS}__purchase-button
      u-button -button-blue -button-medium
      u-fs16 u-fwb
      u-mb12
    "
    container: '
      u-pr6 u-pb24 u-pl6
    '
    message: '
      u-mt18 u-mr24 u-mb18 u-ml24
      u-fs14
      u-color--dark-gray-alt-1
    '
    link: '
      u-dib
      u-fs14 u-fws
      u-pb2
      u-bss u-bw0 u-bbw1
    '
    notice: '
      u-db
      u-pb12
      u-ffs u-fsi u-fs14
      u-color--dark-gray-alt-1
    '
    displayName: '
      u-fs24 u-ffs
      u-tal
      u-mt12 u-mb0 u-ml12 u-mr36
    '
    colorName: '
      u-fsi u-ffs u-ttc
      u-ml12 u-tal
      u-mt2 u-mb12
      u-color--dark-gray-alt-2
    '
    descriptionCallout: '
      u-tal u-ml12 u-mr12
      u-fs14 u-ffs
      u-color--dark-gray-alt-3
    '

  classesWillUpdate: ->
    block:
      '-wide': @isInStock()
    title:
      'u-fl': @isInStock()
    ctaText:
      'u-dn': @state.addingToCart

  componentDidMount: ->
    if @isInStock()
      # So as to not mess with the ReactCSSTransition
      setTimeout @focusFirstInput, 300
      @changeSelectedVariantType @refs.firstInput.value

  focusFirstInput: ->
    React.findDOMNode(@refs.firstInput)?.focus()

  handleChangeOption: (evt) ->
    value = evt.target.value
    @setState selectedVariantType: value
    @trackInteraction "#{@props.analyticsCategory}-click-variantOption\
      #{_.upperFirst _.camelCase(value)}",
      evt

    @changeSelectedVariantType value

  changeSelectedVariantType: (value) ->
    # Stopgap to allow variant images to change on PDPs
    if _.isFunction @props.manageChangeSelectedVariantType
      _.defer (->
        @props.manageChangeSelectedVariantType value
      ).bind @

  handleAddItem: ->
    unless @state.addingToCart
      @setState addingToCart: true
      @props.manageAddItem
        product_id: @props.id
        variant_id: _.get @props.variants, "#{@state.selectedVariantType}.variant_id"
        hto_in_stock: _.get @props.variants, 'hto.in_stock', false

  isInStock: ->
    _.reduce @props.variants, (acc, attrs) ->
      acc or (attrs.in_stock and attrs.active)
    , false

  getTitleCopy: ->
    if @isInStock()
      'Choose lenses'
    else if not @props.visible
      'Sold out'
    else
      'Out of stock'

  getVariantCopy: (variant) ->
    assembly = if @props.clip_on then 'clipons' else @props.assembly_type
    _.get VARIANT_COPY, "#{assembly}.#{variant}", {}

  getNoticeCopy: ->
    ca_entity_online = Date.now() > +new Date(2016, 4, 9)
    if @getFeature('taxesAndDuties') and not ca_entity_online
      'Includes all duties and taxes, as applicable'
    else
      'Free shipping and returns'

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

  manageClose: (evt) ->
    @trackInteraction "#{@props.analyticsCategory}-click-cancel", evt
    @props.handleClose()

  renderVariant: (variant, key) ->
    classes = @getClasses()

    inputProps =
      type: 'radio'
      name: 'variant'
      value: key
      className: classes.variantHiddenInput
      onChange: @handleChangeOption
      disabled: not variant.in_stock
      defaultChecked: key is @state.selectedVariantType

    inputProps['ref'] = 'firstInput' if key is @state.selectedVariantType

    copy = @getVariantCopy key
    price = parseInt @convert('cents', 'dollars', variant.price_cents)

    labelClass = classes.variantLabel
    labelClass = if copy.description then "#{labelClass} u-mb18" else "#{labelClass} u-mb24"

    <label className=labelClass key=key>
      <input {...inputProps} />
      <span className=classes.variantStyledInput />
      <span className=classes.variantTitle children=copy.title />
      <span className=classes.variantPrice children="$#{price}" />
      <span className=classes.variantDescription children=copy.description />
    </label>


  render: ->
    classes = @getClasses()

    oosCopy =
      if @props.visible
        'Due to popular demand, this item is currently out of stock.'
      else
        'We’re sorry, but this frame is no longer available.'

    <div className=classes.block>

      {if @props.version is 1
        ctaCopy = 'Add to cart'

        <div className=classes.header>
          <h3 className=classes.title children={@getTitleCopy()} />
          {if @isInStock()
            <button
              className=classes.cancel
              onClick=@manageClose
              children='Cancel' />}
        </div>
      else
        ctaCopy = 'Select lenses'

        <div className=classes.header>
          <h3 className=classes.displayName children=@props.display_name />
          <p className=classes.colorName children=@props.color />
          {if @props.description_callout
            <p className=classes.descriptionCallout children=@props.description_callout />
          }
          <button
            className=classes.x
            onClick=@manageClose>
            <IconX cssModifier='u-fill--dark-gray-alt-2' />
          </button>
        </div>
      }


      {if @isInStock()
        [
          <fieldset key='purchase-fieldset' className=classes.fieldset>
            <div className=classes.variantList
              children={_.map @props.variants, @renderVariant} />
          </fieldset>

          <CTA
            key='purchase-cta'
            analyticsSlug="
              #{@props.analyticsCategory}-click-variant\
              #{_.upperFirst _.camelCase(@state.selectedVariantType)}"
            type='button'
            tagName='button'
            onClick=@handleAddItem
            id='pdp__button--purchase'
            cssModifier=classes.purchaseButton
            cssUtility=''
            variation='minimal'>

            <ReactCSSTransitionGroup
              transitionName='-transition-slide-up-fade'
              transitionApppear>
                {if @state.addingToCart
                  <span key='added' className='u-dib'>
                    <Checkmark isChecked hideBox />
                    Added!
                  </span>}
            </ReactCSSTransitionGroup>

            <span children=ctaCopy className=classes.ctaText />
          </CTA>

          <span key='notice' className=classes.notice children={@getNoticeCopy()} />
        ]
      else
        <div className=classes.container>
          <p className=classes.message children=oosCopy />
          <a href={@getGalleryUrl()}
            className=classes.link
            children='Find another frame'
            onClick={@trackInteraction.bind @,
              "#{@props.analyticsCategory}-click-purchaseFindAnother"} />
        </div>
      }
    </div>
