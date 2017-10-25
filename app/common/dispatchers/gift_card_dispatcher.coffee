[
  _
  Backbone

  BaseDispatcher
  Logger
] = [
  require 'lodash'
  require '../backbone/backbone'

  require './base_dispatcher'
  require '../logger'
]

log = Logger.get('GiftCardDispatcher').log

class GiftCardModel extends Backbone.BaseModel
  url: -> '/api/v2/gift_cards'

  defaults: ->
    list: 'LP_giftcard'
    product_category: 'Gift Card'
    delivery_date: ''
    note: ''
    recipient_name: ''
    recipient_email: ''
    sender_name: ''
    sender_email: ''

  validation: ->
    sender_name: required: true
    recipient_name: required: true

class EGiftCardModel extends GiftCardModel
  validation: ->
    sender_name: required: true
    recipient_name: required: true
    sender_email:
      required: true
      pattern: 'email'
      msg: 'Email address must be valid'
    recipient_email:
      required: true
      pattern: 'email'
      msg: 'Email address must be valid'


class GiftCardProductModel extends Backbone.BaseModel
  idAttribute: 'type'

class GiftCardVariantModel extends Backbone.BaseModel
  idAttribute: 'price_cents'

class GiftCardVariantCollection extends Backbone.BaseCollection
  model: GiftCardVariantModel

class GiftCardsCollection extends Backbone.BaseCollection
  url: -> '/api/v2/gift_cards'

  model: GiftCardProductModel

  parse: (resp) ->
    _.map resp.gift_cards, (product) ->
      product.variants = new GiftCardVariantCollection(product.variants)
      product


class GiftCardDispatcher extends BaseDispatcher
  channel: -> 'giftCard'

  collections: ->
    giftCards:
      class: GiftCardsCollection
      fetchOnWake: true

  events: ->
    'sync giftCards': @onSync

  getInitialStore: -> @buildStoreData()

  buildStoreData: ->
    __fetched: @collection('giftCards').isFetched()
    giftCards: @data('giftCards')
    formErrors: {}

  onSync: -> @replaceStore @buildStoreData()

  onCartItemAddSuccess: (item, xhr, options) ->
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'addToCart'
      products: item.toJSON()
    @navigate item.successRoute if not _.isEmpty item.successRoute

  getGiftCardModel: (product, variant, attrs={}) ->
    type = product.get 'type'
    item = _.defaults attrs,
      product_id: product.get 'id'
      variant_id: variant.get 'id'
      sku: variant.get 'sku'
      name: product.get 'label'
      variant_type:
        _.upperFirst "#{type} Gift Card #{variant.get('price_cents')/100}"

    if type is 'physical'
      # Override values that don't apply to physical GCs
      item.delivery_date = ''
      item.recipient_email = ''
      item.sender_email = ''
      new GiftCardModel(item)
    else
      new EGiftCardModel(item)

  getGiftCardProduct: (attrs) ->
    type = _.get attrs, 'type'
    amount = _.get attrs, 'amount_cents'

    product = @collection('giftCards').get type
    variant = product.get('variants').get(amount) if product

    return null unless variant

    @getGiftCardModel product, variant, attrs

  pushProductImpressions: ->
    products = []
    @collection('giftCards').each (product) =>
      product.get('variants').each (variant) =>
        products.push @getGiftCardModel(product, variant).toJSON()

    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productImpression'
      products: products

  pushProductClick: (type) ->
    products = []
    product = @collection('giftCards').get type
    if product
      product.get('variants').each (variant) =>
        products.push @getGiftCardModel(product, variant).toJSON()

      @commandDispatcher 'analytics', 'pushProductEvent',
        type: 'productClick'
        products: products

  pushProductDetail: (attrs) ->
    product = @getGiftCardProduct attrs
    if product
      @commandDispatcher 'analytics', 'pushProductEvent',
        type: 'productDetail'
        products: product.toJSON()

  commands:
    addToCart: (attrs, successRoute = '/cart') ->
      giftCardModel = @getGiftCardProduct attrs
      if giftCardModel
        errors = giftCardModel.validate()
        if errors
          @replaceStore formErrors: errors
        else
          giftCardModel.successRoute = successRoute
          giftCardModel.save null,
            success: @onCartItemAddSuccess.bind @
      else
        log 'Gift card product/variant not found for attributes: ', attrs

    pushStepImpressions: (step, attrs) ->
      switch step
        when 'hero'
          @pushProductImpressions()
        when 'type'
          @pushProductClick attrs.type
        when 'amount_cents'
          @pushProductDetail _.pick attrs, ['type', 'amount_cents']

module.exports = GiftCardDispatcher
