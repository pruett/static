[
  _

  Backbone
  BaseDispatcher
  Logger

  ImageUploadModel
  PrescriptionRequestModel
] = [
  require 'lodash'

  require '../backbone/backbone'
  require './base_dispatcher'
  require '../logger'

  require '../backbone/models/image_upload_model'
  require '../backbone/models/prescription_request_model'
]

class StateModel extends Backbone.BaseModel
  defaults: ->
    isSaving: false
    isUploading: false

class PrescriptionRequestDispatcher extends BaseDispatcher
  log = Logger.get('PrescriptionRequestDispatcher').log

  channel: -> 'prescriptionRequest'

  collections: ->
    prescriptionRequests:
      class: PrescriptionRequestModel

  models: ->
    imageUpload: new ImageUploadModel
    prescriptionRequest: new PrescriptionRequestModel
    state: new StateModel

  mixins: -> [
      'api'
      'modals'
    ]

  events: ->
    'change state': @onStateChange

  backboneDidInitialize: ->
    @model('imageUpload').sessionStart(
      prefix: 'prescriptionRequest'
      name: 'imageUpload'
      ttl:  15 * 60 * 1000  # 15 minutes.
    )

  getInitialStore: -> @buildStoreData()

  buildStoreData: ->
    state: @data('state')
    imageUpload: @data('imageUpload')
    errors: {}

  onStateChange: ->
    @replaceStore
      state: @data('state')

  onUploadSuccess: (model, xhr, options) ->
    @model('state').set(isUploading: false)
    @replaceStore @buildStoreData()
    @navigate "/account/orders/#{options.orderId}/prescription/confirm"

  onUploadError: (model, xhr, options) ->
    @model('state').set(isUploading: false)
    @replaceStore errors: @parseApiError(xhr.response)
    @navigate "/account/orders/#{options.orderId}/prescription/resize"

  onPrescriptionRequestSaveSuccess: (model, xhr, options) ->
    @model('state').set(isSaving: false)
    @replaceStore @buildStoreData()
    @model('imageUpload').sessionClear()
    @commandDispatcher 'account', 'refresh'
    @navigate "/account/orders/#{options.salesOrderId}/prescription/success"

  onPrescriptionRequestSaveError: (model, xhr, options) ->
    @model('state').set(isSaving: false)
    @replaceStore errors: @parseApiError(xhr.response)
    @navigate "/account/orders/#{options.salesOrderId}/prescription/error"


  commands:
    uploadPrescription: (data, options) ->
      state = @model 'state'
      return if state.get('isUploading')

      state.set({isUploading: true})
      @model('imageUpload').save(
        null,
        data: data
        orderId: options.orderId
        wait: true
        validate: false
        success: @onUploadSuccess.bind(@)
        error: @onUploadError.bind(@)
      )

    savePrescription: (salesOrderId) ->
      state = @model 'state'
      return if state.get 'isSaving'

      uploadData = @data('imageUpload')

      state.set({isSaving: true})
      prModel = @model 'prescriptionRequest'
      prModel.set(
        variant_type_id: PrescriptionRequestModel.requestTypes['upload']
        sales_order_id: salesOrderId
        attributes:
          blob_id: _.get uploadData, 'blob_id'
          name: _.get uploadData, 'filename'
      )
      prModel.save(
        null,
        salesOrderId: salesOrderId
        wait: true
        validate: false
        success: @onPrescriptionRequestSaveSuccess.bind(@)
        error: @onPrescriptionRequestSaveError.bind(@))

module.exports = PrescriptionRequestDispatcher
