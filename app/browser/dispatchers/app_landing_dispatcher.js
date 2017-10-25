"use strict";

const _ = require("lodash");
const Backbone = require("../../common/backbone/backbone");
const BaseDispatcher = require("../../common/dispatchers/base_dispatcher");

class AppLinkSmsModel extends Backbone.BaseModel {
  url() {
    return this.apiBaseUrl('app-link-sms');
  }

  permittedAttributes() {
    return ['telephone', 'message_type'];
  }
}

class AppLandingDispatcher extends BaseDispatcher {
  channel() {
    return 'appLanding';
  }

  onSuccess(model, response) {
    const category = _.camelCase(`${model.get('message_type') || ''} appLanding`);

    if(response.sent) {
      this.pushEvent(`${category}-sendSms-success`);
    }
    else {
      this.pushEvent(`${category}-sendSms-failure`);
    }
  }

  commands() {
    return {
      sendSms(telephone, message_type) {
        const appLinkSms = new AppLinkSmsModel({
          telephone: telephone,
          message_type: message_type
        });
        appLinkSms.save(null, {
          success: this.onSuccess.bind(this)
        });
      }
    };
  }
}

module.exports = AppLandingDispatcher;
