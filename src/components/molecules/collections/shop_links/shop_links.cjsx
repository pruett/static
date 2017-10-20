[
  _
  React

  CTA

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'

  require 'components/mixins/mixins'

  require './shop_links.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-collections-shop-links'

  propTypes: ->
    cssModifier: React.PropTypes.string
    frameAssembly: React.PropTypes.object
    gaCategory: React.PropTypes.string
    version: React.PropTypes.oneOf ['fans', 'men', 'women']

  getDefaultProps: ->
    cssModifier: ''
    gaCategory: 'Landing-Page'
    version: 'fans'

  getButton: (label, productId=null, href='', soldOut=false) ->
    buttonProps =
      children: label
      cssModifier: "#{@BLOCK_CLASS}__link
        -cta-inline
        u-reset u-ffs u-fwn
        js-ga-click
      "
      variation: 'secondary'

    if soldOut
      _.assign buttonProps, disabled: true
    else if href
      _.assign buttonProps,
        href: href
        tagName: 'a'

    <CTA {...buttonProps} analyticsSlug='landingPage-click-shop' />

  render: ->
    item = @props.frameAssembly

    if item.sold_out
      buttons = @getButton 'Sold Out', null, null, true
    else
      if @props.version is 'men'
        buttons = @getButton 'Shop Now', item.product_men_id, item.men_url
      else if @props.version is 'women'
        buttons = @getButton 'Shop Now', item.product_women_id, item.women_url
      else
        buttons = [
          @getButton('Shop Men', item.product_men_id, item.men_url) if item.product_men_id?
          @getButton('Shop Women', item.product_women_id, item.women_url) if item.product_women_id?
        ]

    <div children=buttons className="#{@BLOCK_CLASS} #{@props.cssModifier}" />
