Backbone = require '../../../backbone'

class EstimatePrescriptionNonRxModel extends Backbone.BaseModel

  url: -> @apiBaseUrl('estimate/prescriptions/non-rx')

  defaults:
    use_high_index: false
    attributes: {}

  permittedAttributes: -> [
    'use_high_index'
    'attributes'
  ]


module.exports = EstimatePrescriptionNonRxModel
