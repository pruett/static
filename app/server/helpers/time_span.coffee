_ = require 'lodash'

module.exports =
  duration: (span) ->
    return span if _.isNumber(span)
    # Converts simple time spans like '1h5m30s' to milliseconds.
    span = "#{span}".toLowerCase().replace(/\s/g, '')
    parts = span.match(/(\d+\D)/g)
    _.reduce parts, (total, part) ->
      unit = part.substr(-1)
      amount = parseInt(part.substr(0, _.size(part) - 1), 10)
      switch unit
        when 'h' then total += amount * 60 * 60 * 1000
        when 'm' then total += amount * 60 * 1000
        when 's' then total += amount * 1000
    , 0
