[
  _

  BaseDispatcher
  Backbone
  Backbone.Cache

  LoginModel
  NewCustomerModel
  NewMinimalCustomerModel
  SessionModel

  Mixins
] = [
  require 'lodash'

  require './base_dispatcher'
  require '../backbone/backbone'
  require '../backbone/cache'

  require '../backbone/models/login_model'
  require '../backbone/models/new_customer_model'
  require '../backbone/models/new_minimal_customer_model'
  require '../backbone/models/session_model'

  require './mixins/mixins'
]

class LogoutModel extends Backbone.BaseModel
  url: ->  @apiBaseUrl('account/logout')
  defaults: -> logout: true

class SessionDispatcher extends BaseDispatcher

  channel: -> 'session'

  shouldAlwaysWake: -> true

  events: ->
    'sync session': @onSync

  windowEvents: ->
    'storage': @syncFromCache

  mixins: -> [
    'modals'
    'api'
  ]

  wake: ->
    @command 'refresh'
    @restartFetchInterval()

  restartFetchInterval: ->
    # Fetch the session endpoint periodically (but infrequently) because if
    # someone has multiple tabs open, it'll refresh cookies, the header, and the
    # logged-in state.
    clearInterval @fetchInterval
    @fetchInterval = setInterval @command.bind(@, 'refresh'), 10 * 60000  # 10 minutes.

  models: ->
    session:
      class: SessionModel
      alwaysFetch: true
      ttl: @__getSessionTTL()

  __getSessionTTL: ->
    parseInt(@requestDispatcher('config', 'get', 'server.features.session_storage_ttl')) or 0

  __syncSessionWithStorage: ->
    unless @environment.browser
      return
    session = @model 'session'
    fromStorage = Backbone.Cache.get(session.cacheKey(), session.cacheVersion())
    if fromStorage?
      if session.get('seconds_since_arrival') > fromStorage.seconds_since_arrival
        # local storage is less recent, so set it
        @updateLocalStorage()
      else
        # page data is older than local storage, refresh it
        session.unset 'cart.items' # Nested arrays don't end up updating otherwise
        session.set(fromStorage)
    else
      # local storage isn't current, so set it
      @updateLocalStorage()

  getInitialStore: ->
    if @model('session').isFetched()
      @__syncSessionWithStorage()
    @buildStoreData()

  syncFromCache: (event) ->
    # Called on a localStorage change event
    if Backbone.Cache.match(event.key, @model('session').cacheKey())
      @command 'refresh'

  buildStoreData: ->
    store = _.assign @data('session'),
      __fetched: @model('session').isFetched()
      initialEmail: ''
      showWelcomeBackCart: false
      isLoggedIn: _.get @data('session'), 'customer.authenticated', false

    @commandDispatcher 'analytics', 'push', 'wp.session',
      userEmailMD5Digest: _.get store, 'customer.email_md5_digest', ''
      userEmailSHADigest: _.get store, 'customer.email_sha_digest', ''
      userId: _.get store, 'customer.id', ''
      userHasNonHtoSalesOrders: _.get store, 'customer.has_non_hto_sales_orders', false

    store

  loginOrSignupViaFavoriteModal: (obj) ->
    obj.fromFavoriteModal or false

  onSync: ->
    @replaceStore @buildStoreData()

  resetErrors: ->
    @setStore loginErrors: {}

  onLoginSuccess: (model) ->
    @modals success: 'doLogin'
    @resetErrors()
    @command 'reload', =>
      @navigate model.route if model.route

    @commandDispatcher('favorites', 'processFavorites') if model.fromFavoriteModal

  onLoginError: (model, xhr, options) ->
    @modals error: 'doLogin'
    @replaceStore loginErrors: @parseApiError(xhr.response)

  onLogoutSuccess: (model) ->
    @modals success: 'doLogout'
    @command 'reload', =>
      @navigate model.route if model.route

  onNewCustomerSuccess: (model, xhr) ->
    @modals success: 'createCustomer'
    @resetErrors()
    @command 'reload', =>
      if model.route
        @navigate model.route
      else
        @replaceStore customer: xhr.response

    @commandDispatcher('favorites', 'processFavorites') if model.fromFavoriteModal

  onNewCustomerError: (model, xhr, options) ->
    @modals error: 'createCustomer'
    @replaceStore newCustomerErrors: @parseApiError(xhr.response)

  locationDidChange: ->
    @setStore(
      unauthorizedError: ''
      loginErrors: {}
      newCustomerErrors: {}
    )

  updateLocalStorage: ->
    session = @model 'session'
    Backbone.Cache.set(session.cacheKey(), session.cacheVersion(), session.toJSON(), session.cacheTTL())

  updateCart: (cart) ->
    session = @model 'session'
    session.unset 'cart.items' # Nested arrays don't end up updating otherwise
    session.set(cart: cart)

    if session.hasChanged()
      @updateLocalStorage()
    @replaceStore cart: cart

  requests:
    isLoggedIn: -> @store.isLoggedIn

  commands:
    refresh: ->
      @restartFetchInterval()
      @model('session').fetch()

    logout: (options = {}) ->
      return if _.isEmpty(@model('session').get 'customer')  # Already logged-out.

      return if @modals isShowing: 'doLogout'

      logout = new LogoutModel(logout: true)
      logout.route = options.routeSuccess

      logout.save null, success: @onLogoutSuccess.bind(@)

    login: (attrs, options = {}) ->
      return if @modals isShowing: 'doLogout'

      nextParam = _.get @currentLocation(), 'query.next'
      nextParam = '/account' if not _.startsWith(options.routeSuccess, '/')

      _.defaults options, routeSuccess: nextParam or '/'

      login = new LoginModel(attrs)
      login.route = options.routeSuccess
      login.fromFavoriteModal = @loginOrSignupViaFavoriteModal options

      if options.loginType is 'checkout'
        login.url = login.apiBaseUrl('estimate/login')

      errors = login.validate()

      if errors
        @replaceStore loginErrors: Backbone.Labels.format(errors, @getLocale('country'))
      else
        @modals loading: 'doLogin'
        login.save null,
          success: @onLoginSuccess.bind(@)
          error: @onLoginError.bind(@)

    reload: (success) ->
      # forceReload: force skips the cache read
      options = forceReload: true
      options.success = success if success
      @model('session').fetch(options)

    changeEmail: (email) ->
      if email.search(/.+\@.+\..+/) is 0
        @setStore initialEmail: email
      else
        @setStore initialEmail: ''

    unauthorized: (message = 'Oops. You\'ll need to sign in first.') ->
      location = @currentLocation()
      nextUrl = location.pathname
      nextUrl = "#{nextUrl}?#{location.search}" if location.search
      @navigate "/login?next=#{encodeURIComponent(nextUrl)}"
      @setStore unauthorizedError: message

    createNewCustomer: (attrs, route, options = {}) ->
      return if @modals isShowing: 'createCustomer'

      customer = if attrs.minimal then new NewMinimalCustomerModel(attrs) else new NewCustomerModel(attrs)
      customer.route = route if route
      customer.fromFavoriteModal = @loginOrSignupViaFavoriteModal attrs

      if options.newCustomerType is 'checkout'
        customer.url = customer.apiBaseUrl 'estimate/customer'

      errors = customer.validate()

      if errors
        @replaceStore newCustomerErrors: Backbone.Labels.format(errors, @getLocale('country'))
      else
        @modals loading: 'createCustomer'
        customer.save null,
          success: @onNewCustomerSuccess.bind(@)
          error: @onNewCustomerError.bind(@)

    hideWelcomeBackHto: ->
      @setStore showWelcomeBackHtoVersion: null

    addCartItem: (item, isHto) ->
      cart = _.assign {}, @store.cart
      cart.quantity++
      if isHto
        cart.hto_quantity++
        cart.hto_quantity_remaining--
        cart.hto_limit_reached = not cart.hto_quantity_remaining
      cart.items.push item
      @updateCart cart
      # Route to cart after an ATC, unless it's an HTO before the limit, or the HTO Drawer is enabled
      if not isHto or (
        cart.hto_limit_reached and not _.includes @getExperimentVariant('htoDrawer'), 'enabled'
      )
        @navigate '/cart'

    removeCartItem: (id, isHto) ->
      cart = _.assign {}, @store.cart
      items = _.filter cart.items, (i) -> i.id isnt id
      if items.length < cart.items.length
        cart.items = items
        cart.quantity--
        if isHto
          cart.hto_quantity--
          cart.hto_quantity_remaining++
          cart.hto_limit_reached = false
        @updateCart cart

module.exports = SessionDispatcher
