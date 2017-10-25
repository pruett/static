'use strict';

const BaseCollectionHandler = require('hedeia/server/handlers/base_collection_handler');

class OffWhiteHandler extends BaseCollectionHandler {

  name() {
    return 'OffWhite';
  }

  prefetch() {
    return [this.endpoint];
  }

  get endpoint() {
    return '/api/v2/variations/landing-page/off-white';
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

module.exports = OffWhiteHandler;
