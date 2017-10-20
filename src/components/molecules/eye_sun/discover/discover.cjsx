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

  require './discover.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-eyesun-discover'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  getDefaultProps: ->
    collections: {}

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    heading:
      'u-grid__col -c-12 -c-8--600 -c-12--900
      u-tac
      u-ffs
      u-fws
      u-reset u-fs24 u-fs30--600 u-fs34--900 u-fs40--1200 u-pb48'
    calloutBlock:
      "#{@BLOCK_CLASS}__callout-block
      u-pr
      u-mb48 u-mla u-mra"
    calloutContent:
      'u-grid__row u-tac u-tal--900'
    calloutImagery:
      'u-grid__col u-w12c -c-7--900 -col-middle
      u-mb36 u-mb0--900'
    calloutPicture:
      'u-db
      u-pr
      u-ratio--3-2'
    calloutImage:
      'u-size--fill'
    calloutWrapper:
      'u-grid__col u-w12c -c-8--600 -c-5--900 -col-middle'
    calloutTitle:
      'u-reset u-fs24 u-fs30--600 u-fs34--900 u-fs40--1200
      u-pb12
      u-fws
      u-ffs'
    calloutDescription:
      'u-reset u-fs16 u-fs18--900
      u-color--dark-gray-alt-3
      u-ffss
      u-pb36'
    calloutLink:
      'u-grid__col -c-8 -c-4--600
      u-button -button-gray -button-medium
      u-reset u-fs16
      u-ffss u-fws'

  renderCollection: (collection, i) ->
    pictureAttrs =
      sources: [
        quality: @getQualityBySize(collection.images, 'xs')
        url: @getImageBySize(collection.images, 'xs')
        widths: _.range 320, 1500, 200
        sizes: '(min-width: 900px) 47vw, 100vw'
        mediaQuery: '(min-width: 0px)'
      ]
      img:
        alt: _.get collection, 'analytics.name', ''

    <Callout {...collection}
      key=i
      pictureAttrs=pictureAttrs
      variations={link: 'default'}
      cssUtilities={@pickClasses(@classes, 'callout')} />

  render:  ->
    @classes = @getClasses()

    <div className=@classes.block>
      <h2 className=@classes.heading children=@props.heading />

      { _.map @props.collections, @renderCollection }

    </div>
