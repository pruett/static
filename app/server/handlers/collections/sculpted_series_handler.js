'use strict';

const BaseCollectionHandler = require('hedeia/server/handlers/base_collection_handler');

class SculptedSeriesHandler extends BaseCollectionHandler {

  name() {
    return 'SculptedSeries';
  }

  prefetch() {
    return [this.endpoint];
  }

  get endpoint() {
    return '/api/v2/variations/landing-page/sculpted-series';
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

module.exports = SculptedSeriesHandler;
