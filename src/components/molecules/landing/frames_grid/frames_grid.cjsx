[
  _
  React

  CoreFrame

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/landing/frame/frame'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-landing-frames-grid'

  mixins: [
    Mixins.classes
    Mixins.context
  ]

  getDefaultProps: ->
    version: 'fans'
    cssModifier: ''
    cssModifierColorName: ''
    cssModifierFrameName: ''
    cssModifierImagesContainer: ''
    gaListModifier: ''
    defaultPosition: 1

  getStaticClasses: ->
    block: "
      #{@props.cssModifier}
      u-tac
    "
    container: '
      u-grid -maxed
      u-mla u-mra
    '
    gridRow: '
      u-grid__row
    '
    hr: '
      u-bc--light-gray u-bw0 u-bbw1 u-bss
      u-mb48 u-mb60--600 u-mb84--900
    '

  render: ->
    classes = @getClasses()
    # CoreFrame uses abbreviations for men's and women's versions
    frameVersion = {men: 'm', women: 'f', fans: 'fans'}[@props.version]
    frames = _.map @props.frames, (frame, i) =>
      frameProps =
        key: i
        useTextColors: @props.useTextColors
        listModifier: @props.listModifier
        position: @props.defaultPosition + i
        useTextColors: @props.useTextColors
        products: frame.products
        version: frameVersion
        cssModifierFrameName: @props.cssModifierFrameName
        cssModifierColorName: @props.cssModifierColorName
        cssModifierImagesContainer: @props.cssModifierImagesContainer
        gaListModifier: @props.gaListModifier
        columnModifier: @props.columnModifier
        cssModifierShopLinks: @props.cssModifierShopLinks

      <CoreFrame {...frameProps} />

    <div className=classes.container>
      {
        if @props.topBorder
          <hr className=classes.hr />
      }
      <div className=classes.gridRow>
        <div className=classes.block children=frames />
      </div>
    </div>
