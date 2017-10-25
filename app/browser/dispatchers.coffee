Dispatchers = require '../common/dispatchers'

Dispatchers.browser = [
  require './dispatchers/analytics_dispatcher'
  require './dispatchers/app_landing_dispatcher'
  require './dispatchers/apple_pay_dispatcher'
  require './dispatchers/capabilities_dispatcher'
  require './dispatchers/cookies_dispatcher'
  require './dispatchers/email_capture_dispatcher'
  require './dispatchers/experiments_dispatcher'
  require './dispatchers/geo_dispatcher'
  require './dispatchers/layout_dispatcher'
  require './dispatchers/livechat_dispatcher'
  require './dispatchers/modals_dispatcher'
  require './dispatchers/password_dispatcher'
  require './dispatchers/pd_dispatcher'
  require './dispatchers/places_dispatcher'
  require './dispatchers/post_checkout_dispatcher'
  require './dispatchers/retail_email_capture_dispatcher'
  require './dispatchers/routing_dispatcher'
  require './dispatchers/search_dispatcher'
  require './dispatchers/scripts_dispatcher'
  require './dispatchers/scrolling_dispatcher'
  require './dispatchers/social_dispatcher'
  require './dispatchers/stripe_dispatcher'
]

module.exports = Dispatchers
