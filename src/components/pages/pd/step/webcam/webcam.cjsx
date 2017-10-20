[
  _
  React

  ReloadArrow
  Breadcrumbs
  CTA
  Form
  WebcamOverlay
  PhotoUpload
  ModalAlert
  LayoutMinimal
  Footer

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/reload_arrow/reload_arrow'
  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/pd_webcam_overlay/pd_webcam_overlay'
  require 'components/molecules/pd/photo_upload/photo_upload'
  require 'components/organisms/modals/modal_alert/modal_alert'
  require 'components/layouts/layout_minimal/layout_minimal'
  require 'components/molecules/pd/footer/footer'

  require 'components/mixins/mixins'

  require './webcam.scss'
]


module.exports = React.createClass

  BLOCK_CLASS: 'c-pd-webcam'

  mixins: [
    Mixins.context
    Mixins.classes
    Mixins.dispatcher
    Mixins.analytics
  ]

  breadcrumbs: [
    {text: 'How to measure PD', href: '/pd/instructions'}
    {text: 'Tool'}
  ]

  receiveStoreChanges: -> [
    'capabilities'
  ]

  statics:
    route: ->
      path: '/pd/webcam'
      handler: 'Pd'
      bundle: 'pd'

  getDefaultProps: =>
    showFooter: false
    showHelpFooter: true
    actions:
      takePhoto: @takePhoto
      retakePhoto: @retakePhoto
    alert:
      txtHeading: "You'll need to allow access to your camera to get started. \
                  (Look for a notification near the top of your browser.)"
      children: "Without camera access, you won't be able take a new photo, \
                but you can always upload a photo from your computer if that's easier."
      txtConfirm: 'Got it.'
      routeConfirm: ''
    image:
      src: '//i.warbycdn.com/v/c/assets/pd/image/camera-button/0/5b2dfa9db6/150x150/27bc.png'
      alt: 'Camera Button'
      width: '60'
      height: '60'

  getInitialState: ->
    countDownText: ''         # the current number of the countdown
    cameraFlash: false        # display the white "camera flash" overlay
    countDown: false          # the user has clicked the camera button and the shutter is counting down
    takingPhoto: true         # the camera is currently active
    photoTaken: false         # a photo has been taken
    webcamInitialized: false  # the camera has been initialized and is drawing to the canvas
    askedCamera: false        # the user has been asked for permission to use the camera
    refusedCamera: false      # the user has refused permission to access the camera
    retryCamera: false        # the user has dismissed the modal after refusing camera access;
                              # allow them to retry granting camera access

  clearModal: (evt) ->
    evt.preventDefault()
    @setState
      refusedCamera: false
      retryCamera: true

  submitPhotoForm: ->
    form = React.findDOMNode(@refs.pdPhotoForm)
    pdFormData = new FormData(form)
    @commandDispatcher 'pd', 'upload', pdFormData

  componentDidMount: ->
    @commandDispatcher 'capabilities', 'ensure', 'canvasToBlob'
    @commandDispatcher 'capabilities', 'ensure', 'getUserMedia'
    @initWebcam() if @getStore('capabilities').getUserMedia?.available

  componentDidUpdate: ->
    # If the capabilities dispatcher was delayed in de-prefixing getUserMedia, init the webcam
    @initWebcam() if @getStore('capabilities').getUserMedia?.available and not @state.askedCamera

  componentWillUnmount: ->
    # Turn off the webcam
    if _.get(@state, 'stream.getTracks')
      @state.stream.getTracks()[0].stop()
    else if _.get(@state, 'stream.stop')
      @state.stream.stop()

  initWebcam: ->
    video = React.findDOMNode(@refs.pdVideo)
    canvas = React.findDOMNode(@refs.pdCanvas)

    video.addEventListener('play', @drawVideo)

    @setState askedCamera: true

    navigator.getUserMedia(
      {
        video: true
        audio: false
      },
      (stream) =>
        @setState
          refusedCamera: false
          stream: stream
        if (navigator.mozGetUserMedia)
          video.mozSrcObject = stream;
        else
          vendorURL = window.URL || window.webkitURL
          video.src = vendorURL.createObjectURL(stream)
        video.play()
      , =>
        @setState refusedCamera: true
    )

  drawVideo: ->
    video = React.findDOMNode(@refs.pdVideo)
    canvas = React.findDOMNode(@refs.pdCanvas)
    return unless video and canvas

    canvas.height = video.videoHeight
    canvas.width = video.videoWidth
    ctx = canvas.getContext('2d')
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height)

    if not @state.webcamInitialized
        @setState 'webcamInitialized': true

    setTimeout(@drawVideo, 20)

  takePhoto: ->
    video = React.findDOMNode(@refs.pdVideo)
    video.pause()
    @setState
      cameraFlash: true
      countDown: false
      countDownText: ''
      takingPhoto: false
      photoTaken: true

    setTimeout (=> @setState cameraFlash: false), 200

  retakePhoto: ->
    video = React.findDOMNode(@refs.pdVideo)
    video.play()
    @setState
      takingPhoto: true
      photoTaken: false

  handleUsePhoto: ->
    canvas = React.findDOMNode(@refs.pdCanvas)
    canvas.toBlob (blob) =>
      formData = new FormData()
      formData.append('image_file', blob, 'pd_image.jpg')
      @commandDispatcher 'pd', 'upload', formData
    , 'image/jpeg'

  handleUploadLinkClick: ->
    @refs.uploadPhoto.handleSubmitButtonClick()

  handleCameraButtonClick: ->
    return if @state.countDown

    @setState countDown: true
    @countDown(3, @takePhoto)

    @trackInteraction 'pd-click-takePhoto'

  countDown: (count, callback, timeout=1000) ->
    if count > 0
      @setState countDownText: count
      setTimeout(@countDown, timeout, count - 1, callback)
    else
      callback()

  getStaticClasses: ->
    buttonSeparator: "#{@BLOCK_CLASS}__button-separator"
    cameraButton: 'u-mt24 u-mb12'
    hr: 'u-bc--light-gray u-bw0 u-bbw1 u-bss'
    breadcrumbs: "#{@BLOCK_CLASS}__breadcrumbs"
    cameraFlashOverlay: "#{@BLOCK_CLASS}__camera-flash-overlay"
    canvas: "#{@BLOCK_CLASS}__canvas"
    canvasPlaceholder: "#{@BLOCK_CLASS}__canvas-placeholder"
    countDownOverlay: "#{@BLOCK_CLASS}__countdown-overlay"
    hideAll: 'u-dn'
    layout: '-use-grid -full-page'
    retakePhoto: "#{@BLOCK_CLASS}__retake-photo
      u-button -button-white -button-large
      u-fs16 u-ffss u-fws u-mt36 u-mr6
      "
    uploadButton: "#{@BLOCK_CLASS}__upload-button
      u-color--blue u-button-reset
      u-mt18 u-ffss u-fws u-fs16
      "
    usePhoto: "#{@BLOCK_CLASS}__use-photo
      u-button -button-blue -button-large
      u-fs16 u-ffss u-fws u-mt36 u-ml6
      "
    webcam: "#{@BLOCK_CLASS} u-pr u-tac"

  classesWillUpdate: ->
    hideCameraButton = (not (
        @state.webcamInitialized and
        _.get @getStore('capabilities'), 'canvasToBlob.available'
      )) or @state.photoTaken

    buttonSeparator:
      'u-dn': not @state.photoTaken
    cameraFlashOverlay:
      '-fade-in': @state.cameraFlash
    cameraNotSupported:
      'u-dn': _.get @getStore('capabilities'), 'getUserMedia.supported'
    cameraSupported:
      'u-dn': not _.get @getStore('capabilities'), 'getUserMedia.supported'
    cameraButton:
      'u-dn': hideCameraButton
      'u-dib': not hideCameraButton
    hr:
      'u-dn': hideCameraButton
    cameraPermission:
      'u-dn': not _.get @getStore('capabilities'), 'getUserMedia.supported'
    canvas:
      'u-dn': not @state.webcamInitialized
    countDownOverlay:
      'u-dn': not @state.countDown
    retakePhoto:
      '-button-hide': not @state.photoTaken
    retryCameraPermission:
      'u-dn': not @state.retryCamera
    usePhoto:
      '-button-hide': not @state.photoTaken
    webcamOverlay:
      '-fade-out': not (@state.webcamInitialized and @state.takingPhoto and not @state.countDown)

  render: ->
    classes = @getClasses()
    capabilities = @getStore('capabilities')
    toBlobAvailable = capabilities.canvasToBlob?.available
    getUserMediaSupported = capabilities.getUserMedia?.supported

    <LayoutMinimal cssModifier=classes.layout {...@props}>
      <Breadcrumbs links=@breadcrumbs cssModifier=classes.breadcrumbs {...@props} />
      <div className=classes.webcam>
        <video ref='pdVideo' className=classes.hideAll />
        <div className=classes.canvasPlaceholder>
          <p className=classes.cameraPermission>
            Grant access to your camera to begin
            <br />
            (look for a notification near the top of your browser).
            <br />
          </p>
          <p className=classes.cameraNotSupported>
            Accessing your camera...<br /><br />
            If your browser doesn’t support camera access, don’t worry &mdash; we can MacGyver this one!<br />
            Just follow the instructions on the previous page to take a photo using another device,<br />
            and then <a onClick=@handleUploadLinkClick>upload your photo.</a>  Easy.
          </p>
          <p>
            <a
              className=classes.retryCameraPermission
              onClick=@initWebcam>
              Click here to take a picture once you’ve granted access (you may need to refresh the page).
            </a>
          </p>
        </div>
        <canvas ref='pdCanvas' className=classes.canvas />
        <WebcamOverlay cssModifier=classes.webcamOverlay />
        <div className=classes.cameraFlashOverlay />
        <p className=classes.countDownOverlay children=@state.countDownText />

        <a {...@props}
          onClick=@handleCameraButtonClick
          className=classes.cameraButton>
          <img {...@props.image} />
        </a>

        <hr className=classes.hr />

        <CTA
          analyticsSlug='pd-click-retakePhoto'
          variation='minimal'
          cssUtility=classes.retakePhoto
          children='Retake photo'
          onClick=@retakePhoto />

        <CTA
          analyticsSlug='pd-click-usePhoto'
          variation='minimal'
          cssUtility=classes.usePhoto
          children='Use this photo'
          onClick=@handleUsePhoto />

        <div className=classes.cameraSupported>
          <PhotoUpload
            txtSubmit='Upload a photo instead'
            allowWebcam=false
            cssUtilitySubmit=classes.uploadButton
            ref='uploadPhoto' />
        </div>

        <div className=classes.cameraNotSupported>
          <br />
          <PhotoUpload
            txtSubmit='Upload your photo'
            allowWebcam=false
            cssUtilitySubmit=classes.uploadButton
            ref='uploadPhoto' />
        </div>
      </div>
      {if @state.refusedCamera
        <ModalAlert onConfirm=@clearModal {...@props.alert} />
      }
    </LayoutMinimal>
