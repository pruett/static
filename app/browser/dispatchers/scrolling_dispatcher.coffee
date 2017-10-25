[
  _
  Logger

  BaseDispatcher
] = [
  require 'lodash'
  require '../logger'

  require '../../common/dispatchers/base_dispatcher'
]

log = Logger.get('ScrollingDispatcher').log

class ScrollingDispatcher extends BaseDispatcher
  # Handles scrolling commands.

  channel: -> 'scrolling'

  wake: -> @commandDispatcher 'capabilities', 'ensure', 'requestAnimationFrame'

  getInitialStore: ->
    isScrolling: false

  storeDidChange: (store) ->
    isScrolling = store.get('isScrolling')
    wasScrolling = store.previous('isScrolling')

    if isScrolling isnt wasScrolling
      # Start scrolling, or finish and invoke callback.
      if isScrolling then requestAnimationFrame @doScroll.bind(@)
      else _.result store, 'attributes.callback'

  EASINGS:
    linear:     (t) -> t
    inQuad:     (t) -> t * t
    outQuad:    (t) -> t * (2 - t)
    inOutQuad:  (t) -> if t < .5 then 2 * t * t else -1 + (4 - 2 * t) * t

  doScroll: ->
    return unless @store.isScrolling

    {distance, fnTiming, time, timeStart, yStart} = @store

    timeLeft = Math.min 1, (new Date().getTime() - timeStart) / time

    # Perform interval scroll.
    window.scrollTo 0, (fnTiming(timeLeft) * distance) + yStart

    if timeLeft < 1
      requestAnimationFrame @doScroll.bind(@)
    else
      @setStore isScrolling: false

  commands:
    scrollTo: (yFinish = 0, opts = {}) ->
      return unless window and document

      @setStore isScrolling: false # Cancel other scrolls.

      _.defaults opts,
        easing: 'inOutQuad' # Set to linear, inQuad, outQuad, inOutQuad.
        time: 'auto'        # Number in milliseconds or 'auto'.
        rate: 2             # If time is 'auto', time = distance / rate.
        offset: 0           # Number of pixels from target (+/-).
        delay: 0            # Number in milliseconds.
        callback: ->        # Callback function.

      yStart = @request 'scrollTop'
      distance = yFinish + opts.offset - yStart
      timeRated = Math.abs distance / opts.rate

      return opts.callback() if distance is 0 # Return if already at finish.

      attrs =
        isScrolling:  true
        callback:     if _.isFunction opts.callback then opts.callback else ->
        distance:     distance
        fnTiming:     @EASINGS[opts.easing] or @EASINGS.linear
        time:         if isNaN(opts.time) then timeRated else opts.time
        timeStart:    new Date().getTime() + opts.delay
        yStart:       yStart

      _.delay @setStore.bind(@, attrs), opts.delay

  requests:
    scrollTop: ->
      if window.pageYOffset?
        window.pageYOffset
      else if _.get document, 'documentElement.clientHeight'
        _.get document, 'documentElement.scrollTop'
      else
        _.get document, 'body.scrollTop', 0

module.exports = ScrollingDispatcher
