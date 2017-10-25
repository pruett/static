Backbone = require '../../../backbone'

class EstimatePrescriptionReadersModel extends Backbone.BaseModel

  url: -> @apiBaseUrl('estimate/prescriptions/readers')

  defaults:
    use_high_index: false
    attributes: {}

  permittedAttributes: -> [
    'use_high_index'
    'attributes'
  ]

  validation: ->
    'attributes.readers_strength':
      required: true
      msg: 'You must select a strength.'

module.exports = EstimatePrescriptionReadersModel
