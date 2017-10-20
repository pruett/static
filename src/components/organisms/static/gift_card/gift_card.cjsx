[
  _
  React

  LayoutDefault

  Calendar
  GiftCardFieldset
  Hero
  RadioGroup
  Markdown
  Takeover
  CTA
  Form
  Step

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/fieldsets/calendar_fieldset/calendar_fieldset'
  require 'components/organisms/fieldsets/gift_card_fieldset/gift_card_fieldset'
  require 'components/molecules/gift_card/hero/hero'
  require 'components/molecules/gift_card/radio_group/radio_group'
  require 'components/molecules/markdown/markdown'
  require 'components/molecules/modals/takeover/takeover'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/gift_card/step/step'

  require 'components/mixins/mixins'

  require './gift_card.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-gift-card'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
    Mixins.scrolling
  ]

  propTypes:
    steps: React.PropTypes.array
    footnote: React.PropTypes.string
    form_labels: React.PropTypes.object
    form_placeholders: React.PropTypes.object
    faq: React.PropTypes.object
    maxLengthNote: React.PropTypes.number
    session: React.PropTypes.object
    variation: React.PropTypes.string

  getDefaultProps: ->
    steps: []
    footnote: ''
    form_labels: {}
    form_placeholders: {}
    faq: {}
    maxLengthNote: 200
    session: {}
    variation: ''

  getInitialState: ->
    stepClicks: 0
    stepCurrent: 0
    stepShowing: 0
    takeoverActive: false
    form:
      sender_email: _.get(@props, 'session.customer.email', '')
      sender_name: _.get(@props, 'session.customer.first_name', '')
      recipient_email: ''
      recipient_name: ''
      note: ''

  componentDidUpdate: (prevProps, prevState) ->
    return if @state.stepClicks is prevState.stepClicks
    @scrollToNode @refs[@getRef(@state.stepCurrent)].getDOMNode()

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    form: "
      #{@BLOCK_CLASS}__form
    "
    calendar: "
      #{@BLOCK_CLASS}__calendar
      u-grid__col
      u-w12c u-w10c--600 u-w6c--900 u-w5c--1200
      u-m0a
    "
    form: "
      #{@BLOCK_CLASS}__details
    "
    details: '
      u-mw600 u-ma
    '
    footnote: '
      u-fs20 u-ffss
      u-color--light-gray
    '
    questionBlock: '
      u-mw600 u-ma u-mt0 u-mb40
      u-pl18 u-pr18
      u-tal
    '
    question: '
      u-fs20 u-ffs u-fws u-mb12
    '
    cta: '
      u-fs16 u-fws
      u-reset--button
      u-button -button-modular -button-blue
    '
    footnote: '
      u-mt48
      u-fs12 u-ffss
      u-color--dark-gray-alt-2
    '

  classesWillUpdate: ->
    block:
      # Allows skinning of page.
      "#{@BLOCK_CLASS}--#{@props.variation}": Boolean(@props.variation)

  # Helpers

  getRef: (index) ->
    "stepContainer-#{index}"

  mergeFormData: (obj) ->
    _.defaults obj, @state.form

  isEGiftCard: ->
    _.get(@state, 'form.type') is 'electronic'

  rejectStep: (step) ->
    step.content is 'calendar' and not @isEGiftCard()

  # Handlers

  handleSubmit: (event) ->
    event.preventDefault()
    @commandDispatcher 'giftCard', 'addToCart', @state.form

  handleOpenTakeover: (event) ->
    event.preventDefault()
    @trackInteraction 'giftCard-open-faq', event
    @setState takeoverActive: true

  handleCloseTakeover: (event) ->
    event.preventDefault()
    @setState takeoverActive: false

  # Managers

  manageClickStep: (index, isPenultimate, event) ->
    name = event.target.name
    formData = @mergeFormData("#{name}": event.target.value)
    @setState
      stepClicks: @state.stepClicks + 1
      stepCurrent: index + 1
      stepShowing: Math.max @state.stepShowing, index + 1
      form: formData

    @props.showFooter() if _.isFunction(@props.showFooter) and isPenultimate

    @commandDispatcher 'giftCard', 'pushStepImpressions', name, formData

  manageChangeField: (name, event) ->
    value = event.target.value
    value = value.substr(0, @props.maxLengthNote) if name is 'note'

    @setState form: @mergeFormData("#{name}": value)

  # Renderers

  renderQuestion: (question, i) ->
    <section className=@classes.questionBlock key="question#{i}">
      <h3 className=@classes.question children=question.question />
      <Markdown rawMarkdown=question.answer />
    </section>

  renderStep: (step, index, steps) ->

    # Pass index, and whether it is the penultimate step.
    manageClickStep = @manageClickStep.bind @, index, index is steps.length - 2

    if step.content is 'hero'
      # Don't wrap Hero.
      return <Hero key=step.content {...step}
        manageClick=manageClickStep
        manageTakeover=@handleOpenTakeover />

    component = switch step.content
      when 'radio_group'
        <RadioGroup
          key=step.content
          options=step.options
          name=step.id
          manageClick=manageClickStep />

      when 'calendar'
        <Calendar
          key=step.content
          radioName=step.id
          cssModifiers={block: @classes.calendar}
          manageChangeDate=manageClickStep />

      when 'form'
        <div className=@classes.details key=step.content>
          <GiftCardFieldset
            {...@state.form}
            giftCardErrors=@props.giftCardErrors
            cssModifierLabel={if index % 2 is 1 then '-background-alt'}
            isEGiftCard={@isEGiftCard()}
            labels=@props.form_labels
            placeholders=@props.form_placeholders
            manageChangeField=@manageChangeField
            maxLengthNote=@props.maxLengthNote />
          <CTA
            variation='minimal'
            analyticsSlug='giftCard-click-submit'
            children='Add to cart'
            cssModifier=@classes.cta />
          <Markdown
            cssModifiers={p: 'u-reset'}
            className=@classes.footnote
            rawMarkdown=@props.footnote />
        </div>
      else false

    data = _.clone step # Clone step so you don't overwrite data.
    data.label = "Step #{index} of #{steps.length - 1}" if data.label is null

    ref = @getRef index

    isShowing = @state.stepShowing >= index
    cssModifier = if isShowing then 'u-df' else 'u-dn'

    <Step {...data}
      content=step.content
      cssModifier=cssModifier
      ref=ref key=index
      children=component />

  render: ->
    @classes = @getClasses()

    # Grab active steps.
    steps = _.reject @props.steps, @rejectStep

    <div className=@classes.block>
      <Takeover
        active=@state.takeoverActive
        analyticsSlug='giftCard-close-faq'
        title={_.get @props.faq, 'title'}
        manageClose=@handleCloseTakeover
        children={_.map _.get(@props.faq, 'questions'), @renderQuestion} />
      <Form
        className=@classes.form
        onSubmit=@handleSubmit
        children={_.map steps, @renderStep} />
    </div>
