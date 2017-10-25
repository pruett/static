BaseHandler = require 'hedeia/server/handlers/base_handler'

class QuizHandler extends BaseHandler
  name: -> 'Quiz'

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

module.exports = QuizHandler
