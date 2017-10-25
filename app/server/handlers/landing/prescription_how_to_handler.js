'use strict';

const BaseCollectionHandler = require('hedeia/server/handlers/base_collection_handler');

class PrescriptionHowToHandler extends BaseCollectionHandler {
  name() {
    return 'PrescriptionHowTo';
  }

  get endpoint() {
    return '/api/v2/variations/prescription-how-to';
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

module.exports = PrescriptionHowToHandler;
