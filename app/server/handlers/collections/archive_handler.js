"use strict";

const BaseCollectionHandler = require("hedeia/server/handlers/base_collection_handler");

class ArchiveHandler extends BaseCollectionHandler {
  name() {
    return "Archive";
  }

  prefetch() {
    return [this.endpoint];
  }

  get endpoint() {
    return "/api/v2/variations/landing-page/archive";
  }

  prepare() {
    const prefetchError = this.prefetchErrors[this.endpoint];
    const isError = Number.isInteger(prefetchError);

    if (isError) {
      this.throwError(prefetchError);
      return false;
    } else {
      return true;
    }
  }
}

module.exports = ArchiveHandler;
