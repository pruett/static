[
  _
  React

  FormGroupPhoneNumber
  FormGroupText
  Error

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/formgroups/phone_number/phone_number'
  require 'components/organisms/formgroups/text_v2/text_v2'
  require 'components/atoms/forms/error/error'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-checkout-customer-fieldset'

  mixins: [
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
    Mixins.scrolling
    React.addons.LinkedStateMixin
  ]

  propTypes:
    customer: React.PropTypes.object
    customerErrors: React.PropTypes.object
    addresses: React.PropTypes.array
    addressErrors: React.PropTypes.object
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    customer: {}
    customerErrors: {}
    addresses: []
    addressErrors: {}
    cssModifier: ''

  getInitialState: ->
    customer = @props.customer

    first_name: customer.first_name or ''
    last_name:  customer.last_name or ''
    full_name:  customer.full_name or ''
    email:      customer.email or ''
    password:   ''
    telephone:  _.get @props, 'addresses[0].telephone', ''

  componentDidUpdate: (prevProps) ->
    # Changes from false -> true
    if !_.get(prevProps, 'customerErrors.accountRecognized') \
    and  _.get(@props, 'customerErrors.accountRecognized')
      @scrollToNode(React.findDOMNode(@refs.accountRecognized), { offset: -24 })

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-fieldset-reset
      -bordered
    "
    legend: '
      u-mb24 u-pr u-w100p
      u-fs20 u-ffs u-fws
    '
    link:
      'u-link--underline u-pa u-r0 u-t0'
    checkbox:
      'u-fs14 u-color--dark-gray-alt-2'
    checkboxLabel:
      'u-pt2'

  handleChangeInput: (endpoint, field) ->
    _.bind (evt) ->
      if evt.target isnt document.activeElement
        @commandDispatcher 'estimate', 'validateInformation', endpoint,
          "#{field}": evt.target.value
    , @

  render: ->
    classes = @getClasses()
    model = if @props.is_authenticated then 'accountCustomer' else 'customer'

    <fieldset className=classes.block>

      <legend
        key='legend'
        className=classes.legend
        children='Your details' />

      {if @props.customerErrors.generic
        <Error children=@props.customerErrors.generic
          cssModifier='u-mb24' />
      }

      {if @props.customerErrors.accountRecognized
        <Error cssModifier='u-mb18 u-fs14' ref='accountRecognized'>
          We already have an account registered with this email
          address. <a href='/checkout/forgot-password' children='Forgot password?' />
        </Error>
      }

      <FormGroupText
        key='name'
        txtLabel='First and Last Name'
        txtPlaceholder='First and Last Name'
        name='customer_full_name'
        txtError={_.get @props, "errors.#{model}.full_name"}
        isValid={_.get @props, "validatedFields.#{model}.full_name", false}
        valueLink=@linkState('full_name')
        onChange={@handleChangeInput(model, 'full_name')}
        onBlur={@handleChangeInput(model, 'full_name')} />

      {unless @props.is_authenticated
        [
          <FormGroupText
            key='email'
            type='email'
            txtLabel='Email'
            txtPlaceholder='Email'
            name='email'
            txtError={_.get @props, 'errors.customer.email'}
            isValid={_.get @props, 'validatedFields.customer.email', false}
            valueLink=@linkState('email')
            onChange={@handleChangeInput('customer', 'email')}
            onBlur={@handleChangeInput('customer', 'email')}
            autoCapitalize='off'
            autoComplete='email' />

          <FormGroupText
            key='password'
            type='password'
            txtLabel='Password'
            txtPlaceholder='Password'
            name='password'
            txtError={_.get @props, 'errors.customer.password'}
            isValid={_.get @props, 'validatedFields.customer.password', false}
            valueLink=@linkState('password')
            onChange={@handleChangeInput('customer', 'password')}
            onBlur={@handleChangeInput('customer', 'password')} />
        ]}

      <FormGroupPhoneNumber
        key='telephone'
        name='telephone'
        txtLabel='Phone'
        txtPlaceholder='Phone'
        txtError={_.get @props, 'errors.address.telephone'}
        isValid={_.get @props, 'validatedFields.address.telephone', false}
        valueLink=@linkState('telephone')
        onChange={@handleChangeInput('address', 'telephone')}
        onBlur={@handleChangeInput('address', 'telephone')}
        showSmsCheckbox={_.get(@props, 'customer.sms_opt_in', null) is null} />

    </fieldset>
