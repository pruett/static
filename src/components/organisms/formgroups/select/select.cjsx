[
  _
  React

  Error
  ErrorV2
  FieldContainer
  Alert
  DownArrow

  Mixins
] =[
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/formgroup/error/error'
  require 'components/molecules/formgroup/error_v2/error_v2'
  require 'components/organisms/formgroups/field_container/field_container'
  require 'components/quanta/icons/alert/alert'
  require 'components/quanta/icons/down_arrow/down_arrow'

  require 'components/mixins/mixins'

  require '../formgroup.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-formgroup'

  VARIATION_CLASS: 'c-formgroup--select'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    showBlankOption: React.PropTypes.bool
    txtLabel: React.PropTypes.node
    txtSubLabel: React.PropTypes.node
    txtError: React.PropTypes.string
    name: React.PropTypes.string

    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string
    cssModifierFieldContainer: React.PropTypes.string
    cssModifierSelect: React.PropTypes.string

  getDefaultProps: ->
    showBlankOption: true
    options: [
      label: 'NY'
      value: 'NY'
    ]

    txtLabel: 'State'
    txtSubLabel: ''
    txtError: ''
    name: 'region'
    showErrorText: true

    cssUtility: ''
    cssModifier: ''
    cssModifierFieldContainer: ''
    cssModifierSelect: ''

    version: 1
    valueOnly: false

  getInitialState: ->
    isFocused: false

  receiveStoreChanges: -> [
    'analytics'
  ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@VARIATION_CLASS}
      #{@props.cssUtility}
      #{@props.cssModifier}
    "
    select: "
      #{@BLOCK_CLASS}__field
      #{@props.cssModifierSelect}
      u-field -select
    "
    arrow: "
      #{@BLOCK_CLASS}__arrow
    "
    alert: "
      #{@BLOCK_CLASS}__icon
      -select
    "

  classesWillUpdate: ->
    block:
      '-focus': @state.isFocused
      '-v2': @props.version is 2
      '-error': not _.isEmpty @props.txtError
    select:
      '-empty':       @state.isEmpty
      '-error':       not _.isEmpty @props.textError
      'u-reset u-fs20': @props.version is 1
      '-v2':          @props.version is 2
    arrow:
      'u-fill--dark-gray':      @props.version is 1
      'u-fill--light-gray -v2': @props.version is 2

  getOptions: (options) ->
    # To create arbitrarily nested <optgroup>s, set the `value` key
    # of an option object to itself be an array of option objects.
    _.map options, (option) =>
      if _.isArray option.value
        <optgroup label=option.label key=option.label>
          {@getOptions option.value}
        </optgroup>
      else
        optionValue = if option.value then option.value else option.label
        optionLabel = if @props.valueOnly then option.value else option.label
        <option
          children=optionLabel
          key=optionValue
          value=optionValue />

  handleChange: (evt) ->
    @commandDispatcher 'analytics', 'pushFormEvent', evt
    @props.valueLink.requestChange(evt.target.value) if @props.valueLink?
    @props.onChange(evt) if _.isFunction(@props.onChange)

  handleFocus: (evt) ->
    @commandDispatcher 'analytics', 'pushFormEvent', evt
    @props.onFocus(evt) if _.isFunction(@props.onFocus)
    @setState isFocused: true

  handleBlur: (evt) ->
    @commandDispatcher 'analytics', 'pushFormEvent', evt
    @props.valueLink.requestChange evt.target.value if @props.valueLink?
    @props.onBlur(evt) if _.isFunction(@props.onBlur)
    @setState isFocused: false

  render: ->
    classes = @getClasses()

    id = _.kebabCase "formgroup-select-#{@props.txtLabel}-#{@props.name}"
    props = _.omit @props, 'children', 'onChange', 'valueLink', 'cssUtility'

    value = @props.valueLink?.value or @props.value or @props.defaultValue or ''

    ErrorComponent = if @props.version is 2 then ErrorV2 else Error

    <div className=classes.block>

      <FieldContainer {...props}
        isEmpty={_.isEmpty value}
        cssModifier=@props.cssModifierFieldContainer
        htmlFor=id>

        <select {...props}
          ref='select'
          id=id
          onChange=@handleChange
          onBlur=@handleBlur
          onFocus=@handleFocus
          value=value
          className=classes.select>

          {if @props.txtLabel and @props.showBlankOption
            <option key='label'></option>}

          {@getOptions @props.options}

        </select>

        <DownArrow cssModifier=classes.arrow />

        {if @props.version is 1 and not _.isEmpty(@props.txtError)
          <Alert cssModifier=classes.alert />}

      </FieldContainer>

      {if @props.showErrorText
        <ErrorComponent {...@props} />}

      {@props.children}
    </div>
