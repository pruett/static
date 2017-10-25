[
  BaseStaticHandler
] = [
  require 'hedeia/server/handlers/base_static_handler'
]

class YearInReview2014Handler extends BaseStaticHandler
  name: -> 'YearInReview2014'

  layout: -> 'yearInReview2014'

module.exports = YearInReview2014Handler
