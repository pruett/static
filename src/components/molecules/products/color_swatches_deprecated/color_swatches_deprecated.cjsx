[
  _
  React

  AddToFavorites

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/products/add_to_favorites/add_to_favorites'

  require 'components/mixins/mixins'

  require '../color_swatches/color_swatches.scss'
]

module.exports = React.createClass
  #This is now deprecated as it contains a lot of inline/legacy analytics

  BLOCK_CLASS: 'c-color-swatches'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes: ->
    activeFrameAssemblyIndex: React.PropTypes.number
    cssModifier: React.PropTypes.string
    frameAssemblies: React.PropTypes.arrayOf React.PropTypes.object
    gaCategory: React.PropTypes.string
    handleColorChange: React.PropTypes.func
    productPosition: React.PropTypes.number
    version: React.PropTypes.string
    addToFavoritesProps: React.PropTypes.object

  getDefaultProps: ->
    activeFrameAssemblyIndex: 0
    cssModifier: ''
    frameAssemblies: []
    gaCategory: 'Landing-Page'
    handleColorChange: ->
    hiddenAssembiles: ''
    htoMode: false
    productPosition: null
    version: 'fans'
    analyticsCategory: "colorSwatch"

  handleSwatchClick: (frameAssemblyIndex, product_id, evt) ->
    @props.handleColorChange(frameAssemblyIndex)

    _.defer =>
      impressionProduct = if _.isFinite(@props.productPosition)
          _.assign {}, @props.frameAssemblies[frameAssemblyIndex], position: @props.productPosition
        else
          @props.frameAssemblies[frameAssemblyIndex]
      @commandDispatcher 'analytics', 'pushProductEvent',
        type: 'productImpression'
        products: [impressionProduct]
      @trackInteraction("colorSwatch-click-#{product_id}", evt) if product_id

  getStaticClasses: ->
    block: [
      @BLOCK_CLASS
      @props.cssModifier
    ]
    swatch: [
      "#{@BLOCK_CLASS}__swatch"
      'u-button-reset'
    ]

  classesWillUpdate: ->
    block:
      'u-pr': @props.addToFavoritesProps

  render: ->
    classes = @getClasses()

    swatches = _.map @props.frameAssemblies, (frameAssembly, i) =>
      swatchProps =
        key: i
        onClick: @handleSwatchClick.bind @, i, (frameAssembly.product_id or frameAssembly.id)

      if frameAssembly.swatch_url
        htoVariant = _.get frameAssembly, 'variants.hto', {}
        htoInStock = _.isMatch htoVariant, active: true, in_stock: true
        _.assign swatchProps,
          className: [
            classes.swatch
            '-active' if i is @props.activeFrameAssemblyIndex
            '-hidden' if @props.hiddenAssembiles.indexOf(i) isnt -1
            '-disabled' if @props.htoMode and not htoInStock
          ].join ' '
          style:
            backgroundImage: "url(#{frameAssembly.swatch_url})"

      else if frameAssembly.color_swatch
        assembly = _.find frameAssembly.gendered_details,
          (detail) => return detail.gender is @props.version
        productId = if assembly then assembly.product_id else 0
        _.assign swatchProps,
          className: [
            classes.swatch
            '-active' if i is @props.activeFrameAssemblyIndex
            'js-ga-click'
          ].join ' '
          style: {backgroundImage: "url('#{frameAssembly.color_swatch}')"}

      else
        _.assign swatchProps,
          className: [
            classes.swatch
            "-color-code-#{frameAssembly.color_code}"
            '-active' if i is @props.activeFrameAssemblyIndex
            'js-ga-click'
          ].join ' '

      if frameAssembly.color
        _.assign swatchProps,
          'aria-label': frameAssembly.color
          'role': 'menuitemradio'
          'aria-checked': i is @props.activeFrameAssemblyIndex

      <button {...swatchProps} />

    <div
      role='menu'
      aria-label='Frame colors'
      aria-controls=@props.swatchAriaControls
      className=classes.block>
      {swatches}
      {<AddToFavorites {...@props.addToFavoritesProps} /> if @props.addToFavoritesProps}
    </div>
