React = require 'react/addons'

_ = require 'lodash'
Primary = require 'components/organisms/products/editions/primary/primary'
Secondary = require 'components/organisms/products/editions/secondary/secondary'
LayoutDefault = require 'components/layouts/layout_default/layout_default'

Mixins = require 'components/mixins/mixins'


module.exports = React.createClass
  mixins: [
    Mixins.analytics
    Mixins.context
    Mixins.dispatcher
  ]

  statics:
    route: ->
      path: [
        '/editions/{product_name*}'
      ]
      asyncPrefetch: ['/.*']
      handler: 'EditionsDetail'

  receiveStoreChanges: -> [
    'applePay'
    'capabilities'
    'editionsProduct'
  ]

  propTypes:
    appState: React.PropTypes.object

  getInitialState: ->
    selectedQuantity: 1

  freeShippingAndReturns: ->
    @getFeature('freeShipping') and @getFeature('freeReturns')

  getProductInfo: ->
    @getStore('editionsProduct')

  getActiveIndex: ->
    _.get @getProductInfo(), 'activeIndex', 0

  addToCart: ->
    {class_key, product_id, variant_id, qty} = @getAddToCartParams(@getActiveIndex())

    @trackInteraction 'addButtonPdp-click-edition'

    @commandDispatcher 'cart', 'addItem', {
      added_via: 'pdp'
      product_id
      qty
      variant_id
    }

  addToCartWithApplePay: ->
    {class_key, product_id, variant_id, qty} = @getAddToCartParams(@getActiveIndex())

    @trackInteraction "#{class_key}_PDP-click-addToCartApplePay"

    @commandDispatcher 'applePay', 'checkout', 'editions', {
      product_id
      qty
      variant: {variant_id}
    }

  getAddToCartParams: (index) ->
    {class_key, legacy__product_id, legacy__variant_id} =
      _.get @getProductInfo(), "products[#{index}]"

    {
      class_key
      product_id: legacy__product_id
      variant_id: legacy__variant_id
      qty: @state.selectedQuantity
    }

  handleColorChange: (newIndex) ->
    @commandDispatcher 'editionsProduct', 'changeActiveVariant', newIndex

  hasVariants: ->
    _.get(@getProductInfo(), 'products', []).length > 1

  changeQuantity: (quantity) ->
    @setState selectedQuantity: Math.max quantity, 1
    @trackInteraction "addButtonPdp-click-quantityOption#{quantity}"

  getActiveProduct: ->
    _.get @getProductInfo(), "products[#{@getActiveIndex()}]", []

  getItemType: (classKey) ->
    switch classKey
      when 'book'
        'Book'
      else
        ''

  render: ->
    {applePay, capabilities, editionsProduct} = @state.stores

    technicalDetails = _.get @getActiveProduct(), 'details', []
    recommendations = _.get @getActiveProduct(), 'recommendations', []

    <LayoutDefault {...@props} cssModifier='-full-width -push-footer'>
      {if editionsProduct?.__fetched
        <div className='u-grid -maxed u-m0a'>
          <Primary key='primary'
            activeIndex=@getActiveIndex()
            applePay=applePay
            addToCart=@addToCart
            addToCartWithApplePay=@addToCartWithApplePay
            applePaySupported=@props.appState?.client?.isApplePayCapable
            capabilities=capabilities
            changeQuantity=@changeQuantity
            editionsProduct=editionsProduct
            handleColorChange=@handleColorChange
            hasVariants=@hasVariants()
            freeShippingAndReturns=@freeShippingAndReturns()
            schemaItemType=@getItemType(editionsProduct.class_key)
            showMulti={@inExperiment('showMultipleEditions', 'enabled')}
            selectedQuantity=@state.selectedQuantity />

          <Secondary key='secondary'
            heading='Why we love it'
            product=@getActiveProduct()
            recommendations=recommendations
            technicalDetails=technicalDetails />
        </div>
      }
    </LayoutDefault>
