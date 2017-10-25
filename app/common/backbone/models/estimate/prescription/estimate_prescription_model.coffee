Backbone = require '../../../backbone'

class EstimatePrescriptionModel extends Backbone.BaseModel

  defaults: ->
    modal: 'savePrescription'
    type: ''


module.exports = EstimatePrescriptionModel
