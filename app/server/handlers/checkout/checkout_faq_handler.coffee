BaseHandler = require 'hedeia/server/handlers/base_handler'


class CheckoutFAQHandler extends BaseHandler
  name: -> 'CheckoutFAQ'

  prefetch: -> ['/api/v2/variations/checkout/faq']

module.exports = CheckoutFAQHandler
