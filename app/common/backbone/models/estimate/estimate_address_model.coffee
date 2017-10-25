AddressModel = require '../address_model'

class EstimateAddressModel extends AddressModel

  url: -> @apiBaseUrl('estimate/addresses')

  permittedAttributes: -> [
    'first_name'
    'last_name'
    'full_name'
    'company'
    'country_code'
    'extended_address'
    'locality'
    'postal_code'
    'region'
    'street_address'
    'telephone'
    'existing_address_id'
  ]


module.exports = EstimateAddressModel
