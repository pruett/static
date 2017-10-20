# This mixin injects products from `__data` into a `callouts.frames`.
# This is used in conjuction with the curated page schema.
_ = require 'lodash'

module.exports =
  mergeProductData: (productsData, callout) ->
    # Attach injected data and set class_key if non-eyewear.
    products = []
    product = productsData[callout.product_id]
    products.push(product) if product?

    unless _.isEmpty callout.grouped_ids
      for product_id in callout.grouped_ids
        if productsData[product_id]?
          products.push productsData[product_id]

    callout.product = products[0]
    callout.products = products
    callout.class_key = product.class_key if product?.class_key
    callout

  mergeProductsIntoContent: (content) ->
    return if _.isEmpty content
    promos = _.get content, 'callouts.promos', []
    frames = _.get content, 'callouts.frames', []

    productsData = _.get content, '__data.products', {}
    products = _.map frames, @mergeProductData.bind(@, productsData)

    # Override callouts key with sorted/merged/injected version.
    # TODO: Use separate key instead of overriding data.
    contentSorted = _.omit content, '__data'
    contentSorted.callouts = _.sortBy products.concat(promos), 'position'
    contentSorted
