Backbone = require '../../../backbone'

class EstimatePrescriptionExistingModel extends Backbone.BaseModel

  url: -> @apiBaseUrl('estimate/prescriptions/existing')

  defaults:
    use_high_index: false
    attributes: {}

  permittedAttributes: -> [
    'use_high_index'
    'attributes'
  ]


module.exports = EstimatePrescriptionExistingModel
