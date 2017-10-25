Backbone = require '../backbone'

class PrescriptionRequestModel extends Backbone.BaseModel

  url: -> @apiBaseUrl('prescriptions/requests')

  defaults:
    use_high_index: false
    attributes: {}

  permittedAttributes: -> [
    'attributes'
    'sales_order_id'
    'variant_type_id'
    'use_high_index'
  ]

  @requestTypes:
    'upload':   1
    'doctor':   2
    'deferred': 3
    'readers':  4
    'manual':   5
    'existing': 6
    'non_rx':   7

module.exports = PrescriptionRequestModel
