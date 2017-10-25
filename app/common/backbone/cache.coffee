Logger = require '../logger'

log = Logger.get('Cache', quiet: true).log

CACHE_PREFIXES = [/^wp\.cache/]

# This immediately sweeps localStorage for items with keys that begin
# with the above prefixes, and removes anything that is stale or
# invalid JSON.
#
# Requires that the item is JSON.stringify'd with an `expires`
# value.
#
# e.g. { expires: 1409929449338, version: '1', value: '...' }

sweptKeys = []

if localStorage?
  for key in _.keys(localStorage)
    now = new Date().getTime()
    for prefix in CACHE_PREFIXES
      if key.search(prefix) == 0
        parsable = false
        try
          item = JSON.parse localStorage.getItem(key)
          fresh = now < item?.expires
          parsable = true
        unless fresh && parsable
          localStorage.removeItem key
          sweptKeys.push key

log "swept stale localStorage item: #{key}" for key in sweptKeys

CACHE_PREFIX = 'wp.cache'

module.exports =
  get: (key, version) ->
    # Check for a fresh and valid item in localStorage.
    log 'cacheGet', key, version
    return null unless localStorage?
    key = @__cacheKey(key)

    now = new Date().getTime()
    try
      item = JSON.parse localStorage.getItem(key)
    valid = item?.value?
    fresh = now < item?.expires
    versionMatch = item?.version == "#{version}"

    log "#{key}:",
      valid: valid
      fresh: fresh
      versionMatch: versionMatch

    if valid && fresh && versionMatch
      item.value
    else
      if item?
        log "removing stale localStorage item: #{key}"
        localStorage.removeItem key
      null

  clear: (key) ->
    return unless localStorage?
    localStorage.removeItem @__cacheKey(key)

  __cacheKey: (key) ->
    "#{CACHE_PREFIX}.#{key}"

  match: (key, objectKey) ->
    key? and key is @__cacheKey(objectKey)

  set: (key, version, value, ttl, options = {}) ->
    # Store a value in localStorage with the appropriate key and
    # expiration time.
    key = @__cacheKey(key)
    log 'cacheSet', key: key, value: value, ttl: ttl

    return unless localStorage?

    try
      # Private browsing may reject using localStorage.
      localStorage.setItem key,
        JSON.stringify
          version: "#{version}"
          expires: new Date().getTime() + ttl
          value: value

    log 'cacheSet with localStorage'

    value
