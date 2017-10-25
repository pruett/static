'use strict';

const BaseCollectionHandler = require('hedeia/server/handlers/base_collection_handler');

class AmandaDeCadenetHandler extends BaseCollectionHandler {

  name() {
    return 'AmandaDeCadenet';
  }

  prefetch() {
    return [
      '/api/v2/variations/amanda-de-cadenet'
    ];
  }

}

module.exports = AmandaDeCadenetHandler;
