[
  _
  React

  Callout

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/callout/callout'

  require 'components/mixins/mixins'

  require './try_before_buy.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-eyesun-try-before-buy'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  getDefaultProps: ->
    heading: ''
    callouts: []

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-tac"
    heading:
      'u-ffs u-fws
      u-reset u-fs24 u-fs30--600 u-fs34--900 u-fs40--1200
      u-pb48'
    row:
      'u-grid__row'
    calloutBlock:
      "#{@BLOCK_CLASS}__callout
      u-grid__col u-w12c -c-6--600"
    calloutCopy:
      'u-tac'
    calloutImagery:
      'u-mb60'
    calloutPicture:
      'u-db u-pr u-ratio--3-2'
    calloutImage:
      'u-size--fill'
    calloutTitle:
      'u-fs26
      u-fws
      u-ffs
      u-pb24'
    calloutDescription:
      'u-reset u-fs16 u-fs18--900
      u-pl24 u-pr24 u-pb24 u-pb36--900
      u-color--dark-gray-alt-3
      u-fwn'
    calloutLink:
      "#{@BLOCK_CLASS}__link
      u-dib
      u-valign--top
      u-color--blue
      u-bbss u-bbw1 u-bc--white
      u-reset u-fs16 u-fs18--900
      u-fws
      u-pb6
      u-ml18 u-mr18"

  renderCollection: (collection, i) ->
    pictureAttrs =
      sources: [
        quality: @getQualityBySize(collection.images, 'xs')
        url: @getImageBySize(collection.images, 'xs')
        widths: _.range 320, 1500, 200
        sizes: '50vw'
        mediaQuery: '(min-width: 0px)'
      ]
      img:
        alt: _.get collection, 'analytics.name', ''

    <Callout {...collection}
      key=i
      linkTarget=@props.linkTarget
      pictureAttrs=pictureAttrs
      cssUtilities={@pickClasses(@classes, 'callout')} />

  render: ->
    @classes = @getClasses()

    <div className=@classes.block>
      { if @props.heading then <h2 className=@classes.heading children=@props.heading /> }
      <div className=@classes.row>
        { _.map @props.collections, @renderCollection }
      </div>
    </div>
