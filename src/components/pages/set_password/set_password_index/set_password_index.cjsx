[
  React

  LayoutDefault

  FormGroupPassword
  Form
  Error
  RightArrow
  CTA

  Mixins
] = [
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/formgroups/password/password'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/forms/error/error'
  require 'components/quanta/icons/right_arrow/right_arrow'
  require 'components/atoms/buttons/cta/cta'

  require 'components/mixins/mixins'

  require '../set_password.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-set-password'

  statics:
    route: ->
      path: '/account/set-password/{token}'
      handler: 'Default'
      bundle: 'session'
      title: 'Set Password'

  mixins: [
    Mixins.classes
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
    @commandDispatcher 'password', 'setPassword',
      password: @state.password
      token: @getRouteParams().token

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    form:
      'u-ml0 u-mr0 u-mt24'
    heading:
      'u-reset u-fs24 u-mb12 u-ffs u-fws'
    subheading:
      'u-reset u-fs16 u-mb24'
    continueArrow:
      'u-icon u-fill--blue -icon-inline'
    loginArrow:
      'u-icon u-fill--white -icon-inline'

  render: ->
    classes = @getClasses()
    errors = @getStore('password').setPasswordErrors or {}

    <LayoutDefault {...@props}>
      <div className=classes.block>
        <h1 className=classes.heading
          children='Welcome!' />
        <p className=classes.subheading
          children='Enter a password for your new account.' />

        <Form
          id='set-password'
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
            analyticsSlug='setPassword-click-submit'
            variation='primary'
            type='submit'
            cssModifier='-cta-full'>
            Create Account
            <RightArrow cssUtility=classes.loginArrow />
          </CTA>
          <Error children={errors.generic} />
        </Form>
      </div>
    </LayoutDefault>
