[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require '../color_swatches/color_swatches.scss'
]

#This component contains quite a lot of logic to handle legacy analytics/analytics in the markup
#Should be versioned or refactored
module.exports = React.createClass
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

  getDefaultProps: ->
    activeFrameAssemblyIndex: 0
    cssModifier: ''
    frameAssemblies: []
    gaCategory: 'Landing-Page'
    handleColorChange: ->
    hiddenAssembiles: ''
    productPosition: null
    version: 'fans'
    analyticsCategory: "colorSwatch"

  handleSwatchClick: (frameAssemblyIndex, product_id, evt) ->
    impressionProduct = if _.isFinite(@props.productPosition)
        _.assign {}, @props.frameAssemblies[frameAssemblyIndex], position: @props.productPosition
      else
        @props.frameAssemblies[frameAssemblyIndex]
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productImpression'
      products: [impressionProduct]
    #TODO the below will never fire, as an assembly won't ever have an id, this needs to be versioned or refactored
    @trackInteraction("colorSwatch-click-#{product_id}", evt) if product_id
    @props.handleColorChange(frameAssemblyIndex)

  getStaticClasses: ->
    block: [
      @BLOCK_CLASS
      @props.cssModifier
    ]
    swatch: [
      "#{@BLOCK_CLASS}__swatch"
      'u-button-reset'
    ]

  render: ->
    classes = @getClasses()

    swatches = _.map @props.frameAssemblies, (frameAssembly, i) =>
      swatchProps =
        key: i
        #TODO the below needs to be refactored, ideally to pass in the product SKU instead of ID
        #Products don't have IDs as they aren't gendered
        onClick: @handleSwatchClick.bind @, i, (frameAssembly.product_id or frameAssembly.id)

      if frameAssembly.swatch_url
        _.assign swatchProps,
          className: [
            classes.swatch
            '-active' if i is @props.activeFrameAssemblyIndex
            '-hidden' if @props.hiddenAssembiles.indexOf(i) isnt -1
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

    <div children=swatches
      role='menu'
      aria-label='Frame colors'
      aria-controls=@props.swatchAriaControls
      className=classes.block />
