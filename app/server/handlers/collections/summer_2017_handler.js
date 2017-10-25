'use strict';

const BaseCollectionHandler = require('hedeia/server/handlers/base_collection_handler');

class Summer2017Handler extends BaseCollectionHandler {

  name() {
    return 'Summer2017';
  }

  prefetch() {
    return [this.endpoint];
  }

  get endpoint() {
    return '/api/v2/variations/landing-page/summer-2017';
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

module.exports = Summer2017Handler;
