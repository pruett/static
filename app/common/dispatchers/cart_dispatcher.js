'use strict';
const _ = require('lodash');
const Backbone = require('../backbone/backbone');
const BaseDispatcher = require('./base_dispatcher');
const CartItemsCollection = require('../backbone/collections/cart_items_collection');
const CartItemModel = require('../backbone/models/cart_item_model');
const CartToEstimateModel = require('../backbone/models/cart_to_estimate_model');

class CartDispatcher extends BaseDispatcher {
  channel() {
    return 'cart';
  }

  mixins() {
    return ['modals'];
  }

  events() {
    return {
      'sync cartItems': this.onCartItemsSync
    };
  }

  collections() {
    return {
      cartItems: {
        class: CartItemsCollection,
        fetchOnWake: this.currentLocation().pathname === '/cart' || this.isHtoDrawerRoute()
      }
    };
  }

  getInitialStore() {
    return this.buildStoreData();
  }

  buildStoreData() {
    const cartItemsCollection = this.collection('cartItems');
    const htoQuantity = cartItemsCollection.htoCount();

    if (htoQuantity && htoQuantity === cartItemsCollection.length) {
      this.commandDispatcher('experiments', 'bucket', 'cartHtoMessaging');
    }

    return {
      __fetched: cartItemsCollection.isFetched(),
      hasMultipleFits: cartItemsCollection.hasMultipleFits(),
      hasRx: cartItemsCollection.hasRx(),
      htoDrawerEnabled: this.isHtoDrawerRoute(),
      htoLimit: cartItemsCollection.HTO_LIMIT,
      htoQuantity,
      items: this.data('cartItems'),
      lastGalleryUrl: cartItemsCollection.lastGalleryUrl(),
      lastProductUrl: cartItemsCollection.lastProductUrl(),
      outOfStockCount: cartItemsCollection.outOfStockCount(),
      outOfStockCountHto: cartItemsCollection.outOfStockCountHto(),
      outOfStockCountPurchase: cartItemsCollection.outOfStockCountPurchase(),
      purchaseItemQuantity: cartItemsCollection.length - htoQuantity,
      subtotal: cartItemsCollection.subtotal(),
    };
  }

  storeDidInitialize() {
    if (!this.store.__fetched || this.store.outOfStockCount === 0 || this.isHtoDrawerRoute()) {
      return;
    }

    if (this.store.outOfStockCountHto) {
      this.pushEvent(`cart-hasOutOfStockHtoItems-${this.store.outOfStockCountHto}`);
    }
    if (this.store.outOfStockCountPurchase) {
      this.pushEvent(`cart-hasOutOfStockPurchaseItems-${this.store.outOfStockCountPurchase}`);
    }
    this.store.items.map(item => {
      if (!item.in_stock) {
        this.pushEvent(`cart-outOfStockProduct-${item.product_id}_${item.option_type}`);
      }
    });
  }

  isHtoDrawerRoute() {
    const path = this.currentLocation().pathname;

    return (
      _.includes(this.getExperimentVariant('htoDrawer'), 'enabled') && (
        /^\/(eye|sun)glasses\/(wo)?men(\/.*)?$/.test(path) ||
        _.includes(['/quiz', '/quiz/results', '/account/favorites', '/home-try-on'], path)
      )
    );
  }

  getEcommerceEvents() {
    return this.requestDispatcher('analytics', 'store').ecommerceEvents;
  }

  onCartItemsSync() {
    this.replaceStore(this.buildStoreData());
  }

  onEstimateCreateSuccess(estimate) {
    if (!estimate.isFetched() || !this.requestDispatcher('cookies', 'get', 'estimate_id')) {
      // If we don't have an estimate, redirect to /checkout
      this.navigate('/checkout');
    }
    else if (estimate.get('is_authenticated')) {
      this.navigate('/checkout/step/information');
    }
    else {
      this.modals({ success: 'createEstimate' });
      this.navigate('/checkout/login');
    }
  }

  onEstimateCreateError(estimate, xhr, options) {
    this.modals({ error: 'createEstimate' });
    this.navigate('/cart');
  }

  onCartItemAddSuccess(item, xhr, options) {
    const cartItem = item.toJSON();
    this.collection('cartItems').add(item);

    if (cartItem.option_type === 'hto') {
      this.commandDispatcher('cookies', 'enterHtoMode', `htoAtc_${_.camelCase(cartItem.added_via)}`);
      this.commandDispatcher('experiments', 'bucket', 'htoDrawer');
    }

    this.commandDispatcher('analytics', 'pushProductEvent', {
      type: this.getEcommerceEvents().addToCart,
      products: cartItem,
    });

    this.commandDispatcher('session', 'addCartItem',
      _.pick(cartItem, 'id', 'product_id', 'variant_id', 'qty'),
      cartItem.option_type === 'hto'
    );
  }

  onCartItemAddError(item, xhr) {
    // If the add is unsuccessful because the HTO is already full, go to cart.
    // This ideally shouldn't happen, but can if the frontend and backend cart
    // states get out of sync.
    if (xhr.status === 403) {
      this.navigate('/cart');
    }
  }

  updateRemovedItem(item) {
    this.commandDispatcher('analytics', 'pushProductEvent', {
      type: this.getEcommerceEvents().removeFromCart,
      products: item,
    });
    this.commandDispatcher('session', 'removeCartItem', item.id, item.option_type === 'hto');
  }

  get commands() {
    return {
      refresh() {
        this.collection('cartItems').fetch();
      },

      createEstimate() {
        if (this.modals({isShowing: 'createEstimate'})) { return; }
        this.modals({loading: 'createEstimate'});

        const cartToEstimate = new CartToEstimateModel();
        cartToEstimate.save(null, {
          success: this.onEstimateCreateSuccess.bind(this),
          error: this.onEstimateCreateError.bind(this)
        });
      },

      addItem(attrs) {
        // Add an item to cart. Expects attrs with a product and variant id.
        // e.g. { variant_id: 4706, product_id: 1300 }
        const cartItem = new CartItemModel;
        cartItem.save(
          _.pick(attrs, 'variant_id', 'product_id', 'qty', 'added_via', 'hto_in_stock'), {
          success: this.onCartItemAddSuccess.bind(this),
          error: this.onCartItemAddError.bind(this)
        });
        if (attrs.option_type === 'hto' && this.store.htoDrawerEnabled) {
          this.replaceStore({ htoDrawerActive: true });
        }
      },

      removeItem(attrs) {
        // Remove an item from the cart. Expects attrs with a cart item id:
        // e.g. { id: 9114934 }
        if (_.get(attrs, 'id')) {
          const cartItem = this.collection('cartItems').get(attrs) || new CartItemModel(attrs);
          this.updateRemovedItem(cartItem.toJSON());
          cartItem.destroy();
          this.onCartItemsSync();
        }
      },

      removeUnavailableItems() {
        const unavailableItems = this.collection('cartItems').where({in_stock: false});
        _.each(unavailableItems, item => {
          this.updateRemovedItem(item.toJSON());
          item.destroy();
        });
        this.onCartItemsSync();
      },

      showHtoDrawer() {
        this.replaceStore({ htoDrawerActive: true });
      },

      hideHtoDrawer() {
        this.replaceStore({ htoDrawerActive: false });
      }
    };
  }
}

module.exports = CartDispatcher;
