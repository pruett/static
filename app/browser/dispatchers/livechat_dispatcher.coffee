[
  _

  Logger
  BaseDispatcher
] = [
  require 'lodash'

  require '../logger'
  require '../../common/dispatchers/base_dispatcher'
]

# Docs at https://docs.google.com/spreadsheets/d/1lm3mP_2evlBkKmKFYIqKXn-l_e4F98XkS9yfi4BqjyY/edit#gid=2033167167
class LivechatDispatcher extends BaseDispatcher
  log = Logger.get('LivechatDispatcher').log

  LOCATION_HASH_REGEX: /#livechat|#medchat/i

  channel: -> 'livechat'

  shouldAlwaysWake: -> true

  getInitialStore: ->
    errors: {}
    isAvailable: false
    isChatStarted: false
    isLoading: false
    openOnScriptReady: false

  getStoreChangeHandlers: ->
    scripts: 'handleScriptsStoreChange'

  wake: ->
    if @requestDispatcher('cookies', 'get', 'loadLivechat')
      @loadScript false

    if window?.location.hash
      hashOptions = @getHashOptions window.location.hash
      if hashOptions
        @handleOpenChat()

    window?.addEventListener 'click', (evt) =>
      # Hijack clicks on MedChat chat-opening links, which often come in from the CMS
      # (e.g. in the copy on the FAQ page to make them open the embedded LiveChat window
      # instead of a new browser window. Crawl up from target until you find an <a>
      # or get to the top of the DOM).
      target = evt.target
      while target.parentNode? and target.tagName isnt 'BODY'

        if target.tagName is 'A'
          href = target.getAttribute 'href'
          options = @getHashOptions(href)
          if options
            if @modifier('isMobileAppRequest')
              # Embedded MedChat window may be buggy in iOS WebView, so ignore any
              # MedChat links.
              break

            evt.preventDefault()
            @handleOpenChat()
          break
        target = target.parentNode

  getHashOptions: (href = '') ->
    hashMatches = href.match @LOCATION_HASH_REGEX

  loadScript: (openOnScriptReady) ->
    src = _.get(@appState, 'config.scripts.livechat')
    if src
      storeUpdate = isLoading: true
      if openOnScriptReady
        storeUpdate.openOnScriptReady = true
      @setStore storeUpdate
      @commandDispatcher 'scripts', 'load',
        name: 'livechat'
        src: src

  handleOpenChat: ->
    if @store.isAvailable
      MedChat?.launch()
    else
      @loadScript true

  handleScriptsStoreChange: (scriptsStore) ->
    return if @store.isAvailable
    @commandDispatcher 'cookies', 'set', 'loadLivechat', true, expires: 86400
    if MedChat?
      @setStore isAvailable: true, isLoading: false
      if window?.location.hash
        hashOptions = @getHashOptions window.location.hash
        if hashOptions
          MedChat?.launch()
    else
      @setStore isAvailable: false, isLoading: false

  commands:
    openChat: ->
      @handleOpenChat()


module.exports = LivechatDispatcher
