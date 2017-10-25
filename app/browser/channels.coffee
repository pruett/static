Radio = require '../common/radio'

# Channels
# --------
# Channels map 1:1 to Dispatchers. We declare channels here because dynamically
# creating channels in the browser is forbidden (but possible) with
# Backbone.Radio.

channelNames = [
  'account'
  'analytics'
  'applePay'
  'appLanding'
  'appointments'
  'appState'
  'birthday'
  'capabilities'
  'cart'
  'checkout'
  'config'
  'content'
  'cookies'
  'editionsProduct'
  'eligibilitySurvey'
  'emailCapture'
  'estimate'
  'experiments'
  'favorites'
  'fetch'
  'frameGallery'
  'frameProduct'
  'geo'
  'giftCard'
  'global'
  'homeTryOn'
  'intakeForm'
  'jobs'
  'landing'
  'layout'
  'livechat'
  'modals'
  'navigation'
  'password'
  'pd'
  'personalization'
  'places'
  'postCheckout'
  'prescriptionCheck'
  'prescriptionRequest'
  'quiz'
  'regions'
  'retail'
  'retailEmailCapture'
  'routing'
  'search'
  'scripts'
  'scrolling'
  'session'
  'social'
  'stripe'
  'variations'
]

channels = {}
channels[name] = Radio.channel(name) for name in channelNames

module.exports = channels
