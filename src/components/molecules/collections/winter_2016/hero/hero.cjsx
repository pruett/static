React = require 'react/addons'
_ = require 'lodash'

Mixins = require 'components/mixins/mixins'

Img = require 'components/atoms/images/img/img'
Picture = require 'components/atoms/images/picture/picture'

require './hero.scss'



module.exports = React.createClass

  mixins: [
    Mixins.dispatcher
    Mixins.classes
    Mixins.image
    Mixins.context
  ]

  BLOCK_CLASS: 'c-winter-2016-hero'

  propTypes:
    image: React.PropTypes.object
    copy: React.PropTypes.string
    logo: React.PropTypes.string
    flake: React.PropTypes.string

  getDefaultProps: ->
    copy: ''
    logo: ''
    flake: ''
    image: {}
    heroVariant: 'fans'

  getExperimentImages: ->
    if @props.heroVariant in ['menB', 'womenB']
      _.get @props, 'image.fans'
    else if @props.heroVariant is 'menA'
      _.get @props, 'image.m'
    else if @props.heroVariant is 'womenA'
      _.get @props, 'image.f'
    else
      _.get @props, 'image.fans'


  getPictureAttrs: ->
    images = @getExperimentImages()

    sources: [
      url: @getImageBySize(images, 'desktop-sd')
      quality: @getQualityBySize(images, 'desktop-sd')
      widths: _.range 900, 2200, 200
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 'tablet')
      quality: @getQualityBySize(images, 'tablet')
      widths: _.range 700, 1400, 200
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'mobile')
      quality: @getQualityBySize(images, 'mobile')
      widths: _.range 300, 700, 100
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Warby Parker Winter 2016'
      className: @classes.image

  getLogoProps: ->
    url: @props.logo
    widths: [200, 250, 300, 320, 370, 400]

  getFlakeProps: ->
    url: @props.flake
    widths: [200, 250, 300]

  logoSizes: [
    breakpoint: 0
    width: '80vw'
  ,
    breakpoint: 600
    width: '50vw'
  ,
    breakpoint: 900
    width: '20vw'
  ,
    breakpoint: 1200
    width: '400px'
  ]

  flakeSizes: [
    breakpoint: 0
    width: '5vw'
  ,
    breakpoint: 1200
    width: '100px'
  ]

  getStaticClasses: ->
    block: '
      u-mw1440
      u-mla u-mra
      u-pr
      u-mbn48--900 u-mbn0--1200
      u-mb48--1200
    '
    image: '
      u-w100p
      u-mb36 u-mb48--600 u-mb72--900
    '
    copy: '
      u-w10c u-w8c--900
      u-tac
      u-mla u-mra
      u-fs24 u-fs36--900
      u-color-winter-2016--blue
      c-winter-2016-body-copy u-ffs
      u-lh34 u-lh46--900
      u-reset u-fws
      u-mt18 u-mt0--600 u-mtn36--900
      u-mb18 u-mb36--900
    '
    logo: '
      u-w7c u-w3c--600
      u-pa--600 u-t0--600 u-l0--600
      u-center-x--600
      u-mb8 u-mb0--600
      u-t25p--600
    '
    logoWrapper: '
      u-tac
    '
    flake: '
      u-mla u-mra
      c-winter-2016-flake
      u-mb24 u-mb96--900
    '
    flakeWrapper: '
      u-tac
    '
    contentWrapper: "
      u-pr
      #{@BLOCK_CLASS}__content-wrapper
    "
    pricingText: '
      u-fs16 u-fs18--900
      u-color-winter-2016--blue-alt
      u-tac
      u-reset u-fws
      u-mb60
    '

  getRegionalPricing: ->
    locale = @getLocale('country')
    _.get @props, "price[#{locale}]"

  render: ->
    @classes = @getStaticClasses()
    logoSrcSet = @getSrcSet @getLogoProps()
    logoSizes = @getImgSizes @logoSizes
    flakeSrcSet = @getSrcSet @getFlakeProps()
    flakeSizes = @getImgSizes @flakeSizes
    pictureAttrs = @getPictureAttrs()

    <div className=@classes.block>
      <div className=@classes.contentWrapper>
        <Picture children={@getPictureChildren(pictureAttrs)} />
        <div className=@classes.logoWrapper>
          <Img srcSet=logoSrcSet
               alt='Warby Parker Winter 2016 Collection'
               sizes=logoSizes
               cssModifier=@classes.logo />
        </div>
      </div>
      <p children=@props.copy className=@classes.copy />
      <h3 children={@getRegionalPricing()} className=@classes.pricingText />
      <div className=@classes.flakeWrapper>
        <Img srcSet=flakeSrcSet sizes=flakeSizes
             alt='Warby Parker Morris frame'
             cssModifier=@classes.flake />
      </div>
    </div>
