'use strict';
const BaseCollectionHandler = require(
  'hedeia/server/handlers/base_collection_handler'
);

class Handler extends BaseCollectionHandler {
  name() {
    return 'BirthdayForm';
  }

  get endpoints() {
    return {
      frames: '/api/v2/variations/landing-page/birthday-frames',
      content: '/api/v2/variations/birthday-form',
      contest: '/api/v2/birthday'
    };
  }

  prefetch() {
    return Object.keys(this.endpoints).map(key => this.endpoints[key]);
  }

  prepare() {
    if (this.locale.country !== 'US') {
      this.redirectWithParams('/7');
      return false;
    }

    if (this.inExperiment('seventhBirthday', 'enabled')) {
      return true;
    }

    this.throwError({ statusCode: 404 });
    return false;
  }
}

module.exports = Handler;
