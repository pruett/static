[
  _
  React

  Logo
  Picture
  SliderFade

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/icons/fall_2015_logo/fall_2015_logo'
  require 'components/atoms/images/picture/picture'
  require 'components/molecules/sliders/fade/fade'

  require 'components/mixins/mixins'

  require './intro_section.scss'
]

module.exports = React.createClass
  CONTENT_PATH: '/fall-2015'
  BLOCK_CLASS: 'c-fall-2015-intro-section'

  MIN_WIDTH_DESKTOP: 960

  mixins: [
    Mixins.classes
  ]

  propTypes:
    version: React.PropTypes.oneOf(['fans', 'men', 'women'])

  getDefaultProps: ->
    version: 'fans'
    country: 'US'

  getInitialState: ->
    hero: null

  getStaticClasses: ->
    slider: "#{@BLOCK_CLASS}__slider"
    staticHero: "#{@BLOCK_CLASS}__static-hero"
    staticHeroImage: "#{@BLOCK_CLASS}__static-hero-image"
    staticHeroWrapper: "#{@BLOCK_CLASS}__static-hero-wrapper"
    introText: [
      "#{@BLOCK_CLASS}__intro-text"
      'u-reset u-ffs -fall-2015-responsive-type -intro-text'
      'u-tac'
    ]
    introTextWrapper: [
      "#{@BLOCK_CLASS}__intro-text-wrapper"
      'u-tac'
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

  render: ->
    return false unless @state.hero
    classes = @getClasses()

    if @props.country is 'US'
      pricing = _.get @props, 'header.intro_text.pricing_text'
    else if @props.country is 'CA'
      pricing = _.get @props, 'header.intro_text.pricing_text_canada'

    slideChildren = [<Logo version=@props.version />]

    <div className=@BLOCK_CLASS>
      {if @state.hero is 'slider'
        <SliderFade
          cssModifier=classes.slider
          slides=@props.header.hero_slider
          slideChildren=slideChildren
          showArrows={left: false, right: false} />}
      {if @state.hero is 'static'
        <div className=classes.staticHeroWrapper>
          <Picture cssModifier=classes.staticHero>
            <source
              className=classes.staticHeroImage
              media="(min-width: 720px)"
              srcSet="#{@props.header.tablet_hero.image} 1x,
                      #{@props.header.tablet_hero.image_2x} 2x" />
            <source
              className=classes.staticHeroImage
              srcSet="#{@props.header.mobile_hero.image} 1x,
                      #{@props.header.mobile_hero.image_2x} 2x" />
            <img
              className=classes.staticHeroImage
              srcSet=@props.header.mobile_hero.image />
          </Picture>
          <Logo />
        </div>}
      <div className=classes.introTextWrapper>
        <p className=classes.introText children=@props.header.intro_text.text />
        <p className=classes.introText children=pricing />
      </div>
    </div>
