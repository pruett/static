[
  _
  React

  Error
  FieldContainer
  Input
  Circle

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/formgroup/error_v2/error_v2'
  require 'components/organisms/formgroups/field_container/field_container'
  require 'components/atoms/forms/input/input'
  require 'components/quanta/icons/circle/circle'

  require 'components/mixins/mixins'

  require '../formgroup.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-formgroup'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    txtLabel: React.PropTypes.string
    txtError: React.PropTypes.string
    txtPlaceholder: React.PropTypes.string
    name: React.PropTypes.string
    value: React.PropTypes.string

    cssUtility: React.PropTypes.string
    cssUtilityField: React.PropTypes.string

    cssModifier: React.PropTypes.string
    cssModifierField: React.PropTypes.string
    cssModifierFieldContainer: React.PropTypes.string

  getDefaultProps: ->
    txtLabel: ''
    txtError: ''
    txtPlaceholder: ''
    name: 'field'
    type: 'text'
    value: ''
    validation: true
    isValid: false
    showErrorText: true
    inputRef: 'input'
    errorIsRed: true

    cssUtility: ''
    cssUtilityField: ''

    cssModifier: ''
    cssModifierField: ''
    cssModifierFieldContainer: ''

  getInitialState: ->
    isFocused: false
    revealPassword: false

  handleChange: (evt) ->
    @props.valueLink?.requestChange evt.target.value
    @props.onChange(evt) if _.isFunction @props.onChange

  handleFocus: (evt) ->
    @props.onFocus(evt) if _.isFunction @props.onFocus
    @setState isFocused: true

  handleBlur: (evt) ->
    @props.valueLink?.requestChange evt.target.value
    @props.onBlur(evt) if _.isFunction @props.onBlur
    @setState isFocused: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS} -v2
      #{@props.cssUtility}
      #{@props.cssModifier}
    "
    field: "
      #{@BLOCK_CLASS}__field
      u-field -v2
      #{@props.cssUtilityField}
      #{@props.cssModifierField}
    "
    button: "
      #{@BLOCK_CLASS}__button
      u-button-reset
      u-color--blue
      u-fs14 u-fws
    "
    circle: '
      u-pa u-center-y
    '

  classesWillUpdate: ->
    block:
      '-focus': @state.isFocused
      '-error': not _.isEmpty @props.txtError
    field:
      '-validation': @props.validation
      'inspectletIgnore': @props.type is 'password'
    circle:
      '-error': not _.isEmpty @props.txtError
      '-valid': @props.isValid and _.isEmpty @props.txtError
    button:
      '-validation': @props.validation and (@props.isValid or @props.txtError.length)

  handlePasswordReveal: ->
    @setState revealPassword: not @state.revealPassword
    React.findDOMNode(@refs[@props.inputRef]).focus()

  render: ->
    id = @props.id or _.kebabCase "formgroup-input-#{@props.txtLabel}-#{@props.name}"
    props = _.omit @props, 'children'
    classes = @getClasses()

    value = @props.valueLink?.value or @props.value or @props.defaultValue or ''

    <div className=classes.block>

      <FieldContainer {...props}
        isEmpty={_.isEmpty value}
        cssModifier=@props.cssModifierFieldContainer
        htmlFor=id
        version=2>

        <Input {...props}
          id=id
          type={if @state.revealPassword then 'text' else @props.type}
          ref=@props.inputRef
          autoCapitalize='off'
          onBlur=@handleBlur
          onFocus=@handleFocus
          onChange=@handleChange
          onSelect=@handleChange
          placeholder={@props.txtPlaceholder or @props.placeholder}
          value=value
          className=classes.field />

        {if @props.type is 'password' and value.length
          <button
            type='button'
            className=classes.button
            children={if @state.revealPassword then 'Hide' else 'Show'}
            onClick=@handlePasswordReveal />}

        {if @props.validation
          <Circle cssModifier=classes.circle />}

      </FieldContainer>

      {if @props.showErrorText
        <Error txtError=@props.txtError isRed=@props.errorIsRed />}

      {@props.children}
    </div>
