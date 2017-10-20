[
  _
  React

  ResponsivePicture
  Img
  SliderFade

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/responsive_picture_v2/responsive_picture_v2'
  require 'components/atoms/images/img/img'
  require 'components/molecules/sliders/fade/fade'

  require 'components/mixins/mixins'

  require './hero.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-collection-core-hero'

  mixins: [
    Mixins.classes
    Mixins.context
  ]

  getInitialState: ->
    hero: null

  selectHero: ->
    # Select whether to display a static hero image or a slider based on viewport width
    viewPortWidth = window?.innerWidth || document?.documentElement.clientWidth
    if viewPortWidth? and viewPortWidth >= @props.MIN_WIDTH_DESKTOP
      @setState hero: 'slider'
    else
      @setState hero: 'static'

  componentDidMount: ->
    @selectHero()
    @debouncedSelectHero = _.debounce(@selectHero, 200)
    window?.addEventListener 'resize', @debouncedSelectHero

  componentWillUnmount: ->
    window?.removeEventListener 'resize', @debouncedSelectHero

  getDefaultProps: ->
    MIN_WIDTH_DESKTOP: 960
    cssModifiers:
      block: ''
      price: ''
      hero: ''
      logo: ''
      contentWrapper: ''
      copyWrapper: ''
      static: ''
      slideImageWrapper: ''
      headerTextWrapper: ''
      pdpLinkWrapper: ''
      frameName: ''
      frameColor: ''
      staticWrapper: ''
      staticHeroWrapper: ''
      staticHeaderText: ''
      staticCopy: ''
      staticContentWrapper: ''
      staticLogo: ''
      staticPriceText: ''

  getStaticClasses: ->
    cssModifiers = @props.cssModifiers or {}

    block: "
      #{@BLOCK_CLASS} #{cssModifiers.block}
    "
    priceText: "
      #{@BLOCK_CLASS}__price-text #{cssModifiers.price}
    "
    heroWrapper: "
      #{@BLOCK_CLASS}__hero-wrapper #{cssModifiers.heroWrapper}
      u-tac
    "
    slideWrapper: "
      #{@BLOCK_CLASS}__slide-wrapper #{cssModifiers.slideWrapper}
    "
    slideImageWrapper: "
      #{@BLOCK_CLASS}__slide-image-wrapper #{cssModifiers.slideImageWrapper}
    "
    logoWrapper: "
      #{@BLOCK_CLASS}__logo-wrapper #{cssModifiers.logo}
    "
    contentWrapper: "
      #{@BLOCK_CLASS}__content-wrapper #{cssModifiers.contentWrapper}
    "
    copyWrapper: "
      #{@BLOCK_CLASS}__copy-wrapper #{cssModifiers.copyWrapper}
    "
    headerText: "
      #{@BLOCK_CLASS}__header-text #{cssModifiers.HeaderText}
    "
    staticHeroWrapper: "
      #{@BLOCK_CLASS}__static-hero-wrapper #{cssModifiers.staticHeroWrapper}
    "
    pdpLinkWrapper: "
      #{@BLOCK_CLASS}__pdp-link-wrapper #{cssModifiers.pdpLinkWrapper}
      u-ffs
    "
    frameName: "
      #{@BLOCK_CLASS}__frame-name #{cssModifiers.frameName}
      u-fws u-reset u-fs20
    "
    frameColor: "
      #{@BLOCK_CLASS}__frame-color #{cssModifiers.frameColor}
      u-fsi u-reset u-fs14
    "
    staticWrapper: "
      #{@BLOCK_CLASS}__static-wrapper #{cssModifiers.staticWrapper}
    "
    staticContentWrapper: "
      #{@BLOCK_CLASS}__static-content-wrapper #{cssModifiers.staticContentWrapper}
      u-tac
    "
    staticHeaderText: "
      #{@BLOCK_CLASS}__static-header-text #{cssModifiers.staticHeaderText}
      u-tac u-fwb
    "
    staticCopy: "
      #{@BLOCK_CLASS}__static-copy #{cssModifiers.staticCopy}
    "
    staticPriceText: "
      #{@BLOCK_CLASS}__static-price-text #{cssModifiers.staticPriceText}
    "
    staticLogoWrapper: "
      #{@BLOCK_CLASS}__static-logo-wrapper #{cssModifiers.staticLogo}
    "
    childrenWrapper: "
      #{@BLOCK_CLASS}__children-wrapper
    "

  classesWillUpdate: ->
    childrenWrapper:
      '-show': @state.imageLoaded

  getRegionalPricing: (contentBlock) ->
    locale = @getLocale('country')
    contentBlock.price[locale]

  getVersionedSlides: ->
    _.get @props, "content.hero_slider[#{@props.version}]"

  getVersionedStaticHero: ->
    _.get @props, "content.static_hero[#{@props.version}]"

  imageLoad: ->
    if not @state.imageLoaded
      @setState imageLoaded: true

  render: ->
    # return false to avoid the 'flicker' effect of the component rerendering
    return false unless @state.hero

    classes = @getClasses()
    slides = @getVersionedSlides()
    staticImages = @getVersionedStaticHero()
    logoSource = _.get @props, 'content.logo.image'

    # slideChildren are any child divs displayed alongside a slider image
    # these children compose an array, with the index number of the child div
    # corresponding to the index of the slide it will be shown on
    # Below, map through the introContent array from the cms, creating a child div
    # for each block of content (price, copy) provided.
    slideChildren = _.map (_.get @props, "content.intro_content[#{@props.version}]"), (contentBlock, i) =>
      pdpLinks = _.get contentBlock, 'pdp_links', {}

      <div className=classes.childrenWrapper>
        <div className=classes.heroWrapper key=i>
          {
            if contentBlock.show_logo
              <Img
                cssModifier=classes.logoWrapper
                srcSet=logoSource
              />
          }
          <div className=classes.contentWrapper>
            {
              if @props.headerText
                <div className=classes.headerText children=contentBlock.header />
            }
            <div
              children=contentBlock.text
              className=classes.copyWrapper
            />
            <div
              children={@getRegionalPricing(contentBlock)}
              className=classes.priceText
            />
          </div>
        </div>
        {
          unless _.isEmpty pdpLinks
            <div className={"#{classes.pdpLinkWrapper} #{pdpLinks.css_modifier}"}>
              <div
                children=pdpLinks.frame_name
                className=classes.frameName
              />
              <div
                children=pdpLinks.frame_color
                className=classes.frameColor
              />
            </div>
        }
      </div>

    <div className=classes.block>
      {
        if @state.hero is 'slider'
          <SliderFade
            slides=slides
            slideChildren=slideChildren
            slideDuration=@props.slideDuration
            showArrows={left: false, right: false}
            imageLoad={@imageLoad}
          />
        else
          <div className=classes.staticWrapper >
            <ResponsivePicture
              sizes=@props.heroSizes
              sourceImages=staticImages
              cssModifier=classes.staticHeroWrapper
            />
            <div className=classes.staticContentWrapper >
              <Img
                cssModifier=classes.staticLogoWrapper
                srcSet=logoSource
              />
              {
                if @props.headerText
                  <div
                    className=classes.staticHeaderText
                    children={_.get @props, 'content.copy.header'}
                  />
              }
              <div
                children={_.get @props, 'content.copy.text'}
                className=classes.staticCopy
              />
              <div
                children={@getRegionalPricing(_.get @props, 'content.copy')}
                className=classes.staticPriceText
              />
            </div>
          </div>
      }
    </div>
