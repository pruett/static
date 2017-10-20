React = require 'react/addons'
_ = require 'lodash'

Picture = require 'components/atoms/images/picture/picture'

Mixins = require 'components/mixins/mixins'

Img = require 'components/atoms/images/img/img'

require './hero.scss'

module.exports = React.createClass

  mixins: [
    Mixins.image
    Mixins.dispatcher
    Mixins.analytics
    Mixins.classes
  ]

  propTypes:
    content: React.PropTypes.object
    copy: React.PropTypes.string
    label: React.PropTypes.object

  getDefaultProps: ->
    content: {}
    copy: ''
    label: ''


  BLOCK_CLASS: 'c-leith-clark-hero'

  getStaticClasses: ->
    block: '
      u-pr
      u-mb48 u-mb96--900
    '
    image: '
      u-w100p
    '
    grid: '
      u-grid -maxed
      u-mla u-mra
    '
    gridLabel: '
      u-grid -maxed
      u-pa u-l0 u-b0
      u-pb18
    '
    copy: '
      u-reset
      u-fs18
      u-lh28
      u-w11c u-w8c--600 u-w11c--900 u-w10c--1200
      u-mla u-mra
      u-mb24--600
    '
    labelWrapper: '
      u-color--white
      u-fs16
    '
    frameName: '
      u-ffs
      u-fwb
    '
    frameColor: '
      u-ffs
      u-fsi
    '
    logo: '
      u-w8c u-12c--600 u-w8c--1200
      u-mt36 u-mb24
    '
    copyBox: "
      #{@BLOCK_CLASS}__copy-box
      u-w11c u-w10c--600 u-w4c--900
      u-tac
      u-color-bg--white
      u-pa--900 u-t0--900 ul0--900
      u-center-y--900
      u-pl24--900 u-pr24--900
      u-mla u-mra
      u-pt24--900 u-pb24--900
      u-pt48--1200 u-pb48--1200
    "

  getLogoAttrs: ->
    images = @props.logo

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
      alt: 'Warby Parker x Leith Clark'
      className: @classes.logo

  getPictureAttrs: ->
    images = @props.image

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
      alt: 'Warby Parker x Leith Clark'
      className: @classes.image

  render: ->
    @classes = @getClasses()
    pictureAttrs = @getPictureAttrs()
    logoAttrs = @getLogoAttrs()
    label = _.get @props, 'label', {}

    <div className=@classes.block>
      <div>
        <Picture children={@getPictureChildren(pictureAttrs)} />
        <div className=@classes.gridLabel>
          <div className=@classes.row>
            <div className=@classes.labelWrapper>
              <span children=label.name className=@classes.frameName />
              <span children=label.color className=@classes.frameColor />
            </div>
          </div>
        </div>
      </div>
      <div className=@classes.copyBox>
        <Picture children={@getPictureChildren(logoAttrs)} />
        <p children=@props.copy
           className=@classes.copy />
      </div>
    </div>
