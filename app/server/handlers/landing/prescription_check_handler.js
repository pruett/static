'use strict';

const BaseCollectionHandler = require('hedeia/server/handlers/base_collection_handler');

class PrescriptionCheckHandler extends BaseCollectionHandler {
  name() {
    return 'PrescriptionCheck';
  }

  get endpoint() {
    return '/api/v2/variations/prescription-check-app-landing';
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

module.exports = PrescriptionCheckHandler;
