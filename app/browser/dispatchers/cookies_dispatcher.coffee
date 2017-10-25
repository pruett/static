[
  _
  Cookies

  Logger
  BaseDispatcher
] = [
  require 'lodash'
  require 'cookies-js'

  require '../logger'
  require '../../common/dispatchers/base_dispatcher'
]

class CookiesDispatcher extends BaseDispatcher
  log = Logger.get('CookiesDispatcher').log

  channel: -> 'cookies'

  getCookieDefaults: ->
    path: '/'
    domain: ".#{@currentLocation().domain}"

  requests:
    get: (name, options = {}) ->
      name = if options.skipPrefix then name else @request('prefixedName', name)
      Cookies.get name

    prefixedName: (name) -> "#{@getLocale('cookie_prefix')}#{name}"

  commands:
    set: (name, value, options = {}) ->
      _.defaults options, @getCookieDefaults()
      name = if options.skipPrefix then name else @request('prefixedName', name)
      Cookies.set name, value, options

    remove: (name, options = {}) ->
      _.defaults options, _.assign(expires: new Date(0), @getCookieDefaults())
      name = if options.skipPrefix then name else @request('prefixedName', name)
      Cookies.expire name, options

    enterHtoMode: (target) ->
      action = if @inHtoMode() then 'enterSubsequent' else 'enter'
      @pushEvent _.compact([
        'htoMode', action, target
      ]).join('-')
      @commands.set.call @, 'htoMode', true, expires: 60 * 60

    leaveHtoMode: (target) ->
      @pushEvent "htoMode-leave-#{target}"
      @commands.remove.call @, 'htoMode'

module.exports = CookiesDispatcher
