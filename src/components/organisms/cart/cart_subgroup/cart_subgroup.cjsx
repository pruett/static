[
  _
  React

  CTA

  CartFooter
  LineItem
  EmptyWithCta

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'

  require 'components/molecules/cart/cart_footer/cart_footer'
  require 'components/molecules/line_item/line_item'
  require 'components/molecules/empty_with_cta/empty_with_cta'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-cart-subgroup'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    cart: React.PropTypes.object
    cartType: React.PropTypes.string
    cssModifier: React.PropTypes.string
    cssUtility: React.PropTypes.string
    openHTOSlotCount: React.PropTypes.number
    manageFillHomeTryOn: React.PropTypes.func

  getDefaultProps: ->
    cart:
      items: []
    cartType: ''
    children: null
    cssModifier: ''
    cssUtility: ''
    manageFillHomeTryOn: ->
    openHTOSlotCount: 0

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      #{@props.cssModifier}
      #{@props.cssUtility}
      u-mt0 u-mra u-mb0 u-mla"

  classesWillUpdate: ->
    block:
      'u-bbw3 u-bbss u-bc--dark-gray
      u-mt36': @props.cartType is 'hto'
      'u-mr0 u-ml0
      u-df u-flexd--c u-ai--c u-jc--c
      u-pa u-t0 u-r0 u-b0 u-l0
      u-color-bg--light-gray-alt-2': @showEmptyCart()
      'u-mw960': not @showEmptyCart()

  handleClickFillHomeTryOn: (evt) ->
    evt.preventDefault()
    @props.manageFillHomeTryOn()

  getFooterButton: ->
    <CTA
      analyticsSlug='cart-click-fillHto'
      children='Fill the rest for me'
      cssModifier='-margin -cta-inline'
      href=''
      onClick=@handleClickFillHomeTryOn
      tagName='a'
      variation='secondary' />

  getItemCount: ->
    _.get @props, 'cart.items.length', 0

  showEmptyCart: ->
    @props.cartType is 'purchase' and @getItemCount() is 0

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      {@props.children}
      {if @showEmptyCart()
        <EmptyWithCta
          headline='There is nothing in your cart. It is empty. A vacuum. Utterly alone. Start shopping to fill it up!'
          ctaChildren='Get shopping'
          ctaLink=@props.cart.lastGalleryUrl
          analyticsSlug='cart-click-shopFromEmptyCart' />
      else if @getItemCount()
        <div>
          {for item, i in @props.cart.items
            # Only show HTOs in the HTO cart, and only show non-HTOs in the purchase cart
            if (@props.cartType is 'hto' and item.option_type is 'hto') or
                (@props.cartType isnt 'hto' and item.option_type isnt 'hto')
              <LineItem
                {...@props}
                item=item
                key=i
                multiColumn=false
                variation='cart' />
          }
        </div>
      }
    </div>
