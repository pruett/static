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

  require './hero.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-eyesun-hero'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-tac u-pr u-mra u-mla"
    wrapper:
      "#{@BLOCK_CLASS}__wrapper
      u-pb48 u-pb72--600 u-pb0--900
      u-grid -maxed u-mra u-mla
      u-bbw1 u-bbss u-bc--light-gray"
    copy:
      'u-grid__row
      u-mra u-mla'
    imagery:
      'u-mb48 u-mb72--600 u-mb0--900'
    picture:
      'u-db u-pr u-h0 u-ratio--1-1 u-ratio--3-2--600 u-ratio--2-1--900'
    image:
      'u-size--contain'
    title:
      'u-fs30 u-fs40--600 u-fs50--900 u-fs60--1200
      u-mb24 u-mb12--600
      u-grid__col u-w12c
      u-ffs u-fws'
    description:
      'u-fs16 u-fs18--900
      u-ffss
      u-grid__col u-w12c
      u-color--dark-gray-alt-3
      u-mb24'
    link:
      "#{@BLOCK_CLASS}__link
      u-button -button-medium -button-pair
      u-grid__col -c-4 -col-middle
      u-fs16
      u-ffss u-fws"

  render: ->
    pictureAttrs =
      sources: [
        quality: @getQualityBySize(@props.images, 'm')
        url: @getImageBySize(@props.images, 'm')
        widths: _.range 900, 2880, 200
        mediaQuery: '(min-width: 900px)'
        sizes: '(min-width: 1440px) 1440px, 100vw'
      ,
        quality: @getQualityBySize(@props.images, 's')
        url: @getImageBySize(@props.images, 's')
        widths: _.range 768, 2048, 200
        mediaQuery: '(min-width: 600px)'
      ,
        quality: @getQualityBySize(@props.images, 'xs')
        url: @getImageBySize(@props.images, 'xs')
        widths: _.range 320, 1500, 200
        mediaQuery: '(min-width: 0px)'
      ]
      img:
        alt: _.get @props, 'analytics.name', 'Eyeglasses/Sunglasses Hero'


    <Callout {...@props} cssModifiers={@getClasses()}
      pictureAttrs=pictureAttrs />
