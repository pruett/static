"use strict";

const _ = require("lodash");
const BaseDispatcher = require("../../common/dispatchers/base_dispatcher");
const Backbone = require("../../common/backbone/backbone");

class FramesModel extends Backbone.BaseModel {
  url() {
    return this.apiBaseUrl("cached/frames");
  }

  cacheTTL() {
    return 20 * 60 * 1000; // 20 minutes
  }

  parse(resp) {
    resp.frames = _(resp.frames)
      .sortBy('products[0].assembly_type', 'order.default')
      .value();
    return resp
  }
}

class SearchDispatcher extends BaseDispatcher {
  channel() {
    return "search";
  }

  models() {
    return {
      frames: {
        class: FramesModel
      }
    };
  }

  events() {
    return {
      "sync frames": this.__onSync
    };
  }

  getInitialStore() {
    const data = this.__buildStoreData();
    data.active = false;
    return data;
  }

  __onSync() {
    this.setStore(this.__buildStoreData());
  }

  __buildStoreData() {
    return this.model("frames").toJSON();
  }

  get commands() {
    return {
      enable() {
        this.commandDispatcher("layout", "showTakeover");
        this.setStore({ active: true });
        this.pushEvent('navigation-click-globalSearchButton');
        if (!this.model("frames").isFetched()) {
          this.model("frames").fetch();
        }
      },

      disable() {
        this.commandDispatcher("layout", "hideTakeover");
        this.setStore({ active: false });
      }
    };
  }
}

module.exports = SearchDispatcher;
