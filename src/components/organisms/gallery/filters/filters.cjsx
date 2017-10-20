[
  _
  React

  Checkbox
  CTA
  FilterCheckbox
  IconAdd
  IconFilter
  IconSearch
  IconX

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/forms/checkbox/checkbox'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/filter_checkbox/filter_checkbox'
  require 'components/quanta/icons/add_check/add_check'
  require 'components/quanta/icons/filter/filter'
  require 'components/quanta/icons/search/search'
  require 'components/quanta/icons/x/x'

  require 'components/mixins/mixins'

  require './filters.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-gallery-filters'
  BREAKPOINT_MOBILE: '768'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
    Mixins.scrolling
  ]

  getInitialState: ->
    expandedFilter: null
    enableStickyFilter: false
    htoChecked: @props.htoChecked

  componentDidMount: ->
    return unless @props.isSticky

    @addScrollListener @checkStickyFilter

    @setState enableStickyFilter: @enableStickyFilter()

  componentDidUpdate: (prevProps, prevState) ->
    return unless @props.isSticky
    @checkStickyFilter()

  checkStickyFilter: ->
    return unless @props.isSticky

    enableStickyFilter = @enableStickyFilter()
    if enableStickyFilter isnt @state.enableStickyFilter
      @setState enableStickyFilter: enableStickyFilter

  enableStickyFilter: ->
    # If offscreen, enable sticky.
    rect = React.findDOMNode(@refs['dummy'])?.getBoundingClientRect()
    if rect then ( rect.top <= 0 or rect.bottom <= 0 ) else false

  scrollToFilters: (callback = ->) ->
    return callback() unless @enableStickyFilter() and @props.isSticky

    # Scroll to node only if it already isn't on screen.
    dummy = React.findDOMNode @refs['dummy']
    @scrollToNode dummy, { time: 300, callback: callback, offset: 1 }

  getDefaultProps: ->
    activeFilters: {}
    clearFiltersAfter: null
    filters: {}
    filtersList: []
    framesCount: 0
    htoChecked: false
    isInline: false
    isSticky: false
    visibleFrames: 0
    manageFilterChange: ->
    manageHtoFilterChange: ->
    handleSearch: ->

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    container: "
      #{@BLOCK_CLASS}__container
      u-mw1440
      u-mra u-mla
    "
    containerFilters: "
      #{@BLOCK_CLASS}__container-filters
    "
    filterBar: "
      #{@BLOCK_CLASS}__filter-bar
    "
    filterHeader: "
      #{@BLOCK_CLASS}__filter-header
    "
    filterGroups: "
      #{@BLOCK_CLASS}__filter-groups
    "
    filterGroupsContainer: "
      #{@BLOCK_CLASS}__filter-groups-container
    "
    filterGroup: "
      #{@BLOCK_CLASS}__filter-group
    "
    filterGroupContainer: "
      #{@BLOCK_CLASS}__filter-group-container
    "
    containerLeft: "
      #{@BLOCK_CLASS}__container-left
    "
    containerRight: "
      #{@BLOCK_CLASS}__container-right
    "
    buttonsBar: "
      #{@BLOCK_CLASS}__buttons-bar
      u-db u-dn--768
    "
    htoCheckbox: "
      #{@BLOCK_CLASS}__hto-checkbox
    "
    searchButton: "
      #{@BLOCK_CLASS}__button
      #{@BLOCK_CLASS}__button--search
    "
    filterButton: "
      #{@BLOCK_CLASS}__button
      #{@BLOCK_CLASS}__button--filter
    "
    searchIcon: "
      #{@BLOCK_CLASS}__search-icon
    "
    searchFramesText: "
      #{@BLOCK_CLASS}__search-frames-text
    "
    filterFramesTextFrames: "
      #{@BLOCK_CLASS}__filter-frames-text--frames
    "
    filterIcon: "
      #{@BLOCK_CLASS}__filter-icon
    "
    containerActiveFilters: "
      #{@BLOCK_CLASS}__container-active-filters
      u-dn u-db--768
    "
    resetLink: "
      #{@BLOCK_CLASS}__reset-link
    "
    modal: "
      #{@BLOCK_CLASS}__modal
    "
    modalHeader: "
      #{@BLOCK_CLASS}__modal-header
    "
    modalClose: "
      #{@BLOCK_CLASS}__modal-close
    "
    iconX: "
      #{@BLOCK_CLASS}__icon-x
    "
    modalFooter: "
      #{@BLOCK_CLASS}__modal-footer
    "
    modalFooterText: "
      #{@BLOCK_CLASS}__modal-footer-text
    "
    clearFilters: "
      #{@BLOCK_CLASS}__clear-filters
    "
    CTA: "
      #{@BLOCK_CLASS}__cta
    "
    filterGroupLabel: "
      #{@BLOCK_CLASS}__filter-group-label
      u-ls1_5 u-fs12 u-pb18
    "
    filterCount: "
      #{@BLOCK_CLASS}__filter-count
    "
    dummy: "
      #{@BLOCK_CLASS}__dummy
    "
    viewing: "
      u-color--dark-gray
      u-dn u-db--768
    "

  classesWillUpdate: ->
    block:
      '-expanded': @state.expandedFilter?
      '-enabled': @state.enableStickyFilter
      "#{@BLOCK_CLASS}--inline": @props.isInline and @state.enableStickyFilter
      "#{@BLOCK_CLASS}--sticky": @props.isSticky
    container:
      '-expanded': @state.expandedFilter?
      '-enabled': @state.enableStickyFilter
      '-show-reset': @props.filtersList.length
    dummy:
      '-expanded': @state.expandedFilter?
      '-enabled': @state.enableStickyFilter
      '-inline': @props.isInline
      '-show-reset': @props.filtersList.length
    containerFilters:
      '-expanded': @state.expandedFilter?
    modal:
      '-expanded': @state.expandedFilter?
    containerActiveFilters:
      '-expanded': @state.expandedFilter?
    filterGroups:
      '-hidden': @state.expandedFilter is null
    filterGroupsContainer:
      '-hidden': @state.expandedFilter is null
    containerLeft:
      '-hidden-mobile': @state.expandedFilter?
    clearFilters:
      '-disabled': not @props.filtersList.length
    filterBar:
      'u-dn u-dib--768': not @state.expandedFilter
      'u-dt u-dib--768': @state.expandedFilter
    searchButton:
      '-hidden-mobile': @props.isInline and @state.enableStickyFilter

  getActiveFiltersString: ->
    if @props.visibleFrames is 0
      'Sorry, there are no products matching the selections.'
    else
      @props.filtersSummary

  handleHeaderFilterClick: (event) ->
    clickCategory = event.target.dataset.name
    currCategory = @state.expandedFilter
    expanded = if clickCategory isnt currCategory then clickCategory else null
    @setState expandedFilter: expanded
    if @getWindowWidth() < @BREAKPOINT_MOBILE
      @commandDispatcher 'layout', if expanded then 'showTakeover' else 'hideTakeover'

    action = if expanded then 'expand' else 'collapse'
    @trackInteraction "gallery-#{action}-#{clickCategory}#{@getFilterButtonState()}", event

  handleFilterClick: ->
    @setState expandedFilter: 'color'
    @commandDispatcher 'layout', 'showTakeover'

  getFilterButtonState: ->
    if @state.enableStickyFilter then '-sticky' else ''

  collapseFilters: (event) ->
    @setState expandedFilter: null
    @commandDispatcher 'layout', 'hideTakeover'
    @trackInteraction 'gallery-collapse-filters', event

  clearFilters: (event) ->
    e = _.clone event
    @scrollToFilters =>
      e.preventDefault()
      @props.manageFilterChange()
      @commandDispatcher 'frameGallery', 'clearFilters'
      @trackInteraction 'gallery-clear-filters', e

  handleHtoFilter: (event) ->
    e = _.clone event
    checked = _.get e, 'target.checked', false
    @scrollToFilters =>
      @setState htoChecked: not @state.htoChecked
      @props.manageHtoFilterChange(checked)
      @commandDispatcher 'frameGallery', 'toggleHTOFilter'
      # For Quiz Promo test
      if checked and @inExperiment 'galleryQuizPromo', 'new'
        @scrollToNode React.findDOMNode(@refs['filters']),
          time: 300
          offset: -1
      action = if checked then 'check' else 'uncheck'
      @trackInteraction "gallery-#{action}-hto#{@getFilterButtonState()}", e

  getWindowWidth: ->
    window.innerWidth or _.get(document, 'documentElement.clientWidth')

  handleFilterChange: (filter) ->
    @props.manageFilterChange()
    @commandDispatcher 'frameGallery', 'toggleFilter', filter
    @scrollToFilters()

  render: ->
    classes = @getClasses()

    htoCheck =
      id: 'gallery-filter-hto'
      cssModifier: classes.htoCheckbox
      cssModifierBox: '-border-light-gray'
      cssModifierInput: '-align-middle'
      txtLabel: 'Available for Home\u00a0Try-On' # Never break HTO.
      isToggle: true
      disabled: not window?
      defaultChecked: @state.htoChecked
      checked: @state.htoChecked
      onClick: @handleHtoFilter

    CTAProps =
      cssModifier: classes.CTA
      onClick: @collapseFilters
      children: "See #{@props.visibleFrames} frames"
      analyticsSlug: 'gallery-seeFrames-filters'

    filterHeaders = _.reduce @props.filters, (result, category, name) =>
      headerProps =
        key: name
        children: name
        'data-name': name
        onClick: @handleHeaderFilterClick

      if not @state.expandedFilter? or name is @state.expandedFilter or _.has category, @state.expandedFilter
        headerProps.className = "#{classes.filterHeader} -active"
      else
        headerProps.className = "#{classes.filterHeader} -inactive"

      result.push <div {...headerProps} />
      result
    , []

    filterGroups = _.reduce @props.filters, (result, category, key) =>
      displayOneRow = category.length < 5
      filterGroup = _.reduce category, (filterGroup, name, index) =>
        # Handle filter groups that have just one filter in them
        if _.isString name
          filterGroup.push(
            <FilterCheckbox
              key="filter-group-#{index}" category=key name=name
              active={_.includes @props.filtersList, name}
              cssModifier="#{if displayOneRow then '-one-row' else '-two-row'}"
              clearFiltersAfter=@props.clearFiltersAfter
              manageFilterChange=@handleFilterChange />
          )
        else
          # The filter group has multiple sub-filters so add a label to each group of checkboxes
          # and add some extra spacing between checkbox groups
          displayOneRow = true
          subgroup = []
          subgroup.push <div
            className=classes.filterGroupLabel
            children = index.toUpperCase()
            key="filter-group-title-#{index}" />
          _.map name, (n, i) =>
            lastCheckboxInGroup = i is name.length - 1 and index is 'width' and 'nose bridge' of @props.filters['fit']
            subgroup.push <FilterCheckbox
              key="filter-group-#{index}-#{i}" category=index name=n
              active={_.includes @props.filtersList, n}
              cssModifier="-one-row #{if lastCheckboxInGroup then 'u-pr12 u-pr72--900' else ''}"
              clearFiltersAfter=@props.clearFiltersAfter
              manageFilterChange=@handleFilterChange />
          filterGroup.push(<div children={subgroup} />)

        filterGroup
      , []

      containerClasses = classes.filterGroupContainer

      childClasses = [
        classes.filterGroup
        if displayOneRow then '-one-row' else '-two-row'
      ].join ' '

      if key is @state.expandedFilter or _.has category, @state.expandedFilter
        containerClasses = "#{containerClasses} -active"
        childClasses = "#{childClasses} -active"

      result.push(
        <div key=key className=containerClasses>
          <div className=childClasses children=filterGroup />
        </div>
      )
      result
    , []

    searchButton =
      <CTA
        analyticsSlug="search-click-searchButton#{@getFilterButtonState()}"
        cssModifier=classes.searchButton
        variation='simple'
        onClick=@props.handleSearch>
        <IconSearch cssModifier=classes.searchIcon />
        <span className=classes.searchFramesText>Search frames</span>
      </CTA>

    <div className=classes.block ref='filters'>
      {if @props.isSticky
        <div className=classes.dummy ref='dummy' />}
      <div className=classes.container>
        <div className=classes.modal>
          <h2 className=classes.modalHeader children='Filter frame selection' />
          <div className=classes.modalClose onClick=@collapseFilters>
            <IconX cssModifier=classes.iconX />
          </div>
          <div className=classes.modalFooter>
            <span
              className=classes.clearFilters
              children="Clear filters (#{@props.filtersList.length})"
              onClick=@clearFilters />
            <CTA {...CTAProps} analyticsSlug='gallery-remove-filters' />
          </div>
        </div>
        <div className=classes.containerFilters>
          <div className=classes.filterBar children=filterHeaders />
          <div className=classes.filterGroups>
            <div className=classes.filterGroupsContainer children=filterGroups />
          </div>
        </div>
        <div className=classes.buttonsBar>
          <CTA
            analyticsSlug="gallery-click-filterButton#{@getFilterButtonState()}"
            cssModifier=classes.filterButton
            variation='simple'
            onClick=@handleFilterClick>
            <IconFilter cssModifier=classes.filterIcon />
            <span children='Filter ' />
            <span className=classes.filterFramesTextFrames children='frames' />
            {if @props.isInline and @state.enableStickyFilter and @props.filtersList.length > 0
              <span className=classes.filterCount children={@props.filtersList.length} />}
          </CTA>
          {searchButton}
        </div>
        {if @props.filtersList.length
          <div className=classes.containerActiveFilters>
            <span children=@getActiveFiltersString() />
            <a
              className=classes.resetLink
              href='#'
              children='Reset filters'
              onClick=@clearFilters />
          </div>}
        {if @getFeature('homeTryOn')
          <div className=classes.containerLeft>
            <Checkbox {...htoCheck} />
          </div>}
        <div
          className=classes.containerRight
          children=searchButton />
      </div>
    </div>
