React = require 'react/addons'
_ = require 'lodash'

Picture = require 'components/atoms/images/picture/picture'

Mixins = require 'components/mixins/mixins'

require './hero.scss'

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.dispatcher
    Mixins.analytics
    Mixins.scrolling
  ]

  BLOCK_CLASS: 'c-resort-hero'

  propTypes:
    labels: React.PropTypes.array
    copy: React.PropTypes.string
    image: React.PropTypes.array
    logo: React.PropTypes.array

  getDefaultProps: ->
    labels: []
    copy: ''
    image: []
    logo: []

  componentDidMount: ->
    @setState showLogo: true

  getLogoAttrs: ->
    images = @props.logo

    sources: [
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
      alt: 'Warby Parker Resort Collection'
      className: @classes.logo

  getPictureAttrs: ->
    images = @props.image

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
      alt: 'Warby Parker Resort Collection'
      className: @classes.image

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-mw2000 u-mla u-mra
      u-pr
      u-mb12 u-mb24--600 u-mb72--900
    "
    imageWrapper: "
      #{@BLOCK_CLASS}__image-wrapper
      u-h0 u-pb1x1
    "
    copyWrapper: "
      #{@BLOCK_CLASS}__copy-wrapper
      u-tac
      u-mla u-mra
      u-pt48 u-pt60--600 u-pt0--900
      u-pa--900 u-t0--900 u-l0--900
      u-center-y--900
    "
    copy: "
      #{@BLOCK_CLASS}__copy
      u-reset
      u-ffs
      u-mla u-mra
      u-color--dark-gray u-color--white--900
      u-lh30
      u-pl6 u-pr6 u-pl0--600 u-pr0--600
      u-w11c u-w10c--600 u-w5c--900
    "
    logo: "
      #{@BLOCK_CLASS}__logo
      u-w7c u-w4c--600 u-w2c--900
      u-mb18
      u-pt24 u-pt0--600
    "
    frameLabels: "
      #{@BLOCK_CLASS}__label
      u-color--white
      u-fs16
      u-bbss--900 u-bbw1 u-bbw0--900 u-bc--white
      u-pb6 u-fs16 u-fs18--900 u-wsnw
    "
    labelWrapper: "
      #{@BLOCK_CLASS}__label-wrapper
      u-pa u-b0 u-r0
      u-pr24 u-pb24
      u-pr36--600 u-pb36--600
    "
    labelName: '
      u-fws
    '
    image: '
      u-w12c
    '
    arrow: "
      #{@BLOCK_CLASS}__arrow
      u-cursor--pointer
      u-dn u-dib--900
      u-pr
    "

  handleScrollJack: ->
    @scrollToNode document.querySelector('#firstGrid'), time: 800

  render: ->
    @classes = @getClasses()
    pictureAttrs = @getPictureAttrs()
    logoAttrs = @getLogoAttrs()

    <div className=@classes.block>
      <div className=@classes.imageWrapper>
        <Picture children={@getPictureChildren(pictureAttrs)} />
      </div>
      <div className=@classes.copyWrapper key='copyWrapper'>
        <Picture children={@getPictureChildren(logoAttrs)} key='picture' />
        <p className=@classes.copy children=@props.copy key='copy' />
        <img src=@props.arrow_png onClick=@handleScrollJack className=@classes.arrow key='arrow' />
      </div>
      <div className=@classes.labelWrapper children={@props.renderLabels(@props.frame_labels)} />
    </div>

