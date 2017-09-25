[
  _
  React
  Radio
] = [
  require 'lodash'
  require 'react/addons'
  require 'backbone.radio'
]

module.exports =
  componentWillUnmount: ->
    @__cleanUpEventListeners()

  addScrollListener: (fn, throttle = 100) ->
    return unless window?
    throttledFn = _.throttle fn, throttle
    window.addEventListener 'scroll', throttledFn
    window.addEventListener 'resize', throttledFn
    if @__scrollListeners.indexOf(throttledFn) < 0
      @__scrollListeners.push(throttledFn)
    if @__resizeListeners.indexOf(throttledFn) < 0
      @__resizeListeners.push(throttledFn)

  refIsInViewport: (ref) ->
    @elementIsInViewport React.findDOMNode(ref)

  elementIsInViewport: (el, bottomBuffer = 0) ->
    return false unless _.isElement el
    rect = el.getBoundingClientRect()
    windowHeight = window.innerHeight or _.get(document, 'documentElement.clientHeight')
    windowWidth = window.innerWidth or _.get(document, 'documentElement.clientWidth')

    return rect.top < windowHeight &&
           rect.bottom > bottomBuffer &&
           rect.right > 0 &&
           rect.left < windowWidth

  getScrollDistance: ->
    Radio.channel('scrolling').request('scrollTop')

  __scrollListeners: []
  __resizeListeners: []

  scrollToNode: (node, opts = {}) ->
    return unless node
    @scrollTo @getScrollDistance() + node.getBoundingClientRect().top, opts

  scrollTo: (yFinish = 0, opts = {}) ->
    Radio.channel('scrolling').request('scrollTo', yFinish, opts)

  __cleanUpEventListeners: ->
    _.each @__scrollListeners, (fn) ->
      window?.removeEventListener 'scroll', fn
    _.each @__resizeListeners, (fn) ->
      window?.removeEventListener 'resize', fn

    @__scrollListeners = []
    @__resizeListeners = []
