[
  _

] = [
  require 'lodash'

]

class Cookies
  # Stores request (incoming) and response (outgoing) cookies. The API is the
  # authority for setting cookies, so 'Set-Cookie' headers coming from
  # prefetched API responses are collected and returned in the final response.

  constructor: (options = {}) ->
    @requestCookies = options.request or {}
    @responseCookies = []
    @cookies = []

  allResponse: -> @responseCookies

  add: (cookie = {}) ->
    # Dev env's can be run without SSL
    if cookie.isSecure and Config.isDev
      delete cookie.isSecure
    @cookies.push(cookie) unless _.isEmpty(cookie)

  mapCookie: (cookie) ->
    return cookie.split(';').reduce (newCookie, cookieParts, index) ->
      kvp = cookieParts.split('=')
      if index == 0
        newCookie['name'] = kvp[0]
        newCookie['value'] = kvp[1]
        return newCookie

      if kvp[0].trim() is 'Domain'
        newCookie['domain'] = Config.get('server.config.cookie_domain')

      if kvp[0].trim() is 'expires'
        newCookie['ttl'] = kvp[1]

      if kvp[0].trim() is 'Path'
        newCookie['path'] = kvp[1]

      if kvp[0].trim() is 'secure'
        newCookie['isSecure'] = true

      if kvp[0].trim() is 'HttpOnly'
        newCookie['isHttpOnly'] = true
      return newCookie;
    , {}

  addResponse: (cookies, options = {}) ->
    if not cookies
      return
    for cookie in cookies.map(@mapCookie)
      if cookie.isSecure and Config.isDev
        delete cookie.isSecure
      @responseCookies.push(cookie)
      @cookies.push(cookie)

  addRequest: (key, value) ->
    @requestCookies[key] = value
    @responseCookies[key] = value

  getRequestHeader: ->
    # For the 'Cookie' header in an API request.
    (_.map @requestCookies, (value, key) -> "#{key}=#{value}").join '; '


module.exports = Cookies
