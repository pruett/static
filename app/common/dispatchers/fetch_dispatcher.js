"use strict";

const { get } = require("lodash");
const Backbone = require("../backbone/backbone");
const BaseDispatcher = require("./base_dispatcher");

class FetchModel extends Backbone.BaseModel {
  defaults() {
    return {
      __fetching: new Date().getTime()
    };
  }

  parse(resp) {
    return {
      data: resp
    };
  }
}

class FetchDispatcher extends BaseDispatcher {
  channel() {
    return "fetch";
  }

  onContentFetched(model) {
    this.setStore({ [model.key]: model.toJSON() });
  }

  onContentError(model, xhr) {
    this.setStore({ [model.key]: { error: xhr.response } });
  }

  get commands() {
    return {
      fetch(key, url) {
        if (!get(this.store, `[${key}].__fetching`)) {
          const model = new FetchModel();
          model.url = url;
          model.key = key;
          model.fetch({
            success: this.onContentFetched.bind(this),
            error: this.onContentError.bind(this)
          });
        }
      }
    };
  }
}

module.exports = FetchDispatcher;
