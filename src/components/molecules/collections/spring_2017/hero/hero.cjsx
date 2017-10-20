React = require 'react/addons'
_ = require 'lodash'

Picture = require 'components/atoms/images/picture/picture'
Video = require 'components/molecules/collections/spring_2017/video/video'

Mixins = require 'components/mixins/mixins'

require './hero.scss'


module.exports = React.createClass

  mixins: [
    Mixins.dispatcher
    Mixins.classes
    Mixins.context
    Mixins.image
  ]

  BLOCK_CLASS: 'c-spring-2017-hero'

  getStaticClasses: ->
    block: '
      u-mw1440
      u-mla u-mra
    '
    cssModifierVideo: "
      #{@BLOCK_CLASS}__css-modifier-video
    "
    cssModifierVideoWrapper: "
      #{@BLOCK_CLASS}__css-modifier-video-wrapper
    "
    copyWrapper: '
      u-tac
      u-mt24 u-mt0--600 u-mt48--900
      u-mb30 u-mb0--600
      u-mb24--600
    '
    copyWrapperMen: '
      u-tac
      u-mt24 u-mt48--900
      u-mb24--600 u-mb48--900
      u-mla u-mra
      u-w11c u-w9c--600 u-w8c--900
    '
    body: '
      u-fs24 u-ffs
    '
    header: "
      #{@BLOCK_CLASS}__header
      u-fs40 u-fs80--900
      u-color--blue
      u-ffs
      u-reset
      u-mb12 u-mb24--1200
    "
    headerMen: "
      #{@BLOCK_CLASS}__header
      u-fs40 u-fs80--900
      u-color--blue
      u-ffs
      u-reset
      u-dn--900
    "
    pricingText: '
      u-fs12 u-fs14--900
      u-fwb u-ffss
      u-reset
      u-ls2
      u-ttu
      u-w9c u-mla u-mra
    '
    image: '
      u-w12c
    '
    pictureWrapper: '
      u-pr
    '
    headerDesktop: "
      #{@BLOCK_CLASS}__header-desktop
      u-dn u-db--900
      u-pa--900 u-t0--900 u-l0--900
      u-center-y--900
      u-w12c u-tac
    "

  classesWillUpdate: ->
    pricingText:
      'u-mb48--600': @props.version is 'm'

  getRegionalPricing: ->
    locale = @getLocale('country')
    _.get @props, "copy.pricing_text[#{locale}]"

  getPictureAttrs: (images = []) ->
    sources: [
      url: @getImageBySize(images, 'desktop-sd')
      quality: @getQualityBySize(images, 'desktop-sd')
      widths: @getImageWidths 900, 2200, 5
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 'tablet')
      quality: @getQualityBySize(images, 'tablet')
      widths: _.range 700, 1400, 200
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'mobile')
      quality: @getQualityBySize(images, 'mobile')
      widths: @getImageWidths 300, 800, 5
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Warby Parker Spring 2017 Collection'
      className: @classes.image

  renderCopy: ->
    copy = @props.copy or {}
    pricing = @getRegionalPricing()
    unless @props.version is 'm'
      <div className=@classes.copyWrapper>
        <h1 children=copy.header className=@classes.header />
        <h2 children=pricing className=@classes.pricingText />
      </div>
    else
      <div className=@classes.copyWrapperMen>
        <h1 children=copy.header className=@classes.headerMen />
        <p children=copy.body className=@classes.body />
        <p children=pricing className=@classes.pricingText />
      </div>

  renderMedia: ->
    unless @props.version is 'm'
      <Video
        cssModifierVideoWrapper=@classes.cssModifierVideoWrapper
        cssModifierVideo=@classes.cssModifierVideo
        tabletVideo=true
        isHero=true
        video=@props.video />
    else
      pictureAttrs = @getPictureAttrs(@props.image)
      copy = @props.copy or {}
      <div className=@classes.pictureWrapper>
        <Picture children={@getPictureChildren(pictureAttrs)} />
        <div className=@classes.headerDesktop>
          <h1 children=copy.header className=@classes.header />
        </div>
      </div>


  render: ->
    @classes = @getClasses()
    <div className=@classes.block>
      {@renderMedia()}
      {@renderCopy()}
    </div>
