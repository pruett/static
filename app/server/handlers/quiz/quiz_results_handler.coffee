BaseHandler = require 'hedeia/server/handlers/base_handler'

class QuizResultsHandler extends BaseHandler
  name: -> 'QuizResults'

  prefetch: -> [
    '/api/v2/variations/quiz-info'
    '/api/v2/variations/quiz-landing'
    '/api/v2/variations/quiz-questions'
    '/api/v2/variations/quiz-results'
  ]

  prepare: ->
    unless @getFeature 'homeTryOn'
      @throwError statusCode: 404
      false
    else unless @getCookie 'hasQuizResults', ''
      @redirectWithParams '/quiz'
      false
    else
      true

module.exports = QuizResultsHandler
