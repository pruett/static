[
  _
  React

  BackArrow
  IconX

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/left_line_arrow/left_line_arrow'
  require 'components/quanta/icons/thin_x/thin_x'

  require 'components/mixins/mixins'

  require './quiz_questions.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-quiz-questions'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  getDefaultProps: ->
    answers: {}
    questions: []
    manageClose: ->
    manageQuizSubmit: ->

  getInitialState: ->
    questionIndex: 0
    questionTransition: false

  componentWillReceiveProps: (props) ->
    # Ensure if the number of questions change, we don't go past the last one
    if @state.questionIndex >= props.questions.length
      @setState questionIndex: props.questions.length - 1

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-pf u-t0 u-r0 u-b0 u-l0
      u-color-bg--light-gray-alt-5
    "
    header: '
      u-pa u-t0 u-w100p u-tac
    '
    progressBar: "
      #{@BLOCK_CLASS}__progress-bar
    "
    progress: "
      #{@BLOCK_CLASS}__progress
    "
    nav: "
      #{@BLOCK_CLASS}__nav
      u-pr u-mw1440
      u-mla u-mra
      u-p18
      u-color-bg--light-gray-alt-5
    "
    navButton: "
      #{@BLOCK_CLASS}__nav-button
      u-button-reset
      u-pa u-t0 u-m12
    "
    iconX: '
      u-ml4 u-mr4 u-mt5 u-mb5
    '
    progressText: '
      u-fs12 u-lh12 u-ls2
      u-fws u-ttu
    '
    fieldset: '
      u-fieldset-reset
      u-h100p
    '
    content: "
      #{@BLOCK_CLASS}__content
      u-h100p u-mw1440
      u-oa
      u-mla u-mra
      u-df u-flexd--c
      u-tac
    "
    questionHeaderContainer: "
      #{@BLOCK_CLASS}__flex-static
      u-pl12 u-pr12 u-pt72 u-pt84--600
    "
    questionHeader: '
      u-w100p u-tac
      u-ffs u-fws
      u-fs26 u-fs44--600
    '
    questionSubhead: '
      u-ffs u-fsi
      u-fs18
      u-color--dark-gray-alt-3
      u-mt12 u-mb0
    '
    input: "
      #{@BLOCK_CLASS}__input
      u-dn
    "
    optionsWrapper: "
      #{@BLOCK_CLASS}__flex-expand
      u-df u-ai--c
    "
    options: "
      #{@BLOCK_CLASS}__options
      u-w100p
      u-df--600 u-jc--c
      u-mla u-mra
      u-pl12 u-pr12
      u-pt6 u-pt24--600 u-pb6 u-pb24--600
    "
    optionContainer: "
      #{@BLOCK_CLASS}__option-container
    "
    optionLabel: '
      u-cursor--pointer
      u-df u-db--600
      u-ai--c
    '
    optionImage: "
      #{@BLOCK_CLASS}__option-image
    "
    optionPill: "
      #{@BLOCK_CLASS}__option-pill
      u-dib
      u-color-bg--white
      u-fs12 u-lh12 u-ls2
      u-fws u-ttu u-wsnw
    "
    optionText: "
      #{@BLOCK_CLASS}__option-text
      u-mt18 u-mt24--600
      u-mb18
      u-tal u-tac--600
    "
    optionDescription: "
      #{@BLOCK_CLASS}__option-description
      u-mt12 u-mb0 u-ml12 u-ml0--600
      u-ffss u-fs18--600 u-lh24
      u-color--dark-gray-alt-3
    "
    ctaContainer: "
      #{@BLOCK_CLASS}__cta-container
      #{@BLOCK_CLASS}__flex-static
      u-pt24 u-pt12--600 u-pb24 u-pb12--600
      u-bss--600 u-bw0 u-btw1
    "
    cta: "
      #{@BLOCK_CLASS}__cta
      u-button -button-medium u-fws
    "

  classesWillUpdate: ->
    question = @props.questions[@state.questionIndex]
    nQuestions = _.size(question.options)
    answers = @props.answers[question.slug]
    isAnswered = _.isArray(answers) and answers.length
    isBordered = question.options[0].description or nQuestions < 3

    cta:
      '-button-white': not isAnswered
      '-button-blue': isAnswered
    ctaContainer:
      'u-vh u-dn u-db--600': question.required
    options:
      'u-flexw--w': not isBordered
      'u-mw960': nQuestions < 3
      '-transition': @state.questionTransition
    optionContainer:
      'u-dib--600 -bordered': isBordered
      'u-dib u-w6c u-wauto--600
       u-pt18 u-pb18 u-pl24 u-pr24': not isBordered
      'u-pl48--600 u-pr48--600': nQuestions >= 3
      'u-w6c--600 u-pl24--600 u-pr24--600': nQuestions < 3
    optionLabel:
      'u-flexd--c': nQuestions < 3 or not isBordered
      'u-pt24 u-pb24': nQuestions < 3
    optionImage:
      '-inline': isBordered
      'u-mt18 u-mb18 u-mr12 u-m0--600 u-dib u-db--600': isBordered and nQuestions >= 3
      'u-m0a': not isBordered
      '-swatch u-mbn12 u-mb0--600': question.slug is 'colors'
    optionText:
      'u-dib': isBordered

  handleInputChange: (evt) ->
    category = evt.target.name
    value = evt.target.value
    command = if evt.target.checked then 'addAnswer' else 'removeAnswer'
    action =
      if evt.target.type is 'radio'
        'click'
      else if evt.target.checked
        'check'
      else
        'uncheck'
    @commandDispatcher 'quiz', command, category, value
    @trackInteraction "quiz-#{action}-#{_.camelCase category}_#{_.camelCase value}"
    if evt.target.type is 'radio' and not @state.questionTransition
      # Give the button time to show it's selected state before the transition
      _.delay @transitionToQuestion, 300, @state.questionIndex + 1

  transitionToQuestion: (index) ->
    @setState questionTransition: true
    _.delay @goToQuestion, 500, index

  handleNextButton: (category, evt) ->
    answers = @props.answers[category]
    if answers and not _.isArray answers
      @commandDispatcher 'quiz', 'removeAnswer', category, answers
    @trackInteraction "quiz-click-#{_.camelCase category}_#{_.camelCase evt.target.textContent}"
    @transitionToQuestion @state.questionIndex + 1

  handleBackButton: ->
    @trackInteraction 'quiz-click-back'
    @transitionToQuestion @state.questionIndex - 1

  goToQuestion: (index) ->
    if index is @props.questions.length
      @props.manageQuizSubmit()
    else
      @setState questionIndex: index
      _.defer => @setState questionTransition: false

  handleClose: ->
    @trackInteraction 'quiz-click-close'
    @props.manageClose()

  getProgressPercent: ->
    "#{(@state.questionIndex / @props.questions.length) * 100}%"

  render: ->
    classes = @getClasses()
    question = @props.questions[@state.questionIndex]
    answers = @props.answers[question.slug]
    isAnswered = _.isArray(answers) and answers.length

    <div className=classes.block>

      <div className=classes.header>
        <div className=classes.progressBar>
          <div className=classes.progress style={width: @getProgressPercent()} />
        </div>
        <div className=classes.nav>
          {if @state.questionIndex
            <button className="#{classes.navButton} u-l0" onClick=@handleBackButton>
              <BackArrow cssModifier=classes.iconX />
            </button>}
          <div
            className=classes.progressText
            children="#{@state.questionIndex + 1} of #{@props.questions.length}" />
          <button className="#{classes.navButton} u-r0" onClick=@handleClose>
            <IconX cssModifier=classes.iconX />
          </button>
        </div>
      </div>

      <fieldset className=classes.fieldset>
        <div className=classes.content>
          <div className=classes.questionHeaderContainer>
            <legend className=classes.questionHeader children=question.header />
            <p className=classes.questionSubhead children=question.subhead />
          </div>
          <div className=classes.optionsWrapper>
            <div className=classes.options>
              {_.map question.options, (option) =>
                <div key=option.key className=classes.optionContainer>
                  <label className=classes.optionLabel>
                    <div className=classes.optionImage>
                      <img src=option.image width=question.image_max_width />
                    </div>
                    <div className=classes.optionText>
                      <input
                        className=classes.input
                        type=question.type
                        name=question.slug
                        value=option.key
                        onChange=@handleInputChange
                        checked={_.includes answers, option.key} />
                      <span className=classes.optionPill children=option.display_name />
                      {if option.description
                        <p className=classes.optionDescription children=option.description />}
                    </div>
                  </label>
                </div>}
            </div>
          </div>
          <div className=classes.ctaContainer>
            <button
              className=classes.cta
              onClick={@handleNextButton.bind @, question.slug}
              children={if isAnswered then 'Continue' else question.skip_text} />
          </div>
        </div>
      </fieldset>

    </div>
