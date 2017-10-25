'use strict';

const BaseCollectionHandler = require('hedeia/server/handlers/base_collection_handler');

class AppLandingHandler extends BaseCollectionHandler {
  name() {
    return 'AppLanding';
  }

  get endpoint() {
    return '/api/v2/variations/app-landing';
  }

  prefetch() {
    return [ this.endpoint ];
  }

  prepare() {
    const prefetchError = this.prefetchErrors[this.endpoint];

    if (Number.isInteger(prefetchError)) {
      this.throwError({statusCode: prefetchError})
      return false;
    }

    return true;
  }
}

module.exports = AppLandingHandler;
