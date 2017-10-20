[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './cta.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-cta'

  mixins: [
    Mixins.analytics
  ]

  propTypes:
    children: React.PropTypes.node
    cssModifier: React.PropTypes.string
    cssUtility: React.PropTypes.string
    disabled: React.PropTypes.bool
    tagName: React.PropTypes.string
    title: React.PropTypes.string
    variation: React.PropTypes.oneOf ['default', 'primary', 'secondary', 'simple', 'minimal']

  getDefaultProps: ->
    children: 'Submit'
    cssModifier: ''
    cssUtility: 'u-dib u-reset'
    disabled: false
    tagName: 'button'
    variation: 'default'

  componentDidMount: ->
    if @props.trackImpressions
      @impressionInteraction @props.title

  handleClick: (event) ->
    @props.onClick(event) if _.isFunction(@props.onClick)

    # This if/else block fixes bugs introduced in https://github.com/WarbyParker/helios/pull/5330,
    # where CTAs being used outside of customer center were falling back on the default value for
    # `@props.title`, instead of respecting their `analyticsSlug` value. The fix supports building
    # the wp.event from either @props.title and the event, or from the event alone. Instead of
    # passing a `title` prop (which has other meaning on an anchor tag), this should be updated
    # to consistently build the `wp.event` value from one source, probably `analyticsSlug`.

    if @props.title
      @clickInteraction @props.title, event
    else
      @trackInteraction event

  render: ->
    eventProps = {}
    eventProps['data-eventid'] = @props.analyticsSlug if @props.analyticsSlug

    <@props.tagName {...@props} {...eventProps}
      onClick=@handleClick
      className={[
        @BLOCK_CLASS
        "#{@BLOCK_CLASS}--#{@props.variation}" if @props.variation
        @props.cssUtility
        @props.cssModifier
        ].join ' '}
      disabled=@props.disabled />
