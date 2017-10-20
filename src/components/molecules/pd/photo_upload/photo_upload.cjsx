[
  _
  React

  CTA
  Form
  Link

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/link/link'

  require 'components/mixins/mixins'

  require './photo_upload.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-photo-upload'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
    Mixins.analytics
  ]

  receiveStoreChanges: -> [
    'capabilities'
  ]

  getDefaultProps: ->
    allowWebcam: true
    txtSubmit: 'Measure PD'
    cssModifier: ''
    cssUtility: ''
    cssModifierSubmit: ''
    cssUtilitySubmit: 'c-cta c-cta--primary u-fs16 u-lh22 u-ffss'
    ctaTagName: 'button'

  handleSubmitButtonClick: (event) ->
    # This is a bit hacky, but it's the simplest way to style
    # a file input.
    event?.preventDefault()
    React.findDOMNode(@refs.pdPhotoSubmit).click()

    @trackEvent()

  submitPhotoForm: ->
    @trackInteraction 'pd-click-uploadPhoto'

    form = React.findDOMNode(@refs.pdPhotoForm)
    pdFormData = new FormData(form)
    @commandDispatcher 'pd', 'upload', pdFormData

  componentDidMount: ->
    # This is a nasty hack because JSX won't support the "capture" attr
    # until a future React release. See https://github.com/facebook/react/pull/3950.
    submit = React.findDOMNode(@refs.pdPhotoSubmit).setAttribute('capture', 'camera')

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssUtility}
      #{@props.cssModifier}
    "
    uploadForm: "#{@BLOCK_CLASS}__form"
    button: "#{@BLOCK_CLASS}__button #{@props.cssModifierSubmit} #{@props.cssUtilitySubmit}"
    webcamButton: "#{@BLOCK_CLASS}__button #{@props.cssModifierSubmit} #{@props.cssUtilitySubmit}"

  classesWillUpdate: ->
    uploadForm:
      '-show-mobile': @props.allowWebcam
    webcamButton:
      '-show-desktop': @props.allowWebcam
      '-hide': not @props.allowWebcam

  trackEvent: ->
    @trackInteraction 'pd-click-' + _.camelCase(@props.txtSubmit)

  render: ->
    classes = @getClasses()

    <div
      className=classes.block>
      <Form
        className=classes.uploadForm
        encType="multipart/form-data"
        method='post'
        ref='pdPhotoForm'>
        {@props.children}
        <button
          className=classes.button
          children=@props.txtSubmit
          onClick=@handleSubmitButtonClick
        />
        <input
          type="file"
          name="image_file"
          accept="image/*;capture=camera"
          capture="camera"
          ref='pdPhotoSubmit'
          className='u-dn'
          onChange=@submitPhotoForm
        />
      </Form>
      <Link
        onClick=@trackEvent
        children=@props.txtSubmit
        href='/pd/webcam'
        className=classes.webcamButton />
    </div>
