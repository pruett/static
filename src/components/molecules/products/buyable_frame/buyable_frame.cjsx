_ = require 'lodash'
React = require 'react/addons'
FrameImage = require 'components/molecules/products/gallery_frame_image/gallery_frame_image'
AddToFavorites = require 'components/atoms/products/add_to_favorites/add_to_favorites'
Mixins = require 'components/mixins/mixins'
AddButton = require 'components/molecules/products/add_button/add_button'

require './buyable_frame.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-buyable-frame'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
    Mixins.product
    Mixins.scrolling
  ]

  getDefaultProps: ->
    addedVia: ''
    analyticsCategory: ''
    canHto: true
    canFavorite: true
    canPurchase: true
    cssModifier: ''
    isFavorite: true
    isInline: false
    product: {}
    size: 'small'

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-dib u-pr u-mb60 u-mb96--900
    "
    content: '
      u-pr u-mt18
    '
    name: '
      u-reset u-mb2
      u-fs20 u-fs24--1200
      u-fws u-ffs
    '
    colorName: '
      u-fs16 u-fs18--1200
      u-ffs u-fsi u-ttc u-color--dark-gray-alt-2
    '
    heartIcon: '
      u-pa u-r0 u-dib
    '
    addButton: '
      u-pa u-pr--600
      u-db u-dib--600
      u-w100p u-wauto--600
      u-center-y u-center-none--600
      u-tar u-l0
    '

  classesWillUpdate: ->
    block:
      'u-tac': @props.canPurchase and @props.canHto
      'u-tal': @props.isInline
    addButton:
      'u-dib u-pr--600 -inline': @props.canPurchase and @props.canHto
      'u-pa u-pr--600
       u-db u-dib--600
       u-w100p u-wauto--600
       u-center-y u-center-none--600
       u-tar u-l0': @props.isInline
    details:
      "#{@BLOCK_CLASS}__details u-dib u-vam u-pr12": not (@props.canPurchase and @props.canHto)
      '-large': @props.size is 'large'
    heartIcon:
      'u-center-y u-mr6': @props.isInline
    buttonsContainer:
      'u-mt24 u-pr': @props.canPurchase or @props.canHto
      'u-dib u-vam': @props.isInline


  handleProductClick: (product, evt) ->
    @trackInteraction "#{@props.analyticsCategory}-clickProduct-\
      #{product.product_id or product.id}"
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      eventMetadata:
        list: @props.analyticsCategory
      products: product

  getProductImage: () ->
    linkProps =
      key: @props.product.product_id
      href: "/#{@props.product.path}"
      onClick: @handleProductClick.bind @, @props.product

    imgProps =
      altText: "#{@props.product.display_name} in #{@props.product.color}"
      image: @props.product.image
      sizes: @props.imageSizes
    responsiveImage = <FrameImage {...imgProps} />

    <a {...linkProps} children=responsiveImage />

  getProductPurchaseProps: ->
    props = _.pick @props.product,
      'assembly_type'
      'clip_on'
      'gender'
      'variants'
      'visible'
    _.assign props,
      addedVia: @props.addedVia
      analyticsCategory: @props.analyticsCategory
      cssModifier: @classes.addButton
      id: _.get @props, 'product.product_id'
      size: @props.size

  getProductHTOProps: ->
    props = _.pick @props.product,
      'assembly_type'
      'color'
      'display_name'
      'gender'
      'variants'
      'visible'
    _.assign props,
      addedVia: @props.addedVia
      analyticsCategory: @props.analyticsCategory
      cart: _.get @props, 'cart', {}
      cssModifier: @classes.addButton
      id: _.get @props, 'product.product_id'
      size: @props.size
      variantTypes: 'hto'

  render: ->
    @classes = @getClasses()

    <div className=@classes.block>

      {@getProductImage()}

      <div className=@classes.content>
        <div className=@classes.details>
          <h3 className=@classes.name children=@props.product.display_name />
          <span className=@classes.colorName children=@getColorDisplayName(@props.product) />

          {if @props.canFavorite
            <AddToFavorites
              cssModifier=@classes.heartIcon
              product_id=@props.product.product_id
              isFavorited=@props.isFavorite />}
        </div>

        <div className=@classes.buttonsContainer>
          {if @props.canHto and @getFeature 'homeTryOn'
            <AddButton {...@getProductHTOProps()} />}
          {if @props.canPurchase
            <AddButton {...@getProductPurchaseProps()} />}
        </div>
      </div>
    </div>
