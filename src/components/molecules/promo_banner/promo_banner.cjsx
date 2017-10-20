[
  _
  React

  IconX

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/x/x'

  require 'components/mixins/mixins'
]

require './promo_banner.scss'

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string
    cta: React.PropTypes.object
    transitionTime: React.PropTypes.number
    images: React.PropTypes.array
    quality: React.PropTypes.number
    bannerAnimatedOnce: React.PropTypes.bool
    fontStyles: React.PropTypes.string
    description_text: React.PropTypes.string

  BLOCK_CLASS: 'c-promo-banner'

  getDefaultProps: ->
    cssUtility: ''
    cssModifier: 'c-promo-banner--holiday'
    cta:
      text: ''
      url: ''
    description_text: ''
    transitionTime: 2000
    images: []
    quality: 100
    bannerAnimatedOnce: false

  getInitialState: ->
    showIntroImage: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      #{@props.cssUtility}
      u-tac
    "
    description: "
      #{@BLOCK_CLASS}__description
      #{@props.fontStyles}
    "
    link: "
      #{@BLOCK_CLASS}__link u-tdu
      u-reset u-fs16 u-ffss u-color--white
    "
    imageContainer: "
      #{@BLOCK_CLASS}__intro-image-container
    "
    introImage: "
      #{@BLOCK_CLASS}__intro-image
    "
    close: "
      #{@BLOCK_CLASS}__close
      u-button-reset
    "
    closeIcon: "
      u-icon
      u-fill--white
      #{@BLOCK_CLASS}__close-icon
    "
    content: "
      #{@BLOCK_CLASS}__content
    "
    wrapper: "
      #{@BLOCK_CLASS}__wrapper
      u-flex--none
    "

  componentWillUnmount: ->
    if @state.transitionTimeout
      clearTimeout @state.transitionTimeout

  onClickClose: (event) ->
    event.preventDefault()
    @trackInteraction 'banner-click-close'
    @commandDispatcher 'navigation', 'closeBanner'

  trackShoppingClick: (event) ->
    @trackInteraction 'banner-click-learnMore'

  setTransitionTimeout: ->
    @setState transitionTimeout: setTimeout(@transititonToText, @props.transitionTime)

  transititonToText: ->
    @setState showIntroImage: false
    @commandDispatcher 'navigation', 'bannerAnimatedOnce'

  createSrcset: ->
    quality = @props.quality
    sources = _.map @props.images, (image) ->
      "#{image.img_src}?quality=#{quality} #{image.resolution}"
    sources.join()

  render: ->
    classes = @getClasses()
    showIntroImage = @state.showIntroImage and not @props.bannerAnimatedOnce

    <div className=classes.wrapper>
      <ReactCSSTransitionGroup transitionName='-transition-slide-down'
        transitionAppear=true
        transitionEnter=true
        transitionLeave=false>

        <div className=classes.block role='banner' key='bannerContent'>
          <ReactCSSTransitionGroup transitionName='-transition-fade'>
            {if showIntroImage and not _.isEmpty @props.images
              <div key='imageContainer' className=classes.imageContainer>
                <img className=classes.introImage
                  src="#{@props.images[0].img_src}?quality=#{@props.quality}"
                  srcSet=@createSrcset()
                  onLoad=@setTransitionTimeout />
              </div>
            else
              <span key='textContent' className=classes.content>
                <span className=classes.description
                  children=@props.description_text />

                {if _.get(@props, 'cta.text')
                  <a className=classes.link
                    href=@props.cta.url
                    onClick=@trackShoppingClick
                    children=@props.cta.text />
                }
              </span>
            }
          </ReactCSSTransitionGroup>

          {if _.get(@props, 'showCloseButton')
            <button className=classes.close onClick=@onClickClose>
              <IconX cssUtility=classes.closeIcon />
            </button>
          }
        </div>

      </ReactCSSTransitionGroup>
    </div>
