'use strict';

const BaseCollectionHandler = require('hedeia/server/handlers/base_collection_handler');

class LensesLandingHandler extends BaseCollectionHandler {
  name() {
    return 'LensesLanding';
  }

  get endpoint() {
    return '/api/v2/variations/lenses-landing';
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

module.exports = LensesLandingHandler;
