'use strict';

const BaseCollectionHandler = require('hedeia/server/handlers/base_collection_handler');

class SunscapadesHandler extends BaseCollectionHandler {

  name() {
    return 'Sunscapades';
  }

  prefetch() {
    return [this.endpoint];
  }

  get endpoint() {
    return '/api/v2/variations/landing-page/sunscapades';
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

module.exports = SunscapadesHandler;
