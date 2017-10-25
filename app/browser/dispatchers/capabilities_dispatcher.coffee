[
  _

  Logger
  BaseDispatcher
] = [
  require 'lodash'

  require '../logger'
  require '../../common/dispatchers/base_dispatcher'
]


class CapabilitiesDispatcher extends BaseDispatcher
  # The purpose of this dispatcher is to handle browser compatibility issues,
  # and to provide a standardized method for loading shims and polyfills.

  log = Logger.get('CapabilitiesDispatcher').log

  channel: -> 'capabilities'

  getStoreChangeHandlers: ->
    scripts: 'handleScriptsStoreChange'

  getInitialStore: ->
    touchEvents: @getTouchEvents()
    getUserMedia:
      supported: (navigator.getUserMedia ||
        navigator.webkitGetUserMedia ||
        navigator.mozGetUserMedia ||
        navigator.msGetUserMedia)?
      available: navigator.getUserMedia?
    canvasToBlob:
      supported: window.HTMLCanvasElement?
      available: window.HTMLCanvasElement?.prototype.toBlob
    requestAnimationFrame:
      supported: (window.requestAnimationFrame or
        window.webkitRequestAnimationFrame or
        window.mozRequestAnimationFrame or
        window.oRequestAnimationFrame)?
      available: window.requestAnimationFrame?
    cssTransition: @getCssTransition()
    cssTransform: @getCssTransform()

  handleScriptsStoreChange: (scriptsStore) ->
    log 'scriptsStore change', scriptsStore
    _.each scriptsStore, (script) =>
      if @store[script.name]? && script.loaded
        log "#{script.name} loaded."
        @setStore script.name,
          supported: true
          available: true

  getTouchEvents: ->
    'ontouchstart' of window or window.DocumentTouch and document instanceof DocumentTouch

  getCssTransition: ->
    @getSupportedImplementation(
      transition:
        cssProperty: 'transition'
        endEvent: 'transitionend'
      OTransition:
        cssProperty: '-o-transition'
        endEvent: 'oTransitionEnd'
      msTransition:
        cssProperty: '-ms-transition'
        endEvent: 'MSTransitionEnd'
      MozTransition:
        cssProperty: '-moz-transition'
        endEvent: 'transitionend'
      WebkitTransition:
        cssProperty: '-webkit-transition'
        endEvent: 'webkitTransitionEnd'
    )

  getCssTransform: ->
    @getSupportedImplementation(
      transform:
        cssProperty: 'transform'
      OTransform:
        cssProperty: '-o-transform'
      msTransform:
        cssProperty: '-ms-transform'
      MozTransform:
        cssProperty: '-moz-transform'
      WebkitTransform:
        cssProperty: '-webkit-transform'
    )

  getSupportedImplementation: (variants) ->
    element = document.body

    supported = _.reduce variants, (acc, attrs, styleProp) ->
      return acc if acc

      if _.get(element, "style.#{styleProp}")?
        return _.assign attrs, jsProperty: styleProp
    , null

    supported: not _.isEmpty supported
    available: not _.isEmpty supported
    vendor: supported

  ensureCapabilities:
    canvasToBlob: ->
      log 'ensure canvasToBlob'
      if not @store.canvasToBlob.loaded
        @commandDispatcher 'scripts', 'load',
           name: 'canvasToBlob'
           src: '/assets/js/polyfills/canvas-to-blob.js'

    getUserMedia: ->
      navigator.getUserMedia = navigator.getUserMedia ||
        navigator.webkitGetUserMedia ||
        navigator.mozGetUserMedia ||
        navigator.msGetUserMedia

      @setStore 'getUserMedia',
        supported: navigator.getUserMedia?
        available: navigator.getUserMedia?

    requestAnimationFrame: ->
      return if @store.requestAnimationFrame.available
      window.requestAnimationFrame =
        window.requestAnimationFrame or
        window.webkitRequestAnimationFrame or
        window.mozRequestAnimationFrame or
        window.oRequestAnimationFrame or
        (callback, element) ->
          timeLast = if timeLast then timeLast else 0
          timeCurrent = (new Date).getTime()
          timeCall = Math.max(0, 16 - (timeCurrent - timeLast))
          id = window.setTimeout (-> callback timeCurrent + timeCall), timeCall
          timeLast = timeCurrent + timeCall
          id

      @setStore 'requestAnimationFrame',
        supported: not _.isEmpty window.requestAnimationFrame
        available: not _.isEmpty window.requestAnimationFrame

  commands:
    ensure: (capability) ->
      @ensureCapabilities[capability].call(@)

module.exports = CapabilitiesDispatcher
