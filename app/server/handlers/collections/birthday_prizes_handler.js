'use strict';

const BaseCollectionHandler = require(
  'hedeia/server/handlers/base_collection_handler'
);

class Handler extends BaseCollectionHandler {
  name() {
    return 'BirthdayPrizes';
  }

  get endpoint() {
    return '/api/v2/variations/birthday-prizes';
  }

  prefetch() {
    return [ this.endpoint ];
  }

  prepare() {
    if (this.inExperiment('seventhBirthday', 'enabled')) {
      return true;
    }
    this.throwError({statusCode: 404});
    return false;
  }
}

module.exports = Handler;
