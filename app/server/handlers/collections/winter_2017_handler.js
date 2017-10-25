"use strict";

const BaseCollectionHandler = require("hedeia/server/handlers/base_collection_handler");

class Winter2017CollectionHandler extends BaseCollectionHandler {
  name() {
    return "Winter2017";
  }

  prefetch() {
    return [this.endpoint];
  }

  get endpoint() {
    const { params = {} } = this.request || {};
    const pathSuffix = params["version"] ? `/${params["version"]}` : "";
    return `/api/v2/variations/landing-page/winter-2017${pathSuffix}`;
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

module.exports = Winter2017CollectionHandler;
