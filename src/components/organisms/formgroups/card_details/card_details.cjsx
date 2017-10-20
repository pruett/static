[
  _
  React

  Error
  FieldContainer
  FormGroupText
  Input
  CreditCard
  Alert
  Circle

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/formgroup/error_v2/error_v2'
  require 'components/organisms/formgroups/field_container/field_container'
  require 'components/organisms/formgroups/text_v2/text_v2'
  require 'components/atoms/forms/input/input'
  require 'components/atoms/icons/credit_card/credit_card'
  require 'components/quanta/icons/alert/alert'
  require 'components/quanta/icons/circle/circle'

  require 'components/mixins/mixins'

  require '../formgroup.scss'
  require './card_details.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass

  BLOCK_CLASS: 'c-formgroup'

  VARIATION_CLASS: 'c-formgroup--card-details'

  FIELDS: ['number', 'expiration', 'cvv', 'address_zip']

  STEP_TWO: ['expiration', 'cvv', 'address_zip']

  mixins: [
    Mixins.classes
    Mixins.context
    Mixins.creditCard
    Mixins.dispatcher
    Mixins.localization
  ]

  propTypes: ->
    txtError: React.PropTypes.string
    number: React.PropTypes.string
    expiration: React.PropTypes.string
    cvv: React.PropTypes.string
    address_zip: React.PropTypes.string
    onChange: React.PropTypes.func

  getDefaultProps: ->
    paymentErrors: {}

    number: ''
    expiration: ''
    cvv: ''
    address_zip: ''
    fieldLabel: 'Card Details'

  getInitialState: ->
    focusedField: null

    number:      @getFormattedState(value: @props.number, name: 'number')
    expiration:  @getFormattedState(value: @props.expiration, name: 'expiration')
    cvv:         @getFormattedState(value: @props.cvv, name: 'cvv')
    address_zip: @getFormattedState(
      value: @props.address_zip
      name: 'address_zip'
      selectionStart: @props.address_zip.length
    )

  # See https://html.spec.whatwg.org/multipage/forms.html#autofill
  autoComplete:
    number:      'billing cc-number'
    cvv:         'billing cc-csc'
    expiration:  'billing cc-exp'
    address_zip: 'billing postal-code'

  componentWillReceiveProps: (props) ->
    if props.address_zip and not @props.address_zip and not _.get @state, 'address_zip.value'
      @setState address_zip: @getFormattedState(
        value: props.address_zip
        name: 'address_zip'
        selectionStart: props.address_zip.length
      )
      @props.onChange 'address_zip': props.address_zip

  componentDidUpdate: (prevProps, prevState) ->
    return unless document?

    field = @getUpdatedField prevState
    return unless field

    input = @getInputElementFromField field
    name = input.name

    if _.has @refs, name # If input in our component.

      mode = @state[name]

      if name in ['number', 'expiration']
        # Fix cursor position.
        input.setSelectionRange(mode.selectionStart, mode.selectionStart)

      # Get next mode if complete and changing value.
      if mode.complete and mode.value isnt prevState[name].value
        newMode = switch name
          when 'number'     then 'expiration'
          when 'expiration' then 'cvv'
          when 'cvv'        then 'address_zip'

        if newMode
          @focusInput @getInputElementFromField(newMode)
        else
          @props.onChange "#{name}": mode.value

  focusInput:
    # Prevent jumpy focus on autocomplete.
    _.debounce (input) ->
      input.focus()
    , 50

  getUpdatedField: (prevState) ->
    _.findLast @FIELDS, (field) =>
      @state[field].value isnt prevState[field].value

  getInputElementFromField: (name) ->
    el = React.findDOMNode(@refs[name])
    return {} unless el
    if el.tagName is 'INPUT' then el else el.getElementsByTagName('input')[0]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@VARIATION_CLASS}
      -v2
    "
    helper: '
      u-pt12
      u-fs14
      u-color--dark-gray-alt-1
    '
    inputNumber: '
      c-formgroup__field
      u-field -v2 -card
      inspectletIgnore
    '
    inputInline:
      'u-w4c -inline'
    stepTwo: '
      u-mt18 u-mbn18
    '

  classesWillUpdate: ->
    circle:
      '-valid': @isComplete()
      '-error': @getErrorMessage().length > 0

  isComplete: ->
    _.reduce ['cc_number', 'cc_expires_year', 'cc_cvv', 'address_zip'], (result, field) =>
      result and _.get @props.validatedFields, field, false
    , true

  isStepTwoFocused: ->
    @STEP_TWO.indexOf(@state.focusedField) isnt -1

  getErrorMessage: ->
    if _.size(@props.errors) > 1
      'Mind checking your payment real quick?'
    else if _.size(@props.errors) is 1
      _.values(@props.errors)[0]
    else
      ''

  getFormattedState: (options) ->
    _.defaults options, { name: '', value: '', selectionStart: 0 }

    {value, name, selectionStart} = options

    format = switch name
      when 'expiration'  then '09/82'
      when 'address_zip'
        if @getLocale('country') is 'CA' then 'A1A1A1' else '12345'
      when 'cvv'
        number = _.get @state, 'number.value', ''
        cardInfo = @findCard firstDigit: number.substr(0, 1)
        cardInfo.formatCVV

      else # Credit Card Number
        cardInfo = @findCard firstDigit: value.substr(0, 1)
        cardInfo.formatNumber

    digits = value.replace(/\D/g, '') # Remove non-numbers

    # Recalculate selectionStart
    preCursorSpacer =
      if name is 'address_zip'
        0
      else
        value.substr(0, selectionStart).replace(/\d/g, '').length
    newSelectionStart = selectionStart - preCursorSpacer

    spacers = 0
    if name is 'expiration'
      # If the first and only digit is neither greater than 1,
      # we can auto-advance the user to the year portion of the input.
      if digits.length is 1 and parseInt(digits) > 1
        digits = "0#{digits}"
        spacers = 1

      # If autocompleting with the full year, we take the last two digits.
      else if digits.length > 4
        digits = digits.substr(0, 2) + digits.substr(-2)

    # Truncate to maximum digit length.
    digits = digits.substr(0, format.replace(/\D/g, '').length)
    # Add in spacers, default with empty string.
    if name is 'address_zip'
      formatted = value.toUpperCase()
      complete = formatted.length >= format.length
    else
      formatted = _.reduce digits, (result, digit, i) ->
        # If format has spacer, add that before next number.
        if format[result.length] and isNaN(parseInt(format[result.length]))
          if i < newSelectionStart then spacers += 1
          result += format[result.length]
        result += digit
      , ''

      newSelectionStart += spacers

      # Trailing spacer
      if format[formatted.length] and isNaN parseInt(format[formatted.length])
          formatted += format[formatted.length]
          if newSelectionStart is formatted.length - 1
            newSelectionStart = formatted.length

      # Deleting a trailing spacer
      prevValue = _.get @state, "#{name}.formatted", ''
      if isNaN(parseInt(prevValue.slice(-1))) and
      value.length < prevValue.length and
      formatted.length is newSelectionStart
        formatted = formatted.slice(0, -2)
        newSelectionStart -= 2

      complete = formatted.length is format.length

    value: value
    formatted: formatted
    complete: complete
    selectionStart: newSelectionStart

  handleFocus: (evt) ->
    @setState focusedField: evt.target.name

  handleBlur: (evt) ->
    @setState focusedField: null
    @props.onBlur(evt) if _.isFunction @props.onBlur

  handleChange: (evt) ->
    objTarget = _.pick evt.target, 'value', 'name', 'selectionStart'
    return if objTarget.value is _.get @state[objTarget.name], 'formatted'

    formattedState = @getFormattedState objTarget
    if formattedState.formatted isnt _.get @state[objTarget.name], 'formatted'
      @setState "#{objTarget.name}": formattedState

  getLabel: (field) ->
    @localize("labels.#{field}", @getLocale('country')) or ''

  inputProps: (mode) ->
    autoComplete:     @autoComplete[mode]
    autoFill:         true
    onBlur:           @handleBlur
    onChange:         @handleChange
    onFocus:          @handleFocus
    onSelect:         @handleChange
    name:             mode
    ref:              mode
    value:            @state[mode].formatted # Show formatted version.
    validation:       false
    showErrorText:    false
    cssModifier:      @classes.inputInline
    cssModifierField: 'inspectletIgnore'
    txtError:         _.get @props, "errors.#{mode}"

  printCreditCardDetail: ->
    company = @findCard(firstDigit: @state.number.value.charAt(0)).name

    if @state.number.value or @state.focusedField is 'number'
      <div className='u-pa u-p12'>
        <CreditCard cardType=company />
      </div>

  printHelperText: ->
    return '' unless document? # Based on client.

    @getHelperCopy _.get(document, 'activeElement.name')

  getHelperCopy: (field) ->
    switch field
      when 'expiration'  then 'Please enter your card’s expiration date.'
      when 'address_zip' then "Please enter your billing #{@getLabel('postal_code').toLowerCase()}."
      when 'cvv'
        company = @findCard(firstDigit: @state.number.value.charAt(0)).name
        if company is 'American Express'
        then 'Please enter the four-digit security code on the front of your card.'
        else 'Please enter the three-digit security code on the back of your card.'
      when 'number' then 'Please add your credit card number.'

  render: ->
    cleanProps = _.omit @props, 'children', 'onChange'
    @classes = @getClasses()

    helper = @printHelperText()
    error = @getErrorMessage()

    <div className=@classes.block>

      <FieldContainer {...cleanProps}
        isFocused={@state.focusedField is 'number'}
        isEmpty={@state.number.value is ''}
        txtLabel={@props.fieldLabel}
        txtError={_.get @props, 'errors.number'}
        htmlFor='card_number'
        version=2>

        <ReactCSSTransitionGroup
          transitionName='-transition-card-icon'
          transitionAppear
          transitionLeave=false
          children={@printCreditCardDetail()} />

        <Input
          {...cleanProps}
          {...@inputProps('number')}
          className=@classes.inputNumber
          id='card_number'
          type='tel'
          pattern='[0-9]*'
          placeholder='1234 1234 1234 1234' />

        <Circle cssModifier=@classes.circle />

      </FieldContainer>

      <ReactCSSTransitionGroup
        transitionName='-transition-card-details'
        transitionAppear>
        {if @state.number.value or @state.focusedField is 'number'
          <div className=@classes.stepTwo>
            <FormGroupText
              type="tel"
              {...@inputProps('expiration')}
              pattern='[0-9]*'
              txtPlaceholder='MM/YY' />

            <FormGroupText
              type="tel"
              {...@inputProps('cvv')}
              pattern='[0-9]*'
              txtPlaceholder='CVC' />

            <FormGroupText
              type={if @getLocale('country') is "US" then "tel" else "text"}
              {...@inputProps('address_zip')}
              pattern={'[0-9]*' if @getLocale('country') is 'US'}
              txtPlaceholder={@getLabel('postal_code')} />
          </div>}
      </ReactCSSTransitionGroup>

      {if @state.number.value and @isStepTwoFocused() and helper isnt error
        <div className=@classes.helper children=helper />}

      <Error txtError=error />

    </div>
