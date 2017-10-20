[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './color_swatches.scss'
]

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
    handleColorChange: ->
    hiddenAssembiles: ''
    productPosition: null
    version: 'fans'
    analyticsCategory: 'Collection'
    gaListModifier: 'Collection'
    position: 0

  dispatchImpression: (impression) ->
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productImpression'
      products: impression
    @trackInteraction "colorSwatch-click-#{impression.id}"

  getBaseImpression: (product) ->
    #  Build an object holding data that doesn't concern gender/ids.
    name: product.name or product.display_name
    position: @props.position
    sku: product.sku
    color: product.color
    brand: 'Warby Parker'
    collections: [
      {
        slug: @props.gaCollectionSlug
      }
    ]
    list: @props.gaListModifier
    category: product.assembly_type

  getVersionedImpressions: (product) ->
    #  Find the gendered assembly, map its ID to the baseImpression.
    baseImpression = @getBaseImpression(product)

    if @props.version is 'men' or @props.version is 'women'
      #  Fallback for any instances in which the parent component might be passing
      #  'men' or 'women' as @props.version.
      genderLookup =
        men: 'm'
        women: 'f'

      genderedProduct = _.find product.gendered_details, gender: genderLookup["#{@props.version}"]
      baseImpression.id = genderedProduct.product_id
    else if @props.version is 'nonEyewear'
      baseImpression = _.assign baseImpression, { id: product.id, category: 'NonEyewear' }
    else
      genderedProduct = _.find product.gendered_details, gender: @props.version
      baseImpression.id = genderedProduct.product_id

    @dispatchImpression(baseImpression)

  getFansImpressions: (product) ->
    productImpressions = []

    baseImpression = @getBaseImpression(product)

    _.map product.gendered_details, (assembly) ->
      genderLookup =
        m: 'Men'
        f: 'Women'
      gender = genderLookup[assembly.gender]
      id = assembly.product_id
      genderedImpression = _.assign {}, baseImpression
      genderedImpression.gender = gender
      genderedImpression.id = id
      productImpressions.push genderedImpression

    _.forEach productImpressions, (impression) =>
      @dispatchImpression(impression)

  handleSwatchClick: (frameAssemblyIndex, product_id, evt) ->
    activeProduct = @props.frameAssemblies[frameAssemblyIndex]

    if @props.version is 'fans'
      @getFansImpressions(activeProduct)
    else
      @getVersionedImpressions(activeProduct)

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
        onClick: @handleSwatchClick.bind @, i, (frameAssembly.product_id or frameAssembly.id)

      if frameAssembly.color_swatch or frameAssembly.swatch_url
        swatchColor = frameAssembly.color_swatch or frameAssembly.swatch_url
        assembly = _.find frameAssembly.gendered_details,
          (detail) => return detail.gender is @props.version
        productId = if assembly then assembly.product_id else 0
        _.assign swatchProps,
          className: [
            classes.swatch
            '-active' if i is @props.activeFrameAssemblyIndex
          ].join ' '
          style: {backgroundImage: "url('#{swatchColor}')"}
      else
        _.assign swatchProps,
          className: [
            classes.swatch
            "-color-code-#{frameAssembly.color_code}"
            '-active' if i is @props.activeFrameAssemblyIndex
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
