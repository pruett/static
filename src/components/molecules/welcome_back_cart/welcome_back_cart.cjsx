[
  _
  React

  Takeover
  CTA
  Img
  IconX

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/modals/takeover/takeover'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/images/img/img'
  require 'components/quanta/icons/x/x'

  require 'components/mixins/mixins'

  require './welcome_back_cart.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-welcome-back-cart'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
    Mixins.image
  ]

  getInitialState: ->
    activeFrameIndex: -1
    frameImagesLoaded: 0

  getDefaultProps: ->
    active: false
    hto_limit_reached: false
    hto_quantity: 0
    hto_quantity_remaining: 0
    hto_gallery_url: null
    hto_images: []

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
    "
    contentWrapper: "
      u-pr
      u-center u-center-none--600
    "
    content: "
      #{@BLOCK_CLASS}__content
      u-pr
      u-dib
      u-h100p u-hauto--600
      u-w100p u-wauto--600
      u-pl12 u-pr12 u-p96--600
      u-tac
      u-center
      u-color-bg--white
    "
    closeButton: "
      #{@BLOCK_CLASS}__close-button
      u-pa
      u-button-reset
    "
    closeIcon: 'u-icon u-fill--dark-gray-alt-2'
    images: "
      #{@BLOCK_CLASS}__images
      u-pr
      u-mla u-mra
    "
    frameImage: "
      #{@BLOCK_CLASS}__frame-image
    "
    headline: "
      #{@BLOCK_CLASS}__headline
      u-ffs u-fws
      u-fs20 u-fs24--600 u-fs26--1200
      u-mt36 u-mb12 u-mra u-mla
    "
    subhead: "
      #{@BLOCK_CLASS}__subhead
      u-ffss
      u-fs16 u-fs18--1200
      u-mt0 u-mb24 u-mra u-mla
      u-color--dark-gray-alt-1
    "
    cta: "
      #{@BLOCK_CLASS}__cta
    "
    linkWrapper: "
      #{@BLOCK_CLASS}__link-wrapper
      u-mt24
      u-dn u-db--600
    "
    link: '
      u-link--underline
      u-fs16
    '

  nextActiveFrame: ->
    nextIndex = @state.activeFrameIndex + 1
    if nextIndex < @props.hto_images.length
      @setState activeFrameIndex: nextIndex
      setTimeout @nextActiveFrame, 1500

  handleClose: (target, event) ->
    @commandDispatcher 'layout', 'hideTakeover'
    @trackInteraction "welcomeBack-close-#{target}", event

  frameImageLoaded: ->
    count = @state.frameImagesLoaded + 1
    @setState frameImagesLoaded: count
    @nextActiveFrame() if count is @props.hto_images.length

  render: ->
    @classes = @getClasses()

    frameImageSizes = @getImgSizes([
      breakpoint: 0
      width: 'calc(100vw - 24px)'
    ,
      breakpoint: 404
      width: '380px'
    ])

    variations =
      partial:
        headline:      'Your Home Try-On has missed you'
        message:       "Just add #{@props.hto_quantity_remaining}
                        more frame#{if @props.hto_quantity_remaining > 1 then 's' else ''}
                        to fill it up."
        link:          'Finish your box'
        url:           "#{@props.hto_gallery_url}?availability=hto"
        analyticsSlug: 'welcomeBack-click-gallery'
      full:
        headline:      'Don’t forget your five'
        message:       'You’ve got a full Home Try-On hanging out in your cart.
                        Still want that free trial?'
        link:          'Place your order'
        url:           '/cart'
        analyticsSlug: 'welcomeBack-click-cart'

    copy = if @props.hto_quantity_remaining is 0 then variations.full else variations.partial

    <Takeover
      active=@props.active
      cssModifier='u-color-bg--white-95p'
      hasHeader=false
      pageHeader=true>

      <div className=@classes.content>
        <button className=@classes.closeButton
          onClick={@handleClose.bind @, 'X'}>
          <IconX cssUtility=@classes.closeIcon />
        </button>

        <div className=@classes.contentWrapper>
          <div className=@classes.images>
            {_.map @props.hto_images, (url, i) =>
              <Img key=i
                cssModifier={[
                  @classes.frameImage
                  '-active' if i is @state.activeFrameIndex
                ].join ' '}
                onLoad=@frameImageLoaded
                srcSet={@getSrcSet url: url, widths: [380, 592, 702, 760]}
                sizes=frameImageSizes />}
          </div>


          <h3 className=@classes.headline children=copy.headline />
          <p className=@classes.subhead children=copy.message />

          <CTA
            analyticsSlug=copy.analyticsSlug
            tagName='a'
            cssModifier=@classes.cta
            href=copy.url
            variation='simple'
            children=copy.link />

          <div className=@classes.linkWrapper>
            <a className=@classes.link
              onClick={@handleClose.bind @, 'keepShopping'}
              children='Keep shopping' />
          </div>

        </div>
      </div>

    </Takeover>
