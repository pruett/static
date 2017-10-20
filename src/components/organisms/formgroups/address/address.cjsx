[
  _
  React

  Actions
  Error
  ErrorV2
  Places
  FieldContainer
  Input

  Alert
  Circle

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/formgroup/actions/actions'
  require 'components/molecules/formgroup/error/error'
  require 'components/molecules/formgroup/error_v2/error_v2'
  require 'components/atoms/places/places'
  require 'components/organisms/formgroups/field_container/field_container'
  require 'components/atoms/forms/input/input'

  require 'components/quanta/icons/alert/alert'
  require 'components/quanta/icons/circle/circle'

  require 'components/mixins/mixins'

  require '../formgroup.scss'
  require './address.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-formgroup'

  VARIATION_CLASS: 'c-formgroup--address'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
  ]

  receiveStoreChanges: -> [
    'places'
  ]

  getStoreChangeHandlers: ->
    places: 'handleChangePlaces'

  propTypes:
    onSuccess: React.PropTypes.func

  getDefaultProps: ->
    value: ''
    version: 1
    validatedFields: {}

    onSuccess: (address) ->
      # Return address object w/
      #  formatted_address
      #  street_address
      #  postal_code
      #  country_code
      #  locality
      #  region

  getInitialState: ->
    isFocused: false

  handleChangePlaces: (nextStore) ->
    return unless nextStore.chosenAddress
    @props.onSuccess(nextStore.chosenAddress)
    @commandDispatcher 'places', 'resetChosenAddress'

  handleClickPlace: (index, evt) ->
    @commandDispatcher 'places', 'setChosenAddressByIndex', index
    @setState isFocused: false

  handleClickClear: ->
    @commandDispatcher 'places', 'resetSuggestions'
    input = React.findDOMNode @refs.input
    input.value = ''
    input.focus()

    @props.valueLink?.requestChange ''
    @props.onChange(target: input) if _.isFunction @props.onChange

  handleChange: (evt) ->
    @commandDispatcher 'places', 'findSuggestions', evt.target.value
    @props.valueLink?.requestChange evt.target.value
    @props.onChange(evt) if _.isFunction @props.onChange

  handleFocus: (evt) ->
    @props.onFocus(evt) if _.isFunction @props.onFocus

  handleFocusContainer: (evt) ->
    @setState isFocused: true

  handleBlur: (evt) ->
    @props.valueLink?.requestChange evt.target.value
    @props.onBlur(evt) if _.isFunction @props.onBlur

  handleBlurContainer: (evt) ->
    @setState isFocused: false

  componentDidUpdate: ->
    places = @getStore('places')
    unless _.isEmpty places.suggestions
      # Add listener if has places
      window.addEventListener 'keydown', @activateNavigation
    else
      # Remove listener if no places
      window.removeEventListener 'keydown', @activateNavigation

  activateNavigation: (evt) ->
    if @state.isFocused and [38, 40].indexOf(evt.which) isnt -1
      evt.preventDefault()
      node = # Grab nodes.
        focus: React.findDOMNode document.activeElement
        place: React.findDOMNode(@refs.places).querySelector 'a'
        input: React.findDOMNode @refs.input

      if evt.which is 40 # Down key pressed.
        node.next = node.focus.nextElementSibling
        node.curr = if node.focus is node.input then node.place else node.next
      else if evt.which is 38 # Up key pressed.
        node.prev = node.focus.previousElementSibling
        node.curr = if node.focus is node.place then node.input else node.prev

      node.curr?.focus()

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@VARIATION_CLASS}
      #{@props.cssUtility or ''}
      #{@props.cssModifier or ''}
      inspectlet-sensitive
    "
    field: "
      #{@BLOCK_CLASS}__field
      #{@VARIATION_CLASS}__field
      u-field
    "
    fieldContainer: "
      #{@VARIATION_CLASS}__field-container
    "
    label: "
      #{@VARIATION_CLASS}__label
    "
    actions: "
      #{@BLOCK_CLASS}__actions
      #{@VARIATION_CLASS}__actions
    "
    errorIcon: "
      #{@BLOCK_CLASS}__icon
    "
    places: "
      #{@VARIATION_CLASS}__places
    "

  classesWillUpdate: ->
    block:
      '-v2': @props.version is 2
    field:
      'u-reset u-fs20': @props.version is 1
      '-v2 -validation': @props.version is 2
    circle:
      '-error': not _.isEmpty @props.txtError
      '-valid': @props.version is 2 and @isValid()

  isValid: ->
    _.reduce ['street_address', 'locality', 'postal_code', 'region'], (result, field) =>
      result and _.get(@props.validatedFields, field, false)
    , true

  render: ->
    classes = @getClasses()
    places = @getStore('places')

    value = @props.valueLink?.value or @props.value or @props.defaultValue or ''
    id = _.kebabCase "formgroup-input-#{@props.txtLabel}-#{@props.name}"

    <div className=classes.block>
      <FieldContainer
        ref='inputContainer'
        cssModifier=classes.fieldContainer
        cssModifierLabel=classes.label
        name=@props.name
        htmlFor=id
        txtError=@props.txtError
        txtLabel=@props.txtLabel
        version=@props.version
        isFocused=@state.isFocused
        handleFocus=@handleFocusContainer
        handleBlur=@handleBlurContainer
        isEmpty={value is ''}>

        <Input {...@props}
          id=id
          name=@props.name
          ref='input'
          autoCapitalize='off'
          autoComplete={if @state.isFocused and value.length then 'off' else 'on'}
          onBlur=@handleBlur
          onFocus=@handleFocus
          onChange=@handleChange
          onSelect=@handleChange
          onPaste=@handleLookup
          value=value
          className=classes.field />

        <Places
          ref='places'
          cssModifier=classes.places
          address=@props.valueLink?.value
          suggestions=places.suggestions
          handleClick=@handleClickPlace />

        {if @props.version is 1
          if _.isEmpty(@props.txtError)
            <Actions {...@state}
              handleClickClear=@handleClickClear
              cssModifier=classes.actions />

          else
            <Alert cssModifier=classes.errorIcon />
        else
          <Circle cssModifier=classes.circle />}

      </FieldContainer>

      {if @props.version is 1
        <Error {...@props} />
      else
        <ErrorV2 {...@props} />}
    </div>
