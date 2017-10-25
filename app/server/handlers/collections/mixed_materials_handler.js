'use strict';

const BaseCollectionHandler = require('hedeia/server/handlers/base_collection_handler');

class MixedMaterialsHandler extends BaseCollectionHandler {

  name() {
    return 'MixedMaterials';
  }

  prefetch() {
    return [this.endpoint];
  }

  get endpoint() {
    return '/api/v2/variations/landing-page/mixed-materials';
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

module.exports = MixedMaterialsHandler;
