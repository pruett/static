_ = require 'lodash'
React = require 'react/addons'

LayoutDefault = require 'components/layouts/layout_default/layout_default'

Landing = require 'components/organisms/quiz/quiz_landing/quiz_landing'
Questions = require 'components/organisms/quiz/quiz_questions/quiz_questions'

Mixins = require 'components/mixins/mixins'

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  CONTENT_PATHS: [
    '/quiz-landing'
    '/quiz-questions'
  ]

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  statics:
    route: ->
      path: '/quiz'
      handler: 'Quiz'
      title: 'Frames quiz'
      bundle: 'quiz'

  fetchVariations: -> @CONTENT_PATHS

  receiveStoreChanges: -> ['quiz']

  toggleQuizVisibility: ->
    @commandDispatcher 'quiz', 'toggleQuizVisibility'

  handleQuizSubmit: ->
    @commandDispatcher 'quiz', 'fetchQuizResults'

  filterQuizQuestions: (questions, answers, skip) ->
    gender = if answers.gender is 'm' then 'men' else 'women'
    _.filter questions, (q) ->
      (q.gender is 'both' or q.gender is gender) and q.slug not in skip

  render: ->
    landing = @getContentVariation(@CONTENT_PATHS[0]) or {}
    questions = @getContentVariation(@CONTENT_PATHS[1]) or []

    quizData = @getStore 'quiz'
    answers = _.get quizData, 'answers', {}
    skip = _.get quizData, 'skip', []

    <LayoutDefault {...@props}
      showHeader={not quizData.showQuiz}
      showFooter=false
      isOverlap=true
      cssModifier='-full-page'>
      <ReactCSSTransitionGroup transitionName='-transition-fade'>
        {if quizData.showQuiz
          <Questions
            key='questions'
            answers=answers
            questions={@filterQuizQuestions questions, answers, skip}
            manageQuizSubmit=@handleQuizSubmit
            manageClose=@toggleQuizVisibility />
        else
          <Landing {...landing}
            key='landing'
            manageLaunchQuiz=@toggleQuizVisibility />}
      </ReactCSSTransitionGroup>
    </LayoutDefault>
