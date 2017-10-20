[
  _
  React

  Alert

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/alert/alert'
  require 'components/mixins/mixins'

  require './field_container.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-field-container'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    isEmpty: React.PropTypes.bool
    isFieldset: React.PropTypes.bool

    txtLabel: React.PropTypes.node
    txtSuperLabel: React.PropTypes.node
    txtSubLabel: React.PropTypes.node
    txtError: React.PropTypes.node

    htmlFor: React.PropTypes.string

    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

    version: React.PropTypes.oneOf [1, 2]

  getDefaultProps: ->
    isEmpty: true
    isFieldset: false

    txtLabel: ''
    txtSuperLabel: ''
    txtSubLabel: ''
    txtError: ''

    htmlFor: ''

    cssUtility: 'u-reset u-fs12'
    cssModifier: ''

    version: 1

  getInitialState: ->
    isFocused: false

  componentWillReceiveProps: (props) ->
    if _.has props, 'isFocused'
      @setState isFocused: props.isFocused

  getStaticClasses: ->
    wrapper: [
      @BLOCK_CLASS
      @props.cssModifier
    ]
    label: "
      #{@BLOCK_CLASS}__label
      #{@props.cssModifierLabel or ''}"
    superLabel: "
      #{@BLOCK_CLASS}__super-label
      u-reset u-fs12"
    subLabel: "
      #{@BLOCK_CLASS}__sub-label
      u-reset u-fs12"

  classesWillUpdate: ->
    isError = not _.isEmpty(@props.txtError)

    wrapper:
      '-empty':    @props.isEmpty
      '-error':    isError
      '-focus':    @state.isFocused
      '-v2':       @props.version is 2
      '-nolabel':  _.size(@props.txtLabel) is 0
    label:
      '-empty': @props.isEmpty
      '-error': isError
      '-focus': @state.isFocused
      'u-reset
        u-fs12 u-ls2_5 u-ttu':  @props.version is 1
    superLabel:
      '-empty': @props.isEmpty
      '-focus': @state.isFocused

  handleFocus: (evt) ->
    @props.handleFocus(evt) if _.isFunction @props.handleFocus
    @setState isFocused: true

  handleBlur: (evt) ->
    @props.handleBlur(evt) if _.isFunction @props.handleBlur
    @setState isFocused: false

  render: ->
    classes = @getClasses()

    ElWrapper = if @props.isFieldset then 'fieldset' else 'div'
    ElLabel = if @props.isFieldset then 'legend' else 'label'

    <ElWrapper
      onBlur=@handleBlur
      onFocus=@handleFocus
      className=classes.wrapper>

      <ElLabel
        children=@props.txtLabel
        htmlFor=@props.htmlFor
        className=classes.label />

      {@props.children}

      {if @props.txtSuperLabel
        <span children=@props.txtSuperLabel className=classes.superLabel />}

      {if @props.txtSubLabel
        <span children=@props.txtSubLabel className=classes.subLabel />}

    </ElWrapper>
