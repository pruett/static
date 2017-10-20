[
  _
  Radio
  React
] = [
  require 'lodash'
  require 'backbone.radio'
  require 'react/addons'
]

module.exports =
  getInteractionCategory: ->
    category = (@ANALYTICS_CATEGORY or @BLOCK_CLASS).replace /^c\-/i, ''
    _.camelCase(category)

  clickInteraction: (name, evt) ->
    category = @getInteractionCategory()
    @trackInteraction "#{category}-click-#{_.camelCase name}", evt

  impressionInteraction: (name) ->
    category = @getInteractionCategory()
    @trackInteraction "#{category}-impression-#{_.camelCase name}"

  trackInteraction: (args...) ->
    # Use @trackInteraction either as the event handler or *from* the event
    # handler for the event that you want to fire tracking on, e.g. click,
    # swipe, etc. If using `@props.analyticsSlug` (see below), the function
    # signature is effectively `trackInteraction: (event) ->`. Otherwise the
    # effective signature is `trackInteraction: (analyticsSlug, event) ->`. The
    # optional-argument-first approach is so that you can do something like: `<a
    # onClick={@trackInteraction.bind @, 'this is an analytics slug'}>Here’s a
    # link</a>`
    #
    # See parseEventSlug in AnalyticsDispatcher for the proper format for
    # analyticsSlug.

    if _.isString(args[0])
      analyticsSlug = args[0]
      event = args[1] or {}
    else
      event = args[0]

    element = event.currentTarget

    # We only use `@props.analyticsSlug` if the interaction in question is on
    # the top-level element of this mixin's component. That's because it'd be
    # confusing for the prop to be passed in and then get used on, say, some
    # arbitrary child <a> inside the component. For interactions on non-top-
    # level components that don't handle tracking within their own use of this
    # mixin (e.g. a plain old child <a> that doesn't have a component of its
    # own), you have to manually pass an analyticsSlug to this function.
    #
    # Slugs should conform to the spec described in the AnalyticsDispatcher's
    # pushEvent command.
    if element is @getDOMNode()
      analyticsSlug = analyticsSlug or @props.analyticsSlug
    else
      analyticsSlug = analyticsSlug

    if not analyticsSlug
      throw new Error 'An analyticsSlug is required to track this interaction.'

    Radio.channel('analytics').request 'pushEvent', name: analyticsSlug
