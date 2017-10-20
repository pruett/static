[
  _
  React

  CTA
  Error
  Tooltip
  FormGroupPassword
  FormGroupText

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/error/error'
  require 'components/atoms/tooltip/tooltip'
  require 'components/organisms/formgroups/password/password'
  require 'components/organisms/formgroups/text_v2/text_v2'

  require 'components/mixins/mixins'

  require './user.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-appointment-user'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    appointment: React.PropTypes.object
    cssModifier: React.PropTypes.string
    customer: React.PropTypes.object
    manageCreateAccountToggle: React.PropTypes.func
    manageUserBook: React.PropTypes.func

  getDefaultProps: ->
    cssModifier: ''

  getInitialState: ->
    appointment = @props.appointment or {}

    account_email: appointment.account_email
    account_password: ''
    create_account: appointment.create_account
    email_subscription: appointment.email_subscription

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-fieldset-reset
      u-grid__row -center"
    legend:
      'u-tac
      u-fs20 u-fs30--600 u-fs34--1200
      u-mb4 u-mb30--600
      u-ffs
      u-fws'
    inputs:
      'u-grid__col u-w12c -c-8--600 -c-6--900
      u-tal'
    body:
      'u-fs16 u-lh26 u-color--dark-gray-alt-3 u-fs18--900 u-lh28--900
      u-mt0 u-mb30
      u-tac'
    bodyButton:
      "#{@BLOCK_CLASS}__body-button
      u-button-reset
      u-color--blue
      u-fws"
    emailFormGroup:
      'u-fs16'
    forgotPassword:
      'u-button-reset
      u-db
      u-color--blue
      u-fs16
      u-fws
      u-mtn12 u-mb12 u-mb30--600'
    submit:
      '-cta-full
      u-fs16
      u-fws
      u-ffss'
    genericError:
      'u-fs16
      u-mt12 u-mb24
      u-color--yellow'
    fieldContainer:
      "#{@BLOCK_CLASS}__field-container u-fs16"


  componentDidUpdate: (prevProps) ->
    if _.get(prevProps, 'appointment.create_account') isnt
      _.get(@props, 'appointment.create_account')
        @setState create_account: _.get @props, 'appointment.create_account'

  handleInputChange: (field) ->
    ((evt) ->
      @setState "#{field}": evt.target.value
    ).bind @

  handleCreateAccountToggleClick: (evt) ->
    evt.target.blur()

    if _.isFunction @props.manageSetCreateAccount
      @props.manageSetCreateAccount not @state.create_account

  handleCTAClick: (evt) ->
    if _.isFunction @props.manageUserBook
      @props.manageUserBook(
        _.pick @state, 'account_email', 'account_password', 'create_account', 'email_subscription'
      )

  getCopy: ->
    if @state.create_account
      legend: 'Create account'
      body:
        text: 'Last step! We just need you to create an account before confirming the appointment. Already have one?'
        button: 'Let\'s log you in.'
      labels:
        email: 'Your email address'
        password: 'Create password'
      submit: 'Create account and book exam'

    else
      legend: 'Log in'
      body:
        text: 'Last step! We just need you to log in before confirming the appointment. New?'
        button: 'Create an account.'
      labels:
        email: 'Your email address'
        password: 'Password'
      submit: 'Log in and book exam'

  render: ->
    appointment = @props.appointment or {}
    classes = @getClasses()
    copy = @getCopy()

    <fieldset className=classes.block>
      <legend children=copy.legend className=classes.legend />

      <div className=classes.inputs>
        <p className=classes.body>
          <span children=copy.body.text /> <button children=copy.body.button
            className=classes.bodyButton
            onClick=@handleCreateAccountToggleClick
            type='button' />
        </p>

        <FormGroupText
          cssModifierFieldContainer=classes.fieldContainer
          onChange={@handleInputChange 'account_email'}
          txtError={_.get appointment, 'errors.account_email'}
          txtLabel=copy.labels.email
          value=@state.account_email />

        <FormGroupText
          cssModifierFieldContainer=classes.fieldContainer
          key='password'
          type='password'
          txtLabel='Password'
          txtPlaceholder='Password'
          name='password'
          txtError={_.get appointment, 'errors.account_password'}
          txtLabel=copy.labels.password
          onChange={@handleInputChange 'account_password'}
          value=@state.account_password />

        {if not @state.create_account
          <a children='Forgot password?'
            className=classes.forgotPassword
            href='/account/forgot-password'
            onClick=@handleForgotPasswordClick
            target='_blank' />
        }

        <CTA analyticsSlug='appointments-click-bookUser'
          children=copy.submit
          cssModifier=classes.submit
          onClick=@handleCTAClick
          type='button'
          variation='primary' />

        {if _.get appointment, 'errors.generic'
          <Error children=appointment.errors.generic
            cssModifier=classes.genericError />
        }
      </div>
    </fieldset>
