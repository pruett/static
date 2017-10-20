[
  _
  React

  GalleryFrame
  PromoBlock

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/products/gallery_frame_radio/gallery_frame_radio'
  require 'components/molecules/promo_block/promo_block'

  require 'components/mixins/mixins'

  require './frames_grid.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-frames-grid'

  mixins: [
    Mixins.classes
    Mixins.context
  ]

  getDefaultProps: ->
    cart: {}
    cssModifier: '-three-column'
    frameIndices: {}
    frames: []
    isFrameHidden: {}
    isProductHidden: {}
    maxFrameWidth: 0
    orderBy: 'default'
    promoIndices: {}
    promos: []
    showHtoQuickAdd: false
    visible: true

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-grid__row
      u-mt66 u-mt90--900 u-mt78--1200
      u-tac
    "
    container: "
      #{@BLOCK_CLASS}__container
      u-grid -maxed
      u-mra u-mla
    "

  classesWillUpdate: ->
    block:
      '-hidden': not @props.visible

  isLowBridgeFit: (item) ->
    _.get item, "products[0].attributes['nose bridge']['low bridge fit']", false

  getFramesProps: ->
    framesProps = _.map @props.frames, (item, i) =>
      hiddenProducts: @props.isProductHidden[i]
      isLowBridgeFit: @isLowBridgeFit item
      index: @props.frameIndices[i]
      key: _.get item, 'products[0].path'
      maxFrameWidth: @props.maxFrameWidth
      productPosition: _.get item, "order.#{@props.orderBy}"
      products: item.products

    _.sortBy framesProps, 'productPosition'

  renderGridItems: ->
    smallSwatch = @inExperiment 'swatchResize', 'small'

    # Get ordered frames, and update indices
    index = 1
    visibleFrameIndices = {}
    framesProps = _.map @getFramesProps(), (item, i) ->
      if item.index
        item.index = index++
        visibleFrameIndices[item.index] = i
      item
    firstVisible = _.findIndex framesProps, (f) -> f.index isnt 0

    gridItems = _.map framesProps, (frameProps, i) =>
      <GalleryFrame
        {...frameProps}
        cart=@props.cart
        favorites=@props.favorites
        firstFrame={firstVisible is i}
        maxFrameWidth=@props.maxFrameWidth
        showHtoQuickAdd=@props.showHtoQuickAdd
        showFavorites=@props.showFavorites
        smallSwatch=smallSwatch />

    # Insert active promos at the right position in the list of grid items
    # For correct positioning, must iterate over promos in ascending order of index
    promosWithIndices = _.sortBy(_.zip(@props.promos, @props.promoIndices), _.last)
    insertedPromoCount = 0
    for promoWithIndex, j in promosWithIndices
      promo = promoWithIndex[0]
      index = promoWithIndex[1]
      if index > -1
        insertedPromoCount++
        insertionIndex = _.get(
            visibleFrameIndices, index, gridItems.length
          ) - 1 + insertedPromoCount

        gridItems.splice insertionIndex, 0,
          <PromoBlock {...promo} key="promo-#{j}" index=index />

    return gridItems

  render: ->
    classes = @getClasses()

    <div className=classes.container>
      <div className=classes.block children=@renderGridItems() />
    </div>
