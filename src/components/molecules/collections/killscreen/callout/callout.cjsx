[
  _
  React

  Picture

  Mixins

] = [

  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/picture/picture'

  require 'components/mixins/mixins'

  require './callout.scss'

]

module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  BLOCK_CLASS: 'c-killscreen-callout'

  getDefaultProps: ->
    header: ''
    copy: ''
    top_image: []
    bottom_image: []

  propTypes:
    header: React.PropTypes.string
    copy: React.PropTypes.string
    top_image: React.PropTypes.array
    bottom_image: React.PropTypes.array

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-mb72
      u-mb120--600
      u-mb140--900
      u-mw2000
      u-mla u-mra
    "
    backgroundImage: '
      u-w100p
    '
    grid: '
      u-grid
      u-mb72 u-mb120--600 u-mb180--900
    '
    row: '
      u-grid__row
      u-tac
    '
    column: '
      u-grid__col u-w11c u-w9c--600
      u-tac
    '
    header: '
      u-fs20 u-fs36--900
      u-fws
      u-reset
      u-mb24
      u-mb36--600
      u-mb48--900
    '
    copy: '
      u-fs18
      u-reset
      u-lh26
    '
    topImage: '
      u-w12c u-w5c--600 u-w5c--900
      u-mr12--600
      u-dib
    '
    bottomImage: "
      #{@BLOCK_CLASS}__bottom-image
      u-w12c u-w5c--600 u-w5c--900
      u-ml12--600
      u-dib
      u-pr
    "
    imageWrapper: '
      u-w12c u-w10c--600
      u-tac
      u-mla u-mra
    '

  getPictureAttrs: (image) ->
    images = @props["#{image}"]

    sources: [
      url: @getImageBySize(images, 'desktop-sd')
      quality: @getQualityBySize(images, 'desktop-sd')
      widths: _.range 800, 1200, 100
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 'tablet')
      quality: @getQualityBySize(images, 'tablet')
      widths: _.range 400, 800, 100
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'mobile')
      quality: @getQualityBySize(images, 'mobile')
      widths: _.range 320, 700, 100
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Killscreen Collection'
      className: @classes["#{_.camelCase image}"]

  render: ->
    @classes = @getClasses()
    topPictureAttrs = @getPictureAttrs('top_image')
    bottomPictureAttrs = @getPictureAttrs('bottom_image')

    <div className=@classes.block>
      <div className=@classes.grid>
        <div className=@classes.row>
          <div className=@classes.column>
            <h1 children=@props.header className=@classes.header />
            <p children=@props.copy className=@classes.copy />
          </div>
        </div>
      </div>
      <div className=@classes.imageWrapper>
          <Picture children={@getPictureChildren(topPictureAttrs)} />
          <Picture children={@getPictureChildren(bottomPictureAttrs)} />
      </div>
    </div>
