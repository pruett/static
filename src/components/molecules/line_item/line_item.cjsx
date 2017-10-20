# Active Experiments
# photoCopy

[
  _
  React

  Alert
  ButtonRemove
  Img

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/alert/alert'
  require 'components/atoms/buttons/remove/remove'
  require 'components/atoms/images/img/img'

  require 'components/mixins/mixins'

  require './line_item.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-line-item'

  mixins: [
    Mixins.analytics
    Mixins.conversion
    Mixins.classes
    Mixins.dispatcher
    Mixins.image
    Mixins.product
  ]

  propTypes:
    item: React.PropTypes.shape
      amount_cents: React.PropTypes.number
      collections: React.PropTypes.array
      color: React.PropTypes.string
      display_name: React.PropTypes.string
      image_url: React.PropTypes.string
      lens_color: React.PropTypes.string
      qty: React.PropTypes.number
    cssModifier: React.PropTypes.string
    multiColumn: React.PropTypes.bool
    textLeftTablet: React.PropTypes.bool
    variation: React.PropTypes.oneOf ['cart', 'customer-center', 'checkout-review', 'checkout-information']
    manageRemoveItem: React.PropTypes.func
    photoVariant: React.PropTypes.string

  getDefaultProps: ->
    cartType: null
    cssModifier: ''
    cssUtility: ''
    imgSizes: '(min-width: 500px) 224px, calc(100vw - 64px)'
    item:
      amount_cents: 1
      collections: []
      color: ''
      display_name: ''
      image_url: ''
    linkImage: true
    manageRemoveItem: ->
    multiColumn: true
    oosCopy: 'This item is out of stock. Please remove it from your cart to check out.'
    textLeftTablet: false
    variation: ''
    photoVariant: ''

  getStaticClasses: ->
    variationClass = "#{@BLOCK_CLASS}--#{@props.variation}"

    block:
      "#{@BLOCK_CLASS}
      #{variationClass}
      #{@props.cssModifier}
      #{@props.cssUtility}
      u-reset u-fs18 u-ffs
      u-clearfix"
    color:
      "#{@BLOCK_CLASS}__color
      u-reset u-fs16 u-ffs u-fsi"
    collectionName:
      'u-fs12 u-color--dark-gray-alt-3 u-ffss u-ls1_5 u-fws u-ttu'
    displayName:
      "u-fs30 u-ffs u-fws u-reset"
    divider: "#{@BLOCK_CLASS}__divider"
    image:
      "#{@BLOCK_CLASS}__image
      #{@BLOCK_CLASS}--#{@props.variation}__image"
    imageContainer:
      "#{@BLOCK_CLASS}__image-container
      #{variationClass}__image-container
      -type-#{_.get(@props, 'item.option_type', 'none')}"
    priceQuantity:
      "#{@BLOCK_CLASS}__price-quantity
      #{variationClass}__price-quantity
      u-reset u-fs16 u-ffss u-mb24"
    price:
      'u-m0'
    quantity:
      'u-m0'
    text:
      "#{@BLOCK_CLASS}__text
      #{variationClass}__text
      u-reset u-fs16"
    itemDetails:
      "#{@BLOCK_CLASS}__item-details
      u-reset u-fs16 u-ffss"
    itemDetailsGiftCard:
      "#{@BLOCK_CLASS}__item-details--gift-card
      u-reset u-fs14 u-ffss u-mb8"
    itemDetailsTitle:
      'u-reset u-fws'
    itemNote: '
      u-dn u-db--600
      u-cb u-mt24
      u-fs16 u-ffss
      u-color--red
    '
    itemNoteMobile: '
      u-cb
      u-dn--600
      u-mt24
      u-fs16 u-ffss
      u-color--red
    '
    itemNoteIcon: '
      u-icon u-fill--red
      u-mr12 u-mt2
    '
    itemRemoveButton: '-cart-item'

  classesWillUpdate: ->
    block:
      '-hto': @props.cartType is 'hto'
    imageContainer:
      'u-db': not @props.multiColumn
      'grid__cell unit-1-2--tablet': @props.multiColumn
    text:
      'u-db': not @props.multiColumn
      'grid__cell unit-1-2--tablet': @props.multiColumn
      '-text-left--tablet': @props.textLeftTablet
    color:
      'u-fs24': @getCents() is 0 and @props.variation is not 'checkout-information'
      'u-mb14 u-color--dark-gray-alt-2': @props.variation is 'checkout-information'
    displayName:
      'u-fs30': @props.variation is not 'checkout-information'
      'u-fs20': @props.variation is not 'customer-center'
      'u-link--unstyled': @props.variation is not 'customer-center'
    itemRemoveButton:
      '-hto': @props.cartType is 'hto'

  getCents: ->
    @props.item.amount_cents ? 0

  getImageProps: (classes) ->
    color = @getColorDisplayName @props.item
    imageProps =
      cssModifier: classes.image
      alt: [
        @props.item.display_name or @props.item.name
        "in #{color}" if color
      ].join ' '

    if _.get(@props, 'item.image_url')
      imageProps.srcSet = @getSrcSet(
        url: @props.item.image_url
        widths: [224, 320, 448, 512, 622, 700, 870]
        quality: 80
      )
    else if _.get(@props, 'item.image_set.fill.front')
      imageProps.imageSet = @props.item.image_set.fill.front

    imageProps.sizes = @props.imgSizes

    imageProps

  handleProductClick: (name, evt) ->
    @clickInteraction(name, evt)

  handleClickRemove: (evt) ->
    evt.preventDefault()
    @props.manageRemoveItem(@props.item)

  renderGiftCardDetails: ->
    return if _.get(@props, 'item.option_type') isnt 'giftcard'

    classes = @getClasses()
    metadata = _.get @props, 'item.option_metadata', {}

    [
      if metadata.delivery_date?
        deliveryDate = new Date metadata.delivery_date
        <p className=classes.itemDetailsGiftCard key='delivery-date'>
          <strong className=classes.itemDetailsTitle children='Delivery Date: ' />
          {"
            #{deliveryDate.getUTCMonth() + 1}/\
            #{deliveryDate.getUTCDate()}/\
            #{deliveryDate.getUTCFullYear().toString().substr(2, 2)}
          "}
        </p>

      if metadata.recipient_name?
        <p className=classes.itemDetailsGiftCard key='to'>
          <strong className=classes.itemDetailsTitle children='To: ' />
          {metadata.recipient_name}
          {", #{metadata.recipient_email}" unless _.isEmpty metadata.recipient_email}
        </p>

      if metadata.sender_name?
        <p className=classes.itemDetailsGiftCard key='from'>
          <strong className=classes.itemDetailsTitle children='From: ' />
          {metadata.sender_name}
          {", #{metadata.sender_email}" unless _.isEmpty metadata.sender_email}
        </p>

      if metadata.note?
        <p className=classes.itemDetailsGiftCard key='note'>
          <strong className=classes.itemDetailsTitle children='Note: ' />
          {metadata.note}
        </p>
    ]

  getLabelChildren: ->
    optionType = _.get @props, 'item.variant_type'
    if optionType in ['rx_photo', 'prog_rx_photo']
      lensType = if @props.photoVariant is 'transitions' then 'Transitions®' else 'light-responsive'
      "#{@props.item.label} with #{lensType} lenses"
    else
      @props.item.label

  render: ->
    cents = @getCents()
    classes = @getClasses()
    color = @getColorDisplayName @props.item
    quantity = _.get(@props, 'item.qty') or _.get(@props, 'item.quantity')

    <div className=classes.block>
      {if @props.linkImage
        <a className=classes.imageContainer
          href=@props.item.product_url
          onClick={@handleProductClick.bind(@, @props.item.product_id)}
          key='image'>
          <Img {...@getImageProps(classes)} />
        </a>
      else
        <span className=classes.imageContainer
          key='image'>
          <Img {...@getImageProps(classes)} />
        </span>}

      <div className=classes.text>
        {if _.some(@props.item.collections, slug: 'low-bridge-fit')
          <div className=classes.collectionName children='low bridge fit' />
        }
        <h3 className=classes.displayName
          children={@props.item.display_name or @props.item.name} />
        {if color
          <div className=classes.color children=color />
        }
        {if @props.item.variant_type_id and @props.item.label
          <div className=classes.itemDetails children={@getLabelChildren()} />
        }
        {@renderGiftCardDetails()}

        {if cents and not @props.cartType
          <div className=classes.priceQuantity key='price-quantity'>
            <p className=classes.price
              children="$#{@convert 'cents', 'dollars', cents}" />

            {if quantity and quantity > 1
              <p className=classes.quantity
                children="Qty: #{quantity}" />
            }
          </div>
        }
      </div>

      {if @props.variation is 'cart'
        <div>
          {if @props.item.in_stock is false
            <div className=classes.itemNoteMobile>
              <Alert cssUtility=classes.itemNoteIcon />
              {@props.oosCopy}
            </div>}
          <hr className=classes.divider />
          <ButtonRemove
            cssModifier=classes.itemRemoveButton
            onClick=@handleClickRemove />
          {unless @props.cartType is 'hto'
            <div className=classes.priceQuantity>
              <p className=classes.price
                children="$#{(@props.item.amount / 100).toFixed(2)}" />

              {if quantity and quantity > 1
                <p className=classes.quantity
                  children="Qty: #{quantity}" />
              }
            </div>
          }
        </div>}

      {if @props.item.in_stock is false
        <div className=classes.itemNote>
          <Alert cssUtility=classes.itemNoteIcon />
          {@props.oosCopy}
        </div>}
    </div>
