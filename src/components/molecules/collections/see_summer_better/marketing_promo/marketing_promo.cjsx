[
  React

  Mixins
] = [
  require 'react/addons'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-marketing-promo'
  GA_CATEGORY: 'Landing-Page-See-Summer-Better'

  getDefaultProps: ->
    headline:         ''
    full_image:       ''
    section_headline: ''
    shop_link_women:  ''
    shop_link_men:    ''
    ga_label:         ''

  render: ->
    sub_class = 'c-shop-now'
    classes =
      block: "
        #{@BLOCK_CLASS}
        #{sub_class}
        "
      promoImage: "
        #{@BLOCK_CLASS}__image
        "
      promoContent: "
        #{@BLOCK_CLASS}__content
        "
      promoName: "
        #{sub_class}__name
        "
      promoDescription: "
        #{sub_class}__description
        "
      promoLinks: "
        #{sub_class}__links
        "
      promoButton: "
        #{sub_class}__button
        u-button -button-medium -button-white -button-pair
        u-reset u-fs16 u-ffs u-mb24
        js-ga-click
        "

    <div className=classes.block>
      <img className=classes.promoImage src=@props.full_image />
      <div className=classes.promoContent>
        <h2 className=classes.promoName children=@props.headline />
        <p className=classes.promoDescription children=@props.section_headline />
        <div className=classes.promoLinks>
          {if @props.shop_link_men
            <a className=classes.promoButton
               href=@props.shop_link_men
               children='Shop Men' />}
          {if @props.shop_link_women
            <a className=classes.promoButton
               href=@props.shop_link_women
               children='Shop Women' />}
        </div>
      </div>
    </div>
