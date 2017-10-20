[
  _
  React

  Actions
  Error
  FieldContainer
  Input
  Alert

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/formgroup/actions/actions'
  require 'components/molecules/formgroup/error/error'
  require 'components/organisms/formgroups/field_container/field_container'
  require 'components/atoms/forms/input/input'
  require 'components/quanta/icons/alert/alert'

  require 'components/mixins/mixins'

  require '../formgroup.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-formgroup'

  VARIATION_CLASS: 'c-formgroup--password'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    txtLabel: React.PropTypes.node
    txtSubLabel: React.PropTypes.node
    txtError: React.PropTypes.string
    name: React.PropTypes.string

    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    txtLabel: 'Password'
    txtSubLabel: ''
    txtError: ''
    name: 'field'

    cssUtility: ''
    cssUtilityField: 'u-reset u-fs20'

    cssModifier: ''
    cssModifierField: ''
    cssModifierFieldContainer: ''

  getInitialState: ->
    revealPassword: false

  handleChange: (evt) ->
    @props.valueLink.requestChange evt.target.value if @props.valueLink?
    @props.onChange(evt) if _.isFunction(@props.onChange)

  handleFocus: (evt) ->
    @props.onFocus(evt) if _.isFunction(@props.onFocus)

  handleBlur: (evt) ->
    @props.valueLink.requestChange evt.target.value if @props.valueLink?
    @props.onBlur(evt) if _.isFunction(@props.onBlur)

  handleClickReveal: ->
    @setState revealPassword: not @state.revealPassword

  manageClickClear: ->
    input = React.findDOMNode @refs.input
    input.value = ''
    input.focus()

    @props.valueLink.requestChange '' if @props.valueLink?
    @props.onChange(target: input) if _.isFunction @props.onChange

  componentDidUpdate: (prevProps, prevState) ->
    if prevState.revealPassword isnt @state.revealPassword
      React.findDOMNode(@refs['input']).focus()

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@VARIATION_CLASS}
      #{@props.cssUtility}
      #{@props.cssModifier}
    "
    field: "
      #{@BLOCK_CLASS}__field
      u-field
      #{@props.cssUtilityField}
      #{@props.cssModifierField}
    "
    actions: "#{@BLOCK_CLASS}__actions"
    errorIcon: "#{@BLOCK_CLASS}__icon"

  render: ->
    id = _.kebabCase "formgroup-password-#{@props.txtLabel}-#{@props.name}"
    props = _.omit @props, 'children', 'onChange', 'cssUtility'

    classes = @getClasses()

    value = @props.valueLink?.value or @props.value or @props.defaultValue or ''

    <div className=classes.block>

      <FieldContainer {...props}
        isEmpty={_.isEmpty value}
        cssModifier=@props.cssModifierFieldContainer
        htmlFor=id>

        <Input {...props}
          id=id
          ref='input'
          autoComplete='off'
          autoCorrect='off'
          onBlur=@handleBlur
          onFocus=@handleFocus
          onChange=@handleChange
          type={if @state.revealPassword then 'text' else 'password'}
          value=value
          className=classes.field />

        {if _.isEmpty(@props.txtError)
          <Actions {...@state}
            txtButton={if @state.revealPassword then 'Hide' else 'Show'}
            cssModifier=classes.actions
            handleClickButton=@handleClickReveal
            handleClickClear=@manageClickClear />
        else
          <Alert cssModifier=classes.errorIcon />}

      </FieldContainer>

      <Error {...@props} />
    </div>
