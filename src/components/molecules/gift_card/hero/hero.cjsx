[
  _
  React

  Markdown
  CTA
  ResponsivePicture

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/images/responsive_picture_v2/responsive_picture_v2'

  require 'components/mixins/mixins'

  require './hero.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-gift-card-hero'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  propTypes:
    background_color: React.PropTypes.string
    background_image: React.PropTypes.string
    cta: React.PropTypes.string
    description: React.PropTypes.string
    modal: React.PropTypes.string
    title: React.PropTypes.string
    theme: React.PropTypes.oneOf ['dark', 'light']
    vignette: React.PropTypes.bool
    manageClick: React.PropTypes.func
    cssModifierCTA: React.PropTypes.string

  getDefaultProps: ->
    background_color: '#a4a4a4'
    background_image: '//i.warbyparker.com/v/c/assets/gift-card/image/holiday-background/2/47366f2cf8.png'
    cta: 'Shop now'
    description: 'Tackle your gift list this season with Warby Parker gift cards. Included with every
      physical gift card is a crop of original buttons—decoration for all your holiday celebrations (and beyond).'
    images: []
    modal: 'Gift card FAQs ›'
    title: 'Gift cards with a little extra'
    theme: 'dark'
    vignette: true
    image_sizes:
      xs:
        break: 0
        image: 600
      s:
        break: 600
        image: 600
      m:
        break: 900
        image: 900
      l:
        break: 1200
        image: 1200

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-tac
      u-dt
      u-w100p
      u-h100p
    "
    content: "
      #{@BLOCK_CLASS}__content
      u-dtc
      u-vam
      u-w100p
    "
    image: "
      #{@BLOCK_CLASS}__image
      u-reset--button
      u-mt24 u-mb24
      u-mw960
      u-w100p
      u-w10c--600
      u-w7c--900
      u-w6c--1200
    "
    img: "
      #{@BLOCK_CLASS}__img
    "
    details: "
      u-pr36 u-pl36
    "
    title: "
      #{@BLOCK_CLASS}__title
      u-ma u-mb12
    "
    description: "
      #{@BLOCK_CLASS}__description
      u-db
      u-body-standard
      u-m0a u-mb24 u-mb36--900
    "
    cta: "
      #{@BLOCK_CLASS}__cta
      u-fs16 u-fws
      u-reset--button
      u-button -button-modular
      u-mr24 u-ml24
    "
    modal: "
      #{@BLOCK_CLASS}__modal
      u-db u-fws
      u-mt24 u-mt36--900
      u-mb24
    "

  classesWillUpdate: ->
    block:
      '-vignette': @props.vignette
    title:
      'u-heading-lg': @props.theme is 'light'
      'u-heading-lg--invert': @props.theme is 'dark'
    description:
      'u-body-standard': @props.theme is 'light'
      'u-body-standard--invert': @props.theme is 'dark'
    cta:
      '-button-white': @props.theme is 'dark'
      '-button-blue': @props.theme is 'light'
    modal:
      'u-color--white': @props.theme is 'dark'
      'u-color--dark-gray': @props.theme is 'light'

  handleClickCta: (evt) ->
    @props.manageClick(evt) if _.isFunction @props.manageClick

  handleClickImage: (evt) ->
    @props.manageClick(evt) if _.isFunction @props.manageClick
    @trackInteraction 'giftCard-click-image', evt

  handleTakeover: (evt) ->
    @props.manageTakeover(evt) if _.isFunction @props.manageTakeover

  render: ->
    @classes = @getClasses()
    style =
      backgroundColor: if @props.background_color.length then @props.background_color else null
      backgroundImage: if @props.background_image.length then "url(#{@props.background_image}?quality=100)" else null

    <div className=@classes.block style=style>
      <div className=@classes.content>
        <button
          className=@classes.image
          name='hero'
          onClick=@handleClickImage>
          <ResponsivePicture
            cssModifier=@classes.img
            altText=@props.title
            sourceImages=@props.images
            sizes=@props.image_sizes
            requestOriginalImages=true />
        </button>
        <div className=@classes.details>
          <h1
            children=@props.title
            className=@classes.title />
          <Markdown
            rawMarkdown=@props.description
            cssBlock=@classes.description />
          <CTA
            type='button'
            onClick=@handleClickCta
            analyticsSlug='giftCard-click-cta'
            variation='minimal'
            cssModifier=@classes.cta
            name='hero'
            value=@props.cta
            children=@props.cta />
          <a
            href='#'
            className=@classes.modal
            children=@props.modal
            onClick=@handleTakeover />
        </div>
      </div>
    </div>
