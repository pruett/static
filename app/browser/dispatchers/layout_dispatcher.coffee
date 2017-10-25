[
  Backbone
  BaseDispatcher
  Logger
] = [

  require '../../common/backbone/backbone'
  require '../../common/dispatchers/base_dispatcher'
  require '../logger'
]

log = Logger.get('LayoutDispatcher').log

NAVIGATION_HASHES = [
  'navigation'
]

SCROLL_LOCK_CLASS = 'u-oh'

class LayoutDispatcher extends BaseDispatcher
  channel: -> 'layout'

  getInitialStore: ->
    isNavVisible: false
    isOverlayShowing: false
    jsSupport: true
    showHeader: true
    takeover: false
    visibleNavSubList: null

  shouldAlwaysWake: -> true

  removeNavigationHash: ->
    if @isNavHashActive()
      window.location.hash = ''

  isNavHashActive: ->
    hashId = window.location.hash?.substr 1
    NAVIGATION_HASHES.indexOf(hashId) > -1

  locationDidChange: ->
    # Reset navigation on location change.
    @replaceStore isOverlayShowing: false
    @unlockBodyScrolling()

  lockBodyScrolling: ->
    # Add overflow: hidden; to both <html> and <body> (needed for iOS Safari)
    return unless document?.body?.classList
    document.body.classList.add(SCROLL_LOCK_CLASS)
    document.documentElement.classList.add(SCROLL_LOCK_CLASS)

  unlockBodyScrolling: ->
    return unless document?.body?.classList
    document.body.classList.remove(SCROLL_LOCK_CLASS)
    document.documentElement.classList.remove(SCROLL_LOCK_CLASS)

  getScrollbarWidth: ->
    _.get(window, 'innerWidth', 0) - _.get(document, 'body.offsetWidth', 0)

  commands:
    setPageTitle: (validPaths, title) ->
      # Since any Component or Dispatcher can issue the command to setPageTitle,
      # the command requires one or more `validPaths` to match against before
      # the title will be changed.
      if @matchesCurrentPath(validPaths)
        if title isnt _.get @appState, 'location.title'
          log "setPageTitle to \"#{title}\""
          @setAppState 'location.title', title
      else
        log "setPageTitle to \"#{title}\" failed, current path doesn't match"

    showTakeover: (showHeader=false) ->
      @setStore
        takeover: true
        scrollbarWidth: this.getScrollbarWidth()
        scrollPosition: _.get(window, 'scrollY', 0)
        showHeader: showHeader
      @lockBodyScrolling()

    hideTakeover: ->
      @unlockBodyScrolling()
      window.scrollTo(0, @store.scrollPosition)
      @setStore
        takeover: false
        showHeader: true

    showNavigation: (subListId) ->
      @setStore
        isNavVisible: true
        isOverlayShowing: true
        scrollbarWidth: this.getScrollbarWidth()
        scrollPosition: _.get(window, 'scrollY', 0)
        showHeader: true
        takeover: false
        visibleNavSubList: subListId
      @lockBodyScrolling()
      @removeNavigationHash()

    hideNavigation: ->
      @unlockBodyScrolling()
      window.scrollTo(0, @store.scrollPosition)
      @setStore
        isNavVisible: false
        isOverlayShowing: false
        showHeader: true
        takeover: false
        visibleNavSubList: null
      @removeNavigationHash()

  requests:
    initNavigation: ->
      # Initialize navigation before mount if open.
      # Checks for data-nav-id attribute or navigation hash.
      drawerId = document.activeElement?.getAttribute("data-nav-id")
      if @isNavHashActive() or drawerId
        @commands.showNavigation.call(@, drawerId)


module.exports = LayoutDispatcher
