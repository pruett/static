[
  _

  BaseDispatcher
  Radio
  Logger

  {makeStartCase}
] = [
  require 'lodash'

  require '../../common/dispatchers/base_dispatcher'
  require '../../common/radio'
  require '../logger'

  require 'hedeia/common/utils/string_formatting'
]

INPUT_DEBOUNCE_TIMEOUT = 1500

SCROLL_DEBOUNCE_TIMEOUT = 1000

RESIZE_DEBOUNCE_TIMEOUT = 1000

POLLING_INTERVAL = 40

ECOMMERCE_EVENT_TYPES =
  # Cart actions
  addToCart: 'addToCart'
  removeFromCart: 'removeFromCart'
  # Checkout
  checkoutOption: 'checkout_option'
  checkoutStep: 'checkout'
  checkoutSuccess: 'purchase'
  # Promos. It's deliberate that these values use 'promotion' instead of 'promo'.
  # That's the way Google's Enhanced Ecommerce schema wants it.
  promoImpression: 'promotionImpression'
  promoClick: 'promotionClick'
  # Product
  productImpression: 'productImpression'
  productClick: 'productClick'
  productDetail: 'productDetail'

debounceTimeouts = {}

isBlockClass = (name) ->
  # If we can't find an id on an element, we use the block class as the
  # descriptor.
  name and name.indexOf('c-') is 0

class AnalyticsDispatcher extends BaseDispatcher
  log = Logger.get('AnalyticsDispatcher').log

  channel: -> 'analytics'

  shouldAlwaysWake: -> true

  getScrollPoints: ->
    # Percentages to track.
    [0.25, 0.5, 0.75, 1.0]

  getInitialStore: ->
    scrollPoints: @getScrollPoints()
    ecommerceEvents: ECOMMERCE_EVENT_TYPES
    checkout:
      currentStep: null
      previousStep: null

  wake: ->
    @checkTryCount = 0
    @checkForTagManager()

    @pushCheckoutEvents @currentLocation().pathname
    @setUpResizeListener()
    @setUpScrollListener()
    @setUpNetworkListeners()

    @checkScrollPosition()

  checkForTagManager: ->
    if window.google_tag_manager?
      elapsed = POLLING_INTERVAL * @checkTryCount
      log "Google Tag Manager available after #{elapsed}ms"
    else
      @checkTryCount += 1
      _.delay @checkForTagManager.bind(@), POLLING_INTERVAL

  setUpResizeListener: ->
    window.addEventListener 'resize',
      _.debounce @handleResize.bind(@), RESIZE_DEBOUNCE_TIMEOUT

  handleResize: ->
    documentElement = document.documentElement or {}
    windowHeight = window.innerHeight or documentElement.clientHeight
    windowWidth = window.innerWidth or documentElement.clientWidth
    @pushEvent "browserWindow-resize-#{windowWidth}x#{windowHeight}"

  setUpScrollListener: ->
    @scrollFn = _.debounce @checkScrollPosition.bind(@), SCROLL_DEBOUNCE_TIMEOUT
    window.addEventListener 'scroll', @scrollFn, @getListenerOptions()

  checkScrollPosition: ->
    return unless @store.scrollPoints[0]

    body = document.body or {}
    html = document.documentElement or {}

    pageHeight = Math.max(
        body.scrollHeight
        body.offsetHeight
        html.clientHeight
        html.scrollHeight
        html.offsetHeight
      ) - 5 # iOS trigger cushion.

    return if pageHeight <= 0

    windowHeight = window.innerHeight or html.clientHeight
    currentPoint = (windowHeight + body.scrollTop) / pageHeight

    scrollPoints = @store.scrollPoints.slice(0)
    while scrollPoints[0] and currentPoint >= scrollPoints[0]
      @pushEvent "browserWindow-scroll-#{Math.floor(scrollPoints.shift() * 100)}%"

    if _.isEmpty scrollPoints
      window.removeEventListener 'scroll', @scrollFn, @getListenerOptions()
    else if not _.isEqual(scrollPoints, @store.scrollPoints)
      @replaceStore scrollPoints: scrollPoints

  getListenerOptions: ->
    if @supportsPassiveEventListeners() then { passive: true } else false

  supportsPassiveEventListeners: ->
    # https://github.com/WICG/EventListenerOptions/blob/gh-pages/explainer.md
    # https://github.com/Modernizr/Modernizr/blob/master/feature-detects/dom/passiveeventlisteners.js
    supports = false

    try
      opts = Object.defineProperty {}, 'passive', get: -> supports = true
      window.addEventListener 'test', null, opts
    catch e

    supports

  setUpNetworkListeners: ->
    @offlineEvents = []

    window.addEventListener 'offline', @handleOffline.bind @
    window.addEventListener 'online', @handleOnline.bind @

  handleOffline: ->
    # User has lost their network connection.
    @pushEvent 'browser-network-offline'

  handleOnline: ->
    # User has regained a network connection; push events saved while offline.
    while @offlineEvents.length > 0
      {eventName, data} = @offlineEvents.pop()
      @command 'push', eventName, data

  broadcast: (eventInfo) ->
    doBroadcast = ->
      Radio.channel('analytics').request 'push', eventInfo.name, eventInfo.data

    if eventInfo.debounce
      clearTimeout debounceTimeouts[eventInfo.key]
      debounceTimeouts[eventInfo.key] = setTimeout doBroadcast, INPUT_DEBOUNCE_TIMEOUT
    else
      _.defer doBroadcast

  getProductCategory: (product={}) ->
    # The various product-related endpoints (PLP, PDP, add to cart, checkout, etc.)
    # each have a different way that they supply the value that we're passing to
    # GTM as "product category". This looks in each place that that value might be.
    category =
      product.assembly_type or
      _.get(product, 'attributes.attributes.frame_assembly_type') or
      product.product_category or
      _.get(product, 'attributes.product_category', product.category)

    if category
      makeStartCase category
    else
      'Unspecified'

  getProductVariant: (product={}) ->
    variant = if typeof product.variant_type is 'object'
        _.get product, 'variant_type.variant'
      else
        product.variant_type
    variant or= product.option_type

    if variant
      makeStartCase variant
    else
      'Unspecified'

  getProductGender: (product={}) ->
    switch (product.gender or '').toLowerCase()
      when 'u' then 'Unisex'
      when 'f' then 'Women'
      when 'm' then 'Men'
      else 'Unspecified'

  getProductColor: (product={}) ->
    if product.color
      makeStartCase product.color
    else
      'Unspecified'

  getProductCollections: (product={}) ->
    collections =
      if product.collections?.length
        product.collections.map (collection) -> collection.slug or ''
      else if _.isPlainObject(product.attributes?.collection)
        Object.keys product.attributes.collection

    if collections
      collections.join '_'
    else
      'Unspecified'

  getTransactionType: (estimate) ->
    transactionType = null
    _.forEach estimate.items, (item) ->
      itemType = if item.variant_type?.toLowerCase() is 'hto' then 'hto' else 'purchase'
      if not transactionType
        transactionType = itemType
      else if transactionType isnt itemType
        transactionType = 'mixed'
        return false
    return transactionType

  prepProductData: (rawProducts, metadata={}) ->
    # Key is product identifier, value is that product's index in the `products` array
    indexMap = {}
    rawProducts = [rawProducts] unless _.isArray rawProducts

    # If you have two of the same product in, say, your cart, the array of products will
    # have one entry for each product, and each one will have `quantity: 1`.
    # This de-duplicates `products` and sets `quantity` appropriately.
    return _.reduce rawProducts, (products, product) =>
      identifier = product.sku
      existingProduct = products[indexMap[identifier]]
      if existingProduct
        existingProduct.quantity = ++existingProduct.quantity or 1
      else
        if identifier
          # `products.length` is the index in `products` that this product will end up at.
          indexMap[identifier] = products.length

        variant = @getProductVariant product
        price = (parseInt(product.amount_cents, 10) / 100).toFixed(2)
        quantity = product.qty or product.quantity

        optionalAttributes =
          # It is possible for edition products to have a quantity above 1
          # We want to log the unit price, not the total amount
          price: if quantity > 1 then (price / quantity).toFixed(2) else price
          variant: variant

        categoryIdentifiers = [
          @getProductCategory product
        ,
          variant
        ,
          @getProductGender product
        ,
          @getProductColor product
        ,
          @getProductCollections product
        ].join '/'

        product = _.assign _.omit(product, ['image_set', 'images']),
          brand: 'Warby Parker'
          id: product.product_id or product.id
          name: product.name or product.display_name
          category: categoryIdentifiers
        ,
          _.pickBy optionalAttributes, (value) ->
            value isnt 'NaN' and (Boolean(value) or value is 0)

        products.push _.assign(product, metadata)

      return products
    , []

  locationDidChange: (nextLocation, prevLocation) ->
    if nextLocation.pathname isnt prevLocation.pathname
      # TODO: Fix location changes so they
      # don't fire when only title changes.
      @pushOptimizelyPageView()

    @pushCheckoutEvents(nextLocation.pathname, prevLocation.pathname)

    # Reset scroll tracking points.
    @replaceStore scrollPoints: @getScrollPoints()

  parseEventSlug: (slug) ->
    # Event slugs should be camelCase, and at least three parts like 'category
    # - action - target - [state]', with state being optional.
    #
    # Examples:
    #
    # checkout-save-information
    # checkout-enter-informationStep
    # checkout-save-information-triggered

    splitName = slug.split '-'
    size = _.size splitName
    return unless size >= 3

    id: slug
    category: splitName[0]
    action: splitName[1]
    target: splitName[2]
    state: if size > 3 then splitName[3] else null

  pushOptimizelyPageView: ->
    window.optimizely or= []
    window.optimizely.push(['trackEvent', window.location.href])

  pushCheckoutEvents: (nextPath, prevPath) ->
    routeToEventMap =
      '/checkout':                               'index'
      '/checkout/confirmation':                  'confirmation'
      '/checkout/faq':                           'faq'
      '/checkout/login':                         'login'
      '/checkout/step/information':              'information'
      '/checkout/step/prescription':             'prescription'
      '/checkout/step/prescription/call-doctor': 'prescriptionCallDoctor'
      '/checkout/step/prescription/lens':        'prescriptionLens'
      '/checkout/step/prescription/readers':     'prescriptionReaders'
      '/checkout/step/review':                   'review'

    exitEvent = routeToEventMap[prevPath]
    @pushEvent("checkout-exit-#{_.camelCase exitEvent}Step") if exitEvent

    enterEvent = routeToEventMap[nextPath]
    @pushEvent("checkout-enter-#{_.camelCase enterEvent}Step") if enterEvent

    @replaceStore checkout: { currentStep: enterEvent, previousStep: exitEvent }

  commands:
    push: (eventName, data) ->
      if window.navigator?.onLine? and not window.navigator.onLine
        # We know the user is offline, so save this until we're back online.
        @offlineEvents.push {eventName, data}

      else
        # We can't get online/offline status, so just try to push.
        window.dataLayer.push _.assign({}, data, event: eventName)

    pushEcommerce: (eventName, data) ->
      _.set data, 'ecommerce.currencyCode', @getLocale('currency')
      @command 'push', eventName, data

    pushCheckoutEvent: (options) ->
      _.defaults options, checkoutMetadata: {}, checkoutState: {}
      {type, checkoutMetadata, estimate, checkoutState} = options

      return unless estimate
      transactionType = @getTransactionType estimate

      # Google's Tag Manager schema for ecommerce events is documented at:
      # https://developers.google.com/tag-manager/enhanced-ecommerce
      productData = @prepProductData estimate.items or []
      dataObjects =
        "#{ECOMMERCE_EVENT_TYPES.checkoutStep}":
          checkout:
            actionField: checkoutMetadata
            products: productData
        "#{ECOMMERCE_EVENT_TYPES.checkoutOption}":
          checkout_option:
            actionField: checkoutMetadata
        "#{ECOMMERCE_EVENT_TYPES.checkoutSuccess}":
          purchase:
            actionField: _.assign checkoutMetadata, transactionType: transactionType
            products: productData

      @command 'pushEcommerce', type,
        _.assign ecommerce: dataObjects[type],
          addresses: _.get estimate, 'address_hashes', []
          checkoutVisitorType: estimate.visitor_type
          checkoutState: checkoutState
          customer:
            id: _.get estimate, 'customer.id'
            emailMD5Digest: _.get estimate, 'customer.email_md5_digest'
            emailSHADigest: _.get estimate, 'customer.email_sha_digest'
            firstNameSHADigest: _.get estimate, 'customer.first_name_sha_digest'
            fullNameSHADigest: _.get estimate, 'customer.full_name_sha_digest'
            lastNameSHADigest: _.get estimate, 'customer.last_name_sha_digest'
          transactionType: transactionType

    pushCheckoutSuccess: (estimate) ->
      checkoutMetadata =
        id: estimate.get('order_ids').join('-')
        affiliation: 'online store'
        coupon: _.get _.first(estimate.get('promo_codes')), 'code'
        couponDiscountAmount: estimate.get('totals.discount')
        currency: @getLocale('currency')
        giftCardAmount: estimate.get('totals.gift_card')
        revenue: estimate.get('totals.revenue')
        revenue_usd_equivalent:
          estimate.get('totals.in_usd.revenue') or estimate.get('totals.revenue')
        shipping: estimate.get('totals.shipping')
        tax: estimate.get('totals.tax')

      checkoutMetadata.option = 'apple pay' if estimate.get('apple_pay')

      @command 'pushCheckoutEvent',
        type: ECOMMERCE_EVENT_TYPES.checkoutSuccess
        estimate: estimate.toJSON()
        checkoutMetadata: checkoutMetadata

    pushFormEvent: (syntheticEvent) ->
      # Push interaction events to Google Tag Manager. This normalizes blur,
      # focus, and change events so that we can understand form interactions
      # from analytics. Rapid-fire events like the `input` event on a text <input>
      # are throttled with an `INPUT_DEBOUNCE_TIMEOUT` timeout per field.
      shouldDebounce = false
      target = syntheticEvent.target
      form = target.form
      eventType = syntheticEvent.type
      elementName = target.name or null
      elementTag = target.tagName.toLowerCase()
      inputType = if target.type then target.type else null
      elementId = target.id or null
      elementClass = _.find target.classList, isBlockClass
      isEmpty = target.value in ['', null, undefined]

      if form?
        # Hopefully all our inputs are contained within a <form>.
        formClass = _.find form.classList, isBlockClass
        formId = form.id or null
      else
        formClass = null
        formId = null

      if elementTag is 'input' and eventType is 'input'
        # Typing into an input field fires an 'input' event that should be
        # debounced.
        eventType = 'change'
        shouldDebounce = true
      else if inputType in ['checkbox', 'radio'] and eventType is 'click'
        # Clicking a checkbox fires a 'click' event we normalize to 'change'.
        eventType = 'change'
      else if elementTag is 'select'
        inputType = null
      else if elementTag is 'form'
        formClass = elementClass
        formId = elementId

      return unless elementTag in ['input', 'select', 'textarea', 'form']
      return unless eventType in ['blur', 'focus', 'change', 'input', 'submit']

      @broadcast
        name: 'wp.formEvent'
        data:
          elementClass: elementClass
          elementId: elementId
          elementName: elementName
          elementTag: elementTag
          eventType: eventType
          formClass: formClass
          formId: formId
          inputType: inputType
          isEmpty: isEmpty
        debounce: shouldDebounce
        key: "#{formId}-#{formClass}-#{elementId}"

    pushFormValidationEvent: (prevErrors, nextErrors, formElement) ->
      # Generic handling of form validation errors. This requires the parent
      # component of the form to explicitly pass a validationErrors prop.

      if not _.isEqual(prevErrors, nextErrors)
        elementClass = _.find formElement.classList, isBlockClass
        elementId = formElement.id or null
        fieldErrors = _.transform nextErrors, (result, value, key) ->
          result[key] = value if value
          result

        # Don't push if validation errors is empty.
        return if _.keys(fieldErrors).length is 0

        @command 'push', 'wp.formValidationEvent',
          elementClass: elementClass
          elementId: elementId
          elementTag: 'form'
          fieldErrors: fieldErrors

    pushFieldValidationEvent: (options) ->
      # Handling of inline form validation errors.
      # Components pass object with values for 'form', 'section', 'field' and 'error'

      @command 'push', 'wp.fieldValidationEvent',
        _.pick options, 'form', 'section', 'field', 'error', 'trigger'

    pushProductEvent: (options) ->
      # Google's Tag Manager schema for ecommerce events is documented at:
      # https://developers.google.com/tag-manager/enhanced-ecommerce
      # `products` is an array of product objects and will be passed straight to GTM.
      # Often it'll just be one product, so you can just pass a single object as
      # `products` and it'll automatically be wrapped in an array to send to GTM.
      # `productMetadata`, if provided, will be `_.assign`ed to each product object.
      # That's useful for tracking things like the products position in a gallery grid.

      {type, products, productMetadata, eventMetadata} = _.defaults options,
        productMetadata: {}
        eventMetadata: {}

      productData = @prepProductData products, productMetadata
      dataObjects =
        "#{ECOMMERCE_EVENT_TYPES.productImpression}":
          impressions: productData
        "#{ECOMMERCE_EVENT_TYPES.productClick}":
          click:
            actionField: eventMetadata
            products: productData
        "#{ECOMMERCE_EVENT_TYPES.productDetail}":
          detail:
            actionField: eventMetadata
            products: productData
        "#{ECOMMERCE_EVENT_TYPES.addToCart}":
          add:
            products: productData
        "#{ECOMMERCE_EVENT_TYPES.removeFromCart}":
          remove:
            products: productData

      @command 'pushEcommerce', type, ecommerce: dataObjects[type]

    pushPromoEvent: (options) ->
      {type, promos, eventMetadata} = _.defaults options, eventMetadata: {}

      # Google's Tag Manager schema for ecommerce events is documented at:
      # https://developers.google.com/tag-manager/enhanced-ecommerce
      dataObjects =
        "#{ECOMMERCE_EVENT_TYPES.promoImpression}":
          promoView:
            promotions: promos
        "#{ECOMMERCE_EVENT_TYPES.promoClick}":
          promoClick:
            promotions: promos

      @command 'pushEcommerce', type, ecommerce: dataObjects[type]

    pushEvent: (options) ->
      # Pushes a `wp.event` to the dataLayer. The options argument should provide a `name`.
      return unless _.isString(options.name)
      event = @parseEventSlug(options.name)
      log "wp.event", event
      @command 'push', 'wp.event', wpEvent: event

module.exports = AnalyticsDispatcher
