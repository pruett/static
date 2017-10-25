[
  _

  Logger
  Backbone
  BaseDispatcher
  AccountModel
  AddressModel
  CustomerModel
  AddressCollection
] = [
  require 'lodash'

  require '../logger'
  require '../backbone/backbone'
  require './base_dispatcher'
  require '../backbone/models/account_model'
  require '../backbone/models/address_model'
  require '../backbone/models/customer_model'
  require '../backbone/collections/address_collection'
]

class PasswordModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('account/customer/password')

  isNew: -> false

  permittedAttributes: -> [
    'current_password'
    'new_password'
  ]

  validation: ->
    current_password:
      required: true
    new_password:
      required: true
      minLength: 6

class AccountDispatcher extends BaseDispatcher
  log = Logger.get('AccountDispatcher').log

  channel: -> 'account'

  mixins: -> [
    'api'
    'modals'
  ]

  collections: ->
    addresses: { class: AddressCollection }

  models: ->
    account: { class: AccountModel, fetchOnWake: { modal: 'fetchAccount' }  }

  events: ->
    'sync account': @onAccountSync
    'change account': @onAccountChange
    'add sort addresses': @onAddressesAddSort
    'remove addresses': @onAddressesRemove

  getStoreChangeHandlers: ->
    session: 'handleSessionStoreChange'

  initialize: -> @updatePageTitle @currentLocation()

  getInitialStore: -> @buildStoreData()

  buildStoreData: ->
    @collection('addresses').reset @data('account').addresses
    account = @data('account')
    addresses = @data('addresses')

    issues = _.reduce account.orders, (accumulator, order) =>
      if order.order_issue?
        accumulator.push
          order_id: order.id
          headline: order.order_issue.cta_headline
          message: order.order_issue.cta_message
          cta: order.order_issue.cta_button
          action: order.order_issue.cta_action
          title: order.order_issue.title
      accumulator
    , []

    _.assign account,
      __fetched: @model('account').isFetched()
      addresses: addresses
      issues: issues
      counts:
        addresses: addresses.length
        bookmarks: account.bookmarks.length
        issues: issues.length
        orders: account.orders.length
        prescriptions: account.prescriptions.length

  onAccountSync: ->
    @modals success: 'fetchAccount'
    @replaceStore @buildStoreData()

  onAccountChange: ->
    @setStore _.omit @data('account'), 'addresses'

  onAddressesAddSort: (address) ->
    @replaceStore addresses: @data('addresses')

  onAddressesRemove: (address) ->
    @modals success: 'destroyAddress'
    @model('account').replace { addresses: @data('addresses') }
    @replaceStore @buildStoreData()

  onAddressSuccess: (address) ->
    @modals success: 'saveAddress'
    @navigate '/account/addresses'
    @collection('addresses').add address, merge: true
    @model('account').set(addresses: @data('addresses'))
    @replaceStore @buildStoreData()
    @resetErrors()

  onAddressError: (model, xhr, options) ->
    errors = @parseApiError(xhr.response)
    @modals error: 'saveAddress'
    @replaceStore addressErrors: errors

  onCustomerSuccess: (customer) ->
    @model('account').set(customer: customer.toJSON())
    @modals success: 'saveCustomer'
    # It's possible a customer's name was changed, so tell the session to
    # refresh to ensure it isn't stale.
    @commandDispatcher 'session', 'reload'
    @resetErrors()

  onCustomerError: (model, xhr, options) ->
    errors = @parseApiError(xhr.response)
    @modals error: 'saveCustomer'
    @replaceStore customerErrors: errors

  onPasswordSuccess: ->
    @modals success: 'savePassword'
    @resetErrors()

  onPasswordError: (model, xhr, options) ->
    errors = @parseApiError(xhr.response)
    @modals error: 'savePassword'
    @replaceStore customerErrors: errors

  resetErrors: ->
    @setStore addressErrors: {}, customerErrors: {}

  updatePageTitle: (location) ->
    if location.route is '/account/orders/{order_id}'
      @setPageTitle(
        /^\/account\/orders\/\d+$/
        "Order no. #{_.get location, 'params.order_id'}"
      )

  locationDidChange: (nextLocation, prevLocation) ->
    # Reset errors after navigation.
    @updatePageTitle(nextLocation)
    @resetErrors()

  handleSessionStoreChange: (store) ->
    unless store.customer
      log 'Customer logged out from another window or tab'
      @navigate '/logout'

  commands:
    saveAddress: (attrs) ->
      return if @modals isShowing: 'saveAddress'

      address = new AddressModel(attrs)
      errors = address.validate()

      if errors
        @replaceStore addressErrors: Backbone.Labels.format(errors, @getLocale('country'))
      else
        return unless @modals loading: 'saveAddress'
        address.save null,
          success: @onAddressSuccess.bind(@)
          error: @onAddressError.bind(@)

    destroyAddress: (attrs) ->
      return if @modals isShowing: 'destroyAddress'
      @navigate '/account/addresses'
      address = @collection('addresses').get(attrs.id)
      address.destroy error: @onAddressError.bind(@), wait: true

    saveCustomer: (attrs) ->
      return if @modals isShowing: 'saveCustomer'

      customer = new CustomerModel(attrs)
      errors = customer.validate()

      if errors
        @replaceStore customerErrors: Backbone.Labels.format(errors, @getLocale('country'))
      else
        @modals loading: 'saveCustomer'
        customer.save null,
          success: @onCustomerSuccess.bind(@)
          error: @onCustomerError.bind(@)

    savePassword: (attrs) ->
      return if @modals isShowing: 'savePassword'

      password = new PasswordModel(attrs)
      errors = password.validate()

      if errors
        @replaceStore customerErrors: Backbone.Labels.format(errors, @getLocale('country'))
      else
        @modals loading: 'savePassword'
        password.save null,
          success: @onPasswordSuccess.bind(@)
          error: @onPasswordError.bind(@)

    refresh: ->
      @model('account').unset('issues', {silent: true})
      @model('account').unset('orders', {silent: true})
      @model('account').fetch()


module.exports = AccountDispatcher
