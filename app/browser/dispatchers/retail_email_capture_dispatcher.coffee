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

class RetailEmailCaptureModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('account/subscribe')

  isNew: -> true

  permittedAttributes: -> [
    'email'
    'short_name'
  ]

  validation: ->
    email:
      pattern: 'email'
      required: true
      msg: 'Email address must be valid.'

class EmailCaptureDispatcher extends BaseDispatcher
  log = Logger.get('RetailEmailCaptureDispatcher').log

  channel: -> 'retailEmailCapture'

  getInitialStore: ->
    emailCaptureErrors: {}
    isEmailCaptureSuccessful: false

  mixins: -> [
    'api'
  ]

  onSuccess: ->
    @pushEvent 'retailEmailCapture-submit-email-success'
    @resetErrors()
    @setStore isEmailCaptureSuccessful: true

  onError: (model, xhr, options) ->
    @pushEvent 'retailEmailCapture-submit-email-error'
    errors = @parseApiError(xhr.response)
    @setStore emailCaptureErrors: errors, isEmailCaptureSuccessful: false

  locationDidChange: ->
    # Reset errors after navigation.
    @resetErrors()

  resetErrors: ->
    @setStore emailCaptureErrors: {}

  commands:
    subscribe: (attrs) ->
      @pushEvent 'retailEmailCapture-submit-email-triggered'
      emailCapture = new RetailEmailCaptureModel(attrs)
      errors = emailCapture.validate()

      if errors
        @pushEvent 'retailEmailCapture-submit-email-error'
        @replaceStore emailCaptureErrors: Backbone.Labels.format(errors, @getLocale('country'))
      else
        emailCapture.save null,
          success: @onSuccess.bind(@)
          error: @onError.bind(@)

module.exports = EmailCaptureDispatcher
