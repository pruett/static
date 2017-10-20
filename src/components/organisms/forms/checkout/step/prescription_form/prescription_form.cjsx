[
  _
  React

  CheckoutSummary
  CTA
  FlowChoice
  ExistingPrescriptionChoice
  Form
  Error

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/checkout/summary/summary'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/buttons/flow_choice/flow_choice'
  require 'components/atoms/buttons/prescription_choice/prescription_choice'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/forms/error/error'

  require 'components/mixins/mixins'

  require './prescription_form.scss'
]

COPY =
  heading:
    add: 'Add a new prescription'
    saved: 'Select a saved prescription or add a new prescription'
    expired: 'Let’s get your prescription'
  hidden: 'See other saved prescriptions'
  readers: 'I need reading glasses'
  nonPrescription: 'I need non-prescription glasses'
  buttonBack: 'Back to prescription page'
  subHeadingExpired: '
    All saved prescriptions have expired.
    Time to enter a new one!
  '

module.exports = React.createClass
  BLOCK_CLASS: 'c-order-prescription-form'

  mixins: [
    Mixins.context
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    routeReaders: React.PropTypes.string
    routeCallDoctor: React.PropTypes.string

    savedPrescriptions: React.PropTypes.array
    showPrescriptions: React.PropTypes.array
    hidePrescriptions: React.PropTypes.array

  getDefaultProps: ->
    routeReaders: '/checkout/step/prescription/readers'
    routeCallDoctor: '/checkout/step/prescription/call-doctor'

    savedPrescriptions: []
    showPrescriptions: []
    hidePrescriptions: []

  getInitialState: ->
    showHidden: false
    showAdd: false

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    heading: "
      #{@BLOCK_CLASS}__heading
      u-ffs u-fws u-fs20
      u-mt0 u-mb12
    "
    subHeading:
      "#{@BLOCK_CLASS}__sub-heading u-reset u-fs16 u-mb24"
    addIcon:
      'u-icon u-fill--dark-gray -icon-margin-right'
    horizontalRule:
      "#{@BLOCK_CLASS}__horizontal-rule u-hr"
    buttonAddPrescription:
      '-cta-full -cta-large -v2'
    buttonBack: "
      #{@BLOCK_CLASS}__back
      u-button -button-small -button-gray
      u-reset u-fs12
    "
    buttonBack2: "
      #{@BLOCK_CLASS}__show-prescriptions
      u-button-reset
      u-fs14 u-fws
    "
    buttonShowPrescriptions: "
      #{@BLOCK_CLASS}__show-prescriptions
      u-button-reset
      u-fs14 u-fws
    "
    buttonUpload:
      'u-hide--visual'
    plus:
      'u-sign -plus -w10 u-pr u-mr12 u-color--blue'
    choices:
      'u-mb48'
    expired: '
      u-fs14 u-mb24
      u-color--dark-gray-alt-2
    '
    addText:
      'u-color--blue'

  classesWillUpdate: ->
    buttonShowPrescriptions:
      'u-hide--visual': @state.showHidden
    buttonExistingPrescription:
      'u-hide--visual': not @state.showHidden

  # Click handlers

  handleSubmitForm: (evt) ->
    evt.preventDefault()

  handleClickShowPrescriptions: ->
    @setState showHidden: true

  handleClickAddPrescription: ->
    @setState showAdd: true
    @commandDispatcher 'scrolling', 'scrollTo', 0

  handleClickBack: ->
    @setState showAdd: false

  handleClickExisting: (prescription) ->
    @commandDispatcher 'estimate', 'savePrescription',
      __modelName: 'prescriptionExisting'
      __navigate: true
      attributes:
        existing_prescription_id: prescription.id

  handleClickNonRx: ->
    @commandDispatcher 'estimate', 'savePrescription',
      __modelName: 'prescriptionNonRx'
      __navigate: true
      use_high_index: false

  handleClickSendLater: ->
    @commandDispatcher 'estimate', 'savePrescription',
      __modelName: 'prescriptionSendLater'
      __navigate: true

  handleChangePrescriptionUpload: (evt) ->
    formData = new FormData React.findDOMNode(@refs.uploadForm)
    @commandDispatcher 'estimate', 'uploadPrescription', formData

  hasExpiredShowing: ->
    _.some @props.showPrescriptions, (prescription) -> prescription.expired

  hasExpiredHidden: ->
    _.some @props.hidePrescriptions, (prescription) -> prescription.expired

  shouldShowExpiredError: ->
    @hasExpiredShowing() or (@hasExpiredHidden() and @state.showHidden)

  # Render helpers

  renderValidPrescriptions: ->
    for prescription in @props.showPrescriptions
      <ExistingPrescriptionChoice
        key=prescription.id
        onClick={@handleClickExisting.bind(@, prescription)}
        prescription=prescription />

  renderHiddenPrescriptions: -> [
    for prescription in @props.hidePrescriptions
      <ExistingPrescriptionChoice
        key=prescription.id
        cssModifier=@classes.buttonExistingPrescription
        onClick={@handleClickExisting.bind(@, prescription)}
        prescription=prescription
        tabIndex={if @state.showHidden then 0 else -1} />

    if @shouldShowExpiredError()
      <div children='Quick note: You can still place your order using expired
        prescriptions, but we’ll need to reach out to you afterward
        for a valid one.' className=@classes.expired />

    <button
      key='buttonShowPrescriptions'
      children="#{COPY.hidden} (#{@props.hidePrescriptions.length})"
      className=@classes.buttonShowPrescriptions
      onClick=@handleClickShowPrescriptions />
  ]

  renderAddPrescriptionsButton: ->
    <CTA
      analyticsSlug='checkout-add-prescription'
      key='buttonAddPrescription'
      cssModifier=@classes.buttonAddPrescription
      onClick=@handleClickAddPrescription
      type='submit'
      variation='secondary'>

      <span className=@classes.plus />
      <span className=@classes.addText children=COPY.heading.add />

    </CTA>

  renderAddPrescriptionChoices: (options = {}) -> [
    if window?.FormData?
      <Form key='uploadForm'
        ref='uploadForm'
        onSubmit=@handleSubmitForm
        encType='multipart/form-data'>

          <FlowChoice heading='Upload a photo of it'
            isCallout=true
            subHeading='This is the quickest option!'
            htmlFor='prescription-upload'
            tagName='label'>

            <input id='prescription-upload'
              accept='image/gif, image/jpeg, image/png, application/pdf'
              ref='fileUpload'
              className=@classes.buttonUpload
              onChange=@handleChangePrescriptionUpload
              type='file'
              name='image' />

          </FlowChoice>
      </Form>

    <FlowChoice
      key='sendLater'
      heading='Send it to us later'
      onClick=@handleClickSendLater
      subHeading=@subHeading.sendLater
      tagName='button'
      type='button' />

    if @getFeature('callDoctor')
      <FlowChoice
        key='callDoctor'
        heading='Have us call your doctor'
        href=@props.routeCallDoctor
        subHeading=@subHeading.callDoctor />

  ]

  renderExpiredText: ->
    <p key='subHeadingExpired'
      className=@classes.subHeading
      children=COPY.subHeadingExpired />

  renderOtherOptions: ->
    unless @props.has_progressives
      [
        <hr key='horizontalRule' className=@classes.horizontalRule />

        <FlowChoice
          key='readers'
          heading=COPY.readers
          href=@props.routeReaders />

        if @props.non_rx_eligible
          <FlowChoice
            key='nonRx'
            tagName='button'
            type='button'
            onClick=@handleClickNonRx
            heading=COPY.nonPrescription />
      ]

  getHeading: ->
    if @state.showAdd then COPY.heading.add
    else if @props.showPrescriptions.length then COPY.heading.saved
    else COPY.heading.expired

  render: ->
    @classes = @getClasses()
    @subHeading =
      sendLater: 'Upload a photo of your prescription after you check out.'
      callDoctor: 'A little slower, but we’re happy to do it.'

    <div className=@classes.block>

      {if @state.showAdd
        <button
          key='buttonBack'
          children=COPY.buttonBack
          className=@classes.buttonBack2
          onClick=@handleClickBack />}

      <h1 className=@classes.heading children=@getHeading() />

      {if @props.prescriptionErrors?.generic
        <Error children={@props.prescriptionErrors.generic} />}

      <div className=@classes.choices>
        {if @state.showAdd
          @renderAddPrescriptionChoices( showBackButton: true )
        else [
          @renderValidPrescriptions()      if @props.showPrescriptions.length
          @renderHiddenPrescriptions()     if @props.hidePrescriptions.length
          @renderAddPrescriptionsButton()  if @props.showPrescriptions.length
          @renderExpiredText()             if @props.savedPrescriptions.length and
                                            not @props.showPrescriptions.length
          @renderAddPrescriptionChoices()  unless @props.showPrescriptions.length
          @renderOtherOptions()            unless @state.showAdd
        ]}
      </div>

      <CheckoutSummary
        totals=@props.totals
        itemCount={_.size(@props.items)}
        ctaCopy='' />

    </div>
