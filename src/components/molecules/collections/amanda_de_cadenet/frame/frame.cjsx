React = require 'react/addons'
_ = require 'lodash'

Img = require 'components/atoms/images/img/img'

Mixins = require 'components/mixins/mixins'

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

require './frame.scss'

module.exports = React.createClass

  mixins: [
    Mixins.image
    Mixins.classes
    Mixins.dispatcher
    Mixins.analytics
  ]

  BLOCK_CLASS: 'c-amanda-de-cadenet-frame'

  propTypes:
    images: React.PropTypes.array
    product_key: React.PropTypes.string
    color: React.PropTypes.string
    name: React.PropTypes.string
    path: React.PropTypes.string
    ga: React.PropTypes.object

  getDefaultProps: ->
    images: []
    product_key: ''
    color: ''
    name: ''
    path: ''
    hasSeparator: false
    ga: {}
    sold_out: true

  getInitialState: ->
    activeImageIndex: 0

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-mw1440
      u-mla u-mra
      u-pr
    "
    container: "
      #{@BLOCK_CLASS}__container
    "
    carousel: '
      u-pr
      u-w12c u-w11c--600 u-w8c--900
      u-mla u-mra
    '
    transitionGroup: "
      #{@BLOCK_CLASS}__image-wrapper
    "
    image: '
      u-w12c
      u-pa u-t0 u-l0
      u-center-x
    '
    buttonLeft: "
      u-cursor--pointer
      #{@BLOCK_CLASS}__button #{@BLOCK_CLASS}__button-left
    "
    buttonRight: "
      u-cursor--pointer
      #{@BLOCK_CLASS}__button #{@BLOCK_CLASS}__button-right
    "
    buttonWrapper: "
      #{@BLOCK_CLASS}__button-wrapper
      u-tac
      u-mt48
      u-mb18
    "
    frameInfoWrapper: '
      u-tac
      u-mb12
    '
    frameName: '
      u-ffs u-fwb
      u-fs16 u-fs24--900
      u-color--black
    '
    frameColor: '
      u-ffs u-fsi
      u-fs16 u-fs24--900
      u-color--black
    '
    separator: "
      #{@BLOCK_CLASS}__separator
      u-mla u-mra
      u-w9c
      u-color-bg--dark-gray-alt-3
      u-dn--600
      u-mt72
      u-mb54
    "
    ctaWrapper: '
      u-tac
    '
    ctaText: "
      #{@BLOCK_CLASS}__cta-text
      u-bbss u-bbw2 u-bbw0--900
      u-bc--black
      u-pb6
      u-fs16 u-color--black
      u-ffss u-fws
    "
    soldOut: '
      u-pb6
      u-fs16 u-color--black
      u-ffss u-fws
    '

  classesWillUpdate: ->
    buttonLeft:
      '-show': @state.activeImageIndex is 0
      '-hide': @state.activeImageIndex isnt 0
    buttonRight:
      '-show': @state.activeImageIndex is 1
      '-hide': @state.activeImageIndex isnt 1

  renderImage: () ->
    images = @props.images or []
    activeImage = images[@state.activeImageIndex]

    imageSizes = [
      breakpoint: 0
      width: '80vw'
    ,
      breakpoint: 600
      width: '70vw'
    ]

    imageProps =
      url:  activeImage or ''
      widths: @getImageWidths 300, 1200, 8

    logoSrcSet = @getSrcSet imageProps

    logoSizes = @getImgSizes imageSizes

    <Img srcSet=logoSrcSet sizes=logoSizes
         key=activeImage
         alt={"Warby Parker #{@props.name} frame"}
         cssModifier=@classes.image />

  renderTransitionGroup: ->
    <ReactCSSTransitionGroup
      transitionName=@classes.transitionGroup >
      {@renderImage()}
    </ReactCSSTransitionGroup>

  renderButton: (button, i) ->
    <button
      className={if i is 0 then @classes.buttonLeft else @classes.buttonRight}
      key=i
      onClick={@handleButtonClick.bind @, i} />

  renderCarousel: () ->
    if @props.sold_out
      <span>
        {@renderTransitionGroup()}
      </span>
    else
      <a href=@props.path onClick={@handleShopLinkClick.bind @, 'Image'} >
        {@renderTransitionGroup()}
      </a>

  renderShopLinks: () ->
    if @props.sold_out
      <span children='Sold out' className=@classes.soldOut />
    else
      <a children='Shop now'
        onClick={@handleShopLinkClick.bind @, ''}
        href=@props.path
        className=@classes.ctaText />

  handleButtonClick: (i) ->
    @setState activeImageIndex: i

  handleShopLinkClick: (modifier = '') ->
    ga = @props.ga or {}

    @trackInteraction "LandingPage-clickShopWomen#{modifier}-#{ga.sku}"
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [
        brand: 'Warby Parker'
        category: ga.type
        list: 'AmandaDeCadenet'
        id: ga.product_id
        name: ga.display_name
        color: ga.color
        position: ga.position
        sku: ga.sku
        url: ga.path,
        gender: 'f',
        collections: [
          slug: 'AmandaDeCadenet'
        ]
      ]

  render: ->
    @classes = @getClasses()
    images = @props.images or []

    <div className=@classes.block>
      <div className=@classes.container>
        <div className=@classes.carousel children={@renderCarousel()} />
      </div>
      <div className=@classes.buttonWrapper>
        {_.map images, @renderButton}
      </div>
      <div className=@classes.frameInfoWrapper>
        <span children=@props.name className=@classes.frameName />
        <span children={" in #{@props.color}"} className=@classes.frameColor />
      </div>
      <div className=@classes.ctaWrapper children={@renderShopLinks()} />
      {
        if @props.hasSeparator
          <div className=@classes.separator />
      }
    </div>
