_ = require 'lodash'

module.exports =
  class WildcardTrie
    constructor: ->
      @children = {}
      @value = null

    __splitPattern: (pattern) ->
      if _.isString(pattern)
        pattern = _.first pattern.split('?')
        _.trim(pattern, '/').split('/')
      else
        pattern

    add: (pattern, value) ->
      pattern = @__splitPattern(pattern)

      if _.isEmpty(pattern)
        @value = value
        return

      head = _.first(pattern)
      tail = _.tail(pattern)

      @children[head] ?= new WildcardTrie
      @children[head].add(tail, value)

    matches: (pattern, wildcard = '*') ->
      pattern = @__splitPattern(pattern)

      head = _.first(pattern)
      tail = _.tail(pattern)

      matches = if @value? then [@value] else []

      for part in [head, wildcard]
        if part in _.keys(@children)
          matches = matches.concat(
            @children[part].matches(tail, wildcard=wildcard)
          )

      matches
