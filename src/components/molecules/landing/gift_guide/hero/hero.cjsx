
_ = require 'lodash'
React = require 'react/addons'

Picture = require 'components/atoms/images/picture/picture'

Mixins = require 'components/mixins/mixins'

require './hero.scss'

module.exports = React.createClass

  BLOCK_CLASS: 'c-gift-guide-hero'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  getDefaulProps: ->
    images: []
    copy: {}

  propTypes:
    images: React.PropTypes.array
    copy: React.PropTypes.object

  getPictureAttrs: (classes) ->
    images = @props.images or []

    sources: [
      quality: @getQualityBySize(images, 'desktop-hd')
      url: @getImageBySize(images, 'desktop-hd')
      widths: @getImageWidths 1200, 1800, 4
      mediaQuery: '(min-width: 1200px)'
      sizes: '(min-width: 1440px) 1440px, 100vw'
    ,
      quality: @getQualityBySize(images, 'desktop-sd')
      url: @getImageBySize(images, 'desktop-sd')
      widths: @getImageWidths 900, 1800, 4
      mediaQuery: '(min-width: 900px)'
      sizes: '(min-width: 1440px) 1440px, 100vw'
    ,
      quality: @getQualityBySize(images, 'tablet')
      url: @getImageBySize(images, 'tablet')
      widths: @getImageWidths 600, 900, 5
      mediaQuery: '(min-width: 600px)'
    ,
      quality: @getQualityBySize(images, 'mobile')
      url: @getImageBySize(images, 'mobile')
      widths: @getImageWidths 300, 600, 5
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Warby Parker Holiday Gift Guide'
      className: classes.image

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-mla u-mra u-mw1440
      u-mb48 u-mb0--600
      u-pr
    "
    image: '
      u-w100p
      u-mb12 u-mb0--900
    '
    pictureWrapper: "
      #{@BLOCK_CLASS}__picture-wrapper
      u-h0
    "
    header: '
      u-fs30 u-fs45--900 u-fs55--1200
      u-color-winter-2016--blue-alt
      u-ffs
      u-reset
      u-mb12
      u-fws
    '
    body: '
      u-fs16 u-fs18--600
      u-color-winter-2016--blue-alt-2
      u-lh24 u-lh26--900
      u-mla u-mra
      u-w10c u-w11c--900
    '
    subheader: '
      u-reset
      u-fs16 u-fs18--600 u-fws
      u-color-winter-2016--blue-alt-2
    '
    copyWrapper: "
      u-tac
      u-pa--600 u-l0--600 u-t0--600
      u-center--600
      #{@BLOCK_CLASS}__copy-wrapper
    "

  render: ->
    classes = @getClasses()
    pictureAttrs = @getPictureAttrs(classes)
    copy = @props.copy or {}

    <div className=classes.block>
      <div className=classes.pictureWrapper>
        <Picture children={@getPictureChildren(pictureAttrs)} />
      </div>
      <div className=classes.copyWrapper>
        <h1 children=copy.header className=classes.header />
        <p children=copy.body className=classes.body />
        <h2 children=copy.subheader className=classes.subheader />
      </div>
    </div>
