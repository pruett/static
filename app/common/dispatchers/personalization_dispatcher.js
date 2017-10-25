'use strict';

const _ = require('lodash');

const BaseDispatcher = require('./base_dispatcher');
const Backbone = require('hedeia/common/backbone/backbone');
const Personalization = require('hedeia/common/utils/personalization');

const Logger = require('../logger');

const COOKIE_EXPIRATION = 3600 * 24 * 7;

class PersonalizationModel extends Backbone.BaseModel {
  url() {
    return this.apiBaseUrl('personalization');
  }
}

class OrderItemsCollection extends Backbone.BaseCollection {
  parse(resp) {
    return resp.items;
  }
}

class PersonalizationDispatcher extends BaseDispatcher {
  channel() {
    return 'personalization';
  }

  events() {
    return {
      'sync personalization': this.onSync
    };
  }

  models() {
    return {
      personalization: {
        class: PersonalizationModel
      }
    }
  }

  collections() {
    return {
      orderItems: {
        class: OrderItemsCollection,
        fetchOnWake: false
      }
    }
  }

  wake() {
    if (this.environment.browser && this.__canShowHtoWelcomeBack()) {
      this.__fetchOrderItems(this.store.has_unconverted_hto);
    }
  }

  getInitialStore() {
    return this.__buildStoreData();
  }

  __buildStoreData() {
    if (this.__canShowHtoWelcomeBack()) {
      this.__fetchOrderItems(this.store.has_unconverted_hto)
    }
    return _.assign(this.data('personalization'), {
      __fetched: this.model('personalization').isFetched(),
      personalization: this.model('personalization')
    });
  }

  onSync() {
    this.replaceStore(this.__buildStoreData())
  }

  __canShowHtoWelcomeBack() {
    return _.get(this.store, 'has_unconverted_hto') &&
      !this.requestDispatcher('cookies', 'get', 'viewedHtoWb') &&
      !Personalization.isPathBlacklisted(this.currentLocation().pathname);
  }

  __fetchOrderItems(order_id) {
    var order = this.collection('orderItems');
    order.url = order.apiBaseUrl(`order/${order_id}`);
    order.fetch({
      success: this.__onOrderFetchSuccess.bind(this)
    });
  }

  __onOrderFetchSuccess() {
    this.commandDispatcher('cookies', 'set', 'viewedHtoWb', true, { expires: COOKIE_EXPIRATION });
    this.setStore({
      showWelcomeBackHtoVersion: 1,
      lastHtoItems: this.collection('orderItems').toJSON()
    });
  }

  get commands() {
    return {
      hideWelcomeBackHto() {
        this.setStore({showWelcomeBackHtoVersion: null});
      }
    }
  }

}

module.exports = PersonalizationDispatcher;
