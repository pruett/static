[
  _
  React

  Tooltip
  FormGroupText
  FormGroupCheckbox
  CTA
  Form
  Error

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/tooltip/tooltip'
  require 'components/organisms/formgroups/text/text'
  require 'components/organisms/formgroups/checkbox/checkbox'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/forms/error/error'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-profile-form'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    React.addons.LinkedStateMixin
  ]

  propTypes:
    manageSubmit: React.PropTypes.func
    manageChangeEmail: React.PropTypes.func
    customerErrors: React.PropTypes.shape(
      generic: React.PropTypes.string
      first_name: React.PropTypes.string
      last_name: React.PropTypes.string
      email: React.PropTypes.string
    )

    customer: React.PropTypes.shape(
      id: React.PropTypes.number
      first_name: React.PropTypes.string
      last_name: React.PropTypes.string
      email: React.PropTypes.string
      wants_marketing_emails: React.PropTypes.bool
    )

  getInitialState: ->
    id: @props.customer.id
    first_name: @props.customer.first_name
    last_name: @props.customer.last_name
    email: @props.customer.email
    wants_marketing_emails: @props.customer.wants_marketing_emails
    sms_opt_in: @props.customer.sms_opt_in

  getDefaultProps: ->
    manageSubmit: ->
    manageChangeEmail: ->

    customerErrors:
      generic: ''
      first_name: ''
      last_name: ''
      email: ''

    customer:
      id: null
      first_name: ''
      last_name: ''
      email: ''
      wants_marketing_emails: false

  handleSubmit: (evt) ->
    evt.preventDefault()
    @props.onSubmit(evt) if _.isFunction(@props.onSubmit)
    @props.manageSubmit(@state) if _.isFunction(@props.manageSubmit)

  handleChangeEmail: (evt) ->
    email = evt.target.value
    @setState email: email
    @props.onChange(evt) if _.isFunction(@props.onChange)
    @props.manageChangeEmail(email) if _.isFunction(@props.manageChangeEmail)

  render: ->
    <Form id='profile-edit'
      method='post'
      className=@BLOCK_CLASS
      validationErrors=@props.customerErrors
      onSubmit=@handleSubmit>
      <FormGroupText
        {...@props}
        txtLabel='First Name'
        name='first_name'
        txtError=@props.customerErrors.first_name
        valueLink=@linkState('first_name') />
      <FormGroupText
        {...@props}
        txtLabel='Last Name'
        name='last_name'
        txtError=@props.customerErrors.last_name
        valueLink=@linkState('last_name') />
      <FormGroupText
        {...@props}
        txtLabel='Email Address'
        name='email'
        type='email'
        autoCapitalize='off'
        txtError=@props.customerErrors.email
        value=@state.email
        onChange=@handleChangeEmail
        onBlur=@handleChangeEmail />
      <CTA
        analyticsSlug='profile-click-changePassword'
        cssModifier='-cta-small -cta-left u-fs12 u-mb24'
        href='/account/profile/password'
        tagName='a'>
        Change password
      </CTA>
      <FormGroupCheckbox
        {...@props}
        name='wants_marketing_emails'
        txtLabel="I’d like to get emails from Warby Parker"
        checkedLink=@linkState('wants_marketing_emails') />
      <FormGroupCheckbox
        {...@props}
        key='sms_opt_in'
        txtLabel={[
          'Text me updates about my order!'
          <br />
          'And yes, I agree to these terms.'
          <Tooltip
            children='I agree to receive texts that might be considered marketing
              and that may be sent using an autodialer.
              I understand checking this box is not required to purchase.' />
        ]}
        name='sms_opt_in'
        checkedLink=@linkState('sms_opt_in') />
      <CTA
        {...@props}
        analyticsSlug='profile-click-save'
        variation='primary'
        cssModifier='-cta-full'>
        Save profile
      </CTA>
      {if @props.customerErrors?.generic
        <Error children={@props.customerErrors.generic} />}
    </Form>
