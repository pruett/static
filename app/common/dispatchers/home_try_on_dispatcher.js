'use strict';

const _ = require('lodash');
const BaseDispatcher = require('./base_dispatcher');
const Backbone = require('../backbone/backbone');
const Url = require('../utils/url');


class Filters extends Backbone.BaseModel {
  constructor(attrs, options) {
    super(_.pickBy(attrs, Filters.isValuePermitted), options);
  }

  permittedAttributes() {
    return ['gender', 'fit'];
  }

  defaults() {
    return {
      gender: 'f',
      fit: 'medium'
    };
  }

  static isValuePermitted(value, fieldName) {
    return _.includes(Filters.permittedValues[fieldName], value);
  }

  static get permittedValues() {
    return {
      gender: ['f', 'm'],
      fit: ['narrow', 'medium', 'wide']
    };
  }
}

class HomeTryOnContentModel extends Backbone.BaseModel {
  url() {
    return this.apiBaseUrl('variations/landing-page/home-try-on');
  }

  parse(resp) {
    return resp.variations;
  }
}

class HtoStarterKitsCollection extends Backbone.BaseCollection {
  url() {
    return this.apiBaseUrl('hto-starter-kits');
  }

  parse(resp) {
    return resp.kits;
  }

  getActiveKits(filters) {
    return this.toJSON().filter((kit) => {
      return _.every(filters, function(filter, name) {
        return filter && filter === kit[name];
      });
    });
  }
}


class HomeTryOnDispatcher extends BaseDispatcher {
  mixins() {
    return [ 'cms' ];
  }

  channel() {
    return 'homeTryOn';
  }

  models() {
    return {
      content: {
        class: HomeTryOnContentModel,
        fetchOnWake: true
      },
      filters: new Filters(this.currentLocation().query || {})
    };
  }

  collections() {
    return {
      starterKits: {
        class: HtoStarterKitsCollection,
        fetchOnWake: true
      }
    };
  }

  events() {
    return {
      'sync content': this.__onSync,
      'change filters': this.__onChangeFilters,
      'sync starterKits': this.__onSync
    };
  }

  wake() {
    if (this.collection('starterKits').isFetched()) {
      this.__onChangeFilters();
    }
  }

  getInitialStore() {
    return _.assign(this.__buildStoreData(), {
      timesKitGroupsHaveShown: 0
    });
  }

  __onChangeFilters() {
    const filters = this.data('filters');
    const activeKits = this.collection('starterKits').getActiveKits(filters);
    this.replaceStore({
      starterKitSettings: filters,
      activeStarterKits: activeKits,
      timesKitGroupsHaveShown: this.store['timesKitGroupsHaveShown'] + 1
    });
    this.__fireKitProductImpressions(activeKits);
  }

  __updateQueryString() {
    // Update URL querystring to reflect new starter kit settings
    if (_.includes(['withQuiz', 'withoutQuiz'], this.getExperimentVariant('htoStarterKit'))) {
      const location = _.omit(this.currentLocation(), 'search');
      location.query = _.assign(
        _.omit(
          location.query,
          Object.keys(this.model('filters').permittedAttributes()).map(_.camelCase)
        ),
        Url.filtersToQueryObject(this.data('filters'))
      );
      this.commandDispatcher('routing', 'replaceState', Url.compile(location));
    }
  }

  __onSync() {
    this.replaceStore(this.__buildStoreData());
  }

  __fireKitProductImpressions(kits) {
    const metadataBaseSlug = `htoStarterKit_${_.values(this.data('filters')).join('_')}`;
    (kits || []).forEach((kit) => {
      this.commandDispatcher('analytics', 'pushProductEvent',
        {
          type: 'productImpression',
          products: kit.products,
          productMetadata: {
            list: `${metadataBaseSlug}_${_.camelCase(kit.title)}`
          }
        }
      );
    });
  }

  __buildStoreData() {
    if (!this.model('content').isFetched()) return {};

    const content = this.getContentVariation(this.data('content'));
    content.hasQuizResults = !_.isEmpty(Backbone.Cache.get('quizResults', 0));

    if (_.includes(['withQuiz', 'withoutQuiz'], this.getExperimentVariant('htoStarterKit'))) {
      content.starterKitSettings = this.data('filters');
      content.activeStarterKits = this.collection('starterKits').getActiveKits(
        content.starterKitSettings
      );
    }
    else {
      if(!_.get(content, 'products.genders')) return content;

      const starterKits = this.data('starterKits');
      content.products.genders = _.map(content.products.genders, function(frameGroup){
        let defaultKit = _.find(starterKits, {gender: frameGroup.gender, title: 'Default'});
        if(!_.get(defaultKit, 'products')){
          frameGroup.frames = [];
          return frameGroup;
        }

        frameGroup.frames = _.map(defaultKit.products, function(frame){
          return _.assign(frame, {
            variants: {
              hto: {
                active: typeof window === 'object',
                in_stock: true,
                variant_id: frame.hto_variant_id
              }
            }
          });
        });

        return frameGroup;
      });
    }

    return content;
  }

  __updateStarterKit(filter, value) {
    if (Filters.isValuePermitted(value, filter)) {
      this.model('filters').set({[filter]: value});
      this.__updateQueryString();
    }
  }

  get commands() {
    return {
      updateStarterKit(filter, value) {
        this.__updateStarterKit(filter, value);
      }
    };
  }
}

module.exports = HomeTryOnDispatcher;
