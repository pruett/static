[
  _
  React

  IconX
  Input
  ListFrame

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/x/x'
  require 'components/atoms/forms/input/input'
  require 'components/molecules/products/list_frame/list_frame'

  require 'components/mixins/mixins'

  require './frame_search.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-frame-search'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    frames: React.PropTypes.array

  getDefaultProps: ->
    analyticsCategory: 'searchModal'
    filters: {}
    frames: []
    htoMode: false
    manageClose: ->
    manageChange: ->
    emptyMessage: 'Hm. Doesn’t look like we carry a frame by that name'
    makeSuggestionOnEmpty: true
    query: ''
    searchableProps: ['display_name']
    title: ''

  getInitialState: ->
    filteredProducts: []
    isDeleting: false

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    grid: "
      #{@BLOCK_CLASS}__grid
      u-grid -maxed
    "
    label: "
      #{@BLOCK_CLASS}__label
      u-reset u-ffss  u-fs12 u-ls2_5 u-ttu
    "
    input: "
      #{@BLOCK_CLASS}__input
      u-reset u-ffs
      u-color-bg--white-0p
    "
    close: "
      #{@BLOCK_CLASS}__close
    "
    cancel: "
      #{@BLOCK_CLASS}__cancel
    "
    iconX: "
      #{@BLOCK_CLASS}__icon-x
    "
    divider: "
      #{@BLOCK_CLASS}__divider
      u-hr
    "
    results: "
      #{@BLOCK_CLASS}__results
      u-grid__row
    "
    message: "
      #{@BLOCK_CLASS}__message
      u-reset u-ffs u-fs16 u-fs24--600
      u-color--dark-gray-alt-2
    "

  componentWillReceiveProps: (nextProps) ->
    @filterFrames nextProps.query

  componentWillMount: ->
    @filterFrames @props.query

  componentDidMount: ->
    input = React.findDOMNode @refs.searchInput
    input.focus()
    input.setSelectionRange @props.query.length, @props.query.length

  productsMatchingQuery: (products, query) ->
    filteredProducts = []
    _.map products, (product) =>
      for prop in @props.searchableProps
        value = _.get product, prop
        return unless value
        value = value.toLowerCase()
        if value.indexOf(query) is 0 or
           value.indexOf(" #{query}") isnt -1
          filteredProducts.push product
          return

    if @props.htoMode
      # Reorder results so out of stock HTO frames are last
      filteredProducts.sort (a, b) ->
        if a.hto_available is b.hto_available
          0
        else if a.hto_available
          -1
        else
          1

    filteredProducts

  filterFrames: (currentQuery) ->
    query = currentQuery.toLowerCase()
    filteredProducts = []
    if @state.filteredProducts.length and
       query.length > @props.query.length
      filteredProducts =
        @productsMatchingQuery @state.filteredProducts, query

    else if query.length
      frames = _.flatten(_.map @props.frames, (frame) -> frame.products)
      filteredProducts = @productsMatchingQuery frames, query

    @setState filteredProducts: filteredProducts

  manageProductClick: (product, evt) ->
    @trackInteraction [
      @props.analyticsCategory
      'clickProduct'
      product.product_id
      @props.query.toLowerCase()
    ].join '-'
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      eventMetadata:
        list: @props.analyticsCategory
      products: product

  handleClose: (evt) ->
    @trackInteraction [
      @props.analyticsCategory
      'click'
      'closeButton'
      @props.query.toLowerCase()
    ].join '-'
    @props.manageClose evt

  handleChange: (evt) ->
    value = evt.target.value
    if value.length > @props.query.length
      @setState isDeleting: false
    else if not @state.isDeleting
      @setState isDeleting: true
      @trackInteraction [
        @props.analyticsCategory
        'delete'
        'inputField'
        @props.query.toLowerCase()
      ].join '-'
    @props.manageChange evt

  # The string fuzzy matching in this component is a quick-and-dirty version
  # taken from http://stackoverflow.com/a/23305385. Down the road it may
  # be worth switching to http://fusejs.io
  getBigrams: (rawStr) ->
    str = rawStr.toLowerCase()
    bigrams = new Array(str.length - 1)
    for i in [0..bigrams.length] by 1
      bigrams[i] = str.slice(i, i + 2)
    bigrams

  stringSimilarity: (str1, str2) ->
    if str1.length > 0 and str2.length > 0
      pairs1 = @getBigrams str1
      pairs2 = @getBigrams str2
      union = pairs1.length + pairs2.length
      hitCount = 0
      for x in pairs1
        for y in pairs2
          if x is y
            hitCount++
      if hitCount > 0
        return (2 * hitCount) / union
    return 0

  getFlattenedFilterGroups: (groups) ->
    filterGroups = {}
    _.forEach groups, (filters, groupName) =>
      if _.isArray(filters)
        filterGroups[groupName] = filters
      else
        _.assign filterGroups, @getFlattenedFilterGroups(filters)
    filterGroups

  getFilterRecommendation: (query) ->
    flattenedFilterGroups = @getFlattenedFilterGroups @props.filters
    topResult =
      group: null
      name: null
      relevance: 0
    for groupName, filters of flattenedFilterGroups
      for filterName in filters
        relevance = @stringSimilarity query, filterName
        if relevance > topResult.relevance
          topResult =
            group: groupName
            name: filterName
            relevance: relevance
    topResult

  renderEmptyMessage: ->
    emptyMessage = "#{@props.emptyMessage} in #{@props.title}."
    if @props.makeSuggestionOnEmpty
      recommendedFilter = @getFilterRecommendation @props.query
      if recommendedFilter.group and recommendedFilter.name
        currentPath = _.get @requestDispatcher('routing', 'location'), 'pathname'
        if currentPath
          emptyMessage =
            <div>
              {"#{emptyMessage} How about seeing "}
              <a href="#{currentPath}?#{
                _.camelCase recommendedFilter.group}=#{_.camelCase recommendedFilter.name}"
                children="every #{recommendedFilter.name} frame?"
              />
            </div>
    emptyMessage

  renderFrame: (product) ->
    <ListFrame
      key="product-#{product.product_id}"
      handleProductClick={@manageProductClick.bind(@, product)}
      htoMode=@props.htoMode
      product=product />

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <div className=classes.grid>
        <div className=classes.label children="Search #{@props.title}" />
        <Input
          ref='searchInput'
          className=classes.input
          placeholder='Frame name'
          onChange=@handleChange
          value=@props.query />
        <a className=classes.close onClick=@handleClose>
          <span className=classes.cancel children='Cancel' />
          <IconX cssModifier=classes.iconX />
        </a>
      </div>
      <hr className=classes.divider />
      <div className=classes.grid>
        {if @state.filteredProducts.length is 0 and @props.query.length > 0
          <div className=classes.message children=@renderEmptyMessage() />
        else
          <div
            className=classes.results
            children={_.map @state.filteredProducts, @renderFrame} />}
      </div>
    </div>
