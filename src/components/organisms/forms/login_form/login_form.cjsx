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
  BLOCK_CLASS: 'c-login-form'

  mixins: [
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
    React.addons.LinkedStateMixin
  ]

  propTypes:
    cssModifier: React.PropTypes.string
    manageSubmit: React.PropTypes.func
    initialEmail: React.PropTypes.string
    unauthorizedError: React.PropTypes.string
    login: React.PropTypes.shape
      email: React.PropTypes.string
      password: React.PropTypes.string

    loginErrors: React.PropTypes.shape
      generic: React.PropTypes.string
      email: React.PropTypes.string
      password: React.PropTypes.string

    showEmailOptIn: React.PropTypes.bool
    showTermsAndConditions: React.PropTypes.bool

  getDefaultProps: ->
    manageSubmit: ->
    cssModifier: ''
    initialEmail: ''
    unauthorizedError: ''
    txtSubmit: 'Sign in'
    login:
      email: ''
      password: ''

    loginErrors:
      generic: ''
      email: ''
      password: ''

    showEmailOptIn: false
    showTermsAndConditions: false

  getInitialState: ->
    _.assign {}, @props.login, email: @props.initialEmail

  getStaticClasses: ->
    block: "#{@BLOCK_CLASS} #{@props.cssModifier}"
    emailOptIn: 'u-ml10 u-mr10'
    textInput: 'inspectletIgnore'

  handleSubmit: (evt) ->
    evt.preventDefault()
    @props.onSubmit(evt) if _.isFunction(@props.onSubmit)
    @props.manageSubmit(@state) if _.isFunction(@props.manageSubmit)

  handleChangeEmail: (evt) ->
    @commandDispatcher 'session', 'changeEmail', evt.target.value
    @setState email: evt.target.value

  classesWillUpdate: ->
    ctaStyles:
      '-cta-full': not @props.ctaModifier
      "#{@props.ctaModifier} -cta-full": @props.ctaModifier

  render: ->
    classes = @getClasses()

    <Form id='login'
      key='loginForm'
      method='post'
      validationErrors=@props.loginErrors
      className=classes.block
      onSubmit=@handleSubmit>

      <Error
        children={@props.unauthorizedError}
        cssModifier='u-mb24'
        key='flash-error' />

      <FormGroupText
        key='email'
        onChange=@handleChangeEmail
        onBlur=@handleChangeEmail
        value=@state.email
        cssModifierField=classes.textInput
        txtError=@props.loginErrors.email
        name='email'
        type='email'
        autoCapitalize='off'
        txtLabel='Email Address' />

      <FormGroupPassword
        key='password'
        valueLink=@linkState('password')
        txtError=@props.loginErrors.password
        name='password'
        txtLabel='Password' />

      {if @props.showEmailOptIn
        <EmailOptIn
          cssModifier=classes.emailOptIn
          checkedLink=@linkState('wants_marketing_emails') />
      }

      <CTA
        analyticsSlug='login-click-submit'
        key='submit'
        variation='primary'
        type='submit'
        cssModifier=classes.ctaStyles
        children=@props.txtSubmit />

      {if @props.showTermsAndConditions
        <TermsAndConditions />
      }

      <Error children={@props.loginErrors.generic} key='error' />
    </Form>
