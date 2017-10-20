[
  _
  React

  FormGroupText
  Markdown
  CTA
  Form
  Error

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/formgroups/text/text'
  require 'components/molecules/markdown/markdown'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/forms/error/error'

  require 'components/mixins/mixins'
]

require './retail_email_capture_form.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-retail-email-capture-form'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    emailCaptureErrors: React.PropTypes.object
    isEmailCaptureSuccessful: React.PropTypes.bool
    copy: React.PropTypes.string
    locationShortName: React.PropTypes.string

  getInitialState: ->
    email: ''

  getDefaultProps: ->
    emailCaptureErrors: {}
    isEmailCaptureSuccessful: false

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    formContainer: '
      u-clearfix
    '
    animationContainer: '
      u-pr
    '
    captureCopy: "
      #{@BLOCK_CLASS}__capture-copy
      u-fs16 u-fs18--900 u-mt36 u-mt66--900 u-mb24
    "
    captureForm: "
      #{@BLOCK_CLASS}__capture-form
      u-pr u-tac u-tal--900
      u-tal
    "
    field: "
      #{@BLOCK_CLASS}__field
      u-fs16 u-tal
    "
    fieldUtility: '
      u-reset u-fs16
    '
    fieldContainer: "
      #{@BLOCK_CLASS}__field-container
    "
    formgroup: "
      #{@BLOCK_CLASS}__formgroup
      u-w100p
      u-mb0
    "
    label: "
      #{@BLOCK_CLASS}__label
    "
    successContainer: "
      #{@BLOCK_CLASS}__success-container
      u-pa u-l0 u-r0
      u-center-y
    "
    thanks: "
      #{@BLOCK_CLASS}__thanks
      u-tac u-fs16 u-ffss u-color--dark-gray-alt-3
    "
    cta: "
      #{@BLOCK_CLASS}__cta
      u-button -button-white u-fs16 u-fws
    "
    plane: "
      #{@BLOCK_CLASS}__plane
      u-db u-m0a
    "
    actions: "
      #{@BLOCK_CLASS}__actions
    "

  classesWillUpdate: ->
    captureCopy:
      '-success': @props.isEmailCaptureSuccessful
    captureForm:
      '-success': @props.isEmailCaptureSuccessful
    plane:
      '-success': @props.isEmailCaptureSuccessful
    thanks:
      '-success': @props.isEmailCaptureSuccessful

  handleSubmit: (evt) ->
    evt.preventDefault()

    @commandDispatcher 'retailEmailCapture', 'subscribe',
      email: @state.email
      short_name: @props.locationShortName

  handleChange: (evt) ->
    @setState email: evt.target.value

  render: ->
    classes = @getClasses()

    <div className=classes.animationContainer>
      <div className=classes.successContainer>
        <img
          className=classes.plane
          src='//i.warbycdn.com/v/c/assets/navigation/image/email-capture/1/96a760c4c2.png' />
        <p className=classes.thanks>Thanks for signing up!</p>
      </div>

      <p className=classes.captureCopy>{@props.copy}</p>
      <Form
        className=classes.captureForm
        onSubmit=@handleSubmit
        id='retailEmailCapture'
        name='retailEmailCapture'
        validationErrors=@props.emailCaptureErrors>

        <div className=classes.formContainer>
          <FormGroupText
            txtError={_.get(@props, 'emailCaptureErrors.email')}
            cssModifier=classes.formgroup
            cssModifierFieldContainer=classes.fieldContainer
            cssModifierField=classes.field
            cssModifierLabel=classes.label
            cssModifierActions=classes.actions
            cssUtilityField=classes.fieldUtility
            value=@state.email
            txtLabel='email address'
            onChange=@handleChange />

          <CTA
            analyticsSlug='retailEmailCapture-click-submit'
            cssModifier=classes.cta
            children='Sign me up' />
        </div>
      </Form>
    </div>
