'use strict';

const BaseCollectionHandler = require('hedeia/server/handlers/base_collection_handler');

class BuyAPairGiveAPairHandler extends BaseCollectionHandler {
  name() {
    return 'BuyAPairGiveAPair';
  }

  get endpoint() {
    return '/api/v2/variations/buy-a-pair-give-a-pair';
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

module.exports = BuyAPairGiveAPairHandler;
