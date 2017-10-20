[
  _
  React

  Alert
  CTA
  Form
  Help
  Markdown
  UploadCTA

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/icons/customer_center/alert/alert'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/footer/help/help'
  require 'components/molecules/markdown/markdown'
  require 'components/molecules/upload_cta/upload_cta'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-order-issue'

  propTypes:
    help_data: React.PropTypes.object
    order: React.PropTypes.object

  mixins: [
    Mixins.classes
    Mixins.dispatcher
    Mixins.analytics
  ]

  getStaticClasses: ->
    alert:
      "u-icon u-db u-fill--yellow"
    cta:
      "#{@BLOCK_CLASS}__cta
       u-ffss u-fs16"
    dotted:
      "#{@BLOCK_CLASS}__dotted"
    icons:
      'u-db u-mla u-mra u-p0 u-pb3 u-mb12 u-tac'
    alertIcon:
      "#{@BLOCK_CLASS}__alert-icon u-dib u-vam"
    helpIcons:
      "#{@BLOCK_CLASS}__help-icons"
    statusButton:
      "#{@BLOCK_CLASS}__status-button
       u-button u-fws u-fs14"
    statusHeadline:
      'u-fs30 u-fs40--600 u-ffs u-fws'
    statusMessage:
      'u-ma u-mb12 u-mt12 u-mw600 u-fs16 u-ffss'
    examLinkWrapper: 'u-tac u-pt12'
    examLink: "
      {@BLOCK_CLASS}__link u-fs16
      u-reset u-bbss u-bbw2
      u-bc--blue u-fws u-pb6
    "

  classesWillUpdate: ->
    statusButton:
      '-button-blue': @getAction(@props.order.order_issue) is 'upload'
      '-button-clear': @getAction(@props.order.order_issue) isnt 'upload'

  getActionRoute: (action) ->
    switch action
      when 'email' then 'mailto:help@warbyparker.com'
      when 'phone' then 'tel:888.492.7297'
      when 'chat' then '/chat'
      when 'pd' then '/pd/instructions'
      else ''

  handleClick: (action, evt) ->
    return unless _.isString action
    if action is 'chat'
      evt.preventDefault()
      @commandDispatcher 'livechat', 'openChat'

  handlePrescriptionImageChange: (evt, formData) ->
    order_id = @props.order.order_id
    @commandDispatcher 'prescriptionRequest', 'uploadPrescription', formData,
      order_id: order_id

  handleSubmitForm: (evt) ->
    evt.preventDefault()

  getAction: (issue) ->
    issue.detail_action?.toLowerCase()

  handleEyeExamClick: ->
    @trackInteraction 'customerCenter-clickLink-eyeExams'

  renderCTA: (issue) ->
    action = @getAction(issue)

    if action is 'upload' and window?.FormData?
      <div>
        <UploadCTA
          orderId=@props.order.id
          variation='minimal'
          cssModifier=@classes.statusButton
          title='Upload'
          children=issue.detail_button />
          <div className=@classes.examLinkWrapper>
            <div children='or' />
            <a href='/appointments/eye-exams'
              onClick=@handleEyeExamClick
              children='Book an eye exam'
              className=@classes.examLink />
          </div>
      </div>
    else
      <CTA
        href=@getActionRoute(action)
        onClick={@handleClick.bind(@, action)}
        variation='simple'
        cssModifier=@classes.statusButton
        title=issue.title
        tagName='a'
        children=issue.detail_button />

  render: ->
    issue = @props.order?.order_issue
    @classes = @getClasses()

    <span>
      {if @props.order
        [
          <div className=@classes.cta>
            <div className=@classes.icons>
              <div className=@classes.alertIcon>
                <Alert cssUtility=@classes.alert />
              </div>
            </div>
            <div className=@classes.statusHeadline children=issue.detail_headline />
            <Markdown
              className=@classes.statusMessage
              rawMarkdown=issue.detail_message />
            {if issue
              @renderCTA(issue)
            else
              <div className=@classes.helpIcons>
                <Help {...@props.help_data}
                  analyticsSlug='order-click-help'
                  trackImpressions=true />
              </div>
            }
          </div>
          <hr className=@classes.dotted />
        ]
      }
    </span>
