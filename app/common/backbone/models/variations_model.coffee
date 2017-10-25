Backbone = require '../backbone'

class VariationsModel extends Backbone.BaseModel
  initialize: (attrs, options) ->
    @path = options.path
    @query = options.query or ''
    @url = @apiBaseUrl("variations#{@path}#{@query}")

  defaults: ->
    # Initial fetching time.
    __fetching: new Date().getTime()

  parse: (resp) ->
    resp.variations

module.exports = VariationsModel
