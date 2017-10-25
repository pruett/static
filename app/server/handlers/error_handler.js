"use strict";

const _ = require("lodash");
const BaseHandler = require("hedeia/server/handlers/base_handler");

class ErrorHandler extends BaseHandler {
  name() {
    return "Error";
  }

  prefetch() {
    return [this.contentEndpoint()];
  }

  prefetchOptions() {
    return { timeout: 10000 };
  }

  contentEndpoint() {
    // Strip new lines, tabs, whitespace and encode path.
    return `/api/v2/rewrites?path=${encodeURIComponent(this.path.replace(/\s/g, ""))}`;
  }

  prepare() {
    const rewrite = this.prefetched[this.contentEndpoint()] || {};

    // Continue if no rewrite returned or circular.
    if (!rewrite.target_path || rewrite.target_path === this.path) {
      return true;
    }

    if (["permanent", "temporary"].indexOf(rewrite.type) > -1) {
      this.redirectWithParams(rewrite.target_path, {
        statusCode: "permanent" ? 301 : 302
      });
      return false;
    } else if (rewrite.type === "vanity") {
      // Vanity URLs "look" like other pages.
      // You can also replace their endpoints with custom data.
      // This currently only works with /api/v2/variation endpoints.
      const route = this.options.getRoute(rewrite.target_path);
      if (route !== null) {
        if (!_.isEmpty(rewrite.api_rewrites)) {
          // Override api endpoints with custom endpoints.
          _.assign(route, { apiRewrites: rewrite.api_rewrites });
        }

        // Invoke handler that matches route.
        const HandlerClass = require(`hedeia/server/handlers/${route.handler}`);
        new HandlerClass(this.request, this.reply, route);
        return false;
      }
    }
    return true;
  }

  get() {
    const response = this.request.response;

    const error = response.statusCode
      ? // Errors that bubble up from Layout or Handlers, likely from a component.
        _.clone(response)
      : // Errors that bubble up from routing, like a 404.
        _.clone(response.output.payload);

    if (Config.debug && error.statusCode >= 500) {
      _.assign(error, { stack: response.stack });
    }

    if (response.isBoom && response.json) {
      return this.reply({ error }).code(error.statusCode);
    } else {
      return this.render({
        bundle: null,
        bundleFile: null,
        component: "PagesError",
        error,
        layout: _.result(this, "layout"),
        statusCode: error.statusCode,
        stores: [],
        title: error.statusCode
      });
    }
  }
}

module.exports = ErrorHandler;
