[
  _

  Backbone
  BaseDispatcher
  Logger

  AccountCustomerModel
  EstimateModel
  EstimateAddressModel
  EstimateCustomerModel
  EstimatePaymentModel
  EstimateDiscountModel
  EstimateOrderModel
  EstimateShippingModel

  EstimatePrescriptionModel
  EstimatePrescriptionCallDoctorModel
  EstimatePrescriptionExistingModel
  EstimatePrescriptionNonRxModel
  EstimatePrescriptionReadersModel
  EstimatePrescriptionSendLaterModel
  EstimatePrescriptionUploadedModel

  ImageUploadModel

  LoginModel
] = [
  require 'lodash'

  require '../backbone/backbone'
  require './base_dispatcher'
  require '../logger'

  require '../backbone/models/account_customer_model'
  require '../backbone/models/estimate/estimate_model'
  require '../backbone/models/estimate/estimate_address_model'
  require '../backbone/models/estimate/estimate_customer_model'
  require '../backbone/models/estimate/estimate_payment_model'
  require '../backbone/models/estimate/estimate_discount_model'
  require '../backbone/models/estimate/estimate_order_model'
  require '../backbone/models/estimate/estimate_shipping_model'

  require '../backbone/models/estimate/prescription/estimate_prescription_model'
  require '../backbone/models/estimate/prescription/estimate_prescription_call_doctor_model'
  require '../backbone/models/estimate/prescription/estimate_prescription_existing_model'
  require '../backbone/models/estimate/prescription/estimate_prescription_non_rx_model'
  require '../backbone/models/estimate/prescription/estimate_prescription_readers_model'
  require '../backbone/models/estimate/prescription/estimate_prescription_send_later_model'
  require '../backbone/models/estimate/prescription/estimate_prescription_uploaded_model'

  require '../backbone/models/image_upload_model'

  require '../backbone/models/login_model'
]

class StateModel extends Backbone.BaseModel
  defaults: ->
    addressSaving: false
    addressShouldSave: false
    customerSaving: false
    customerShouldSave: false
    paymentSaving: false
    paymentShouldSave: false

class EstimateDispatcher extends BaseDispatcher
  log = Logger.get('EstimateDispatcher').log

  channel: -> 'estimate'

  informationModels: ['customer', 'address', 'payment', 'shipping']

  mixins: -> [
    'api'
    'modals'
  ]

  events: ->
    'sync estimate': @onEstimateSync

  getStoreChangeHandlers: ->
    stripe: 'handleStripeStoreChange'
    analytics: 'handleAnalyticsStoreChange'

  models: ->
    @extendValidation()

    estimate: { class: EstimateModel }
    address: new EstimateAddressModel
    customer: new EstimateCustomerModel
    accountCustomer: new AccountCustomerModel
    payment: new EstimatePaymentModel
    discount: new EstimateDiscountModel
    order: new EstimateOrderModel
    shipping: new EstimateShippingModel
    login: new LoginModel
    state: new StateModel

    prescription: new EstimatePrescriptionModel
    prescriptionCallDoctor: new EstimatePrescriptionCallDoctorModel
    prescriptionExisting: new EstimatePrescriptionExistingModel
    prescriptionNonRx: new EstimatePrescriptionNonRxModel
    prescriptionReaders: new EstimatePrescriptionReadersModel
    prescriptionSendLater: new EstimatePrescriptionSendLaterModel
    prescriptionUploaded: new EstimatePrescriptionUploadedModel

    imageUpload: new ImageUploadModel

  extendValidation: ->
    EstimateCustomerModel = EstimateCustomerModel.extend
      validation: =>
        full_name: @validateFullName
        email: [
          required: true
          msg: 'Please add your email address'
        ,
          pattern: 'email'
          msg: 'Please check your email address'
        ]
        password: [
          required: (val, attr, computed) -> not Boolean(computed.id)
          msg: 'Password, please :)'
        ,
          minLength: 6
          msg: 'Must be at least 6 characters'
        ]

    EstimateAddressModel = EstimateAddressModel.extend
      validation: =>
        full_name: @validateFullName
        country_code: required: true
        locality:
          required: true
          msg: 'Please fill in your city'
        postal_code: (value, attr, computed) =>
          # Can't validate zip code for saved addresses
          return if computed.existing_address_id
          if @getLocale('country') is 'CA'
            postalCode = 'postal code'
            regex = /^[A-Z]\d[A-Z][ \-]?\d[A-Z]\d$/
          else
            postalCode = 'zip code'
            regex = /^\d{5}([ \-]\d{4})?$/
          # Zip is missing/empty
          unless value
            _.upperFirst "#{postalCode}, please"
          # Zip doesn't pass regex validator
          else unless regex.test(value)
            "Please fix your #{postalCode}"
        region:
          required: true
          msg: 'Please fill in your state'
        street_address:
          required: true
          msg: 'Please add your street'
        telephone: (value, attr, computed) ->
          # Can't validate phone numbers for saved addresses
          return if computed.existing_address_id
          size = _.size value
          if size is 0
            'Can we get your digits?'
          else if size isnt 12 and size isnt 14
            # Not of the format '555-555-5555' or '1-555-555-5555'
            'Please fix your phone number'

    AccountCustomerModel = AccountCustomerModel.extend
      validation: =>
        full_name: @validateFullName

    EstimatePaymentModel = EstimatePaymentModel.extend
      validation: =>
        cc_number: (val, attr, computed) ->
          # Number not required for saved credit cards
          return if computed.cc_id
          # Number is missing/empty
          unless computed.cc_number
            'Please add your credit card number.'
          # Number is invalid without a cc_type_id
          else unless computed.cc_type_id
            'Invalid card number'
          # Number should be 16 digits (15 for Amex)
          else if (parseInt(computed.cc_type_id) isnt 1 and computed.cc_number.length isnt 16) or
                  (parseInt(computed.cc_type_id) is 1 and computed.cc_number.length isnt 15)
            'Invalid card length'
          # Could do a Luhn check here to make sure the number passes checksum validation

        address_zip: (val, attr, computed) =>
          # Zip not required for saved credit cards
          return if computed.cc_id

          if @getLocale('country') is 'CA'
            postalCode = 'postal code'
            regex = /^[A-Z]\d[A-Z][ \-]?\d[A-Z]\d$/
          else
            postalCode = 'zip code'
            regex = /^\d{5}([ \-]\d{4})?$/

          # Zip is missing/empty
          unless computed.address_zip
            "Please enter your billing #{postalCode}."
          # Zip doesn't pass regex validator
          else unless regex.test(computed.address_zip)
            "Invalid #{postalCode}"

        cc_expires_year: (val, attr, computed) ->
          # Expiration is missing/empty
          unless computed.cc_expires_month and computed.cc_expires_year
            return 'Please enter your card’s expiration date.'

          now = new Date()
          nowYear = now.getFullYear()
          nowMonth = now.getMonth() + 1

          expMonth = +computed.cc_expires_month
          expYear = +computed.cc_expires_year

          if computed.cc_expires_year.length < 4 or expMonth > 12 or expMonth < 1
            'Invalid expiration date'
          else if nowYear > expYear or (nowYear is expYear and nowMonth > expMonth)
            'Expired credit card :-('

        cc_cvv: (val, attr, computed) ->
          # CVV not required for saved credit cards
          return if computed.cc_id
          # CVV should be 3 digits (4 for Amex)
          if parseInt(computed.cc_type_id) is 1 and _.get(computed, 'cc_cvv', '').length isnt 4
            'Please enter the four-digit security code on the front of your card.'
          else if parseInt(computed.cc_type_id) isnt 1 and _.get(computed, 'cc_cvv', '').length isnt 3
            'Please enter the three-digit security code on the back of your card.'

    EstimatePrescriptionCallDoctorModel = EstimatePrescriptionCallDoctorModel.extend
      validation: =>
        'attributes.patient_name': @validateFullName
        'attributes.provider_name':
          required: true
          msg: 'Provider name must be valid.'
        'attributes.provider_phone': (value) ->
          size = _.size value
          if size is 0
            'Provider phone number required.'
          else if size isnt 12 and size isnt 14
            # Not of the format '555-555-5555' or '1-555-555-5555'
            'Provider phone number must be valid.'
        'attributes.region':
          required: true
          msg: 'Please select a state/region.'
        'attributes.patient_birth_date_formatted': (date = '') ->
          # Formatted version.
          # Date comes in MM-DD-YYYY
          parts = date.split '-'
          if parts.length isnt 3
            'Patient birth date must be valid and in MM-DD-YYYY format.'
          else
            [month, day, year] = _.map parts, _.parseInt

            currYear = new Date().getFullYear()
            if year > currYear - 2
              return 'Patient birth date must be at least 2 years in past.'

            monthLengths = [31,28,31,30,31,30,31,31,30,31,30,31]
            if year % 400 is 0 or (year % 100 isnt 0 and year % 4 is 0) # Leap year
              monthLengths[1] = 29

            if year < 1000 or month < 1 or month > 12 or day < 1 or day > monthLengths[month-1]
              'Patient birth date must be valid.'

  validateFullName: (value) ->
    if _.size(value) is 0
      'Please fill in your name'
    else
      split = _.trim(value).replace(/\s+/g, ' ').split ' '
      if _.size(split) < 2
        'Please add your last name'

  storeDidInitialize: ->
    @updatePageTitle(@store.steps)

  wake: ->
    if not @requestDispatcher('cookies', 'get', 'estimate_id')
      # If we don't have an estimate cookie, redirect to /checkout
      @navigate '/checkout'
      return

    if not @model('estimate').isFetched()
      # If we fetch from the browser, we need to reset the store.
      @command 'fetchEstimate',
        modal: true
        success: @handleFetchEstimateSuccess.bind @
        error: @handleFetchEstimateError.bind @
    else
      @replaceStore @buildStoreData()
      @updateCheckoutSteps()
      @validateInitialData()

  sessionModels: [
    'prescription'
    'prescriptionCallDoctor'
    'prescriptionExisting'
    'prescriptionNonRx'
    'prescriptionReaders'
    'prescriptionSendLater'
    'prescriptionUploaded'
    'payment'
  ]

  sessionPrefix: ->
    "estimate-#{@model('estimate').get('id')}"

  backboneDidInitialize: ->
    @initializeInformationModels()

    prefix = @sessionPrefix()

    @model(key).sessionStart(
      prefix: prefix
      name: key
      ttl:  2 * 24 * 60 * 60 * 1000  # 48 hours.
    ) for key in @sessionModels

  initializeInformationModels: ->
    log 'initializeInformationModels'

    @model('customer').set(@getInitialCustomer())
    @model('address').set(@getInitialAddress())
    @model('payment').set(@getInitialPayment())

    if @environment.browser
      if @isRecognizedAmexUser() and not @model('estimate').get('is_authenticated')
        @model('login').set(email: @model('customer').get('email'))

      if @isAmexPayment()
        @commandDispatcher 'checkout', 'showNotification',
          text: 'We’ve autofilled your account with your Amex payment details.'

      if @isNamelessUser()
        @model('accountCustomer').set('email', @model('customer').get('email'))
      else if @model('estimate').get('is_authenticated')
        @model('accountCustomer').set(@getInitialCustomer())

    if @inExperiment('onePageNonRxSunCheckout', 'one_page') and
        _.isEmpty(@model('address').validate())
      @doSaveInformationModel 'address', true

  getInitialCustomer: ->
    _.get @data('estimate'), 'customer', {}

  getInitialAddress: ->
    estimate = @data 'estimate'

    name = _.pick _.get(estimate, 'customer', {}), 'first_name', 'last_name'

    address = if _.get estimate, 'addresses[0]'
      # Use first address on estimate if available.
      _.get estimate, 'addresses[0]'

    else if estimate.is_authenticated
      # Otherwise use first saved address available.
      account = _.get @getStore('checkout'), 'account'
      address = _.get account, 'addresses[0]', {}
      if not _.isEmpty(address)
        _.assign address, existing_address_id: address.id
      address

    else
      {}

    _.defaults address, country_code: @getLocale 'country'

    _.assign name, address

  getInitialPayment: ->
    estimate = @data 'estimate'

    if @isAmexPayment()
      amexPayment = _.get estimate, 'amex_payment'
      _.assign amexPayment, cc_type_id: 1

    else if _.get estimate, 'payments[0]'
      # Use first payment on estimate if available.
      _.get estimate, 'payments[0]'

    else if estimate.is_authenticated
      # Use first saved payment available.
      account = _.get @getStore('checkout'), 'account'
      accountPayment = _.get account, 'payments[0]'
      if accountPayment
        _.assign accountPayment, payment_type: 'saved_credit_card'
      else
        {}

    else
      {}

  isAmexPayment: ->
    amexPayment = @model('estimate').get 'amex_payment'
    amexPayment and _.every amexPayment

  isRecognizedAmexUser: ->
    @isAmexPayment() and @model('customer').get 'id'

  isNamelessUser: ->
    customer = @model 'customer'

    @model('estimate').get('is_authenticated') and
      (not customer.get('first_name') or
      not customer.get('last_name'))

  handleFetchEstimateSuccess: ->
    @initializeInformationModels()
    @modals success: 'fetchEstimate'

  handleFetchEstimateError: -> @navigate '/checkout'

  getInitialStore: -> @buildStoreData()

  buildStoreData: ->
    estimateData = @data('estimate')
    prescriptions = _.get(estimateData, 'prescriptions', [])

    _.assign estimateData,
      __fetched: @model('estimate').isFetched()
      is_expedited_shipping_available: @isExpeditedShippingAvailable()
      paymentData: _.mapValues @data('payment', onlyPermitted: false), (value) ->
        if _.isNumber(value)
          "#{value}"
        else
          value
      prescriptions: _.map prescriptions, @mapPrescriptionFormat.bind(@)
      steps: @getSteps()
      is_nameless_user: @isNamelessUser()

  getStepIndex: (stepName) ->
    _.findIndex @getSteps(), (step) -> _.snakeCase(step.title) is _.snakeCase(stepName)

  getSteps: ->
    estimateData = @data('estimate')

    steps = [
      title: 'Login'
      complete: true
      indicated: false
      route: '/checkout/login'
    ,
      title: 'Information'
      complete: _.some(estimateData.addresses) and
        _.some(estimateData.customer)
      indicated: true
      route: '/checkout/step/information'
    ,
      title: 'Prescription'
      complete: _.some(estimateData.prescriptions)
      indicated: @isPrescriptionStepRequired()
      route: '/checkout/step/prescription'
    ,
      title: 'Review'
      complete: false
      indicated: true
      route: '/checkout/step/review'
    ,
      title: 'Confirmation'
      complete: false
      indicated: false
      route: '/checkout/confirmation'
    ]

    currentPath = @currentLocation().pathname
    prevComplete = true

    steps = _.map steps, (step, index) ->
      step.active = true if _.startsWith currentPath, step.route
      step.enabled = prevComplete
      prevComplete = step.complete or (prevComplete and not step.indicated)

      step

    steps

  mapPrescriptionFormat: (prescription, index) ->
    # Push formatted birth date down to component.
    birthdate = _.get prescription, 'attributes.patient_birth_date'

    if birthdate
      _.merge prescription, attributes:
        patient_birth_date_formatted: @changeDateFormat birthdate

    prescription

  changeDateFormat: (date, options) ->
    formattedArr = date.split('-')
    if _.get options, 'toISO', false
      formattedArr.unshift formattedArr.pop() # MM-DD-YYYY -> YYYY-MM-DD.
    else
      formattedArr.push formattedArr.shift() # YYYY-MM-DD -> MM-DD-YYYY.

    formattedArr.join '-'

  handleStripeStoreChange: (store) ->
    if not store.isAvailable and not store.isLoading
      @modals error: 'fetchStripe'

    if _.isEmpty store.errors
      @replaceStore paymentErrors: {}
    else
      @replaceStore paymentErrors: store.errors
      @handleSaveInformationError()

    @markState 'payment', saving: false

  markState: (endpoint, attrs) ->
    attrs = _.mapKeys attrs, (val, key) -> _.camelCase("#{endpoint}-#{key}")
    @model('state').set(attrs)

  isSaving: (endpoint) ->
    @model('state').get "#{endpoint}Saving"

  shouldSave: (endpoint) ->
    @model('state').get "#{endpoint}ShouldSave"

  isExpeditedShippingAvailable: ->
    if @model('estimate').isFetched()
      @model('estimate').get('is_expedited_shipping_available')
    else
      false

  allInformationModelsValid: ->
    informationModels =
      if @isRecognizedAmexUser() and not @model('estimate').get('is_authenticated')
        _.without @informationModels, 'customer'
      else
        @informationModels

    _.reduce informationModels, (acc, name) =>
      acc and
        _.isEmpty(@store["#{name}Errors"]) and
        @isSaving(name) is false and
        @shouldSave(name) is false
    , true

  onEstimateSync: ->
    @replaceStore @buildStoreData()

  onInformationModelSuccess: (endpoint, liveUpdate, model, xhr, options) ->
    @replaceStore "#{endpoint}Errors": {}
    if not liveUpdate
      @pushEvent "checkout-save-#{_.camelCase endpoint}-success"
    @markState endpoint, saving: false, shouldSave: false

    if liveUpdate
      @command 'fetchEstimate'
    else
      @saveNextInformationModel()

  onInformationModelError: (endpoint, model, xhr, options) ->
    if not @isInactiveError xhr.status
      errors = @parseApiError(xhr.response)
      @handleSaveInformationError()
      @pushEvent "checkout-save-#{_.camelCase endpoint}-error"

      if endpoint is 'customer' and xhr.status is 403
        @replaceStore customerErrors: accountRecognized: true
        errors.password = errors.generic
      else
        @replaceStore "#{endpoint}Errors": errors

      @setFieldErrors endpoint, _.omit errors, 'generic'

      @stopSavingInformationModels()
      @markState endpoint, saving: false

  showModelErrors: (name, errors) ->
    @replaceStore "#{name}Errors": Backbone.Labels.format(errors)
    @handleSaveInformationError()

  shouldSkipInformationModelSave: (name) ->
    switch name
      when 'customer'
        # Don't bother updating customer data we already have on the estimate.
        @model('estimate').get('is_authenticated')
      when 'payment'
        # Do nothing if we're using a saved payment.
        @model(name).get('cc_id') or @isAmexPayment()

  didSaveInformation: ->
    @replaceStore(
      addressErrors: {}
      customerErrors: {}
      paymentErrors: {}
    )

    @command 'fetchEstimate',
      success: @handleSaveInformationSuccess.bind @
      error: @handleSaveInformationError.bind @

  isPrescriptionStepRequired: ->
    @model('estimate').get('prescription_required')

  handleSaveInformationSuccess: ->
    if @skipReview
      @commands.submitOrder.call @
    else
      @modals success: 'saveInformation'
      @pushEvent 'checkout-complete-informationStep'

      if @isPrescriptionStepRequired()
        @navigate '/checkout/step/prescription'
      else
        @navigate '/checkout/step/review'

  handleSaveInformationError: ->
    if @skipReview
      @modals error: 'submitOrder'
    else
      @modals error: 'saveInformation'

  stripeKeyMap:
    cc_cvv:           'cvc'
    cc_expires_month: 'exp_month'
    cc_expires_year:  'exp_year'
    cc_number:        'number'
    address_zip:      'address_zip'

  formatPaymentForStripe: (data) ->
    formatted = _.reduce data, (acc, value, key) =>
      stripeKey = _.get @stripeKeyMap, key
      acc[stripeKey] = value if stripeKey
      acc
    , {}

  handleInformationModelChange: ->
    if @allInformationModelsValid()
      @didSaveInformation()
    else
      @saveNextInformationModel()

  handleAnalyticsStoreChange: ->
    @updateCheckoutSteps()

  updateCheckoutSteps: ->
    analyticsStore = @getStore('analytics')

    currentStep = _.get analyticsStore, 'checkout.currentStep'
    previousStep = _.get analyticsStore, 'checkout.previousStep'

    return unless currentStep

    stepIndex = @getStepIndex currentStep

    if stepIndex? and stepIndex > -1 and (
        previousStep isnt @store.previousStep or
        currentStep isnt @store.currentStep
      )
      estimate = @data('estimate')
      account = _.get @getStore('checkout'), 'account'
      checkoutState =
        creditCardRequired: estimate.cc_required
        hasAddress: _.size(estimate.addresses) > 0
        hasCreditCardPayment: _.size(estimate.payment) > 0
        hasGiftCardPayment: _.size(estimate.gift_cards) > 0
        hasHTO: estimate.has_hto
        hasOptical: estimate.has_optical
        hasPrescription: _.size(estimate.prescriptions) > 0
        hasProgressives: estimate.has_progressives
        hasSun: estimate.has_sun
        isAmexCheckout: @isAmexPayment()
        isAuthenticated: estimate.is_authenticated
        isHTOOnly: estimate.is_hto_only
        isPrescriptionRequired: estimate.prescription_required
        isShippingRequired: estimate.shipping_required
        isSunOnly: estimate.is_sun_only
        nonRxEligible: estimate.non_rx_eligible
        promoCodeCount: _.size estimate.promo_codes
        savedAddressCount: _.size account.addresses
        savedPaymentCount: _.size account.payments
        savedPrescriptionCount: _.size account.prescriptions

      @commandDispatcher 'analytics', 'pushCheckoutEvent',
        type: 'checkout'
        checkoutState: checkoutState
        checkoutMetadata:
          # GTM's step numbering uses a 1-based index
          step: stepIndex + 1
        estimate: estimate

    @setStore currentStep: currentStep, previousStep: previousStep

  updatePageTitle: (steps) ->
    title = 'Checkout'
    _.each steps, (step) ->
      if step.active
        title += " #{step.title}"
        false
    @setPageTitle /^\/checkout\/(step|login)\/.*$/, title

  locationDidChange: ->
    steps = @getSteps()
    @updatePageTitle(steps)
    @replaceStore steps: steps, orderErrors: {}

  scheduleSaveInformationModel: (name) -> @markState name, shouldSave: true

  unscheduleSaveInformationModel: (name) -> @markState name, shouldSave: false

  saveNextInformationModel: ->
    _.each @informationModels, (name) =>
      if @isSaving(name)
        # Another model is already saving, just exit the loop.
        false
      else if @shouldSave(name)
        @doSaveInformationModel name
        false

  stopSavingInformationModels: ->
    _.each @informationModels, @unscheduleSaveInformationModel.bind(@)

  doSaveInformationModel: (name, liveUpdate) ->
    state = @model 'state'
    model = @model name

    # Set a mid-save flag to track the completion of all models.
    @markState name, saving: true, shouldSave: false
    state.once "change:#{name}Saving", @handleInformationModelChange, @

    if not liveUpdate
      @pushEvent "checkout-save-#{_.camelCase name}-triggered"
      # Reset errors from previous save attempts.
      @replaceStore "#{name}Errors": {}

    if name is 'payment' and not @model('estimate').get('cc_required')
      # Skip this for payment if we don't need a credit card.
      state.set(paymentSaving: false, paymentShouldSave: false)
      return

    if name is 'customer' and @isNamelessUser()
      state.set(customerSaving: false, customerShouldSave: false)
      return

    # Get errors against the model validation rules.
    errors = model.validate()

    if errors
      @stopSavingInformationModels()
      @showModelErrors name, errors
      @pushEvent "checkout-save-#{_.camelCase name}-error"
      @markState name, saving: false
    else
      if @shouldSkipInformationModelSave name
        @markState name, saving: false
      else if name is 'payment'
        # Get a Stripe token with the payment instead of saving to the server.
        @commandDispatcher 'stripe', 'tokenize',
          @formatPaymentForStripe @data('payment', onlyPermitted: false)
      else
        model.save(
          null,
          type: 'POST'
          wait: true
          success: @onInformationModelSuccess.bind(@, name, liveUpdate)
          error: @onInformationModelError.bind(@, name)
        )

  saveInformationLoginModel: ->
    login = @model 'login'
    login.url = login.apiBaseUrl 'estimate/login'

    errors = login.validate()
    if errors
      @replaceStore loginErrors: errors
      @handleSaveInformationError()
    else
      login.save(
        null,
        type: 'POST'
        success: @onInformationLoginModelSuccess.bind @
        error: @onInformationLoginModelError.bind @
      )

  onInformationLoginModelSuccess: ->
    @replaceStore loginErrors: {}
    _.each _.without(@informationModels, 'customer'),
      @scheduleSaveInformationModel.bind(@)
    @saveNextInformationModel()

  onInformationLoginModelError: (model, xhr, options) ->
    if not @isInactiveError xhr.status
      @handleSaveInformationError()
      @replaceStore loginErrors: @parseApiError xhr.response

  saveInformationAccountCustomerModel: ->
    accountCustomer = @model 'accountCustomer'

    errors = accountCustomer.validate()
    if errors
      @replaceStore accountCustomerErrors: errors
      @handleSaveInformationError()
    else
      accountCustomer.save(
        null,
        type: 'PUT'
        success: @handleAccountCustomerSuccess.bind(@)
        error: @handleAccountCustomerError.bind(@)
      )

  handleAccountCustomerSuccess: ->
    @replaceStore accountCustomerErrors: {}
    _.each _.without(@informationModels, 'customer'),
      @scheduleSaveInformationModel.bind(@)
    @saveNextInformationModel()

  handleAccountCustomerError: (model, xhr, options) ->
    if not @isInactiveError xhr.status
      @handleSaveInformationError()
      @replaceStore accountCustomerErrors: @parseApiError xhr.response

  handleDiscountSuccess: (model, xhr, options) ->
    @setStore discountError: {}
    @pushEvent 'checkout-save-discount-success'
    @command 'fetchEstimate', success: @setInformationStatus.bind(@)

  handleDiscountError: (model, xhr, options) ->
    if not @isInactiveError xhr.status
      @pushEvent 'checkout-save-discount-error'
      @setStore discountError: @parseApiError(xhr.response)

  getNotification: (model) ->
    route: '/checkout/step/prescription'
    text:
      switch model
        when 'prescriptionCallDoctor'
          'Great! We’ll reach out to your doctor for your prescription.'
        when 'prescriptionExisting'
          'Thanks for your prescription!'
        when 'prescriptionSendLater'
          'Great! You’ll send us your prescription later.'
        when 'prescriptionUploaded'
          'Thanks for your prescription photo!'
        when 'prescriptionNonRx'
          'Got it! No prescription for these frames.'
        when 'prescriptionReaders'
          'Great! Reading glasses it is.'
        else
          'Thanks for your prescription!'

  # Prescription Handlers

  onPrescriptionSuccess: (model, xhr, options) ->
    @replaceStore prescriptionErrors: {}
    @command 'fetchEstimate'
    @pushEvent 'checkout-save-prescription-success'
    @pushEvent "checkout-save-choice#{_.upperFirst @model('prescription').get('type')}-success"
    @modals success: @model('prescription').get('modal')

    if model.get('__navigate')
      @pushEvent 'checkout-complete-prescriptionStep'
      @navigate '/checkout/step/review'

  onPrescriptionError: (model, xhr, options) ->
    if not @isInactiveError xhr.status
      @modals error: @model('prescription').get('modal')
      @pushEvent 'checkout-save-prescription-error'
      @pushEvent "checkout-save-choice#{_.upperFirst @model('prescription').get('type')}-error"
      @replaceStore prescriptionErrors: @parseApiError(xhr.response)

  onUploadSuccess: (model, xhr, options) ->
    @modals success: 'uploadPrescription'
    @replaceStore prescriptionErrors: {}
    @pushEvent 'checkout-upload-prescription-success'

    @commands.savePrescription.call @,
      __modelName: 'prescriptionUploaded'
      attributes:
        name: model.get 'filename'
        blob_id: model.get 'blob_id'

  onUploadError: (model, xhr, options) ->
    if not @isInactiveError xhr.status
      @modals error: 'uploadPrescription'
      @pushEvent 'checkout-upload-prescription-error'
      @replaceStore prescriptionErrors: @parseApiError(xhr.response)

  # Callbacks on order placement
  handleOrderSuccess: (model, xhr, options) ->
    completedOrderIds = model.get('order_ids') or []
    # Clear estimate localStorage.
    @model(key).sessionClear() for key in @sessionModels
    @pushEvent 'checkout-place-order-success'
    @pushEvent 'checkout-complete-reviewStep'
    @commandDispatcher 'cookies', 'leaveHtoMode', 'placeOrder'
    # Ensure the header state is fresh, as cart should have 0 items and user
    # should be logged-in now.
    @commandDispatcher 'session', 'reload', =>
      @navigate "/checkout/confirmation?orders=#{completedOrderIds.join(',')}"
      @commandDispatcher 'postCheckout', 'setEstimate', model.get('analytics')

  getOrderLeadTimeCategory: ->
    FALLBACK_CATEGORY = 14
    categories = _.uniq(@model('estimate').get('order_lead_time_categories') or [FALLBACK_CATEGORY])
    if categories.length is 1
      _.head categories
    else
      FALLBACK_CATEGORY

  getRxUploadQueryString: ->
    if @model('prescription').get('type') is 'prescriptionSendLater'
        '&showRxUpload=true'
    else
      ''

  handleOrderError: (model, xhr, options) ->
    if not @isInactiveError xhr.status
      errors = @parseApiError(xhr.response)
      @modals error: 'submitOrder'
      @pushEvent 'checkout-place-order-error'
      @setStore orderErrors: errors
      @commandDispatcher 'checkout', 'showNotification',
        text: 'Sorry, there was a problem placing your order.
          Please try again, or call us at 888.492.7297.'

      @pushValidationErrorEvent 'estimate', errors, 'backend'
      # Update fields for payment declined errors
      message = _.get errors, 'generic', ''
      if message.indexOf('Invalid payment data') > -1
        field =
          if message.indexOf('security code') > -1
            'cc_cvv'
          else if message.indexOf('expired') > -1
            'cc_expires_year'
          else
            'cc_number'
        @setFieldErrors 'payment', "#{field}": message

  isInactiveError: (status) ->
    if status is 409
      @navigate '/cart'
      return true
    else
      return false

  splitFullName: (name) ->
    split = _.trim(name).replace(/\s+/g, ' ').split ' '

    full_name: name
    first_name: split[0]
    last_name: split.slice(1).join ' '

  setFieldErrors: (name, errors) ->
    prevValidated = _.assign {}, @store.validatedFields
    prevValidated[name] = {} unless prevValidated[name]
    prevErrors = _.assign {}, @store.errors
    prevErrors[name] = {} unless prevErrors[name]

    prevValidated[name] = _.omit prevValidated[name], _.keysIn errors
    prevErrors[name] = _.assign prevErrors[name], errors

    @replaceStore
      errors: prevErrors
      validatedFields: prevValidated
      informationStepComplete: false

    @pushValidationErrorEvent name, errors, 'backend'

  validateAttributes: (name, attrs) ->
    # If attributes are valid, they are added to `@store.validatedFields`
    #   eg: {'customer': {'email': true}}
    # If attributes have errors, they are added to `@store.errors`
    #   eg: {'customer': {'email': 'error message'}}

    prevValidated = _.assign {}, @store.validatedFields
    prevValidated[name] = {} unless prevValidated[name]
    prevErrors = _.assign {}, @store.errors
    prevErrors[name] = {} unless prevErrors[name]

    model = @model(name)
    fields = _.keysIn attrs

    errors = model.validate()
    errors = _.pick errors, fields

    errorFields = _.keysIn errors
    validatedFields = _.difference fields, errorFields

    # Prescription attributes are nested under `attributes`
    if errorFields.length
      splitFields = errorFields[0].split '.'
      if splitFields[0] is 'attributes'
        # _.unset would solve this if we were on 4.0.0+
        prevValidated[name] =
          _.extend _.omit(prevValidated[name], 'attributes'),
            attributes: _.omit prevValidated[name].attributes, splitFields[1]
      else
        prevValidated[name] = _.omit prevValidated[name], errorFields
    validated = _.zipObject validatedFields, _.map(fields, -> true)
    _.assign prevValidated[name], validated

    if validatedFields.length
      splitFields = validatedFields[0].split '.'
      if splitFields[0] is 'attributes'
        prevErrors[name] =
          _.extend _.omit(prevErrors[name], 'attributes'),
            attributes: _.omit prevErrors[name].attributes, splitFields[1]
      else
        prevErrors[name] = _.omit prevErrors[name], validatedFields
    _.assign prevErrors[name], errors

    @replaceStore
      errors: prevErrors
      validatedFields: prevValidated
      "#{name}Errors": {} # Reset legacy/backend errors as well

    @pushValidationErrorEvent name, errors, 'inline'

  pushValidationErrorEvent: (name, errors, trigger) ->
    _.map errors, (value, key) =>
      @commandDispatcher 'analytics', 'pushFieldValidationEvent',
        form: 'checkout'
        section: name
        field: key
        error: value
        trigger: trigger

  validateInitialData: ->
    validatedFields = _.assign {}, @store.validatedFields

    @setPaymentZipFromAddress()

    _.map @informationModels, (name) =>
      name = 'accountCustomer' if name is 'customer' and @isNamelessUser()
      model = @model name
      attr = _.mapValues model.attributes, -> true

      errors = model.validate()
      errorAttr = _.keysIn errors

      validatedFields[name] = _.omit attr, errorAttr

    @replaceStore validatedFields: validatedFields
    @setInformationStatus()

  setPaymentZipFromAddress: ->
    addressZip = @model('address').get('postal_code')
    paymentZip = @model('payment').get('address_zip')
    if addressZip and not paymentZip
      @model('payment').set('address_zip', addressZip)
      paymentData = _.assign {}, @store.paymentData
      paymentData.address_zip = addressZip
      @replaceStore paymentData: paymentData

  clearValidation: (name) ->
    prevValidated = _.assign {}, @store.validatedFields
    prevValidated[name] = {}
    prevErrors = _.assign {}, @store.errors
    prevErrors[name] = {}

    @replaceStore
      errors: prevErrors
      validatedFields: prevValidated
      informationStepComplete: false

  setInformationStatus: ->
    # Don't validate payment if it's not required
    models = _.without @informationModels,
      unless @model('estimate').get('cc_required') then 'payment'

    isComplete = _.reduce models, (acc, name) =>
      name = 'accountCustomer' if name is 'customer' and @isNamelessUser()
      model = @model name
      errors = model.validate()
      acc and _.isEmpty errors
    , true

    @replaceStore informationStepComplete: isComplete

  setModelStatus: (name) ->
    errors = @model(name).validate()
    @replaceStore "#{name}Complete": _.isEmpty errors


  commands:
    fetchEstimate: (options = {}) ->
      _.defaults options, modal: false, type: 'POST'
      @modals loading: 'fetchEstimate' if options.modal
      @model('estimate').fetch(_.pick options, ['error', 'type', 'success'])

    clearInformation: (name) ->
      @model(name).clear()
      @clearValidation name

    updateInformation: (name, attrs) ->
      @model(name).set(_.assign(@data(name), attrs))

    validateInformation: (name, attrs) ->
      model = @model(name)

      if attrs['full_name']
        model.set(_.assign @data(name), attrs, @splitFullName(attrs['full_name']))
        # Update the store for customer name, to allow for autofill of address name
        if name is 'customer' or 'accountCustomer'
          @replaceStore 'customer.full_name': attrs['full_name']
      else
        model.set(_.assign @data(name), attrs)

      @setPaymentZipFromAddress() if attrs['postal_code']

      @validateAttributes name, attrs

      if name is 'prescriptionCallDoctor'
        @setModelStatus name
      else
        @setInformationStatus()

      if name is 'address' and
          @inExperiment('onePageNonRxSunCheckout', 'one_page') and
          _.isEmpty(model.validate())
        @doSaveInformationModel 'address', true

    validateInformationForm: ->
      # Set the error/valid states for all fields at the same time
      validatedFields = {}
      errorFields = {}

      _.map @informationModels, (name) =>
        name = 'accountCustomer' if name is 'customer' and @isNamelessUser()
        model = @model name
        attr = _.mapValues model.attributes, -> true

        errors = model.validate()
        errorAttr = _.keysIn errors

        validatedFields[name] = _.omit attr, errorAttr
        errorFields[name] = errors

        @pushValidationErrorEvent name, errors, 'form'

      @replaceStore
        validatedFields: validatedFields
        errors: errorFields

    validateModelForm: (name) ->
      validatedFields = _.assign {}, @store.validatedFields
      errorFields = _.assign {}, @store.errors

      model = @model name
      attr = _.mapValues model.attributes, -> true
      errors = model.validate()
      errorAttr = _.keysIn errors

      validatedFields[name] = _.omit attr, errorAttr
      errorFields[name] = errors

      @pushValidationErrorEvent name, errors, 'form'

      @replaceStore
        validatedFields: validatedFields
        errors: errorFields

    saveInformation: ->
      if @skipReview
        return if @modals isShowing: 'submitOrder'
        @modals loading: 'submitOrder'
        @pushEvent 'checkout-place-order-triggered'
      else
        return if @modals isShowing: 'saveInformation'
        @modals loading: 'saveInformation'
        @pushEvent 'checkout-save-information-triggered'

      if @isRecognizedAmexUser() and not @model('estimate').get('is_authenticated')
        # We recognize this Amex user by their email.
        @saveInformationLoginModel()

      else if @isNamelessUser()
        @saveInformationAccountCustomerModel()

      else
        _.each @informationModels, @scheduleSaveInformationModel.bind(@)
        @saveNextInformationModel()

    saveInformationAndSubmitOrder: ->
      @skipReview = true
      @commands.saveInformation.call @

    saveSmsOptIn: (value) ->
      name = if @model('estimate').get('is_authenticated') then 'accountCustomer' else 'customer'
      @model(name).set(sms_opt_in: value)

      # If we won't be saving the customer model later, save it now
      if name is 'accountCustomer' and not @isNamelessUser()
        @model(name).save(
          null,
          type: 'PUT'
        )

    applyDiscount: (code) ->
      @pushEvent 'checkout-save-discount-triggered'
      @model('discount').save code: code.toLowerCase(),
        type: 'POST'
        wait: true
        success: @handleDiscountSuccess.bind(@)
        error: @handleDiscountError.bind(@)

    removeDiscount: (code) ->
      @model('discount').set(code: code.toLowerCase())
      @pushEvent 'checkout-destroy-discount-triggered'
      @model('discount').destroy(
        success: @handleDiscountSuccess.bind(@)
        error: @handleDiscountError.bind(@)
      )

    updateShipping: (useExpeditedShipping = false) ->
      @model('shipping').set(use_expedited_shipping: useExpeditedShipping)

      action = if useExpeditedShipping then 'on' else 'off'
      @pushEvent "checkout-click-expeditedShipping-#{action}"

      estimate = @model 'estimate'
      expedited_shipping_cost = estimate.get 'shipping_methods.expedited.method_cost'
      standard_shipping_cost = estimate.get 'shipping_methods.standard.method_cost'
      totals = _.clone estimate.get('totals')

      # We are assuming only two types of shipping variants here:
      # <standard or expedited>
      # Note: Expanding beyond these 2 possible variants will require
      # more robust logic
      if useExpeditedShipping
        totals.shipping_cents = expedited_shipping_cost
      else
        # We assume that standard shipping is the other option
        totals.shipping_cents = standard_shipping_cost

      # Recalculate total, based on estimate.py calculation.
      totals.total_cents = totals.subtotal_cents - totals.discount_cents +
        totals.tax_cents + totals.shipping_cents
      totals.balance_cents = totals.total_cents

      estimate.set(totals: totals)
      @setStore totals: totals

    savePrescription: (attrs = {}) ->
      # Set prescription type and modal.
      @model('prescription').set(type: attrs.__modelName) if attrs.__modelName
      @model('prescription').set(modal: attrs.__modalName) if attrs.__modalName

      modalName = @model('prescription').get('modal')
      return if @modals isShowing: modalName

      type = @model('prescription').get('type')
      unless type
        @replaceStore prescriptionErrors: generic: 'Please select one.'
        @navigate '/checkout/step/prescription'
        return

      @pushEvent 'checkout-save-prescription-triggered'
      @pushEvent "checkout-save-choice#{_.upperFirst type}-triggered"

      # Fix formatting on birth date.
      if _.get attrs, 'attributes.patient_birth_date_formatted', false
        attrs.attributes.patient_birth_date =
          @changeDateFormat attrs.attributes.patient_birth_date_formatted,
            toISO: true

      @model(type).set(attrs)
      errors = @model(type).validate()

      if errors
        @replaceStore prescriptionErrors: errors
        @pushEvent "checkout-save-prescription-error"
        @commandDispatcher 'checkout', 'clearNotification'
      else
        if _.isBoolean attrs.use_high_index
          # Save if on use_high_index is given.

          selection_action = _.get attrs, 'lens_selection_action', 'save'

          if attrs.use_high_index
            @pushEvent "checkout-#{selection_action}-choicePrescriptionHighIndexYes-triggered"
          else
            @pushEvent "checkout-#{selection_action}-choicePrescriptionHighIndexNo-triggered"

        # If the lens selection step is either complete, or not necessary, save the prescription
        if _.isBoolean(attrs.use_high_index) or not @model('estimate').get('can_upgrade_lenses')
          @modals loading: modalName
          @model(type).save(
            null,
            wait: true
            validate: false
            success: @onPrescriptionSuccess.bind(@)
            error: @onPrescriptionError.bind(@)
          )
        else
          @replaceStore prescriptionErrors: {}
          @commandDispatcher 'checkout', 'showNotification',
            @getNotification type
          @navigate '/checkout/step/prescription/lens'

    uploadPrescription: (data = {}) ->
      return if @modals isShowing: 'uploadPrescription'
      @pushEvent 'checkout-upload-prescription-triggered'
      @modals loading: 'uploadPrescription'

      uploadModel = @model('imageUpload')
      uploadModel.save(
        null,
        data: data
        wait: true
        validate: false
        success: @onUploadSuccess.bind(@)
        error: @onUploadError.bind(@)
      )

    submitOrder: ->
      if not @skipReview
        return if @modals isShowing: 'submitOrder'
        @modals loading: 'submitOrder'
        @pushEvent 'checkout-place-order-triggered'
      estimate = @data 'estimate'
      payment = @data 'payment'
      gift_cards = {'gift_cards': _.get(@data('estimate'), 'gift_cards', [])}

      if @isAmexPayment()
        token = _.get estimate, 'amex_payment.cc_token'
        payment = _.assign payment, estimate.amex_payment
      else
        token = @requestDispatcher 'stripe', 'token',
          last4: payment.cc_last_four
          exp_month: payment.cc_expires_month
          exp_year: payment.cc_expires_year

      @model('order').save _.assign({}, payment, gift_cards, cc_token: token),
        type: 'POST'
        success: @handleOrderSuccess.bind(@)
        error: @handleOrderError.bind(@)

module.exports = EstimateDispatcher
