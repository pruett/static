[
  BaseStaticHandler
] = [
  require 'hedeia/server/handlers/base_static_handler'
]

class AnnualReport2014Handler extends BaseStaticHandler
  name: -> 'AnnualReport2014'

  layout: -> 'annualReport2014'

module.exports = AnnualReport2014Handler
