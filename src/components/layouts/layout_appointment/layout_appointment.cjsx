[
  _
  React

  Markdown
  Takeover
  UnsupportedBrowserNotice

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'
  require 'components/molecules/modals/takeover/takeover'
  require 'components/atoms/unsupported_browser_notice/unsupported_browser_notice'

  require 'components/mixins/mixins'
]

require './layout_appointment.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-layout-appointment'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  propTypes:
    appState: React.PropTypes.object

  getDefaultProps: ->
    appState: {}

  getInitialState: ->
    takeoverActive: false

  handleOpenTakeover: (evt) ->
    evt.preventDefault()
    @trackInteraction 'appointments-open-faq', evt
    @setState takeoverActive: true

  handleCloseTakeover: (evt) ->
    evt.preventDefault()
    @setState takeoverActive: false

  getStaticClasses: ->
    block: 'u-template'
    main: 'u-template__main -full-width u-oh'
    footer: "
      #{@BLOCK_CLASS}__footer
      u-w100p
      u-mt72 u-mb72 u-mla u-mra
      u-pt24 u-pb48 u-pb0--600
      u-tac
    "
    footerButton: '
      u-button-reset
      u-color--blue
      u-fws
    '
    questionBlock: "
      u-mt36 u-mla u-mra
      u-pl18 u-pr18 u-pl36--600 u-pr36--600
      u-tal
    "
    question: "
      u-mb12
      u-reset u-fs20 u-ffs u-fws
    "

  renderQuestion: (question, i) ->
    classes = @getClasses()

    <section className=classes.questionBlock key="question-#{i}">
      <h3 className=classes.question children=question.question />
      <Markdown rawMarkdown=question.answer />
    </section>

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <UnsupportedBrowserNotice />

      <Takeover active=@state.takeoverActive
        analyticsSlug='appointments-close-faq'
        title={_.get @props.content, 'faq.title'}
        manageClose=@handleCloseTakeover
        children={_.map _.get(@props.content, 'faq.questions', []), @renderQuestion} />

      <main {...@props}
        role='main'
        className=classes.main />

      <footer className=classes.footer>
        <button className=classes.footerButton
          children='Booking FAQs'
          onClick=@handleOpenTakeover />
      </footer>

    </div>
