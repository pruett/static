[
  React

  FormGroupPassword
  CTA
  Form
  Error

  Mixins
] = [
  require 'react/addons'

  require 'components/organisms/formgroups/password/password'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/forms/error/error'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-password-form'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    React.addons.LinkedStateMixin
  ]

  propTypes:
    isError: React.PropTypes.bool

    customer: React.PropTypes.shape
      current_password: React.PropTypes.string
      new_password: React.PropTypes.string

    customerErrors: React.PropTypes.shape
      generic: React.PropTypes.string
      current_password: React.PropTypes.string
      new_password: React.PropTypes.string

  getDefaultProps: ->
    isError: false

    customer:
      current_password: ''
      new_password: ''

    customerErrors:
      generic: ''
      current_password: ''
      new_password: ''

  getInitialState: ->
    current_password: ''
    new_password: ''

    reveal_current_password: false
    reveal_password: false

  handleSubmit: (evt) ->
    evt.preventDefault()
    @props.onSubmit(evt) if _.isFunction(@props.onSubmit)
    @props.manageSubmit(@state) if _.isFunction(@props.manageSubmit)

  render: ->
    <Form id='password-edit'
      method='post'
      validationErrors=@props.customerErrors
      className=@BLOCK_CLASS
      onSubmit=@handleSubmit>
      <FormGroupPassword
        valueLink=@linkState('current_password')
        txtError=@props.customerErrors.current_password
        name='current_password'
        txtLabel='Current Password' />
      <FormGroupPassword
        valueLink=@linkState('new_password')
        txtError=@props.customerErrors.new_password
        name='new_password'
        txtLabel='New Password' />
      <CTA
        {...@props}
        analyticsSlug='changePassword-click-submit'
        variation='primary'
        type='submit'
        cssModifier='-cta-full'>
        Change Password
      </CTA>
      <Error children={@props.customerErrors.generic} />
    </Form>
