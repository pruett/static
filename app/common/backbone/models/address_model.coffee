Backbone = require '../backbone'

class AddressModel extends Backbone.BaseModel

  url: ->
    baseUrl = 'account/addresses'
    @apiBaseUrl(if @get('id') then "#{baseUrl}/#{@get 'id'}" else baseUrl)

  parse: (resp) ->
    resp.address

  permittedAttributes: -> [
    'company'
    'country_code'
    'extended_address'
    'first_name'
    'id'
    'last_name'
    'locality'
    'postal_code'
    'region'
    'street_address'
    'telephone'
  ]

  validation: ->
    country_code: required: true
    first_name: required: true
    last_name: required: true
    locality: required: true
    postal_code: required: true
    region: required: true
    street_address: required: true
    telephone: required: true


module.exports = AddressModel
