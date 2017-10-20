
_ = require 'lodash'
React = require 'react/addons'

Picture = require 'components/atoms/images/picture/picture'

Mixins = require 'components/mixins/mixins'

require './gift_card.scss'

module.exports = React.createClass

  BLOCK_CLASS: 'c-gift-guide-gift-card'

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.analytics
    Mixins.dispatcher
  ]

  getDefaultProps: ->
    images: []
    pricing_text: ''
    title_text: ''
    subtitle: ''
    ctas: []
    css_modifier_callout: ''
    css_modifier_cartoon: ''
    show_sprite: false

  propTypes:
    images: React.PropTypes.array
    ctas: React.PropTypes.array
    pricing_text: React.PropTypes.string
    title_text: React.PropTypes.string
    ctas: React.PropTypes.array
    css_modifier_callout: React.PropTypes.string
    css_modifier_cartoon: React.PropTypes.string
    show_sprite: React.PropTypes.bool

  getPictureAttrs: (classes) ->
    images = @props.images or []

    sources: [
      url: @getImageBySize(images, 'desktop-hd')
      quality: @getQualityBySize(images, 'desktop-hd')
      widths: @getImageWidths 900, 1500, 5
      mediaQuery: '(min-width: 1200px)'
    ,
      url: @getImageBySize(images, 'desktop-sd')
      quality: @getQualityBySize(images, 'desktop-sd')
      widths: @getImageWidths 500, 1100, 5
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 'tablet')
      quality: @getQualityBySize(images, 'tablet')
      widths: @getImageWidths 700, 1200, 5
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'mobile')
      quality: @getQualityBySize(images, 'mobile')
      widths: @getImageWidths 200, 800, 7
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: @props.image_alt_text
      className: if not @props.animated then classes.image else classes.cartoonLoader

  getStaticClasses: ->
    block: "
      u-pr
      #{@BLOCK_CLASS}
      u-mla u-mra u-mw1440
      #{@props.css_modifier_callout}
    "
    background: "
      u-h0 u-pb3x2--600 u-pb2x1--900
      #{@BLOCK_CLASS}__background
    "
    image: "
      u-pa u-w12c
      #{@BLOCK_CLASS}__image
    "
    copyWrapper: "
      u-pa
      u-center-y--600
      #{@BLOCK_CLASS}__copy-wrapper
      u-w10c--600
      u-l5c--600
      u-tac u-w5c--900
    "
    pricingText: '
      u-reset u-fs18 u-fs20--900 u-fs24--1200
      u-ffs u-fws
      u-color-winter-2016--blue-alt-2
      u-mb6
    '
    titleText: '
      u-reset u-fs20 u-fs26--900 u-fs30--1200
      u-ffs u-fws
      u-color-winter-2016--blue-alt-2
      u-mb6
    '
    body: '
      u-fs18
      u-color-winter-2016--blue-alt-2
      u-lh26 u-lh28--900
      u-mb18 u-mb24--900
      u-reset
    '
    link: '
      u-fws
      u-fs18--900
      c-gift-guide__link
    '
    linkLeft: '
      u-mr12
      u-fws
      u-fs18--900
      c-gift-guide__link
    '
    sprite: "
      u-pa u-dn u-dib--900
      #{@BLOCK_CLASS}__sprite
    "
    eyebrow: '
      u-reset u-fs18 u-fs20--900
      u-fs24--1200
      u-ffs u-fsi u-color--dark-gray-alt
      u-mb6
      u-w9c u-w7c--900 u-mla u-mra
    '

  getPictureAttrs: (classes) ->
    images = @props.images or []

    sources: [
      url: @getImageBySize(images, 'desktop-sd')
      quality: @getQualityBySize(images, 'desktop-sd')
      widths: @getImageWidths 500, 1100, 5
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 'tablet')
      quality: @getQualityBySize(images, 'tablet')
      widths: @getImageWidths 700, 1200, 5
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'mobile')
      quality: @getQualityBySize(images, 'mobile')
      widths: @getImageWidths 200, 800, 7
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Warby Parker Gift Card'
      className: classes.image

  handleClick: ->
    @trackInteraction "LandingPage-clickShopGiftCard-digital"

    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [
        brand: 'Warby Parker'
        list: 'GiftGuide2016'
        id: 39996
        name: 'Gift Card'
        sku: '8011_0050_BGC'
        url: '/gift-card'
        position: @props.gaPosition
      ]

  renderCTA: (cta={}, i) ->
    classes = @getClasses()
    <a
      href=cta.path
      key=i
      onClick=@handleClick
      className={if i is 0 then classes.linkLeft else classes.link}
      children=cta.link_text />

  render: ->
    classes = @getClasses()
    pictureAttrs = @getPictureAttrs(classes)

    <div className=classes.block>
      <div className=classes.background />
      <Picture children={@getPictureChildren(pictureAttrs)} />
      <div className=classes.copyWrapper>
        <h2 children=@props.pricing_text className=classes.pricingText />
        <h3 children=@props.title_text className=classes.titleText />
        <h4 children=@props.eyebrow className=classes.eyebrow />
        <p children=@props.subtitle className=classes.body />
        { (@props.ctas or []).map @renderCTA }
      </div>
      {
        if @props.show_sprite
          <img src=@props.sprite_png className=classes.sprite />
      }
    </div>
