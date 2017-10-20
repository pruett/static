[
  _
  React

  Mixins

  ResponsivePicture
  SliderFade
] = [

  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require 'components/atoms/images/responsive_picture_v2/responsive_picture_v2'
  require 'components/molecules/sliders/fade/fade'

  require './intro_section.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-winter-2015-intro-section'

  MIN_WIDTH_DESKTOP: 960

  mixins: [
    Mixins.classes
  ]

  getInitialState: ->
    hero: null

  getDefaultProps: ->
    images: []
    sizes:
      mobile: [
        break: 0
        image: 500
      ]
      tablet: [
        break: 640
        image: 960
      ]
      desktop: [
        break: 960
        image: 2000
      ]

  selectHero: ->
    # Select whether to display a static hero image or a slider based on viewport width
    viewPortWidth = window?.innerWidth || document?.documentElement.clientWidth
    if viewPortWidth? and viewPortWidth >= @MIN_WIDTH_DESKTOP
      @setState hero: 'slider'
    else
      @setState hero: 'static'

  componentDidMount: ->
    @selectHero()
    @debouncedSelectHero = _.debounce(@selectHero, 200)
    window?.addEventListener 'resize', @debouncedSelectHero

  componentWillUnmount: ->
    window?.removeEventListener 'resize', @debouncedSelectHero

  getStaticClasses:->
    slider: "
      #{@BLOCK_CLASS}__slider-wrapper
    "
    heroText: "
      #{@BLOCK_CLASS}__hero-text u-reset u-ffs u-fs24
    "
    heroWrapper: "
      #{@BLOCK_CLASS}__hero-wrapper
    "
    heroWrapperRight: "
      #{@BLOCK_CLASS}__hero-wrapper -right
    "
    pricingText: "
      #{@BLOCK_CLASS}__pricing-text u-reset u-ffs u-fs24
    "
    logo: "
      #{@BLOCK_CLASS}__logo
    "
    copyWrapper: "
      #{@BLOCK_CLASS}__copy-wrapper
    "

    staticWrapper: "
      #{@BLOCK_CLASS}__static-wrapper
    "

    imageWrapper: "
      #{@BLOCK_CLASS}__image-wrapper
    "

  getSlidesVersion: ->
    _.get @props, "hero_slider[#{@props.version}]"

  getStaticVersion: ->
    _.get @props, "static_hero[#{@props.version}]"

  render: ->
    return false unless @state.hero
    classes = @getClasses()
    slides = @getSlidesVersion()
    staticImages = @getStaticVersion()

    slideChildren = [
      <div className={
          if @props.version is 'men'
            classes.heroWrapperRight
          else
            classes.heroWrapper
      }>
        <img src=@props.logo.image className=classes.logo />
        <div className=classes.copyWrapper>
          <div children=@props.intro_text.text className=classes.heroText />
          <div
            children={
              if @props.country is 'CA'
                _.get @props, 'intro_text.pricing_text_canada'
              else
                _.get @props, 'intro_text.pricing_text'
            }
            className=classes.pricingText
          />
        </div>
      </div>
    ]

    <div className=@BLOCK_CLASS>
      <div className=classes.imageWrapper >
      {
        if @state.hero is 'slider'
          <SliderFade
            slideChildren=slideChildren
            slides=slides
            slideDuration=5500
            showArrows={left: false, right: false}
            cssModifier=classes.slider
          />
        else
          <ResponsivePicture
            sizes=@props.sizes
            sourceImages=staticImages
            cssModifier=classes.staticWrapper
          />
      }
      </div>
    </div>
