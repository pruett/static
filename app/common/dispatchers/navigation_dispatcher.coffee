[
  _

  NavigationModel
  BaseDispatcher
] = [
  require 'lodash'

  require '../backbone/models/navigation_model'
  require './base_dispatcher'
]

# Map routes to their features' keys from AppState's locale
LOCALE_BASED_FEATURES =
  '/gift-card': 'giftCards'
  '/home-try-on': 'homeTryOn'

class NavigationDispatcher extends BaseDispatcher
  channel: -> 'navigation'

  shouldAlwaysWake: -> true

  mixins: -> [
    'cms'
  ]

  contentPath: -> '/navigation'

  models: ->
    navigation:
      class: NavigationModel
      fetchOnWake: true

  events: ->
    'sync navigation': @onNavigationSync
    'change:banner navigation': @onBannerChange

  getInitialStore: -> @buildStoreData()

  onNavigationSync: -> @replaceStore @buildStoreData()

  onBannerChange: -> @replaceStore @buildStoreData()

  buildStoreData: ->
    # Get correct variation.
    contentVariation = @getContentVariation @data('navigation')

    # Strip links to routes whose features aren't supported in this locale.
    store = _.mapValues contentVariation, @removeUnsupportedLinks.bind(@)

    store.smart_banner = @configureSmartBanner(store.smart_banner)

    if @environment.server
      _.merge store,
        banner:
          show: false
    else
      _.merge store,
        banner:
          bannerAnimatedOnce: @hasBannerAnimated()
          show: @getBannerVisibility store.banner

    _.assign store, __fetched: @model('navigation').isFetched()

  configureSmartBanner: (details = {}) ->
    eligibleDevice = _.get @appState, 'client.isNativeAppCapable'
    variant = {}
    currentLocation = @currentLocation().pathname

    if eligibleDevice
      eligiblePath = @getSmartBannerEligiblePath details.whitelist

      if currentLocation is '/'
        variant = _.find details.variants, (aVariant) -> aVariant.homepage_variant
      else
        variant = _.find details.variants, (aVariant) -> not aVariant.homepage_variant

      shouldBeHidden = @getCookie 'smartBannerClosed'

    enabled = _.every [
      details.enabled
      eligibleDevice
      eligiblePath
      not _.isEmpty(variant)
      not shouldBeHidden
    ]

    _.assign variant, enabled: enabled

    if enabled
      whitelist_entry = _.find details.whitelist, (entry) ->
        return new RegExp(entry.reg_ex).test currentLocation
      if whitelist_entry
        encodedCurrentPath = encodeURIComponent(currentLocation)
        final_cta_url = "#{whitelist_entry.cta_url}&af_web_dp=https%3A%2F%2Fwww.warbyparker.com#{encodedCurrentPath}"
        _.assign variant, cta_url: final_cta_url

  getSmartBannerEligiblePath: (whitelist = []) ->
    currentLocation = @currentLocation().pathname

    isEligiblePath = _.some whitelist, (entry) ->
      new RegExp(entry.reg_ex).test currentLocation
    return isEligiblePath


  getBannerVisibility: (banner = {}) ->
    currentLocation = @currentLocation().pathname

    isBlacklisted = _.some banner.blacklist, (path) ->
      _.startsWith currentLocation, path

    isClosed = @requestDispatcher 'cookies', 'get', 'bannerClosed'

    isHidden = not banner.show

    not (isBlacklisted or isClosed or isHidden)

  hasBannerAnimated: ->
    @requestDispatcher('cookies', 'get', 'bannerAnimatedOnce') is 'true'

  removeUnsupportedLinks: (section) ->
    return section unless _.has section, 'links'

    section.links = _.reduce section.links, (acc, link) =>
      localeBasedFeature = _.get LOCALE_BASED_FEATURES, link.route, false

      # Include this link if it's specifically listed as locale-based AND it's
      # supported in this locale, or if it's not locale-based.
      if @getFeature(localeBasedFeature) or not localeBasedFeature
        acc.concat link
      else
        acc
    , []

    section

  commands:
    closeBanner: ->
      @commandDispatcher 'cookies', 'set', 'bannerClosed', true
      @model('navigation').set 'banner.show', false

    bannerAnimatedOnce: ->
      @commandDispatcher 'cookies', 'set', 'bannerAnimatedOnce', true, expires: (3600 * 12)

    closeSmartBanner: ->
      @commandDispatcher 'cookies', 'set', 'smartBannerClosed', true
      @replaceStore @buildStoreData()

  requests:
    smartBannerActive: ->
      _.get @store, 'smart_banner.enabled', false

module.exports = NavigationDispatcher
