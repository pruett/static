[
  _
  React

  Img

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-line-item-checkout'

  mixins: [
    Mixins.classes
    Mixins.conversion
    Mixins.image
    Mixins.product
  ]

  getDefaultProps: ->
    item: {}
    multiColumn: true

  getStaticClasses: ->
    block:  "
      #{@BLOCK_CLASS}
      u-pb48
    "
    details: '
      u-pr u-vat
    '
    displayName: '
      u-ffs u-fws u-m0
    '
    color: '
      u-ffs u-fsi u-fwn u-mb0
      u-color--dark-gray-alt-2
    '
    priceQuantity: '
      u-db u-t0 u-r0
      u-ffss u-fs18
      u-color--dark-gray-alt-3
      u-tar
    '
    price: 'u-m0'
    quantity: 'u-m0'
    variant: '
      u-db u-b0 u-r0
      u-ffss
      u-color--dark-gray-alt-3
    '
    htoList: '
      u-list-inside
      u-dn u-db--900
      u-m0 u-pl0 u-pt4
    '
    htoItem: '
      u-mt6
      u-ffs u-fs18 u-fws
      u-color--dark-gray-alt-2
    '
    htoColor: '
      u-fwn u-fsi
    '

  classesWillUpdate: ->
    image:
      'u-w6c u-w12c--900
       u-pr9 u-pr0--900
       u-pb12--900': @props.multiColumn
      'u-pb12': not @props.multiColumn
    details:
      'u-dib u-db--900
       u-w6c u-w12c--900
       u-pl9 u-pl0--900': @props.multiColumn
      'u-pt18 u-pt0--900': @props.htoItems
    text:
      'u-pr84--900': @props.multiColumn
      'u-pr84': not @props.multiColumn
    displayName:
      'u-fs24 u-fs30--900': @props.multiColumn
      'u-fs30': not @props.multiColumn
    color:
      'u-fs16 u-fs18--900
       u-mt2 u-mt4--900': @props.multiColumn
      'u-fs18 u-mt4': not @props.multiColumn
    priceQuantity:
      'u-pt6 u-pt4--900 u-pa--900': @props.multiColumn
      'u-pa u-pt4': not @props.multiColumn
    variant:
      'u-fs14 u-fs16--900 u-pa--900': @props.multiColumn
      'u-pa u-fs16': not @props.multiColumn

  getImageProps: ->
    img = _.get(@props, 'item.image_url') or _.get(@props, 'item.attributes.images.full')

    if @props.htoItems
      img = '//i.warbycdn.com/v/c/assets/checkout/image/hto-box/1/c672a75267.jpg'

    srcSet: @getSrcSet
      url: img
      widths: [284, 340, 396, 568, 680, 792]
    sizes: @getImgSizes [
      breakpoint: 0
      width: 'calc(100vw - 36px)'
    ,
      breakpoint: 432
      width: '396px'
    ]

  render: ->
    classes = @getClasses()

    if @props.htoItems
      price = 'Free'
      name = 'Home Try-On'
      altText = name
    else
      cents = _.get @props, 'item.amount_cents', 0
      if cents
        price = "$#{@convert 'cents', 'dollars', cents}"
      name = _.get @props, 'item.display_name'
      color = @getColorDisplayName @props.item
      altText = [name, " in #{color}" if color].join ''
      variantType = _.get @props, 'item.variant_type'
      quantity = _.get @props, 'item.quantity'

    <div className=classes.block>

      <Img {...@getImageProps()}
        alt=altText
        cssModifier=classes.image />

      <div className=classes.details>
        <div className=classes.text>
          <h3 className=classes.displayName children=name />
          {<h5 className=classes.color children=color /> if color}
        </div>

        {if price
          <div className=classes.priceQuantity>
            <p className=classes.price
              children=price />

            {if quantity and quantity > 1
              <p className=classes.quantity
                children="Qty: #{quantity}" />
            }
          </div>
        }

        {if @props.htoItems
          <ul className=classes.htoList children={_.map @props.htoItems, (item, i) =>
            <li className=classes.htoItem key=i>
              {item.display_name}
              {if item.color
                <span
                  className=classes.htoColor
                  children=" in #{@getColorDisplayName item}" />}
            </li>
          } />}

        {if _.includes variantType, 'High-Index'
          <span className=classes.variant children='High Index' />}
      </div>

    </div>
