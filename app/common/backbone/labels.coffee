[
  _
  Logger
] = [
  require 'lodash'
  require '../logger'
]

FIELD_LABELS =
  # Maps model attributes to their label counterparts.
  company:           'Company'
  country_code:      'Country'
  extended_address:  'Apt/Suite'
  first_name:        'First name'
  formatted_address: 'Street address'
  last_name:         'Last name'
  locality:          'City'
  postal_code:
    US: 'Zip code'
    CA: 'Postal code'
  region:
    US: 'State'
    CA: 'Province'
  street_address:    'Street address'
  telephone:         'Phone'

module.exports =
  get: (fieldName, country) ->
    label = _.upperFirst _.kebabCase(fieldName).replace('-', ' ')
    content = FIELD_LABELS[fieldName]
    if content
      if _.isObject(content)
        content[country]
      else
        content
    else
      label

  message: (fieldName, message, country) ->
    message = "#{@get(fieldName, country)} #{message}"
    message = "#{message}." unless _.endsWith(message, '.')
    message

  format: (errors, country = 'US') ->
    _.mapValues errors, (message, fieldName) =>
      currentLabel = _.kebabCase(fieldName).replace('-', ' ')
      regExp = new RegExp("^#{currentLabel} ", 'i')
      errors[fieldName] = @message(
        fieldName
        message.replace(regExp, '')
        country
      )
