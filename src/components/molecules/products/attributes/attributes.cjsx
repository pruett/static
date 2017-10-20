[
  _
  React

  ColorSwatches

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/products/color_swatches_deprecated/color_swatches_deprecated'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-product-attributes'

  mixins: [
    Mixins.classes
    Mixins.product
  ]

  propTypes:
    activeColor: React.PropTypes.object
    addToFavoritesProps: React.PropTypes.object
    colors: React.PropTypes.array
    selectedVariantType: React.PropTypes.string

  getStaticClasses: ->
    block: '
      u-tac
      u-db
      u-pr
    '
    nameColorContainer: '
      u-mln6--960
    '
    eyebrow: '
      u-tac
      u-pb12
      u-ttu u-ls2_5
      u-ffss u-fs12 u-fws
      u-color--dark-gray-alt-3'
    displayName: '
      u-mt0 u-mb0
      u-pb6 u-pb12--1200
      u-ffs u-fws u-fs24 u-fs30--600 u-fs34--1200'
    color: '
      u-reset
      u-mt4 u-mt8--1200
      u-fsi u-ffs u-color--dark-gray-alt-2
      u-fs18--600
    '
    message: '
      u-mt0 u-mb18
      u-fs16--600
      u-color--dark-gray-alt-3
    '
    swatches: 'u-pr u-pr18 u-pl18 u-pl0--600 u-pr0--600'

  classesWillUpdate: ->
    color:
      'u-fs18': not @props.lensType

  formatDisplayName: (displayName) ->
    # Replace standard hyphens with non-breaking ones (U+2011).
    displayName.replace '-', '‑'

  render: ->
    classes = @getClasses()

    activeColor = @props.colors[@props.activeColorIndex]

    <span className=classes.block>
      {if activeColor.is_low_bridge_fit
        <div className=classes.eyebrow children='Low Bridge Fit' />
      }

      <h1 children={@formatDisplayName activeColor.display_name}
        className=classes.displayName />

      {if @props.lensType and not @props.hideMessage
        [
          <p
            key="messageMobile"
            className="#{classes.message} u-dn--600"
            children={"Including #{@props.lensType}"} />
          <p
            key="messageDesktop"
            className="#{classes.message} u-dn u-db--600"
            children={"Starting at $#{@props.lowestPrice}, including #{@props.lensType}"} />
        ]
      else unless @props.hideMessage
        <p
          className="#{classes.message} u-dn u-db--600"
          children={"Starting at $#{@props.lowestPrice}"} />}

      <div className=classes.nameColorContainer>

        <ColorSwatches
          cssModifier=classes.swatches
          activeFrameAssemblyIndex=@props.activeColorIndex
          frameAssemblies=@props.colors
          addToFavoritesProps=@props.addToFavoritesProps
          htoMode=@props.htoMode
          handleColorChange=@props.manageChangeColor />

        <h2
          className=classes.color
          children={@getColorDisplayName(activeColor, @props.selectedVariantType)} />

      </div>
    </span>
