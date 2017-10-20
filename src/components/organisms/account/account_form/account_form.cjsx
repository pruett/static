[
  _
  React

  LoginForm
  NewCustomerForm
  RightArrow

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/forms/login_form/login_form'
  require 'components/organisms/forms/new_customer_form/new_customer_form'
  require 'components/quanta/icons/right_arrow/right_arrow'

  require 'components/mixins/mixins'

  require './account_form.scss'
]

COPY =
  forgotPassword: 'Forgot password?'
  returningUser:
    heading: 'Sign in'
    action: 'Sign in'
    alt:
      heading: 'I’m new here'
      action: 'Create an account'
  newUser:
      heading: 'Create an account'
      action: 'Create account'
      alt:
        heading: 'I have an account'
        action: 'Sign in'

module.exports = React.createClass
  BLOCK_CLASS: 'c-account-form'

  mixins: [
    Mixins.classes
    Mixins.context
    React.LinkedStateMixin
  ]

  propTypes:
    routeForgotPassword: React.PropTypes.string
    loginErrors: React.PropTypes.object
    unauthorizedError: React.PropTypes.string
    newCustomerErrors: React.PropTypes.object
    manageNewCustomerSubmit: React.PropTypes.func
    manageLoginSubmit: React.PropTypes.func

  getDefaultProps: ->
    routeForgotPassword: '/account/forgot-password'
    loginErrors: {}
    unauthorizedError: ''
    newCustomerErrors: {}
    manageNewCustomerSubmit: ->
    manageLoginSubmit: ->

  handleToggle: (evt) ->
    @setState isNewCustomer: not @state.isNewCustomer

  getInitialState: ->
    isNewCustomer: false

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    form: "
      u-ml0 u-mr0 u-mt24
    "
    heading: '
      u-ffs u-fs24 u-fws
      u-tac
    '
    hr: '
      u-hr
    '
    continueArrow: '
      u-icon u-fill--blue -icon-inline
    '
    loginArrow: '
      u-icon u-fill--white -icon-inline
    '
    forgot: '
      u-ffss u-fs12 u-tac u-mb18
    '
    toggle: '
      u-reset--button
      u-ffss u-fs16 u-fws
      u-color--blue
      u-db u-m0a u-mt4
    '
    toggleHeading: '
      u-ffs u-fs24 u-fws
      u-tac
      u-m0 u-mtn5
    '
    alt: '
      u-tac
    '

  classesWillUpdate: ->
    form:
      'u-mb24': @state.isNewCustomer
      'u-mb12': not @state.isNewCustomer

  render: ->
    classes = @getClasses()
    isNewCustomer = @state.isNewCustomer

    copyState = if isNewCustomer then COPY.newUser else COPY.returningUser

    txtSubmit =
      <span>
        {copyState.action}
        <RightArrow cssUtility=classes.loginArrow />
      </span>

    <div className=classes.block>
      <h1 className=classes.heading children=copyState.heading />
      <div className=classes.form>
        {if isNewCustomer
          <NewCustomerForm
            {...@props}
            manageSubmit=@props.manageNewCustomerSubmit
            key='newCustomerForm'
            showEmailOptIn={@getLocale('country') is 'CA'}
            txtSubmit=txtSubmit />
        else
          <LoginForm
            {...@props}
            manageSubmit=@props.manageLoginSubmit
            key='loginForm'
            txtSubmit=txtSubmit />}
      </div>

      {unless isNewCustomer
        <div className=classes.forgot>
          <a href=@props.routeForgotPassword children=COPY.forgotPassword />
        </div>}

      <hr className=classes.hr />

      <div className=classes.alt>
        <h1 className=classes.toggleHeading children=copyState.alt.heading />

        <button
          onClick=@handleToggle
          className=classes.toggle
          children=copyState.alt.action  />
      </div>

    </div>
