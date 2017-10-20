[
  _
  React

  CTA
  Form

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/form/form'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-order-issue'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
    Mixins.analytics
  ]

  propTypes:
    cssModifier: React.PropTypes.string
    cssUtility: React.PropTypes.string
    filename: React.PropTypes.string
    onClick: React.PropTypes.func
    title: React.PropTypes.string
    onSubmit: React.PropTypes.func
    orderId: React.PropTypes.string
    variation: React.PropTypes.string
    showEyeExamLink: React.PropTypes.bool

  getDefaultProps: ->
    filename: 'image'
    title: @BLOCK_CLASS
    showEyeExamLink: false

  getStaticClasses: ->
    upload:
      'u-hide--visual'
    mobileEyeExamLinkWrapper:
      'u-dn--900 u-mb8'
    desktopEyeExamLinkWrapper:
      "#{@BLOCK_CLASS}__desktop-eye-exam-link u-dn u-db--900 u-pl60 u-pl0--900 u-pl30--1200 u-pr"
    eyeExamLink:
      "#{@BLOCK_CLASS}__link u-fs16 u-reset u-bbss u-bbw2 u-bc--blue u-fws u-pb6"
    mobileEyeExamSpacerText:
      'u-fs16 u-reset u-mb4'
    desktopEyeExamSpacerText:
      'u-fs16 u-reset u-pl6'

  classesWillUpdate: ->
    wrapper:
      'u-dib--600': @props.showEyeExamLink

  handleSubmitForm: (evt) ->
    evt.preventDefault()
    @props.onSubmit() if _.isFunction @props.onSubmit

  onUploadReady: (evt) ->
    formData = new FormData React.findDOMNode(@refs.uploadForm)
    @commandDispatcher 'prescriptionRequest', 'uploadPrescription', formData,
      orderId: @props.orderId

  handleEyeExamClick: ->
    @trackInteraction 'customerCenter-clickLink-eyeExams'

  render: ->
    classes = @getClasses()

    <div>
      <div className=classes.wrapper>
        <Form
          ref='uploadForm'
          onSubmit=@handleSubmitForm
          encType='multipart/form-data'>
            <CTA
              onClick=@props.onClick
              variation=@props.variation
              cssModifier=@props.cssModifier
              cssUtility=@props.cssUtility
              title=@props.title
              tagName='label'
              htmlFor='file'>
              {@props.children}
              <input
                id='file'
                accept='image/gif, image/jpeg, image/png, application/pdf'
                className=classes.upload
                onChange=@onUploadReady
                type='file'
                name=@props.filename />
            </CTA>
        </Form>
      </div>
      {
        if @props.showEyeExamLink
          <div>
            <div className=classes.mobileEyeExamLinkWrapper>
              <div children='or' className=classes.mobileEyeExamSpacerText />
              <a href='/appointments/eye-exams'
                onClick=@handleEyeExamClick
                className=classes.eyeExamLink
                children='Book an eye exam' />
            </div>
            <div className=classes.desktopEyeExamLinkWrapper>
              <a href='/appointments/eye-exams'
                onClick=@handleEyeExamClick
                className=classes.eyeExamLink
                children='Book an eye exam' />
              <span children=' or ' className=classes.desktopEyeExamSpacerText />
            </div>
          </div>
      }
    </div>
