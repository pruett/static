[
  _

  Logger
  Backbone
  BaseDispatcher
] = [
  require 'lodash'

  require '../logger'
  require '../../common/backbone/backbone'
  require '../../common/dispatchers/base_dispatcher'
]

class PdValidationModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('pd-request/validate')

  permittedAttributes: -> [
    'blob_id'
    'url'
  ]

class PdRequestModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('pd-request')

  idAttribute: 'pd_request_id'

  permittedAttributes: -> [
    'blob_id'
    'pd_request_id'
  ]

  validation: ->
    blob_id: required: true

class PdDispatcher extends BaseDispatcher
  log = Logger.get('PdDispatcher').log

  channel: -> 'pd'

  mixins: -> [
    'modals'
  ]

  getInitialStore: ->
    image:
      src: ''

  uploadSuccess: (model) ->
    @replaceStore
      image:
        src: model.get('url')
      blob_id: model.get('blob_id')
    @modals success: 'doUpload'
    @navigate '/pd/review'

  uploadError: ->
    @modals error: 'doUpload'
    @navigate '/pd/error/photo'

  submitSuccess: ->
    log 'submit pd image success'
    @modals success: 'doSubmit'
    @navigate '/pd/success'

  commands:
    upload: (pdFormData) ->
      return if @modals isShowing: 'saveImage'
      log 'validate PD image with model2', pdFormData

      @modals loading: 'doUpload'
      model = new PdValidationModel()
      model.save null,
        success: @uploadSuccess.bind(@)
        error: @uploadError.bind(@)
        data: pdFormData
        validate: false

    submit: ->
      return if @modals isShowing: 'saveRequest'
      log 'submit pd image'

      @modals loading: 'saveRequest'
      model = new PdRequestModel(blob_id: @getStoreData().blob_id)
      model.save null,
        validate: false
        success: @submitSuccess.bind(@)


module.exports = PdDispatcher
