[
  _
] = [
  require 'lodash'
]

module.exports =
  componentWillReceiveProps: (nextProps) ->
    # When props change, we need to reset the memoized default classes.
    delete @__staticClasses

  getClasses: ->
    if not @__staticClasses?
      # Collapse `getStaticClasses` into objects and memoize the result of in
      # @__defaultClasses for all future calls.
      staticClasses = _.result @, 'getStaticClasses', {}

      for key, classList of staticClasses
        classList = classList.join(' ') if _.isArray(classList)
        # Trim multiple whitespaces and newlines from awkward strings
        # that result from ES6 templates
        classList = classList.replace(/\s+/g, ' ').trim()
        staticClasses[key] = {}
        staticClasses[key][classList] = true

      @__staticClasses = staticClasses

    dynamicClasses = _.result @, 'classesWillUpdate', {}
    mergedClasses = _.merge {}, @__staticClasses, dynamicClasses

    # Stringify classes using keys.
    _.transform mergedClasses, (classes, classObj, key) ->
      classes[key] = _.keys(_.pickBy(classObj, _.identity)).join ' '
    , {}

  pickClasses: (classes = {}, prefix = '') ->
    # Used to pick classes that may need to be prefixed.
    # Returns object with keys reverted to correct name.
    # Example: `calloutBlock` -> `block`

    picked = _.pickBy classes, (val, key) -> key.indexOf(prefix) is 0
    _.mapKeys picked, (val, key) -> _.camelCase key.substr(prefix.length)
