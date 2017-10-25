'use strict';

const BaseCollectionHandler = require('hedeia/server/handlers/base_collection_handler');

class InsuranceHandler extends BaseCollectionHandler {

  name() {
    return 'Insurance';
  }

  prefetch() {
    return [this.endpoint];
  }

  get endpoint() {
    return '/api/v2/variations/insurance';
  }

  prepare() {
    const prefetchError = this.prefetchErrors[this.endpoint];

    if (Number.isInteger(prefetchError)) {
      this.throwError({statusCode: prefetchError})
      return false;
    } else {
      return true;
    }
  }

}

module.exports = InsuranceHandler;
