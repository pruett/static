_ = require 'lodash'

module.exports =
  handleKeyDown: (evt) ->
    @["handle#{evt.key}Key"]? evt
