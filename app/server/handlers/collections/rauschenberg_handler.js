'use strict';

const BaseCollectionHandler = require('hedeia/server/handlers/base_collection_handler');

class RauschenbergHandler extends BaseCollectionHandler {

  name() {
    return 'Rauschenberg';
  }

  prefetch() {
    return [this.endpoint];
  }

  get endpoint() {
    return '/api/v2/variations/landing-page/rauschenberg';
  }

  prepare() {
    const prefetchError = this.prefetchErrors[this.endpoint];

    if (prefetchError) {
      this.throwError({statusCode: 404});
      return false;
    } else {
      return true;
    }
  }

}

module.exports = RauschenbergHandler;
