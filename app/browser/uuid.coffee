# UUID
# ----
#
# Assign a UUID to each unique visitor.
#
# If the user agent did not submit a cookie containing a valid UUID, we
# randomly generate one and store it in a persistent cookie named "wp_id".
# The intent is for this UUID to be permanently associated with a particular
# web browser, which allows us to track the user's activity via access logs,
# whether or not they're logged in.

[
  Cookies

  UUID
  Url
  Logger
] = [
  require 'cookies-js'

  require '../common/utils/uuid'
  require '../common/utils/url'
  require './logger'
]

log = Logger.get('UUID').log

UUID_COOKIE_NAME = 'wp_id'

module.exports =
  check: ->
    uuid = Cookies.get(UUID_COOKIE_NAME) or ''

    if UUID.test(uuid)
      log "existing UUID: #{uuid}"
    else
      uuid = UUID.generate()
      log "setting new UUID: #{uuid}"
      Cookies.set UUID_COOKIE_NAME, uuid,
        domain: Url.parse(location.href).domain
        expires: 'Tue, 19 Jan 2038 03:14:07 GMT'
        path: '/'
        secure: true
