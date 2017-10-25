[
  _
  Backbone
  Backbone.Cache

  BaseDispatcher
  Url
  Logger
] = [
  require 'lodash'
  require '../backbone/backbone'
  require '../backbone/cache'

  require './base_dispatcher'
  require '../utils/url'
  require '../logger'
]

log = Logger.get('QuizDispatcher').log

REGEX_PATH = /^\/quiz(\/results)?$/

class FramesQuiz extends Backbone.BaseCollection
  parse: (resp) -> resp.frames

class QuizDispatcher extends BaseDispatcher
  channel: -> 'quiz'

  shouldInitialize: ->
    @currentLocation().pathname.match REGEX_PATH

  getInitialStore: -> @buildStoreData()

  buildStoreData: ->
    cachedData = Backbone.Cache.get 'quizResults', 0
    location = @currentLocation()

    if _.isEmpty(cachedData) and location.pathname is '/quiz/results'
      @commandDispatcher 'cookies', 'remove', 'hasQuizResults'
      @navigate '/quiz'
      return

    initialAnswers = @getAnswersFromUrl location
    # If gender isn't in url, and we're on the results page, try to get it from cache
    if _.isEmpty(initialAnswers) and location.pathname is '/quiz/results'
      initialAnswers.gender = cachedData.gender
    store = @resetStoreData initialAnswers
    store.frames = cachedData.frames if cachedData
    store.showQuiz = true if _.get location, 'query.active'
    store.showInstructionsTakeover = false
    store.hideResults = false

    store

  resetStoreData: (initialAnswers) ->
    hasAnswers = not _.isEmpty initialAnswers
    answers:
      _.assign {}, initialAnswers,
        colors: []
        shapes: []
        materials: []
    skip: if hasAnswers then _.keys(initialAnswers) else ['wears_glasses']
    showQuiz: hasAnswers

  getAnswersFromUrl: (location) ->
    answers = {}
    if _.get location, 'query.gender'
      answers.gender = location.query.gender.toLowerCase()
    answers

  getAnswersQueryString: ->
    answers = _.map(@store.answers, (val, key) ->
      if _.isArray val
        _.map(val, (v) -> "#{key}=#{v}").join '&'
      else
        "#{key}=#{val}"
    ).filter(String)

    @commandDispatcher 'experiments', 'bucket', 'quizMaxWeightCategory'
    variant = @getExperimentVariant 'quizMaxWeightCategory'
    if variant
      answers.push "max_weight=#{variant}"

    @commandDispatcher 'experiments', 'bucket', 'quizResultsFrameCount'
    frameCount = parseInt @getExperimentVariant('quizResultsFrameCount'), 10
    if frameCount
      answers.push "limit=#{frameCount}"

    answers.join '&'

  getAnswersAnalyticsString: ->
    answers = _.assign {}, @store.answers
    answers.width = '' unless answers.width
    _.map(answers, (val, key) ->
      if _.isArray val
        "#{_.camelCase(key)}=#{_.map(val.sort(), _.camelCase).join(',')}"
      else
        "#{_.camelCase(key)}=#{_.camelCase(val)}"
    ).sort().join '&'

  showResults: ->
    @replaceStore hideResults: false

  onQuizSuccess: (collection) ->
    frames = collection.toJSON()
    gender = @store.answers.gender

    # Move all the duplicate frames to the end of the list
    framesUnique = []
    framesDupe = []
    _.map frames, (frame) ->
      if _.find(framesUnique, (f) -> f.display_name is frame.display_name)
        framesDupe.push frame
      else
        framesUnique.push frame

    frames = framesUnique.concat framesDupe
    _.map frames, (frame, i) -> frame.position = i+1

    # Save quiz results in localStorage, and set a cookie so the backend knows
    Backbone.Cache.set(
      'quizResults'
      0
      {frames: frames, gender: gender}
      7 * 24 * 60 * 60 * 1000  # 1 week.
    )
    if Backbone.Cache.get 'quizResults', 0
      @commandDispatcher 'cookies', 'set', 'hasQuizResults', gender, expires: 7 * 24 * 60 * 60

    # Save the quiz answers in a cookie so we can re-fetch later
    # This will replace localStorage and the `hasQuizResults` cookie
    # To be rolled out after 10/12/17 when those have expired for all
    @commandDispatcher 'cookies', 'set', 'quizAnswers',
      @getAnswersQueryString(),
      expires: 7 * 24 * 60 * 60

    @commandDispatcher 'experiments', 'bucket', 'quizLoadingCopy'
    @pushEvent('htoMode-wouldEnter-quizCompletion') unless @inHtoMode()
    @replaceStore _.assign @resetStoreData(gender: gender), frames: frames


  commands:
    addAnswer: (key, val) ->
      answers = _.assign {}, @store.answers
      if _.isArray answers[key]
        answers[key].push(val) if val not in answers[key]
      else
        answers[key] = val
      @replaceStore answers: answers

    removeAnswer: (key, val) ->
      answers = _.assign {}, @store.answers
      if _.isArray answers[key]
        _.pull answers[key], val
      else
        delete answers[key]
      @replaceStore answers: answers

    fetchQuizResults: ->
      quiz = new FramesQuiz
      quiz.url = "/api/v2/frames-quiz?#{@getAnswersQueryString()}"
      @pushEvent "quiz-submit-#{@getAnswersAnalyticsString()}"
      quiz.fetch success: @onQuizSuccess.bind @
      @replaceStore
        showInstructionsTakeover: true
        hideResults: true
        frames: []
      @navigate '/quiz/results'
      setTimeout @showResults.bind(@), 5000
      window?.scrollTo 0, 0

    toggleQuizVisibility: ->
      @replaceStore showQuiz: not @store.showQuiz

    hideInstructionsTakeover: ->
      @replaceStore showInstructionsTakeover: false

module.exports = QuizDispatcher
