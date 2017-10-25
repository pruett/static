Backbone = require '../../../backbone'

class EstimatePrescriptionUploadedModel extends Backbone.BaseModel

  url: -> @apiBaseUrl('estimate/prescriptions/uploaded')

  defaults:
    use_high_index: false
    attributes: {}

  permittedAttributes: -> [
    'use_high_index'
    'attributes'
  ]


module.exports = EstimatePrescriptionUploadedModel
