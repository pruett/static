Backbone = require '../../../backbone'

class EstimatePrescriptionCallDrModel extends Backbone.BaseModel

  url: -> @apiBaseUrl('estimate/prescriptions/call-doctor')

  defaults:
    use_high_index: false
    attributes: {}

  permittedAttributes: -> [
    'use_high_index'
    'attributes'
  ]

  validation: ->
    'attributes.provider_name':
      required: true
      msg: 'Provider name must be valid.'
    'attributes.provider_phone':
      required: true
      msg: 'Provider phone number must be valid.'
    'attributes.patient_name':
      required: true
      msg: 'Patient name must be valid.'
    'attributes.region':
      required: true
      msg: 'Please select a state/region.'
    'attributes.patient_birth_date_formatted': (date = '') ->
      # Formatted version.
      # Date comes in MM-DD-YYYY

      # Fix for Safari "Invalid Date" conversion with dashes.
      # Future: Use date parser like Moment or Sugar.
      date = date.replace(/-/g, "/")

      timeDate = new Date(date).getTime()
      timeNow = new Date().getTime()

      if isNaN(timeDate) or date is '' or date.length < 'MM-DD-YYYY'.length
        return 'Patient birth date must be valid and in MM-DD-YYYY format.'

      if timeNow - timeDate < (1000 * 60 * 60 * 24 * 365 * 2) # 2 years
        return 'Patient birth date must be at least 2 years in past.'


module.exports = EstimatePrescriptionCallDrModel
