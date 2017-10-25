_ = require 'lodash'
Url = require('url')

module.exports =
  compile: (url) ->
    if _.isEmpty(url.host)
      url.host = url.hostname
      url.host += ":#{url.port}" if url.port

    if _.isEmpty(url.search) and not _.isEmpty(url.query)
      params = _.map url.query, (value, key) ->
        "#{encodeURIComponent(key)}=#{encodeURIComponent(value)}"
      url.search = "?#{params.join('&')}"

    if not _.startsWith(url.pathname, '/')
      url.pathname = "/#{url.pathname}"

    [
      url.protocol
      '//'
      url.host
      url.pathname
      url.search
      url.hash
    ].join('')

  parse: (url = '') ->
    defaults =
      hash: null
      host: location?.host
      hostname: location?.hostname
      href: null
      pathname: null
      port: null
      protocol: location?.protocol
      search: null
      domain: null
      query: {}

    if document?
      parsed = document.createElement 'a'
      parsed.href = url
    else
      parsed = Url.parse(url)

    parsed.domain = parsed.hostname?.split('.').splice(-2).join('.')
    parsed.query = {}

    for pair in _.trimStart(parsed.search, '?').split('&')
      [key, val] = pair.split('=')
      if val
        try
          _.set parsed.query, key, decodeURIComponent(val)
        catch
          # If `decodeURIComponent` fails, we just set the plain string.
          _.set parsed.query, key, val
      else
        _.set parsed.query, key, ''

    # IE BUG: pathname strips leading slash.
    pathname =
      if _.startsWith(parsed.pathname, '/')
        parsed.pathname
      else
        "/#{parsed.pathname}"

    result = {}

    for key in _.keys defaults
      result[key] = defaults[key]
      if _.some(parsed[key])
        result[key] = parsed[key]

    result.pathname = pathname

    result

  queryObjectToFilters: (queryObject = {}, allowedFilters) ->
    # Swap key out with lowercase, space separated version
    # This is needed to convert 'noseBridge' -> 'nose bridge'
    queryObject = _.mapKeys queryObject, (value, key) -> _.lowerCase key

    filters = _.pick queryObject, _.keys(allowedFilters)
    activeFilters = {}

    _.each filters, (filterList, category) ->
      _.each (filterList or '').split('~'), (filter) ->
        activeFilters[category] or= []
        if _.lowerCase(filter) in allowedFilters[category]
          # To support filters like 'low bridge fit'
          activeFilters[category].push _.lowerCase(filter)
        else if _.kebabCase(filter) in allowedFilters[category]
          # To support filters like 'two-tone'
          activeFilters[category].push _.kebabCase(filter)
    _.mapValues activeFilters, (filterList) -> _.uniq filterList

  filtersToQueryObject: (activeFilters) ->
    result = _.reduce activeFilters, (acc, filtersList, category) ->
      camelFiltersList =
        if typeof filtersList is 'string'
          [_.camelCase(filtersList)]
        else
          _.camelCase(f) for f in filtersList
      camelCategory = _.camelCase(category)
      acc[camelCategory] = camelFiltersList.join '~'
      acc
    , {}
    result
