[
  _
  React

  IIcon

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/i/i'

  require 'components/mixins/mixins'

  require './tooltip.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-tooltip'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  propTypes:
    analyticsSlug: React.PropTypes.string
    isVisible: React.PropTypes.bool
    name: React.PropTypes.string

  getDefaultProps: ->
    analyticsSlug: ''
    cssContentsModifier: ''
    isVisible: true
    name: 'tooltip'
    version: 1

  getInitialState: ->
    didCalculate: false
    isCalculating: false
    isOpen: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
    "
    trigger: "
      #{@BLOCK_CLASS}__trigger
    "
    triggerIcon: "
      #{@BLOCK_CLASS}__trigger-icon
    "
    triggerIconUtility: '
      u-icon u-fill--blue
    '
    contents: "
      #{@BLOCK_CLASS}__contents
      #{@props.cssContentsModifier}
    "
    contentsText: "
      #{@BLOCK_CLASS}__contents-text
      u-ffss u-mb24
    "

  classesWillUpdate: ->
    trigger:
      '-open': @state.isOpen
      '-v2': @props.version is 2
    triggerIcon:
      '-open': @state.isOpen
    contents:
      '-open': @state.isOpen
      '-calculating': @state.isCalculating
      '-v2': @props.version is 2
    contentsText:
      '-open': @state.isOpen
      'u-fs16': @props.version is 1
      'u-fs14
       u-color--dark-gray-alt-2
       -v2': @props.version is 2

  componentDidMount: ->
    if @props.isVisible
      @setUpHeightCalculation()

  setUpHeightCalculation: ->
    @triggerHeightCalculation()
    window?.addEventListener 'resize', @triggerHeightCalculation

  componentWillUnmount: ->
    window?.removeEventListener 'resize', @triggerHeightCalculation

  triggerHeightCalculation: ->
    @setState isCalculating: true

  componentDidUpdate: (prevProps) ->
    if @props.isVisible and not prevProps.isVisible
      # Component just became visible; calculation will now work.
      @setUpHeightCalculation()

    else if @state.isCalculating
      # Ok to calculate the contents' height.
      @setState(
        contentsHeight: @getContentsHeight()
        didCalculate: true
        isCalculating: false
      )

  getContentsHeight: ->
    el = React.findDOMNode @refs['contents-text']
    el.offsetHeight

  handleTriggerBlur: (evt) ->
    # This bit of ugliness accommodates certain browsers that, when a focused
    # button is clicked, fire a blur event before the click event. The `_.delay`
    # call here attempts to ensure that `@setState` happens after the click
    # handler has executed.
    if _.isFunction @props.handleBlur
      @props.handleBlur(evt)
    else
      _.delay (-> @setState isOpen: false).bind(@), 100

  handleTriggerClick: (evt) ->
    evt.preventDefault()

    isClosed = not @state.isOpen
    evt.currentTarget.focus() if isClosed

    @setState isOpen: isClosed, (->
      if @props.analyticsSlug
        @trackInteraction "#{@props.analyticsSlug}-#{if @state.isOpen then 'open' else 'close'}"
    ).bind @

    if _.isFunction @props.handleClick
      @props.handleClick(evt)

  render: ->
    classes = @getClasses()

    contentsHeight = if @state.isOpen and not @state.isCalculating
        @state.contentsHeight
      else
        0

    <span className=classes.block>
      <button
        name=@props.name
        className=classes.trigger
        onClick=@handleTriggerClick
        onFocus=@props.handleFocus
        onBlur=@handleTriggerBlur
        type='button'>
        <IIcon
          cssModifier=classes.triggerIcon
          cssUtility=classes.triggerIconUtility
          fillBackground=@state.isOpen />
      </button>

      <span
        className=classes.contents
        style={height: contentsHeight}>
        <span
          ref='contents-text'
          className=classes.contentsText
          children=@props.children />
      </span>
    </span>
