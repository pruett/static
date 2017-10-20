[
  _
  React

  FormGroupText
  BackLink
  CTA
  Form
  Error
  RightArrow

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/formgroups/text/text'
  require 'components/atoms/back_link/back_link'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/forms/error/error'
  require 'components/quanta/icons/right_arrow/right_arrow'

  require 'components/mixins/mixins'

  require '../forgot_password.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-forgot-password'

  mixins: [
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
    React.addons.LinkedStateMixin
  ]

  propTypes:
    errors: React.PropTypes.object

  getDefaultProps: ->
    initialEmail: ''
    errors: {}
    backLink: ''
    cssModifier: ''

  getInitialState: ->
    email: @props.initialEmail

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS} #{@props.cssModifier}"
    backLink:
      "#{@BLOCK_CLASS}__back-link"
    heading:
      'u-reset u-fs24 u-mb12 u-ffs u-fws'
    subheading:
      'u-reset u-fs16 u-mb24'

  handleChangeEmail: (evt) ->
    @commandDispatcher 'session', 'changeEmail', evt.target.value
    @setState email: evt.target.value

  handleSubmit: (evt) ->
    evt.preventDefault()
    @props.onSubmit(evt) if _.isFunction(@props.onSubmit)
    @props.manageSubmit(@state.email) if _.isFunction(@props.manageSubmit)

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <BackLink cssModifier=classes.backLink />

      <h1 className=classes.heading
        children='Forgot password' />
      <p className=classes.subheading
        children='Enter your email address and we’ll send you instructions to
          reset your password.' />

      <Form
        id='forgot-password'
        method='post'
        key='form'
        validationErrors=@props.errors
        onSubmit=@handleSubmit>

        <FormGroupText
          txtError=@props.errors.email
          onChange=@handleChangeEmail
          onBlur=@handleChangeEmail
          value=@state.email
          name='email'
          type='email'
          autoCapitalize='off'
          txtLabel='Email address' />

        <CTA
          analyticsSlug='forgotPassword-click-reset'
          key='submit'
          variation='primary'
          type='submit'
          cssModifier='-cta-full'>
          {'Send reset instructions'}
          <RightArrow cssUtility='u-icon u-fill--white -icon-inline' />
        </CTA>

        <Error children=@props.errors.generic />
      </Form>
    </div>
