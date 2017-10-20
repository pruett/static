_ = require 'lodash'

DAYS = [
  'Sunday'
  'Monday'
  'Tuesday'
  'Wednesday'
  'Thursday'
  'Friday'
  'Saturday'
]

MONTHS = [
  'January'
  'February'
  'March'
  'April'
  'May'
  'June'
  'July'
  'August'
  'September'
  'October'
  'November'
  'December'
]

formatNumber = (value, options = {}) ->
  _.defaults options, digits: 2, pad: 0, signed: true
  num = parseFloat(value, 10)
  if isNaN(num)
    ''
  else
    fixed = "#{num.toFixed(options.digits)}"
    if options.signed
      if _.startsWith(fixed, '-')
        "-#{_.padStart fixed.substr(1), options.pad, '0'}"
      else
        "+#{_.padStart fixed, options.pad, '0'}"
    else
      _.padStart fixed, options.pad, '0'

module.exports =
  formatted: (type, value) ->
    operation = "#{type}".toLowerCase()

    switch operation
      when 'prescription'
        prescription = {}
        for eye in ['od', 'os']
          for type in ['axis', 'cylinder', 'sphere', 'add']
            measure = _.get(value, "#{eye}_#{type}", '')
            prescription["#{eye}_#{type}"] = @convert('prescription', type, measure)
        prescription
      else
        throw new Error("Unable to format '#{operation}'")

  formatTwelveHourTime: (h, m) ->
    # https://stackoverflow.com/a/14399178/767724

    hour = ((h + 11) % 12 + 1)
    time = if h >= 12 then 'p.m.' else 'a.m.'
    "#{hour}#{if m isnt 0 then ":#{m}" else ''} #{time}"

  getOrdinal: (n) ->
    # https://ecommerce.shopify.com/c/ecommerce-design/t/ordinal-number-in-javascript-1st-2nd-3rd-4th-29259

    s=["th","st","nd","rd"]
    v=n%100
    n+(s[(v-20)%10]||s[v]||s[0])

  convert: (unitFrom, unitTo, value, options = {}) ->
    operation = "#{unitFrom} => #{unitTo}".toLowerCase()

    switch operation
      when 'cents => dollars'
        (value / 100).toFixed(2)
      when 'date => object'
        date = new Date(value)

        month: MONTHS[date.getMonth()]
        date: date.getDate()
        year: date.getFullYear()
      when 'utcdate => object'
        date = new Date value

        date: date.getUTCDate()
        ordinalDate: @getOrdinal(date.getUTCDate())
        day: DAYS[date.getUTCDay()]
        hours: date.getUTCHours()
        minutes: date.getUTCMinutes()
        formattedTime: @formatTwelveHourTime(date.getUTCHours(), date.getUTCMinutes())
        month: MONTHS[date.getUTCMonth()]
        year: date.getUTCFullYear()
      when 'date => days-since'
        (Date.now() - new Date(value)) / 1000 / 60 / 60 / 24
      when 'prescription => add'
        formatNumber value, digits: 2
      when 'prescription => axis'
        formatNumber value, digits: 0, pad: 3, signed: false
      when 'prescription => cylinder'
        formatNumber value, digits: 2
      when 'prescription => pd'
        formatNumber value, digits: 1, signed: false
      when 'prescription => sphere'
        formatNumber value, digits: 2
      else
        throw new Error("Unable to convert '#{operation}'")
