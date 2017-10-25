
'use strict';

const BaseCollectionHandler = require('hedeia/server/handlers/base_collection_handler');

class Spring2017Handler extends BaseCollectionHandler {

  name() {
    return 'Spring2017';
  }

  prefetch() {
    return [
      '/api/v2/variations/landing-page/spring-2017'
    ];
  }

}

module.exports = Spring2017Handler;

