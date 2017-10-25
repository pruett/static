[
  _

  Logger
  BaseDispatcher

  CartItemModel
  CartToEstimateModel

  EstimateModel
  EstimateAddressModel
  EstimateCustomerModel
  EstimateOrderModel
  EstimateShippingModel
  EstimatePrescriptionSendLaterModel
] = [
  require 'lodash'

  require '../logger'
  require '../../common/dispatchers/base_dispatcher'

  require '../../common/backbone/models/cart_item_model'
  require '../../common/backbone/models/cart_to_estimate_model'

  require '../../common/backbone/models/estimate/estimate_model'
  require '../../common/backbone/models/estimate/estimate_address_model'
  require '../../common/backbone/models/estimate/estimate_customer_model'
  require '../../common/backbone/models/estimate/estimate_order_model'
  require '../../common/backbone/models/estimate/estimate_shipping_model'
  require '../../common/backbone/models/estimate/prescription/estimate_prescription_send_later_model'
]

class ApplePayDispatcher extends BaseDispatcher
  log = Logger.get('ApplePayDispatcher').log

  channel: -> 'applePay'

  shouldAlwaysWake: true

  models: ->
    estimate: new EstimateModel
    order: new EstimateOrderModel
    shipping: new EstimateShippingModel
    address: new EstimateAddressModel
    customer: new EstimateCustomerModel
    prescription: new EstimatePrescriptionSendLaterModel

  getInitialStore: ->
    checkoutRequested: null
    isApplePayActive: false
    isApplePayAvailable: null
    isEstimateCreated: false
    isApplePayCapable: (
      @inExperiment('applePay', 'activated') and
      _.get(@appState, 'client.isApplePayCapable', false)
    )
    isLoading: false
    isStripeAvailable: false
    errors: []

  wake: ->
    if @store.isApplePayCapable
      # This dispatcher only cares about the Stripe dispatcher if it's in
      # an Apple Pay capable browser.
      @getChannel('stripe').on 'change', @handleStripeStoreChange.bind(@)
      @getChannel('stripe').request '__wakeOnStore'
      @setStore isLoading: true
      @pushEvent 'browser-support-applePay'

    else
      @setStore isLoading: false, isApplePayAvailable: false

  initialize: ->
    @recalculateQueue = []

  isEstimateCreated: -> @store.isEstimateCreated

  onCartItemAddSuccess: (item) ->
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: _.get @requestDispatcher('analytics', 'store'), 'ecommerceEvents.addToCart'
      products: item.toJSON()
    @createEstimateForApplePay()

  createEstimateForApplePay: ->
    cartToEstimate = new CartToEstimateModel()
    cartToEstimate.save apple_pay: true,
      success: @onEstimateCreateSuccess.bind(@)
      error: @onEstimateCreateError.bind(@)

  recalculate: (attrs, sessionCallback) ->
    # Recalculate calls need to be buffered and handled async because we may
    # not have the estimate yet. We should only have one in the queue at most.
    log 'recalculate', attrs, sessionCallback
    if attrs and sessionCallback
      @recalculateQueue.push [attrs, sessionCallback]
    @recalculateTask @recalculateQueue.shift() if @isEstimateCreated()

  recalculateTask: (task) ->
    return unless task?
    [attrs, sessionCallback] = task
    log 'recalculateTask', attrs, sessionCallback

    if attrs.shippingMethod
      shippingMethodId = attrs.shippingMethod.identifier
      # Update shipping method then notify ApplePaySession.
      if @model('estimate').get('shipping.method_id') isnt shippingMethodId
        @model('shipping').save(
          use_expedited_shipping: shippingMethodId isnt '1'
        ,
          success: @notifyApplePaySession.bind(@, true, sessionCallback)
          error: @notifyApplePaySession.bind(@, false, sessionCallback)
          type: 'POST'
        )
    else if attrs.shippingAddress
      # Update shipping address then notify ApplePaySession.
      address = attrs.shippingAddress
      postalCode = address.postalCode
      postalCode += '0' while _.size(postalCode) < 5

      # Ensure uppercase countryCode
      countryCode = (address.countryCode or '').toUpperCase() or @getLocale('country')

      @model('address').save(
        # Here, we save a temporary address with the limited information that
        # Apple Pay provides in order to calculate shipping. This isn't
        # actually relevant to Warby Parker, as our shipping rates are flat, but
        # the estimate won't report the shipping or tax totals correctly without
        # a placeholder address.
        first_name: 'Unknown'
        last_name: 'ApplePayUser'
        street_address: '1 Infinite Loop'
        locality: address.locality
        region: address.administrativeArea
        postal_code: postalCode
        country_code: countryCode
        telephone: '888-492-7297'  # Warby Parker CX phone number.
      ,
        success: @notifyApplePaySession.bind(@, true, sessionCallback)
        error: @notifyApplePaySession.bind(@, false, sessionCallback)
        type: 'POST'
      )

  notifyApplePaySession: (success, sessionCallback) ->
    # Notify the ApplePaySession of new totals after recalculating taxes or
    # shipping.
    if success
      @model('estimate').fetch success: (model) =>
        # The ApplePaySession requires similar, but slightly different arguments
        # when calling back after shipping address or method is changed.
        args = _.compact [
          model.applePayShippingMethods() if sessionCallback is 'completeShippingContactSelection'
          model.applePayTotal()
          model.applePayLineItems()
        ]
        args.unshift ApplePaySession.STATUS_SUCCESS
        log 'notifyApplePaySession', sessionCallback, args
        @session[sessionCallback].apply @session, args
    else
      # Assemble default arguments for ApplePaySession
      args = _.compact [
        @model('estimate').applePayShippingMethods() if sessionCallback is 'completeShippingContactSelection'
        @model('estimate').applePayTotal()
        @model('estimate').applePayLineItems()
      ]
      if sessionCallback is 'completeShippingContactSelection'
        # This adds an error state next to shipping address,
        # letting user know to pick a new address.
        args.unshift ApplePaySession.STATUS_INVALID_SHIPPING_POSTAL_ADDRESS
      else
        # This will close apple pay and show our error statement.
        args.unshift ApplePaySession.STATUS_FAILURE
        errors = {
          completeShippingMethodSelection: 'Unable to change shipping method.'
          completeShippingContactSelection: 'Unable to use shipping address.'
        }
        @setStore errors: [errors[sessionCallback]]
      @session[sessionCallback].apply @session, args

  getInitialPaymentRequest: ->
    # An Apple Pay PaymentRequest used to initialize the action sheet. Most
    # line items are pending and will be replaced once the estimate is created
    # with accurate information.
    return {
      countryCode: @getLocale('country')
      currencyCode: @getLocale('currency')
      lineItems: [
        type: 'final'
        label: 'Shipping'
        amount: 0.0
      ,
        type: 'pending'
        label: 'Tax'
        amount: 0.0
      ]
      requiredShippingContactFields: _.compact [
        'email' unless @requestDispatcher('session', 'isLoggedIn')
        'name'
        'phone'
        'postalAddress'
      ]
      shippingMethods: []
      total:
        label: 'Warby Parker'
        amount: 0.01
        type: 'pending'
    }

  getOrderLeadTimeCategory: ->
    FALLBACK_CATEGORY = 14
    categories = _.uniq(@model('estimate').get('order_lead_time_categories') or [FALLBACK_CATEGORY])
    if categories.length is 1
      _.head categories
    else
      FALLBACK_CATEGORY

  createApplePaySession: (amount) ->
    # Create the ApplePaySession and bind to it's callback methods.
    return if @store.isApplePayActive

    @session = Stripe.applePay.buildSession(
      @getInitialPaymentRequest(amount)
      @onStripeCompletion.bind(@)
      @onStripeError.bind(@)
    )

    @session.onshippingmethodselected = @onApplePayShippingMethod.bind(@)
    @session.onshippingcontactselected = @onApplePayContactSelected.bind(@)
    @session.oncancel = @onApplePayCancel.bind(@)

    @setStore isApplePayActive: true
    @pushEvent 'browser-active-applePay'

  onPlaceOrderError: (reason, completion) ->
    log 'onPlaceOrderError', reason
    error =
      switch reason
        when 'customer' then 'Unable to check out with provided name or email.'
        when 'address' then 'Unable to check out with the provided address.'
        when 'placeOrder' then 'Unable to complete payment.'
        else 'Aw shucks, an unknown error occurred.'
    @setStore errors: [error]
    completion(false)

  randomPassword: ->
    r = -> Math.random().toString(36).substr(2, 8)
    [r(), r(), r(), r()].join('')

  # Apple Pay Session Events
  # ------------------------

  onApplePayCancel: (event) ->
    log 'onApplePayCancel'
    # Callback from ApplePaySession when canceled.
    @setStore(
      isApplePayActive: false
      isEstimateCreated: false
      checkoutRequested: null
    )

  onApplePayShippingMethod: (event) ->
    # Callback from ApplePaySession when a shipping method is selected/changed.
    log 'onApplePayShippingMethod'
    shippingMethod = event.shippingMethod
    @recalculate shippingMethod: shippingMethod, 'completeShippingMethodSelection'

  onApplePayContactSelected: (event) ->
    # Callback from ApplePaySession when a shipping contact is selected/changed.
    log 'onApplePayContactSelected'
    shippingAddress = event.shippingContact
    @recalculate shippingAddress: shippingAddress, 'completeShippingContactSelection'

  # Stripe Events
  # -------------

  onStripeCompletion: (result, completion) ->
    log 'onStripeCompletion', result

    contact = result.shippingContact

    customerDetails = {
      email: contact.emailAddress
      first_name: contact.givenName
      last_name: contact.familyName
      password: @randomPassword()
    }

    streetAddress = contact.addressLines[0]
    extendedAddress = contact.addressLines[1] or null
    company = null

    if _.size(contact.addressLines) is 3
      company = contact.addressLines[0]
      streetAddress = contact.addressLines[1]
      extendedAddress = contact.addressLines[2]

    # Ensure uppercase countryCode
    countryCode = (contact.countryCode or '').toUpperCase() or @getLocale('country')

    addressDetails = {
      company: company
      country_code: countryCode
      email: contact.emailAddress
      extended_address: extendedAddress
      first_name: contact.givenName
      last_name: contact.familyName
      locality: contact.locality
      postal_code: contact.postalCode
      region: contact.administrativeArea
      street_address: streetAddress
      telephone: contact.phoneNumber
    }

    brand = _.get(result, 'token.card.brand')

    card_type_id =
      if /express/i.test(brand) then 1
      else if /discover/i.test(brand) then 2
      else if /mastercard/i.test(brand) then 3
      else if /visa/i.test(brand) then 4
      else 99

    paymentDetails = {
      cc_token: result.token.id
      cc_expires_month: result.token.card.exp_month
      cc_expires_year: result.token.card.exp_year
      cc_last_four: result.token.card.last4
      cc_type_id: card_type_id
    }

    saveCustomer = (success) =>
      log 'saveCustomer', customerDetails
      if @requestDispatcher('session', 'isLoggedIn')
        # Don't modify the customer if we're logged-in.
        success()
      else
        @model('customer').save customerDetails,
          type: 'POST'
          success: success
          error: @onPlaceOrderError.bind @, 'customer', completion

    saveAddress = (success) =>
      log 'saveAddress'
      @model('address').save addressDetails,
        type: 'POST'
        success: success
        error: @onPlaceOrderError.bind @, 'address', completion

    saveShipping = (success) =>
      log 'saveShipping'
      if result.shippingMethod
        shippingMethodId = result.shippingMethod.identifier
        @model('shipping').save(
          use_expedited_shipping: shippingMethodId isnt '1'
        ,
          type: 'POST'
          success: success
          error: @onPlaceOrderError.bind @, 'shipping', completion
        )
      else
        success()

    savePrescription = (success) =>
      log 'savePrescription'
      if @model('estimate').get('prescription_required')
        @model('prescription').save {},
          success: success
          error: @onPlaceOrderError.bind @, 'prescription', completion
      else
        success()

    placeOrder = (success) =>
      log 'placeOrder'
      @model('order').save paymentDetails,
        type: 'POST'
        success: success
        error: @onPlaceOrderError.bind @, 'placeOrder', completion

    placeOrderSuccess = (confirmation) =>
      log 'order placed', confirmation
      completion(true)
      orders = confirmation.get('order_ids').join ','
      completedUrl = "/checkout/confirmation?orders=#{
        orders}&applePay=true&olt=#{@getOrderLeadTimeCategory()}"

      analytics = confirmation.get('analytics')
      analytics.apple_pay = true
      @commandDispatcher 'postCheckout', 'setEstimate', analytics

      if @model('estimate').get('prescription_required')
        @navigate "#{completedUrl}&showRxUpload=true"
      else
        @navigate completedUrl


    # Look at me, I'm the callback captain now.
    saveCustomer -> saveAddress -> saveShipping -> savePrescription ->
      placeOrder(placeOrderSuccess)

  onStripeError: (error) ->
    log 'onStripeError', error
    @setStore
      isApplePayActive: false
      errors: ['Unable to complete Apple Pay due to Stripe error.']

  # Estimate Events
  # ---------------

  onEstimateCreateSuccess: (estimate) ->
    log 'onEstimateCreateSuccess'
    hasEstimateCookie = @requestDispatcher 'cookies', 'get', 'estimate_id'
    return unless estimate.isFetched() and hasEstimateCookie
    @setStore isEstimateCreated: true
    @recalculate()

  onEstimateCreateError: (estimate, xhr, options) ->
    log 'onEstimateCreateError'
    @setStore errors: [
      "Unable to check out, is your cart empty?"
    ]

  handleStripeStoreChange: (stripeStore) ->
    log 'handleStripeStoreChange', stripeStore
    return if @store.isStripeAvailable
    if stripeStore.isAvailable and Stripe?.applePay?
      @setStore isLoading: false, isStripeAvailable: true
      @command 'checkAvailability'
    else
      @setStore isLoading: stripeStore.isLoading

  commands:
    checkAvailability: ->
      return unless @store.isStripeAvailable
      Stripe.applePay.checkAvailability (available) =>
        available = available or @environment.debug
        @setStore isApplePayAvailable: available
        @pushEvent 'stripe-available-applePay' if available

    checkout: (source, attrs) ->
      return if @store.isApplePayActive
      @setStore checkoutRequested: [source, attrs]

      if not @store.isApplePayAvailable
        @setStore errors: ['Sorry, Apple Pay is not available on this device.']
        return

      amount = 0

      toDecimals = (amount) ->
        parseFloat (amount * 0.01).toFixed(2)

      switch source
        when 'cart'
          log 'checkout:cart'
          cart = @requestDispatcher 'cart', 'store'
          amount = toDecimals(_.get(cart, 'subtotal', 0))
          @createEstimateForApplePay()
        when 'frameProduct', 'editions'
          log "checkout:#{source}"
          amount = toDecimals(_.get(attrs, 'variant.price_cents', 0))
          productVariant = {
            product_id: attrs.product_id
            variant_id: _.get attrs, 'variant.variant_id'
            apple_pay: true
            qty: attrs.qty or 1
          }
          cartItem = new CartItemModel
          cartItem.save productVariant, success: @onCartItemAddSuccess.bind(@)
        when 'giftCard'
          log 'checkout:giftCard is not yet implemented'
        else
          log "checkout:#{source} is unknown"

      @createApplePaySession(amount)
      @session.begin()

module.exports = ApplePayDispatcher
