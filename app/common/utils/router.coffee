[
  _
  Call
  Url
] = [
  require 'lodash'
  require 'call'
  require './url'
]

class Router
  constructor: (routes) ->
    @router = new Call.Router
    for route in routes
      if _.startsWith(route.path, '/')
        @router.add { method: 'get', path: route.path }, route

  route: (url) ->
    url = Url.parse url if _.isString url
    path = url.pathname
    path = _.trimEnd(path, '/') if path.length > 1
    result = @router.route 'get', path
    if not result.isBoom
      _.assign {params: result.params, url: url}, result.route
    else
      null

  canRoute: (currentUrl, targetUrl) ->
    @checkRoutability(currentUrl, targetUrl).routable

  checkRoutability: (currentUrl, targetUrl) ->
    currentUrl = Url.parse currentUrl
    targetUrl = Url.parse targetUrl

    # Temporary fix for the quiz GA tracking bug (see PROD-7854)
    persistParamRoutes = ['/quiz', '/quiz/results']
    if currentUrl.pathname in persistParamRoutes and targetUrl.pathname in persistParamRoutes
      # Pass query params from the current url to the target (excluding page-specific ones)
      _.assign targetUrl.query, _.omit(currentUrl.query, 'gender', 'active')
      delete targetUrl.search
      targetUrl = Url.parse Url.compile(targetUrl)

    currentRoute = @route(currentUrl.href)
    targetRoute = @route(targetUrl.href)

    routability =
      routable: false
      target: targetRoute
      current: currentRoute
      identical: _.isEqual targetRoute, currentRoute

    if not targetRoute?
      return _.assign routability, reason: 'unknown route'

    sameHost = targetUrl.hostname? and targetUrl.hostname is currentUrl.hostname
    sameProtocol = targetUrl.protocol? and targetUrl.protocol is currentUrl.protocol

    if targetRoute.bundle?
      sameBundle = currentRoute.bundle is targetRoute.bundle
    else
      sameBundle = false

    if not sameProtocol
      _.assign routability, reason: 'mismatched protocol'
    else if not sameBundle
      _.assign routability, reason: [
        'mismatched bundles', targetRoute?.bundle, '<>', currentRoute?.bundle
      ].join ' '
    else if not sameHost
      _.assign routability, reason: [
          'mismatched hosts', targetUrl?.hostname, '<>', currentUrl?.hostname
        ].join ' '
    else
      _.assign routability, routable: true


module.exports = Router
