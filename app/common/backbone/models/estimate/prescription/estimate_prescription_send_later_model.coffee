Backbone = require '../../../backbone'

class EstimatePrescriptionSendLaterModel extends Backbone.BaseModel

  url: -> @apiBaseUrl('estimate/prescriptions/send-later')

  defaults:
    use_high_index: false
    attributes: {}

  permittedAttributes: -> [
    'use_high_index'
    'attributes'
  ]


module.exports = EstimatePrescriptionSendLaterModel
