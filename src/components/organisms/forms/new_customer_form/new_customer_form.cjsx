[
  _
  React

  EmailOptIn
  FormGroupText
  FormGroupPassword
  CTA
  Form
  Error
  TermsAndConditions

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/formgroups/email_opt_in/email_opt_in'
  require 'components/organisms/formgroups/text/text'
  require 'components/organisms/formgroups/password/password'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/forms/error/error'
  require 'components/atoms/terms_and_conditions/terms_and_conditions'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-new-customer-form'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    React.addons.LinkedStateMixin
  ]

  propTypes:
    manageSubmit: React.PropTypes.func
    initialEmail: React.PropTypes.string
    txtSubmit: React.PropTypes.node
    hideNameFields: React.PropTypes.bool
    showEmailOptIn: React.PropTypes.bool
    newCustomer: React.PropTypes.shape(
      email: React.PropTypes.string
      password: React.PropTypes.string
      first_name: React.PropTypes.string
      last_name: React.PropTypes.string
    )

    newCustomerErrors: React.PropTypes.shape(
      generic: React.PropTypes.string
      email: React.PropTypes.string
      password: React.PropTypes.string
      first_name: React.PropTypes.string
      last_name: React.PropTypes.string
    )

  getDefaultProps: ->
    manageSubmit: ->
    initialEmail: ''
    txtSubmit: 'Sign in'
    hideNameFields: false
    showEmailOptIn: false
    newCustomer:
      email: ''
      password: ''
      first_name: ''
      last_name: ''

    newCustomerErrors:
      generic: ''
      email: ''
      password: ''
      first_name: ''
      last_name: ''

  getInitialState: ->
    _.assign {}, @props.newCustomer, email: @props.initialEmail

  handleChangeEmail: (evt) ->
    @commandDispatcher 'session', 'changeEmail', evt.target.value
    @setState email: evt.target.value

  handleSubmit: (evt) ->
    evt.preventDefault()
    @props.onSubmit(evt) if _.isFunction(@props.onSubmit)
    @props.manageSubmit(@state) if _.isFunction(@props.manageSubmit)

  render: ->
    <Form id='new-account'
      key='newCustomerForm'
      method='post'
      validationErrors=@props.newCustomerErrors
      className=@BLOCK_CLASS
      onSubmit=@handleSubmit>

      { unless @props.hideNameFields
        [ <FormGroupText
            key='first_name'
            valueLink=@linkState('first_name')
            txtError=@props.newCustomerErrors.first_name
            name='first_name'
            txtLabel='First Name' />
        , <FormGroupText
            key='last_name'
            valueLink=@linkState('last_name')
            txtError=@props.newCustomerErrors.last_name
            name='last_name'
            txtLabel='Last Name' />
        ]
      }

      <FormGroupText
        key='email'
        type='email'
        autoCapitalize='off'
        value=@state.email
        onChange=@handleChangeEmail
        onBlur=@handleChangeEmail
        txtError=@props.newCustomerErrors.email
        name='email'
        txtLabel='Email Address' />

      <FormGroupPassword
        key='password'
        valueLink=@linkState('password')
        txtError=@props.newCustomerErrors.password
        name='password'
        txtLabel='Password' />

      {if @props.showEmailOptIn
        <EmailOptIn checkedLink=@linkState('wants_marketing_emails') />
      }

      <CTA
        analyticsSlug='signup-click-submit'
        key='submit'
        variation='primary'
        type='submit'
        cssModifier='-cta-full'
        children=@props.txtSubmit />

      <TermsAndConditions />

      <Error children={@props.newCustomerErrors.generic} key='error' />
    </Form>
