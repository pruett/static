const _ = require('lodash');
const Backbone = require('../backbone/backbone');
const BaseDispatcher = require('./base_dispatcher');
const Logger = require('../logger');
const ImageSet = require('../utils/image_set');

const { log } = Logger.get('FrameProductDispatcher');


const REGEX_PATH = /^\/(monocle|eyeglasses|sunglasses)\/(women|men|colonel)\/.*$/;
// For WARB-3102: Add transition upsell to PDPs
const GALLERY_REGEX = /^\/(eyeglasses|sunglasses)\/(wo)?men\/?$/;
const UPSELL_LOOKUP = { eyeglasses: {rx: ['rx_photo'], prog_rx: ['prog_rx_photo']} };
// For now, this is where we'll keep track of CMS endpoints with active experiments
const CMS_EXPERIMENTS = {
  details: 'photochromics',
  fitImages: 'staffPhotosOnPdp',
}


const getAnalyticsCategory = function(product) {
  // The category value to pass for interaction events for this product's PDP
  let analyticsCategory = 'PDP';
  if (product.gender === 'f') {
    analyticsCategory += '_womens';
  }
  else if (product.gender === 'm') {
    analyticsCategory += '_mens';
  }
  if (product.assembly_type === 'eyeglasses') {
    analyticsCategory += '_optical';
  }
  else if (product.assembly_type === 'sunglasses') {
    analyticsCategory += '_sunwear';
  }
  return analyticsCategory;
};

class FrameProductColorsCollection extends Backbone.BaseCollection {
  parse(resp) {
    return _.map(resp.products, function(product) {
      if (product.image_set) {
        product.image_set = ImageSet.unpack(product.image_set);
      }
      _.map(product.recommendations, function(rec) {
        if (!rec.name) {
          rec.name = rec.display_name;
        }
        if (rec.image_set) {
          rec.image_set = ImageSet.unpack(rec.image_set);
        }
      });
      product.analytics_category = getAnalyticsCategory(product);
      return product;
    });
  }
}

class FrameProductVariantsCollection extends Backbone.BaseCollection {
  parse(resp) {
    return _.map(resp.salable, function(product) {
      product.variants = _.mapValues(product.variants, function(variant) {
        if (variant.image_set) variant.image_set = ImageSet.unpack(variant.image_set);
        return variant;
      });
      return product;
    });
  }
}

class FrameProductRecommendations extends Backbone.BaseModel {
  parse(resp) {
    return _.forEach(resp.recommendations, function(recSet) {
      return _.forEach(recSet, function(rec) {
        rec.analytics_category = getAnalyticsCategory(rec);
        return rec;
      });
    });
  }
}

class FrameProductDetails extends Backbone.BaseModel {
  parse(resp) {
    return resp.details;
  }
}

class FrameProductDispatcher extends BaseDispatcher {
  channel() {
    return 'frameProduct';
  }


  getPath(kind, location) {
    if (!location) location = this.currentLocation();
    return `/api/v2/cached/${kind}${location.pathname}`;
  }

  setCollections() {
    FrameProductColorsCollection.prototype.url = this.getPath('products');
    FrameProductVariantsCollection.prototype.url = this.getPath('salable');
    FrameProductRecommendations.prototype.url = this.getPath('recommendations');
    FrameProductDetails.prototype.url = this.getPath('product-details');
  }

  collections() {
    this.setCollections();
    // Only fetch if page is correct.
    const doFetch = this.currentLocation().pathname.match(REGEX_PATH);

    return {
      frameColors: {
        class: FrameProductColorsCollection,
        fetchOnWake: doFetch
      },
      frameVariants: {
        class: FrameProductVariantsCollection,
        fetchOnWake: doFetch
      },
      frameRecommendations: {
        class: FrameProductRecommendations,
        fetchOnWake: doFetch
      },
      frameDetails: {
        class: FrameProductDetails,
        fetchOnWake: doFetch
      }
    };
  }

  updatePageTitle(product) {
    let audience = null, kind = null;
    if (!_.startsWith(product.path, 'monocle')) {
      kind = _.upperFirst(product.assembly_type);
      if (product.gender === 'm') {
        audience = 'for Men'
      }
      else if (product.gender === 'f') {
        audience = 'for Women';
      }
    }

    this.setPageTitle(
      REGEX_PATH,
      _.compact([
        product.display_name,
        kind,
        product.color ? `in ${_.startCase(product.color)}` : null,
        audience
      ]).join(" ")
    );
  }

  getInitialStore() {
    return this.buildStoreData();
  }

  shouldInitialize() {
    return this.currentLocation().pathname.match(REGEX_PATH);
  }

  handleActiveProductChange() {
    const product = _.get(this.store, `colors[${this.store.activeColorIndex || 0}]`);
    if (product) {
      this.trackProductDetailEvent(product);
      this.updatePageTitle(product);
    }
  }

  storeDidChange(store) {
    if (store.changed.__fetched || store.changed.activeColorIndex) {
      this.handleActiveProductChange();
    }
  }

  initialize() {
    this.handleActiveProductChange();
  }

  events() {
    return {
      'sync frameColors': this.onSyncComplete,
      'sync frameVariants': this.onSyncComplete,
      'sync frameRecommendations': this.onSyncComplete,
      'sync frameDetails': this.onSyncComplete,
    };
  }

  allSynced() {
    return (
      this.collection('frameColors').isFetched() &&
      this.collection('frameVariants').isFetched() &&
      this.collection('frameRecommendations').isFetched() &&
      this.collection('frameDetails').isFetched()
    );
  }

  onSyncComplete() {
    this.replaceStore(this.buildStoreData());
  }

  addUpsellVariants(variants, assembly_type) {
    return _.mapValues(variants, function(val, key) {
      if (_.get(UPSELL_LOOKUP, `[${assembly_type}][${key}]`)) {
        val.upsells = _.values(_.pick(variants, UPSELL_LOOKUP[assembly_type][key]));
      }
      return val;
    });
  }

  parseFrameDetails(activeColor) {
    const frameDetails = this.data('frameDetails');
    const result = {};

    // Build data object, excluding variations
    _.mapValues(frameDetails, (content, endpoint) => {
      if (!_.includes(endpoint, '__')) {
        const key = _.camelCase(endpoint.replace('pdp-', ''));
        const details = this.getCmsContent(content, key, activeColor);
        if (details) {
          result[key] = details;
        }
      }
    });

    // Swap in variations
    _.mapValues(frameDetails, (content, endpoint) => {
      if (_.includes(endpoint, '__')) {
        const arr = endpoint.split('__');
        const key = _.camelCase(arr[0].replace('pdp-', ''));
        const variation = arr[1];
        const details = this.getCmsContent(content, key, activeColor);
        if (details && CMS_EXPERIMENTS[key] && this.getExperimentVariant(CMS_EXPERIMENTS[key]) === variation) {
          result[key] = details;
        }
      }
    });

    return result;
  }

  getCmsContent(content, endpoint, activeColor) {
    if (endpoint === 'details') {
      return content[activeColor.pdp_details_cms_identifier];
    }
    else if (endpoint === 'collectionContent') {
      if (_.includes(_.get(content, 'product_ids'), activeColor.id)) {
        return content;
      }
    }
    else {
      return content;
    }
    return null;
  }

  buildStoreData() {
    if (!this.allSynced()) { return this.emptyStore(); }

    const frameVariants = this.collection('frameVariants');
    const frameRecommendations = this.collection('frameRecommendations');
    const htoMode = this.inHtoMode();
    let allHtoInStock = true;

    const colors = _.map(this.data('frameColors'), color => {
      color.recommendations = (frameRecommendations.get(color.path) || []).slice(0, 3);

      const variants = frameVariants.get(color.id) && frameVariants.get(color.id).get('variants') || {};
      color.variants = this.addUpsellVariants(variants, color.assembly_type);

      if (!_.get(color, 'variants.hto.in_stock') || !_.get(color, 'variants.hto.active')) {
        allHtoInStock = false;
      }

      return color;
    });

    if (htoMode && !allHtoInStock) {
      // Reorder colors so that the HTO in stock variants are first
      colors.sort(function(a, b) {
        let aActive = _.isMatch(_.get(a, 'variants.hto', {}), {active: true, in_stock: true});
        let bActive = _.isMatch(_.get(b, 'variants.hto', {}), {active: true, in_stock: true});
        if (aActive === bActive) {
          return 0;
        }
        else if (aActive) {
          return -1;
        }
        else {
          return 1;
        }
      });
      this.pushEvent('htoMode-feature-pdpHtoOutOfStock');
    }

    if (htoMode) {
      this.pushEvent('htoMode-feature-pdpChangeAtcEmphasis');
      this.commandDispatcher('experiments', 'bucket', 'pdpAtcHtoMode');
    }

    const activeColorIndex = Math.max(0,
      _.findIndex(colors, { path: _.trimStart(this.currentLocation().pathname, '/') })
    );
    const content = this.parseFrameDetails(colors[activeColorIndex]);
    if (content.fitImages) {
      this.commandDispatcher("experiments", "bucket", "staffPhotosOnPdp");
    }

    // Override widths from referrer query string if we came from a PLP
    if (this.environment.browser && !this.inExperiment('matchMultiplewidths', 'original')) {
      const referrer = this.requestDispatcher('routing', 'parse', document.referrer);
      if (referrer.pathname.match(GALLERY_REGEX)) {
        let filterWidths = _.map(_.get(referrer.query, 'width', '').split('~'), _.startCase)

        _.forEach(colors, function(color) {
          let productWidths = _.get(color, 'width_groups', []);
          const widths = _.intersection(filterWidths, productWidths);
          color.width_group = (widths.length === 1) ? widths[0] : _.get(
            color, 'width_group', '–'
          );
        });
      }
    }

    return {
      __fetched: true,
      activeColorIndex,
      colors,
      htoMode,
      content: content,
      selectedVariantType: this.getSelectedVariantType(colors[activeColorIndex]),
      sizingDetailsOpen: false,
    };
  }

  emptyStore() {
    return {
      __fetched: false,
      colors: [],
      activeColorIndex: _.get(this, 'store.activeColorIndex', 0),
      selectedVariantType: null,
      sizingDetailsOpen: false
    };
  }

  getSelectedVariantType(product) {
    const activeProduct = product || {};
    if (!activeProduct.assembly_type) { return null; }

    const orderedVariants = ['rx', 'prog_rx'];
    if (activeProduct.assembly_type === 'sunglasses') {
      orderedVariants.unshift('non_rx');
    }
    else if (activeProduct.assembly_type != 'eyeglasses') {
      orderedVariants.length = 0;
    }

    return _.reduce(orderedVariants, function(acc, variant) {
      if (acc) {
        return acc;
      }
      else if (_.get(activeProduct, `variants.${variant}.in_stock`)) {
        return variant;
      }
    }
    , null);
  }

  trackProductDetailEvent(product) {
    const list = _.compact(['PDP', product.gender, product.assembly_type]).join('_');

    this.commandDispatcher('analytics', 'pushProductEvent', {
      type: 'productDetail',
      products: product,
      eventMetadata: { list }
    });

    // Fire product impression events on all recommended frames
    if (product.recommendations) {
      this.commandDispatcher('analytics', 'pushProductEvent', {
        type: 'productImpression',
        products: product.recommendations,
        productMetadata: { list }
      });
    }
  }

  get commands() {
    return {
      changeActiveColor(colorIndex) {
        const product = _.get(this.store, `colors[${colorIndex}]`);
        if (product) {
          const content = this.parseFrameDetails(product);
          const newState = {
            activeColorIndex: colorIndex,
            selectedVariantType: this.getSelectedVariantType(product),
          };
          if(!_.isEqual(this.store.content, content)) newState.content = content;
          this.replaceStore(newState);
          if (product.path) {
            this.commandDispatcher('routing', 'replaceState', `/${product.path}`);
          }
        }
      },

      changeSelectedVariantType(variantType) {
        this.setStore({selectedVariantType: variantType});
      },

      closeSizingDetails() {
        this.commandDispatcher('layout', 'hideTakeover');
        this.setStore({sizingDetailsOpen: false});
      },

      toggleSizingDetails() {
        const newState = !_.get(this.store, 'sizingDetailsOpen', false);
        if (!newState) {
          this.commandDispatcher('layout', 'hideTakeover');
        }
        return this.setStore({sizingDetailsOpen: newState});
      },

      switchToPurchaseMode() {
        this.commandDispatcher('cookies', 'leaveHtoMode', 'pdpBuyInstead');
        this.setStore({ htoMode: false });
      }
    };
  }
}

module.exports = FrameProductDispatcher;
