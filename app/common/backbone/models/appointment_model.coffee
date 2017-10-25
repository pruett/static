[
  _

  Backbone
  Logger
] = [
  require 'lodash'

  require '../backbone'
  require '../../logger'
]

log = Logger.get('AppointmentModel').log

class AppointmentModel extends Backbone.BaseModel
  url: -> @apiBaseUrl 'appointments/create'

  defaults: ->
    # Keep this here, outside of defaults set in the dispatcher, to only show
    # the notice when the dispatcher first wakes up, and not on subsequent
    # clearing of this model, like when a user clears booking progress to start
    # over.
    show_notice: true

  validation:
    email:
      pattern: 'email'
      required: true
    first_name:
      required: true
    last_name:
      required: true
    telephone:
      required: true
    account_email:
      pattern: 'email'
      required: (value, attr, computedState) ->
        computedState.service_key is 'optometrist' and
          not computedState.authenticated
    account_password:
      required: (value, attr, computedState) ->
        computedState.service_key is 'optometrist' and
          not computedState.authenticated
    customer_id:
      required: (value, attr, computedState) ->
        computedState.require_customer_id

module.exports = AppointmentModel
