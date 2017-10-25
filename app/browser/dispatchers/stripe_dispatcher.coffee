[
  _

  Logger
  Backbone
  BaseDispatcher
] = [
  require 'lodash'

  require '../logger'
  require '../../common/backbone/backbone'
  require '../../common/dispatchers/base_dispatcher'
]

class StripeModel extends Backbone.BaseModel
  initialize: ->
    @sessionStart(
      name: 'stripe'
      ttl:  2 * 24 * 60 * 60 * 1000  # 48 hours.
    )

class StripeDispatcher extends BaseDispatcher
  log = Logger.get('StripeDispatcher').log

  channel: -> 'stripe'

  models: ->
    stripe: new StripeModel

  getInitialStore: ->
    isAvailable: false
    isLoading: false
    errors: {}

  getStoreChangeHandlers: ->
    scripts: 'handleScriptsStoreChange'

  wake: ->
    @setStore isLoading: true
    @commandDispatcher 'scripts', 'load',
      name: 'stripe',
      src: _.get @appState, 'config.scripts.stripe'

  handleScriptsStoreChange: (scriptsStore) ->
    return if @store.isAvailable
    if Stripe?
      Stripe.setPublishableKey _.get(@appState, 'locale.stripe_public_key')
      @setStore isAvailable: true, isLoading: false
    else if _.get(scriptsStore, 'stripe.timedOut')
      @setStore isAvailable: false, isLoading: false

  handleTokenize: (status, response) ->
    if response.error
      if response.error.param
        @replaceStore "errors.#{response.error.param}", response.error.message
      else
        @replaceStore 'errors.generic', response.error.message
    else
      cardIdentifier = @getCardIdentifier(response.card)
      @model('stripe').set "#{cardIdentifier}": response
      @setStore errors: {}, tokens: @data('stripe')

  getCardIdentifier: (card) ->
    # Responses from Stripe are added to the @store.responses object and keyed
    # by the card's last4, month, and year like '4242-1-2018'.
    last4 = if card.last4 then card.last4 else "#{card.number}".substr(-4)
    [last4, _.padStart(card.exp_month, 2, '0'), card.exp_year].join('-')

  requests:
    token: (attrs) ->
      # Any responses from Stripe will be available in the store data, but this
      # request will extract it from store data for you.
      #
      # Usage:
      #
      # @requestDispatcher 'stripe', 'token',
      #   number: '4242424242424242'
      #   exp_month: 1
      #   exp_year: 2018
      #   cvc: '123'
      #
      # => "tok_16Rq2cJJr2ygCbQ9Tk4t0cxu"
      @model('stripe').get "#{@getCardIdentifier(attrs)}.id"

  commands:
    tokenize: (attrs) ->
      # Converts credit card information into a Stripe token.
      # https://stripe.com/docs/stripe.js
      #
      # number: card number as a string without any separators, e.g.
      #         '4242424242424242'.
      # exp_month: two digit card's expiration month, e.g. 12.
      # exp_year: four digit card's expiration year, e.g. 2016.
      # cvc: card security code as a string, e.g. '123'.
      #
      # Usage:
      #
      # @commandDispatcher 'stripe', 'tokenize',
      #   number: '4242424242424242'
      #   exp_month: 1
      #   exp_year: 2018
      #   cvc: '123'
      #
      if @store.isAvailable
        @model('stripe').set @getCardIdentifier(attrs), true
        Stripe.card.createToken(
          _.pick attrs, 'number', 'cvc', 'exp_month', 'exp_year'
          @handleTokenize.bind(@)
        )


module.exports = StripeDispatcher
