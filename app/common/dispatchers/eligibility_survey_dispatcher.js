'use strict';
const _ = require('lodash');

const Backbone = require('../backbone/backbone');
const BaseDispatcher = require('./base_dispatcher');


class EstimateModel extends Backbone.BaseModel {
  url() {
    return this.apiBaseUrl(`estimate?estimate_token=${this.get('estimateToken')}`);
  }
}

class EligibilitySurveyDispatcher extends BaseDispatcher {

  channel() {
    return 'eligibilitySurvey';
  }

  models() {
    return {
      estimate: new EstimateModel({
        estimateToken: _.get(this.currentLocation(), 'query.estimate_token')
      })
    };
  }

  wake() {
    this.model('estimate').fetch({
      success: () => {
        this.setStore({__fetched: true});
      },
      error: () => {
        this.setStore({__fetched: true});
      }
    });
  }

  events() {
    return {
      'change estimate': this.__onChange
    };
  }

  getInitialStore() {
    return this.__buildStoreData();
  }

  __buildStoreData() {
    return {
      __fetched: Boolean(_.get(this.store, '__feteched', false)),
      estimate: _.get(this.data('estimate'), 'estimate', {})
    };
  }

  __onChange() {
    this.replaceStore(this.__buildStoreData());
  }
}

module.exports = EligibilitySurveyDispatcher;
