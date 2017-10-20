[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './listbox.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-listbox'

  mixins: [
    Mixins.context
    Mixins.classes
    Mixins.keyEvent
    Mixins.dispatcher
    React.addons.LinkedStateMixin
  ]

  propTypes:
    name: React.PropTypes.string
    options: React.PropTypes.arrayOf(
      React.PropTypes.shape(
        data: React.PropTypes.shape(
          id: React.PropTypes.oneOfType [
            React.PropTypes.number
            React.PropTypes.string
          ]
        )
        component: React.PropTypes.func
      )
    )
    focusedIndex: React.PropTypes.number
    labelId: React.PropTypes.string
    onChange: React.PropTypes.func
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    options: []
    focusedIndex: 0
    cssModifier: ''

  getStaticClasses: ->
    block: [
      @BLOCK_CLASS
      @props.cssModifier
    ]
    legend:
      'u-reset u-fs24 u-ffs u-mb12 u-fws'
    listContainer:
      "#{@BLOCK_CLASS}__list-container"
    list: [
      "#{@BLOCK_CLASS}__list"
      'u-list-reset'
    ]
    input:
      "#{@BLOCK_CLASS}__input"

  classesWillUpdate: ->
    option:
      '-expanded': @state.isOpen

  getInitialState: ->
    isFocused: false
    isOpen: false
    focusedIndex: @props.focusedIndex

  intercept: (evt) ->
    if evt
      evt.preventDefault()
      evt.stopPropagation()

  createEvent: (type) ->
    return unless document?
    input = React.findDOMNode @refs.input
    event = document.createEvent 'Event'
    event.initEvent type, true, false
    input.dispatchEvent event
    event

  handleBlur: (evt) ->
    @commandDispatcher 'analytics', 'pushFormEvent', @createEvent('blur')
    @intercept evt
    @setState isFocused: false
    @handleClose()

  handleFocus: (evt) ->
    @commandDispatcher 'analytics', 'pushFormEvent', @createEvent('focus')
    @intercept evt
    @setState isFocused: true

  handleClick: (val) ->
    if @state.isOpen
      @setState focusedIndex: val
      @handleClose()
    else
      @handleOpen()

  handleOpen: (evt) ->
    @intercept evt
    @setState isOpen: true, (->
      React.findDOMNode(@refs.menu).focus()
    ).bind(@)

  handleClose: (evt) ->
    @intercept evt
    @setState isOpen: false

  moveFocus: (move) ->
    lastOptionIndex = @props.options.length - 1
    targetedOption = @state.focusedIndex + move

    index = if targetedOption >= lastOptionIndex
        lastOptionIndex
      else if targetedOption > 0
        targetedOption
      else
        0
    @setState focusedIndex: index

  handleArrowDownKey: (evt) ->
    @intercept evt
    if @state.isOpen
      @moveFocus 1
    else
      @handleOpen()

  handleArrowUpKey: (evt) ->
    @intercept evt
    if @state.isOpen
      @moveFocus -1
    else
      @handleOpen()

  # React maps space to ' '
  'handle Key': (evt) ->
    @intercept evt
    unless @state.isOpen
      @handleOpen evt
    else
      @handleClose()
      React.findDOMNode(@refs.menu).focus()

  handleEnterKey: (evt) ->
    return unless @state.isOpen

    @intercept evt
    @handleClose()
    React.findDOMNode(@refs.menu).focus()

  handleEscapeKey: (evt) ->
    if @state.isOpen
      @handleClose evt

  componentWillUpdate: (nextProps, nextState) ->
    if @state.focusedIndex isnt nextState.focusedIndex
      selectedValue = @props.options[nextState.focusedIndex].data.id
      @linkState('selectedValue').requestChange selectedValue

      @props.onChange? selectedValue
      @commandDispatcher 'analytics', 'pushFormEvent', @createEvent('change')

  renderOption: (option, i) ->
    classes = @getClasses()

    ###
    # An option is treated specially if either:
    # 1. The listbox is expanded and it's the first option
    # 2. The listbox is closed and it's the selected option
    ###
    isExpandedFirstOrClosedSelected = (@state.isOpen and i is 0) or
      (not @state.isOpen and @state.focusedIndex is i)

    cssModifier = [
      classes.option
      '-selected' if @state.focusedIndex is i
      '-focused' if @state.isFocused and isExpandedFirstOrClosedSelected
    ].join ' '

    showDownArrow = isExpandedFirstOrClosedSelected and
      @props.options.length > 1

    <option.component
      key=i
      role='option'
      id="#{@props.name}-#{option.data.id}"
      onClick={@handleClick.bind(@, i)}
      cssModifier=cssModifier
      aria-selected={@state.focusedIndex is i}
      optionData=option.data
      showDownArrow=showDownArrow
      showDot={@props.options.length > 2} />

  render: ->
    classes = @getClasses()
    inputId = _.kebabCase "formgroup-input-#{@props.name}"

    <div className=classes.block>
      <ul
        role='listbox'
        ref='menu'
        className=classes.list
        tabIndex=0
        onFocus=@handleFocus
        onBlur=@handleBlur
        onKeyDown=@handleKeyDown
        aria-labelledby=@props.labelId
        aria-activedescendant=@state.focusedIndex>

        {_.map @props.options, @renderOption}
      </ul>

      <input
        id=inputId
        ref='input'
        type='hidden'
        name=@props.name
        className=classes.input
        value=@linkState('selectedValue').value />
    </div>
