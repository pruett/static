[
  React

  Markdown
] = [
  require 'react/addons'

  require 'components/molecules/markdown/markdown'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-marketing-promo'

  getDefaultProps: ->
    headline:         ''
    full_image:       ''
    section_headline: ''
    shop_link_women:  ''
    shop_link_men:    ''
    ga_label:         ''
    cssModifier:      ''
    cssModifierName:  ''

  render: ->
    sub_class = 'c-shop-now'
    classes =
      block: "
        #{@BLOCK_CLASS}
        #{sub_class}
        #{@props.cssModifier}
        "
      promoImage: "
        #{@BLOCK_CLASS}__image
        "
      promoContent: "
        #{@BLOCK_CLASS}__content
        "
      promoName: "
        #{sub_class}__name
        #{@props.cssModifierName}
        "
      promoDescription: "
        #{sub_class}__description
        "
      promoLinks: "
        #{sub_class}__links
        "
      promoButton: "
        u-button -button-medium -button-white -button-pair
        u-reset u-ffs u-fs16
        "

    shopNow = (@props.shop_link_men or @props.shop_link_women) and not
      (@props.shop_link_men and @props.shop_link_women)

    <div className=classes.block>
      <img className=classes.promoImage src=@props.full_image />
      <div className=classes.promoContent>
        <h2 className=classes.promoName children=@props.headline />
        <Markdown className=classes.promoDescription rawMarkdown=@props.section_headline />
        <div className=classes.promoLinks>
          {if @props.shop_link_men
            <a
               className=classes.promoButton
               href=@props.shop_link_men
               children={if shopNow then 'Shop Now' else 'Shop Men'} />}
          {if @props.shop_link_women
            <a
               className=classes.promoButton
               href=@props.shop_link_women
               children={if shopNow then 'Shop Now' else 'Shop Women'} />}
        </div>
      </div>
    </div>
