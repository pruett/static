[
  _
  React

  GalleryFrame

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/products/gallery_frame/gallery_frame'

  require 'components/mixins/mixins'

  require './product_cross_sells.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-product-cross-sells'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    baseProduct: React.PropTypes.object
    products: React.PropTypes.array

  getDefaultProps: ->
    baseProduct: {}
    products: []

  getStaticClasses: ->
    block: @BLOCK_CLASS
    titleArea: "#{@BLOCK_CLASS}__title-area"
    title: "
      #{@BLOCK_CLASS}__title
      u-reset u-fs20 u-fs24--600 u-fs30--1200
      u-fws u-ffs
    "

  getTrackingEvent: (product) ->
    if _.indexOf(@props.products, product) is 0 then 'window-scroll-crossSells' else ''

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <div className=classes.titleArea>
        <h3 className=classes.title
          children={if @props.baseProduct.is_low_bridge_fit
              'More Low Bridge Fit frames'
            else
              'Recommended'
          }
        />
      </div>
      {for product in @props.products
        <GalleryFrame
          analyticsCategory=product.analytics_category
          cssModifier='u-grid__col -c-12 -c-7--600 -c-4--900 -fluid-width'
          key="product-#{product.product_id or product.id}"
          products=[product]
          useTextColors=true
          imageSeenTrackingEvent=@getTrackingEvent(product) />
      }
    </div>
