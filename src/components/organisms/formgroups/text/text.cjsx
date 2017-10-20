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

  VARIATION_CLASS: 'c-formgroup--text'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    txtLabel: React.PropTypes.node
    txtSuperLabel: React.PropTypes.node
    txtSubLabel: React.PropTypes.node
    txtError: React.PropTypes.string
    name: React.PropTypes.string
    value: React.PropTypes.string

    cssUtility: React.PropTypes.string
    cssUtilityField: React.PropTypes.string

    cssModifier: React.PropTypes.string
    cssModifierField: React.PropTypes.string
    cssModifierFieldContainer: React.PropTypes.string

  getDefaultProps: ->
    txtLabel: 'First Name'
    txtSuperLabel: ''
    txtSubLabel: ''
    txtError: ''
    name: 'field'
    value: ''

    cssUtility: ''
    cssUtilityField: 'u-reset u-fs20'

    cssModifier: ''
    cssModifierField: ''
    cssModifierFieldContainer: ''
    cssModifierActions: ''

  handleChange: (evt) ->
    @props.valueLink?.requestChange evt.target.value
    @props.onChange(evt) if _.isFunction @props.onChange

  handleFocus: (evt) ->
    @props.onFocus(evt) if _.isFunction @props.onFocus

  handleBlur: (evt) ->
    @props.valueLink?.requestChange evt.target.value
    @props.onBlur(evt) if _.isFunction @props.onBlur

  manageClickClear: ->
    input = React.findDOMNode @refs.input
    input.focus() if input

    @props.valueLink?.requestChange ''
    @props.onChange(target: value: '') if _.isFunction @props.onChange

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
    actions: "
      #{@BLOCK_CLASS}__actions
      #{@props.cssModifierActions}
    "
    errorIcon: "#{@BLOCK_CLASS}__icon"

  render: ->
    id = _.kebabCase "formgroup-input-#{@props.txtLabel}-#{@props.name}"
    props = _.omit @props, 'children'
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
          autoCapitalize='off'
          onBlur=@handleBlur
          onFocus=@handleFocus
          onChange=@handleChange
          onSelect=@handleChange
          value=value
          className=classes.field />

        {if _.isEmpty(@props.txtError)
          <Actions {...@state}
            handleClickClear=@manageClickClear
            cssModifier=classes.actions />
        else
          <Alert cssModifier=classes.errorIcon />}

      </FieldContainer>

      <Error {...@props} />

      {@props.children}
    </div>
