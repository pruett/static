"use strict";

const BaseCollectionHandler = require("hedeia/server/handlers/base_collection_handler");

// ES6 doesn't allow for constant assignment with class definitions
const ENDPOINT = "/api/v2/variations/landing-page/metal";

class MetalHandler extends BaseCollectionHandler {
  name() {
    return "Metal";
  }

  prefetch() {
    return [ENDPOINT];
  }

  prepare() {
    const prefetchError = this.prefetchErrors[ENDPOINT];
    this.throwError({ statusCode: 404 });
    return false;
  }
}

module.exports = MetalHandler;
