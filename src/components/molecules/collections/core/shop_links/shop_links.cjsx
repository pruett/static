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

  require '../../shop_links/shop_links.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-collections-shop-links'

  mixins: [
    Mixins.analytics
    Mixins.dispatcher
  ]

  propTypes: ->
    cssModifier: React.PropTypes.string
    frameAssembly: React.PropTypes.object
    gaCategory: React.PropTypes.string
    version: React.PropTypes.oneOf ['fans', 'men', 'women']

  getDefaultProps: ->
    cssModifier: ''
    gaCategory: 'Landing-Page'
    version: 'fans'
    cssModifierLink: "#{@BLOCK_CLASS}__link
      -cta-inline
      u-reset u-ffs u-fwn
    "

  handleClick: (gaData) ->
    #send gaData off to dispatcher, event type is productClick
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [gaData.ga]

  getWomenButton: (item) ->
    femaleProps =
      children: 'Shop Women'
      cssModifier: @props.cssModifierLink
      variation: 'secondary'
      href: @props.frameAssembly.women_url
      tagName: 'a'
      onClick: @handleClick.bind @,
        ga:
          url: @props.frameAssembly.women_url
          name: @props.frameAssembly.name
          id: @props.frameAssembly.product_women_id
          sku: @props.frameAssembly.product_sku
          category: 'Frame'
          position: @props.position
          list: @props.gaListModifier
          category: "Glasses"
        'women'
    [ <CTA {...femaleProps}
        analyticsSlug="LandingPage-clickShopWomen-#{item.product_sku}" />]

  getGenderedButtons: (item) ->
    maleProps =
      children: 'Shop Men'
      cssModifier: @props.cssModifierLink
      variation: 'secondary'
      tagName: 'a'
      href: item.men_url
      onClick: @handleClick.bind @,
        ga:
          url: item.men_url
          name: item.name
          id: item.product_men_id
          sku: item.product_sku
          category: 'Frame'
          list: @props.gaListModifier
          position: @props.position
        'men'

    femaleProps =
      children: 'Shop Women'
      cssModifier: @props.cssModifierLink
      variation: 'secondary'
      href: @props.frameAssembly.women_url
      tagName: 'a'
      onClick: @handleClick.bind @,
        ga:
          url: @props.frameAssembly.women_url
          name: @props.frameAssembly.name
          id: @props.frameAssembly.product_women_id
          sku: @props.frameAssembly.product_sku
          category: 'Frame'
          list: @props.gaListModifier
          position: @props.position
        'women'

    [
      <CTA {...maleProps}
        analyticsSlug="LandingPage-clickShopMen-#{@props.frameAssembly.product_sku}" />
      <CTA {...femaleProps}
        analyticsSlug="LandingPage-clickShopWomen-#{@props.frameAssembly.product_sku}" />
    ]

  render: ->
    item = @props.frameAssembly

    if item.sold_out
      buttons = @getButton 'Sold Out', null, null, true
    else
      if @props.version is 'fans'
        if not item.men_url
          buttons = @getWomenButton(item)
        else
          buttons = @getGenderedButtons(item)

    <div children=buttons className="#{@BLOCK_CLASS} #{@props.cssModifier}" />
