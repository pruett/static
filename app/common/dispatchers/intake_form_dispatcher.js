'use strict';

const _ = require('lodash');

const BaseDispatcher = require('./base_dispatcher');
const Backbone = require('hedeia/common/backbone/backbone');

class IntakeFormDispatcher extends BaseDispatcher {
  channel() {
    return 'intakeForm';
  }

}

module.exports = IntakeFormDispatcher;
