# Active experiments
# removeFilters
# galleryQuizPromo
[
  _
  Backbone

  BaseDispatcher
  Url
  Logger
] = [
  require 'lodash'
  require '../backbone/backbone'

  require './base_dispatcher'
  require '../utils/url'
  require '../logger'
]

log = Logger.get('FrameGalleryDispatcher').log

REGEX_PATH = /^\/(eyeglasses|sunglasses)\/(wo)?men\/?$/

widthRanges =
  eyeglasses:
    narrow: [0, 130]
    medium: [130.1, 137.9]
    wide: [138, Infinity]
  sunglasses:
    narrow: [0, 132]
    medium: [132.1, 139.9]
    wide: [140, Infinity]

class Filters extends Backbone.BaseModel
  defaults: ->
    activeFilters: {}
    clearFiltersAfter: null
    filtersList: []
    htoFilter: false

class GalleryEndpoint extends Backbone.BaseModel
  defaults: ->
    filters: {}
    frames: []
    framesCount: 0

class ContentEndpoint extends Backbone.BaseModel
  defaults: ->
    hero: null
    promos: []

class FrameGalleryDispatcher extends BaseDispatcher
  channel: -> 'frameGallery'

  mixins: -> [
    'cms'
  ]

  getGalleryEndpoint: (location) ->
    "/api/v2/cached/frames#{location.pathname}"

  getContentEndpoint: (location) ->
    path = @contentPath location
    "/api/v2/cached/variations#{path}#{@getVariationQueryString path}"

  contentPath: (location = @currentLocation()) ->
    "/gallery-content#{location.pathname}"

  getVariation: (resp) ->
    # Filter out experiment variation.
    @getContentVariation resp.variations

  setModels: ->
    location = @currentLocation()
    GalleryEndpoint::url = @getGalleryEndpoint location
    GalleryEndpoint::parse = (resp) =>
      if @inExperiment 'matchMultipleWidths', 'original'
        resp.frames.forEach (frame) =>
          (frame.products or []).forEach @__useOnlyPhysicalWidth

      return resp

    ContentEndpoint::url = @getContentEndpoint location
    ContentEndpoint::parse = @getVariation.bind(@)


  __useOnlyPhysicalWidth: (product) ->
    product.attributes.width = _.mapValues(
      (product.attributes.width or []),
      (v, widthRange) ->
        _.inRange product.width, _.get(widthRanges, "#{product.assembly_type}.#{widthRange}")...
    )

  models: ->
    @setModels()

    # Only fetch if page is correct.
    fetchOnWake = @currentLocation().pathname.match REGEX_PATH

    filters: new Filters
    gallery:
      class: GalleryEndpoint
      fetchOnWake: fetchOnWake
    content:
      class: ContentEndpoint
      fetchOnWake: fetchOnWake

  initialize: -> @updatePageTitle()

  shouldInitialize: ->
    @currentLocation().pathname.match REGEX_PATH

  getFiltersSummary: (filtersData) ->
    filters = _.map filtersData.filtersList, _.upperFirst
    size = _.size(filters)

    if size is 0
      ''
    else if size is 1
      "#{_.first filters} "
    else if size is 2
      "#{filters.join(' and ')} "
    else
      "#{_.take(filters, size - 1).join(', ')}, and #{_.last filters} "

  getAllowedFilters: (filters) ->
    allowedFilters = _.clone filters
    # Un-nest the 'fit' filters
    if 'fit' of filters
      _.assign allowedFilters, filters['fit']
      delete allowedFilters['fit']
    allowedFilters

  storeWillInitialize: ->
    location = @currentLocation()

    queryObject = _.assign {}, location.query # Prevents query mutation.
    allowedFilters = @getAllowedFilters @model('gallery').get('filters')
    activeFilters = Url.queryObjectToFilters queryObject, allowedFilters

    if @inExperiment 'removeFilters', 'noFilters'
      # Active filters disabled in experiment.
      activeFilters = {}

    filtersList = _.reduce activeFilters, (acc, filterItems) ->
      acc.concat filterItems
    , []

    htoFilter = @getFeature('homeTryOn') and (
      location.query.availability is 'hto' or @inHtoMode()
    )

    @model('filters').set(
      activeFilters: activeFilters
      filtersList: filtersList.sort()
      htoFilter: htoFilter
    )

    if htoFilter
      @commandDispatcher 'experiments', 'bucket', 'galleryQuizPromo'
    if location.query.availability is 'hto'
      @commandDispatcher 'cookies', 'enterHtoMode', 'htoGalleryView'
    else if @inHtoMode()
      @pushEvent 'htoMode-feature-filteredGallery'

  events: ->
    'sync gallery': @buildInitialStoreData
    'sync content': @buildInitialStoreData
    'change filters': @onFiltersChange

  getInitialStore: -> @buildStoreData()

  storeDidChange: (store) -> @updatePageTitle()

  updatePageTitle: ->
    @setPageTitle(
      REGEX_PATH
      "#{@store.filtersSummary}#{@store.pageTitle}"
    )

  getPageTitle: ->
    location = @currentLocation()
    gender = if location.pathname.match '/women' then 'Women' else 'Men'
    type = if location.pathname.match '/sun' then 'Sunglasses' else 'Eyeglasses'
    hto = if @model('filters').get('htoFilter') then ' Available for Home Try-On' else ''
    return "#{gender}'s #{type}#{hto}"

  buildStoreData: ->
    galleryData = @data('gallery')
    filtersData = @data('filters')
    contentData = @data('content')

    location = @currentLocation()

    _.assign __fetched: @model('gallery').isFetched(), filtersData,
      @filterFrames(filtersData)
      frames: galleryData.frames
      framesCount: galleryData.framesCount
      filters: galleryData.filters
      promos: contentData.promos
      hero: @filterHero(filtersData)
      pageTitle: @getPageTitle()
      filtersSummary: @getFiltersSummary(filtersData)
      gender: if location.pathname.match '/women' then 'women' else 'men'
      type: if location.pathname.match '/sun' then 'sunglasses' else 'eyeglasses'
      hasQuizResults: @hasGenderQuizResults(if location.pathname.match '/women' then 'f' else 'm')
      htoMode: @inHtoMode()

  buildInitialStoreData: -> @replaceStore @buildStoreData()

  rebuildStoreData: ->
    filtersData = @data('filters')

    @setStore _.assign filtersData, @filterFrames(filtersData),
      filtersSummary: @getFiltersSummary(filtersData)
      hero: @filterHero(filtersData)
      htoMode: @inHtoMode()
      pageTitle: @getPageTitle()

  activeCategoryCount: (activeFilters) ->
    _.reduce activeFilters, (count, categoryItems) ->
      count += if _.size(categoryItems) then 1 else 0
    , 0

  onFiltersChange: ->
    location = _.omit @currentLocation(), 'search'

    filters = Url.filtersToQueryObject @model('filters').get('activeFilters')
    # Custom handling for HTO filter, which doesn't conform to the structure
    # that Url.filtersToQueryObject deals in.
    if @model('filters').get('htoFilter')
      filters.availability = 'hto'

    allowedFilters = @getAllowedFilters @model('gallery').get('filters')
    filterCategories = Object.keys(allowedFilters).map _.camelCase

    location.query = _.assign(
      _.omit(location.query, filterCategories, 'availability')
      filters
    )

    @commandDispatcher 'routing', 'replaceState', Url.compile(location)

    clearTimeout @recalcFiltersTimeout
    @recalcFiltersTimeout = setTimeout @rebuildStoreData.bind(@), 750

  filterFrames: (filtersData) ->
    frames = @model('gallery').get('frames')
    promos = @model('content').get('promos')
    categoryFilterCount = 0
    visibleFrameCount = 0
    visiblePromoCount = 0
    maxFrameWidth = 0
    htoFilter = filtersData.htoFilter
    activeFilters = filtersData.activeFilters
    activeCategoryCount = @activeCategoryCount activeFilters
    noFilters = activeCategoryCount is 0 and not htoFilter
    productImpressions = []
    promoImpressions = []
    frameIndices = {}
    promoIndices = {}
    isProductHidden = {}

    @commandDispatcher('experiments', 'bucket', 'matchMultipleWidths') if activeFilters.width

    (frames or []).map (frame, index) =>
      productsHidden = ''
      if noFilters
        frameHidden = false
        visibleFrameCount++
        productImpressions.push _.assign frame.products[0], position: visibleFrameCount
        if frame.products[0].width > maxFrameWidth
          maxFrameWidth = frame.products[0].width
      else
        frameHidden = true
        (frame.products or []).map (product, index) =>
          if htoFilter and not product.hto_available
            productsHidden += index
            return

          categoryMatchCount = 0
          for category, categoryFilters of activeFilters
            for filterItem in categoryFilters
              lcFilterItem = filterItem.toLowerCase()
              if category of product.attributes
                if product.attributes[category][lcFilterItem]
                  categoryMatchCount++
                  break

          if categoryMatchCount is activeCategoryCount
            if frameHidden
              visibleFrameCount++
              frameHidden = false
              productImpressions.push _.assign product, position: visibleFrameCount
          else
            productsHidden += index

          if product.width > maxFrameWidth and not frameHidden
            maxFrameWidth = product.width

      frameIndices[index] = if frameHidden then 0 else visibleFrameCount
      isProductHidden[index] = productsHidden

    for promo, i in promos
      promoHidden = true
      if noFilters
        allPromoFiltersFalsy = _.every promo.filters, (value) ->
          (_.isArray(value) and _.isEmpty(value)) or not value

        if _.isEmpty(promo.filters) or allPromoFiltersFalsy
          promoImpressions.push promo
          promoHidden = false
      else
        # Figure out whether the currently active filters allow this promo
        promoFilters = promo.filters or {}
        activeNonHtoPromoFilters = _.pickBy promoFilters, (values, categoryName) ->
          categoryName isnt 'is_hto_available' and _.get(values, 'length', 0) > 0

        passesNonHtoFilters = _.size(activeNonHtoPromoFilters) > 0 and
          _.every activeNonHtoPromoFilters, (values, categoryName) ->
            _.intersection(values, _.get(activeFilters, categoryName, [])).length > 0

        if passesNonHtoFilters or (htoFilter and Boolean(promoFilters.is_hto_available))
          promoImpressions.push promo
          promoHidden = false

      promoIndices[i] = if promoHidden then -1 else promo.position

    if productImpressions.length
      @commandDispatcher 'analytics', 'pushProductEvent',
        type: 'productImpression'
        products: productImpressions
    if promoImpressions.length
      @commandDispatcher 'analytics', 'pushPromoEvent',
        type: 'promotionImpression'
        promos: promoImpressions

    frameIndices: frameIndices
    isProductHidden: isProductHidden
    maxFrameWidth: maxFrameWidth
    promoIndices: promoIndices
    visibleFrames: visibleFrameCount

  filterHero: (filtersData) ->
    # Get the currently active hero image
    heroData = @model('content').get('hero')
    htoFilter = filtersData.htoFilter

    if _.isArray(heroData)
      if htoFilter
        activeHero = _.find heroData, (hero) -> hero.limit_to_hto
      else
        activeHero = _.find heroData, (hero) -> not hero.limit_to_hto
      activeHero or= _.first heroData
    else
      # This is for backwards compatibility -- the old schema supplies this as an object,
      # not as an array of filterable heroes.
      activeHero = heroData

    return activeHero

  hasGenderQuizResults: (gender) ->
    gender is @getCookie 'hasQuizResults'

  commands:
    toggleFilter: (filter) ->
      activeFilters = @model('filters').get 'activeFilters'
      filtersList = @model('filters').get 'filtersList'

      if filter.active
        activeFilters[filter.category] or= []
        activeFilters[filter.category].push filter.name
        filtersList.unshift filter.name
      else
        _.pull activeFilters[filter.category], filter.name
        _.pull filtersList, filter.name

      if _.isEmpty(activeFilters[filter.category])
        delete activeFilters[filter.category]

      @model('filters').replace
        filtersList: filtersList
        activeFilters: activeFilters

    toggleHTOFilter: ->
      htoFilter = not @model('filters').get('htoFilter')
      if htoFilter
        @commandDispatcher 'cookies', 'enterHtoMode', 'galleryFilter'
        @commandDispatcher 'experiments', 'bucket', 'galleryQuizPromo'
      else
        @commandDispatcher 'cookies', 'leaveHtoMode', 'galleryFilter'
      @model('filters').set(htoFilter: htoFilter)

    clearFilters: ->
      @model('filters').replace
        activeFilters: {}
        filtersList: []
        clearFiltersAfter: Date.now()

module.exports = FrameGalleryDispatcher
