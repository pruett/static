[
  _
  Radio
] = [
  require 'lodash'
  require 'backbone.radio'
]

class HTTPError extends Error
  name: 'HTTPError'

  constructor: (@statusCode, @message = '') ->


module.exports =
  getRouteParams: ->
    if window?
      _.get Radio.channel('routing').request('location'), 'params', {}
    else
      _.get @props, 'appState.location.params', {}

  getRouteQuery: ->
    if window?
      _.get Radio.channel('routing').request('location'), 'query', {}
    else
      _.get @props, 'appState.location.query', {}

  navigateError: (statusCode = 404, message = 'Not Found') ->
    if window?
      Radio.channel('routing').request 'showErrorPage',
        statusCode: statusCode
        message: message
    else
      throw new HTTPError(statusCode, message)

  findObjectOr404: (collection, source) ->
    foundObject = _.find collection, source

    if not foundObject?
      @navigateError()
      foundObject = {}

    foundObject
