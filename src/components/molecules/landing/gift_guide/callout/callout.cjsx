
_ = require 'lodash'
React = require 'react/addons'

Picture = require 'components/atoms/images/picture/picture'

Mixins = require 'components/mixins/mixins'

module.exports = React.createClass

  BLOCK_CLASS: 'c-gift-guide-callout'

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.analytics
    Mixins.dispatcher
  ]

  getDefaulProps: ->
    images: []
    pricing_text: ''
    title_text: ''
    subtitle: ''
    ctas: []
    css_modifier_callout: 'u-mb72'
    css_modifier_cartoon: 'u-m36 u-mb0--900'


  propTypes:
    images: React.PropTypes.array
    ctas: React.PropTypes.array
    pricing_text: React.PropTypes.string
    title_text: React.PropTypes.string
    ctas: React.PropTypes.array
    css_modifier_callout: React.PropTypes.string
    css_modifier_cartoon: React.PropTypes.string

  getInitialState: ->
    cartoonLoaded: false

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
      #{@BLOCK_CLASS}
      #{@props.css_modifier_callout}
    "
    image: '
      u-w100p
      u-mb12 u-mb0--900
    '
    grid: '
      u-grid -maxed
      u-mla u-mra
    '
    row: '
      u-grid__row
    '
    column: '
      u-grid__col u-w12c
    '
    imageWrapper: '
      u-w12c u-w7c--900
      u-dib
      u-vam
      u-pr
    '
    copyWrapper: '
      u-w12c u-w5c--900
      u-dib
      u-tac
      u-vam
      u-pr
    '
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
    subtitleText: '
      u-reset u-fs18 u-fs20--900
      u-fs24--1200
      u-ffs u-fsi u-color--dark-gray-alt-3
      u-mb18 u-mb24--900
      u-w9c u-w7c--900 u-mla u-mra
    '
    link: '
      u-fws
      u-fs18
      c-gift-guide__link
    '
    cartoon: "
      u-mla u-mra
      #{@props.css_modifier_cartoon}
    "

  classesWillUpdate: ->
    copyWrapper:
      'u-r7c--900': @props.flip
    imageWrapper:
      'u-l5c--900': @props.flip
    cartoon:
      'u-db': @state.cartoonLoaded
      'u-dn': not @state.cartoonLoaded
    cartoonLoader:
      'u-db': not @state.cartoonLoaded
      'u-dn': @state.cartoonLoaded

  handleClick: (cta) ->
    gender = cta.gender or ''
    @trackInteraction "LandingPage-clickShop#{gender}-#{@props.sku}"

    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [
        brand: 'Warby Parker'
        list: 'GiftGuide2016'
        id: @props.product_id
        name: @props.ga_name
        sku: @props.sku
        url: cta.path
        position: @props.gaPosition
      ]

  renderCTA: (cta={}, i) ->
    classes = @getClasses()
    <a
      href=cta.path
      key=i
      onClick={@handleClick.bind @, cta}
      className=classes.link
      children=cta.link_text />

  handleCartoonLoad: ->
    @setState cartoonLoaded: true

  render: ->
    classes = @getClasses()
    pictureAttrs = @getPictureAttrs(classes)
    isClickable = (_.get @props, 'ctas').length < 2
    productLink = _.get @props, 'ctas[0].path', ''
    cta = _.get @props, 'ctas[0]', {}

    <div className=classes.block>
      <div className=classes.grid>
        <div className='u-grid__row'>
          <div className=classes.imageWrapper>
          {
            if @props.animated
              if isClickable
                <div>
                  <a href=productLink onClick={@handleClick.bind @, cta}>
                    <img onLoad=@handleCartoonLoad
                    src=@props.cartoon_path
                    className=classes.cartoon />
                  </a>
                  <Picture children={@getPictureChildren(pictureAttrs)} />
                </div>
              else
                <div>
                  <img onLoad=@handleCartoonLoad
                  src=@props.cartoon_path
                  className=classes.cartoon />
                  <Picture children={@getPictureChildren(pictureAttrs)} />
                </div>
            else
              if isClickable
                <a href=productLink onClick={@handleClick.bind @, cta}>
                  <Picture children={@getPictureChildren(pictureAttrs)} />
                </a>
              else
                <Picture children={@getPictureChildren(pictureAttrs)} />
          }
          </div>
          <div className=classes.copyWrapper>
            <h2 children=@props.pricing_text className=classes.pricingText />
            <h3 children=@props.title_text className=classes.titleText />
            <h4 children=@props.subtitle className=classes.subtitleText />
            { (@props.ctas or []).map @renderCTA }
          </div>
        </div>
      </div>
    </div>
