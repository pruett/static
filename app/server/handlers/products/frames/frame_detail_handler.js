'use strict';

const _ = require('lodash');
const BaseHandler = require('hedeia/server/handlers/base_handler');

class FrameDetailHandler extends BaseHandler {
  name() {
    return 'FrameDetail';
  }

  prefetch() {
    return [
      `/api/v2/products${this.path}`,
      `/api/v2/salable${this.path}`,
      `/api/v2/recommendations${this.path}`,
      `/api/v2/product-details${this.path}`
    ];
  }

  cacheTTL() {
    return 2 * 60 * 60 * 1000; // 2 hours.
  }

  cachePrivacy() {
    return 'private';
  }

  cacheKey() {
    return [
      // We render and cache a slightly different page for Apple Pay capable browsers.
      this.isApplePayCapable ? 'apw:' : '',
      // To support the different swatch treatment in HTO mode
      this.getCookie('htoMode') ? 'hto:' : '',
      this.path
    ].join('');
  }

  prefetchOptions() {
    return { timeout: 10000 };
  }

  prepare() {
    const productData = this.prefetched[`/api/v2/products${this.path}`];

    if (_.isEmpty(productData)) {
      this.throwError({statusCode: 404});
      return false;
    }
    else {
      const firstColor = _.first(productData.products);

      if (_.isEmpty(this.request.params.frame_color)) {
        // Redirect to canonical product url, which includes color.
        // eyeglasses/men/roosevelt => eyeglasses/men/roosevelt/jet-black-matte
        if (_.isEmpty(firstColor)) {
          this.throwError({statusCode: 500});
          return false;
        }
        else {
          this.redirectWithParams(`/${firstColor.path}`);
          return false;
        }
      }
      else {
        // If a frame has a color that is retired, redirect to the first available color.
        const path = _.trimStart(this.path, '/');

        if (_.some(productData.products, product => path === product.path)) {
          return true;
        }
        else {
          this.redirectWithParams(`/${firstColor.path}`);
          return false;
        }
      }
    }
  }
}

module.exports = FrameDetailHandler;
