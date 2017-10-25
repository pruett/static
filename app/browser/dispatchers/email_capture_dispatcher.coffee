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

class EmailCaptureModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('account/subscribe')

  isNew: -> true

  permittedAttributes: -> [
    'email',
    'origin'
  ]

  validation: ->
    email:
      pattern: 'email'
      required: true
      msg: 'Email address must be valid.'


class EmailCaptureDispatcher extends BaseDispatcher
  log = Logger.get('EmailCaptureDispatcher').log

  channel: -> 'emailCapture'

  getInitialStore: ->
    emailCaptureErrors: {}
    showDialog: false

  mixins: -> [
    'api'
  ]

  onSuccess: ->
    @pushEvent 'emailCapture-submit-email-success'
    @resetErrors()
    @setStore isEmailCaptureSuccessful: true

  onError: (model, xhr, options) ->
    @pushEvent 'emailCapture-submit-email-error'
    errors = @parseApiError(xhr.response)
    @setStore emailCaptureErrors: errors, isEmailCaptureSuccessful: false

  locationDidChange: ->
    # Reset errors after navigation.
    @resetErrors()

  resetErrors: ->
    @setStore(
      emailCaptureErrors: {}
    )

  commands:
    subscribe: (attrs) ->
      @pushEvent 'emailCapture-submit-email-triggered'
      emailCapture = new EmailCaptureModel(_.assign(origin: _.get(@appState, 'location.component'), attrs))
      errors = emailCapture.validate()

      if errors
        @pushEvent 'emailCapture-submit-email-error'
        @replaceStore emailCaptureErrors: Backbone.Labels.format(errors, @getLocale('country'))
      else
        emailCapture.save null,
          success: @onSuccess.bind(@)
          error: @onError.bind(@)

module.exports = EmailCaptureDispatcher
