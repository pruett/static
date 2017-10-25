[
  _
  Backbone
] = [
  require 'lodash'
  require '../../backbone/backbone'
]

module.exports =
  parseApiError: (rawResp) ->
    unhandledError = generic: 'Oh no. Something went wrong. Please try again.'
    errors = {}

    try
      resp = JSON.parse(rawResp)
    catch
      return unhandledError

    fields = _.get(resp, 'error.fields', {})
    message = _.get(resp, 'error.message')
    status_code = _.get(resp, 'error.status_code')

    if status_code is 401
      # Catch when the API says the user is not logged-in and navigate to
      # /login.
      @commandDispatcher 'session', 'unauthorized'
      return generic: 'Oops. You\'ll need to sign in first.'
    else if status_code is 413
      return generic: message

    if _.isEmpty fields
      if message
        return generic: resp.error.message
      else
        return unhandledError
    else
      errors['generic'] = false
      _.mapValues fields, (message, fieldName) ->
        if "#{message}".toLowerCase() is 'please enter a value'
          message = Backbone.Labels.message(fieldName, 'is required')
        message or false

    _.assign errors, fields
