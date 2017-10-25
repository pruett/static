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

class ResetPasswordModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('reset-password')

  isNew: -> true

  permittedAttributes: -> [
    'password'
    'token'
  ]

  validation: ->
    password:
      required: true

class ForgotPasswordModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('forgot-password')

  isNew: -> true

  permittedAttributes: -> [
    'email'
  ]

  validation: ->
    email:
      required: true
      pattern: 'email'
      msg: 'Email address must be valid.'

class PasswordDispatcher extends BaseDispatcher
  log = Logger.get('PasswordDispatcher').log

  channel: -> 'password'

  getInitialStore: ->
    forgotPasswordErrors: {}
    resetPasswordErrors: {}

  mixins: -> [
    'api'
    'modals'
  ]

  onSavePasswordSuccess: ->
    @modals success: 'savePassword'
    @resetErrors()
    @navigate '/account/reset-password/success'

  onSavePasswordError: (model, xhr, options) ->
    @modals error: 'savePassword'

    errors = @parseApiError(xhr.response)

    if errors.generic and not errors.password
      errors.password = errors.generic
      errors.generic = false

    @replaceStore resetPasswordErrors: errors

  onForgotPasswordSuccess: (attrs) ->
    @modals success: 'forgotPassword'
    @resetErrors()
    @setStore email: attrs.email
    @navigate @successRouteForgot

  onForgotPasswordError: (model, xhr, options) ->
    @modals error: 'forgotPassword'

    errors = @parseApiError(xhr.response)

    if errors.generic and not errors.email
      errors.email = errors.generic
      errors.generic = false

    @replaceStore forgotPasswordErrors: errors

  onSetPasswordSuccess: ->
    @modals success: 'setPassword'
    @resetErrors()
    @navigate '/account/set-password/success'

  onSetPasswordError: (model, xhr, options) ->
    @modals error: 'setPassword'

    errors = @parseApiError(xhr.response)

    if errors.generic and not errors.password
      errors.password = errors.generic
      errors.generic = false

    @replaceStore setPasswordErrors: errors

  resetErrors: ->
    @setStore forgotPasswordErrors: {}, resetPasswordErrors: {}, setPasswordErrors: {}

  locationDidChange: ->
    # Reset errors after navigation.
    @resetErrors()

  commands:
    savePassword: (attrs) ->
      return if @modals isShowing: 'savePassword'

      resetPassword = new ResetPasswordModel(attrs)
      errors = resetPassword.validate()

      if errors
        @replaceStore resetPasswordErrors: Backbone.Labels.format(errors, @getLocale('country'))
      else
        @modals loading: 'savePassword'
        resetPassword.save null,
          success: @onSavePasswordSuccess.bind(@)
          error: @onSavePasswordError.bind(@)

    forgotPassword: (attrs, @successRouteForgot = '/account/forgot-password/success') ->
      return if @modals isShowing: 'forgotPassword'

      forgotPassword = new ForgotPasswordModel(attrs)
      errors = forgotPassword.validate()

      if errors
        @replaceStore forgotPasswordErrors: Backbone.Labels.format(errors, @getLocale('country'))
      else
        @modals loading: 'forgotPassword'
        forgotPassword.save null,
          success: @onForgotPasswordSuccess.bind(@, attrs)
          error: @onForgotPasswordError.bind(@)

    setPassword: (attrs) ->
      return if @modals isShowing: 'setPassword'

      setPassword = new ResetPasswordModel(attrs)
      errors = setPassword.validate()

      if errors
        @replaceStore setPasswordErrors: Backbone.Labels.format(errors, @getLocale('country'))
      else
        @modals loading: 'setPassword'
        setPassword.save null,
          success: @onSetPasswordSuccess.bind(@)
          error: @onSetPasswordError.bind(@)

module.exports = PasswordDispatcher
