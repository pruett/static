[
  _
  React

  LayoutDefault

  FormGroupPassword
  CTA
  Form
  Error

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/formgroups/password/password'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/forms/error/error'

  require 'components/mixins/mixins'

  require '../reset_password.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-reset-password'

  statics:
    route: ->
      path: '/account/reset-password/{token}'
      handler: 'Default'
      bundle: 'session'
      title: 'Reset Password'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
    React.addons.LinkedStateMixin
  ]

  receiveStoreChanges: -> [
    'password'
  ]

  getInitialState: ->
    password: ''
    reveal_password: false

  handleSubmit: (evt) ->
    evt.preventDefault()
    @commandDispatcher 'password', 'savePassword',
      password: @state.password
      token: @getRouteParams().token

  render: ->
    errors = @getStore('password').resetPasswordErrors or {}

    <LayoutDefault {...@props}>
      <div className=@BLOCK_CLASS>
        <h1 className='u-reset u-fs30 u-mb24 u-ffs u-fwn'>Reset password</h1>
        <Form
          id='reset-password'
          method='post'
          key='form'
          validationErrors=errors
          onSubmit=@handleSubmit>
          <FormGroupPassword
            txtError=errors.password
            valueLink=@linkState('password')
            name='password'
            txtLabel='New Password' />
          <CTA
            {...@props}
            analyticsSlug='resetPassword-click-submit'
            variation='primary'
            type='submit'
            cssModifier='-cta-full'>
            Change password
          </CTA>
          <Error children={errors.generic} />
        </Form>
      </div>
    </LayoutDefault>
