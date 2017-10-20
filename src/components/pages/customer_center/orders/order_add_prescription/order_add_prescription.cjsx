[
  _
  React

  LayoutDefault

  Breadcrumbs
  CTA
  IconX
  OrderIssue
  Takeover
  UploadCTA

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/atoms/buttons/cta/cta'
  require 'components/quanta/icons/x/x'
  require 'components/molecules/templates/customer_center/orders/order_issue/order_issue'
  require 'components/molecules/modals/takeover/takeover'
  require 'components/molecules/upload_cta/upload_cta'

  require 'components/mixins/mixins'

  require '../orders.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-order-add-rx'

  statics:
    route: ->
      visibleBeforeMount: true
      path: '/account/orders/{order_id}/prescription/{step?}'
      handler: 'AccountOrders'
      bundle: 'customer-center'
      title: 'Orders - Add prescription'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
    Mixins.context
    Mixins.routing
  ]

  receiveStoreChanges: -> [
    'account'
    'prescriptionRequest'
  ]

  getStaticClasses: ->
    button:
      'u-db u-button -button-blue u-fs14 u-ffss u-fws'
    cancel:
      "#{@BLOCK_CLASS}__cancel u-ffss u-link--underline"
    confirmImage:
      'u-mb12 u-bss u-bw1 u-bc--light-gray-alt-1'
    container:
      'u-tac'
    content:
      "#{@BLOCK_CLASS}__content"
    dotted:
      "#{@BLOCK_CLASS}__dotted"
    error:
      'u-fs16 u-mb48 u-color--yellow'
    heading:
      "#{@BLOCK_CLASS}__header u-ffs u-fs40 u-mb0"
    iconX:
      "#{@BLOCK_CLASS}__icon-x"
    link:
      'u-link--underline u-fs16'
    message:
      "#{@BLOCK_CLASS}__message u-fs16"
    placeholder:
      "#{@BLOCK_CLASS}__placeholder
      u-mb12 u-bss u-bw1 u-bc--light-gray-alt-1 u-pr"
    placeHolderMessage:
      'u-w10c u-center u-pa'
    preview:
      'u-link--underline u-fl'
    revise:
      'u-link--underline u-cursor--pointer'
    reviseButton:
      "#{@BLOCK_CLASS}__revise u-mt24"
    takeover:
      'u-tac u-color-bg--white-95p'
    takeoverHeader:
      "#{@BLOCK_CLASS}__takeover-header u-db u-tar"
    takeoverClose:
      "#{@BLOCK_CLASS}__takeover-close u-button-reset"
    submitButton:
      "#{@BLOCK_CLASS}__submit -button-block"

  classesWillUpdate: ->
    revise:
      'u-fr': not @uploadIsPdf()

  componentDidMount: ->
    @getOrderOrRedirect @getStore('account')

  getInitialState: ->
    isPreviewing: false

  getStoreChangeHandlers: ->
    account: 'handleAccountChange'

  getOrderId: ->
    _.get @state, 'order.id'

  getOrderOrRedirect: (account) ->
    orders = account.orders or []
    if account.__fetched
      orderId = parseInt(@getRouteParams().order_id, 10)
      order = @findObjectOr404 orders, id: orderId
      @rerouteIfComplete @getStep(), order
    @setState order: order

  getStep: ->
    _.get(@getRouteParams(), 'step', 'cta')

  formatStep: (step) ->
    switch step.toLowerCase()
      when 'confirm' then 'Confirm'
      when 'success' then 'Success'
      else 'Upload'

  handleAccountChange: (account) ->
    @getOrderOrRedirect(account)

  handleOpenPreview: (evt) ->
    @commandDispatcher 'layout', 'showTakeover'
    @trackInteraction 'page-open-takeover', evt
    @setState isPreviewing: true

  handleClosePreview: (evt) ->
    @commandDispatcher 'layout', 'hideTakeover'
    @trackInteraction 'page-close-takeover', evt
    @setState isPreviewing: false

  handleSubmit: (evt) ->
    evt.preventDefault()
    @commandDispatcher 'prescriptionRequest', 'savePrescription', @getOrderId()

  uploadIsPdf: ->
    prescription = @getStore 'prescriptionRequest'
    prescription.imageUpload.filename?.endsWith('.pdf')

  rerouteIfComplete: (step, order) ->
    actionSteps = ['confirm', 'success', 'resize']
    if step not in actionSteps and not order.order_issue
      @commandDispatcher 'routing', 'navigate', '/account'

  formatOrder: (order) ->
    return order if order.order_issue?.detail_action is 'upload'

    uploadIssue = _.assign {}, order.order_issue,
        title: 'upload'
        detail_action: 'upload'
        detail_button: 'Upload a prescription'
        detail_message: """We need one last (very important!) thing before we can get started on your order:
          an up-to-date prescription. If you have it handy, you can upload it right here."""

    _.assign {}, order, order_issue: uploadIssue

  renderConfirmForm: (prescription) ->
    <div className=@classes.container>
      <div className=@classes.content>
        <h1 className=@classes.heading
          children='Review upload' />
        <p className=@classes.message
          children='Please make sure the expiration or exam date is visible!' />

        {if @uploadIsPdf()
          <div className=@classes.placeholder>
            <div className=@classes.placeHolderMessage>
              Your file "{prescription.imageUpload.filename}"
                has been uploaded successfully.
            </div>
          </div>
        else
          [
            <img className=@classes.confirmImage
              src={prescription.imageUpload.img_url}
              alt="Uploaded Prescription - #{prescription.imageUpload.filename}" />

            <a
              onClick=@handleOpenPreview
              className=@classes.preview
              children='View larger' />
          ]
        }

        <UploadCTA
          orderId=@getOrderId()
          title='revise'
          cssModifier=@classes.revise
          variation='minimal'
          children='Re-upload' />
      </div>

      <hr className=@classes.dotted />

      <CTA
        variation='minimal'
        cssModifier=@classes.submitButton
        cssUtility=@classes.button
        title='Submit'
        onClick=@handleSubmit
        children="Submit"
        disabled={not _.isEmpty prescription.errors} />
      <a className=@classes.cancel
        href="/account/orders/#{@getOrderId()}"
        children='Cancel your upload' />
    </div>

  renderSuccess: ->
    <div className=@classes.container>
      <h1 className=@classes.heading
        children='Thanks!' />
      <p className=@classes.message
        children="We'll send you an email if we need anything else." />
      <a className=@classes.link
        href='/account'
        children='Back to my account' />
    </div>

  renderImageSizeError: (prescription) ->
    <div className=@classes.container>
      <div className=@classes.content>
        <h1 className=@classes.heading
          children='Uh oh. Your file is too big.' />
        <p className=@classes.message
          children=prescription.errors.generic />
      </div>

      <UploadCTA
        orderId=@getOrderId()
        cssModifier=@classes.reviseButton
        cssUtility=@classes.button
        variation='minimal'
        children='Re-upload' />
      <a className=@classes.cancel
        href="/account/orders/#{@getOrderId()}"
        children='Cancel your upload' />
    </div>

  renderSaveError: ->
    <div className=@classes.container>
      <div className=@classes.content>
        <div className=@classes.placeholder>
          <div className=@classes.placeHolderMessage>
            We’re having trouble with your upload!
            Please email your prescription to <a
              href='mailto:prescriptions@warbyparker.com'
              children='prescriptions@warbyparker.com'
            /> and we’ll take care of it.
          </div>
        </div>
      </div>

      <UploadCTA
        orderId=@getOrderId()
        cssModifier=@classes.reviseButton
        cssUtility=@classes.button
        variation='minimal'
        children='Re-upload' />
      <a className=@classes.cancel
        href="/account/orders/#{@getOrderId()}"
        children='Cancel your upload' />
    </div>

  render: ->
    @classes = @getClasses()
    prescription = @getStore('prescriptionRequest')
    step = @getStep()
    order = @state.order

    breadcrumbs = [
      {
        text: 'Account'
        href: '/account'
      },
      {
        text: 'Orders'
        href: '/account/orders'
      },
      {
        text: "no. #{order?.id}"
        href: "/account/orders/#{order?.id}"
      },
      {
        text: @formatStep step
      }
    ]

    <LayoutDefault {...@props}>
      <Takeover active=@state.isPreviewing
        hasHeader=false
        cssModifier=@classes.takeover>
        <div className=@classes.container>
          <div className=@classes.content>
            <div className=@classes.takeoverHeader>
              <button className=@classes.takeoverClose onClick=@handleClosePreview>
                <IconX cssModifier=@classes.iconX />
              </button>
            </div>

            <img className=@classes.confirmImage
              src={prescription.imageUpload.img_url}
              alt="Uploaded Prescription - #{prescription.imageUpload.filename}" />
          </div>
        </div>
      </Takeover>

      <Breadcrumbs
        links=breadcrumbs />

      {switch step
        when 'confirm' then @renderConfirmForm(prescription)
        when 'success' then @renderSuccess()
        when 'resize' then @renderImageSizeError(prescription)
        when 'error' then @renderSaveError()
        else
          if order
            <OrderIssue order={@formatOrder(order)} />
      }
    </LayoutDefault>
