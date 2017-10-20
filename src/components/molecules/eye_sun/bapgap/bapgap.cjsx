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

  require './bapgap.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-eyesun-bapgap'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  getStaticClasses: ->
    block:
      'u-mla u-mra u-tac'
    content:
      'u-grid__row'
    imagery:
      'u-grid__col -c-8 -c-3--600'
    picture:
      'u-db u-pr u-ratio--2-1'
    image:
      'u-size--fill'
    wrapper:
      'u-grid__col u-w12c'
    copy:
      'u-grid__row'
    title:
      'u-reset u-fs24 u-fs30--600 u-fs34--900 u-fs40--1200
      u-grid__col u-w12c -c-9--600 -c-12--900
      u-fws
      u-ffs
      u-pb24'
    link:
      'u-grid__col -c-8 -c-4--600 -c-2--900 -col-middle
      u-button -button-white -button-medium
      u-reset u-fs16
      u-ffss u-fws'

  render: ->
    pictureAttrs =
      sources: [
        quality: @getQualityBySize(@props.images, 'xs')
        url: @getImageBySize(@props.images, 'xs')
        widths: _.range 320, 1500, 200
        sizes: '50vw'
        mediaQuery: '(min-width: 0px)'
      ]
      img:
        alt: _.get @props, 'analytics.name', ''

    <Callout
      {...@props}
      pictureAttrs=pictureAttrs
      cssUtilities=@getClasses() />


