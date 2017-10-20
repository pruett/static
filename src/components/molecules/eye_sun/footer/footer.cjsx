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

  require './footer.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-eyesun-footer'

  mixins: [
    Mixins.classes
  ]

  getStaticClasses: ->
    calloutBlock:
      "#{@BLOCK_CLASS}
      u-grid__row
      u-mla u-mra u-tac"
    calloutContent:
      'u-grid__col u-w12c'
    calloutCopy:
      'u-tac u-grid__row'
    calloutTitle:
      'u-reset u-fs24 u-fs30--600 u-fs34--900 u-fs40--1200
      u-grid__col u-w12c
      u-fws
      u-ffs
      u-pb24'
    calloutLink:
      'u-grid__col -c-8 -c-4--600 -c-2--900
      u-button -button-gray -button-medium -button-pair
      u-reset u-fs16
      u-ffss u-fws'

  render: ->
    classes = @getClasses()

    <Callout
      {...@props}
      variations={link: 'default'}
      cssUtilities={@pickClasses(classes, 'callout')} />

