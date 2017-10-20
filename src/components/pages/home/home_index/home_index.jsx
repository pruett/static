const _ = require('lodash');
const React = require('react/addons');
const Mixins = require('components/mixins/mixins');

const LayoutDefault = require('components/layouts/layout_default/layout_default');
const Home = require('components/organisms/static/home/home');
const Home2 = require('components/organisms/static/home_v2/home_v2');
const OrganizationSchema = require ('components/atoms/structured_data/organization/organization');

module.exports = React.createClass({

  mixins: [
    Mixins.context,
    Mixins.dispatcher,
    Mixins.routing
  ],

  statics: {
    route: function () {
      return {
        path: '/',
        handler: 'Home',
        title: 'Glasses & Prescription Eyeglasses'
      };
    }
  },

  getContentPath: function() {
    return this.inNewHomepageGroup() ? '/homepage-fluid' : '/home';
  },

  fetchVariations: function () {
    return [this.getContentPath()];
  },

  receiveStoreChanges: function () {
    return ['geo', 'navigation'];
  },

  getStoreChangeHandlers: function () {
    return {'geo': 'handleChangeGeo'};
  },

  handleChangeGeo: function (nextStore) {
    this.commandDispatcher(
      'analytics',
      'pushEvent',
      {'name': `browser-onRender-${this.getGeoState(nextStore)}`}
    );
  },

  getGeoState: function (geo) {
    if(_.isEmpty(geo.nearbyStores)) {
      return 'noNearbyStores';
    } else {
      if(_.some(geo.nearbyStores, (store) => store.info.offers_eye_exams)) {
        return 'hasNearbyEyeExams';
      } else {
        return 'hasNearbyStores';
      }
    }
  },

  inNewHomepageGroup: function() {
    return (
      /new|twoup|threeup/.test(this.getExperimentVariant('newHomepage2')) &&
      this.getFeature('homeTryOn')
    );
  },

  hasQuizResults: function() {
    const isBrowser = _.get(this.props, 'appState.config.environment.browser');
    const cookiePrefix = _.get(this.props, 'appState.locale.cookie_prefix');

    const cookie = isBrowser ?
      this.requestDispatcher('cookies', 'get', 'hasQuizResults') :
      _.get(this.props, `appState.requestCookies.${cookiePrefix}hasQuizResults`);

    return Boolean(cookie);
  },

  getHomepageContent: function() {
    const hasQuizResults = this.hasQuizResults();

    if(this.inNewHomepageGroup()) {
      const homepage = this.getContentVariation(this.getContentPath());

      if(_.filter(homepage.callouts, (callout) => _.includes(callout.type, 'quiz')).length < 2) {
        return homepage;
      }

      // Replace the quiz promo with quiz results, if the user has results saved
      const quizResultsCallout = _.remove(homepage.callouts, (section) => {
        return section.type === 'quizresults';
      });
      if(hasQuizResults && !_.isEmpty(quizResultsCallout)) {
        const quizIndex = _.findIndex(homepage.callouts, {type: 'quiz'});
        homepage.callouts[quizIndex] = quizResultsCallout[0];
      }

      return homepage;
    }
    else {
      return this.getContentVariation(
        this.getContentPath(),
        hasQuizResults ? `${this.getExperimentVariant('newHomepage2')}quizresults` : false
      );
    }

  },

  render: function() {
    const homepage = this.getHomepageContent();
    const navigation = this.getStore('navigation');

    if(_.isEmpty(homepage)) {
      return false;
    }

    if(this.inNewHomepageGroup()) {
      return (
        <LayoutDefault {...this.props}
          cssModifier={'-full-page'}
          isOverlap={/twoup|threeup/.test(this.getExperimentVariant('newHomepage2'))}>
          <Home2 {...homepage}
            smartBannerActive={_.get(navigation, 'smart_banner.enabled', false)} />
          <OrganizationSchema />
        </LayoutDefault>
      );
    }

    return (
      <LayoutDefault {...this.props} cssModifier={'-full-page'}>
        <Home {...homepage} routeQuery={this.getRouteQuery()} />
        <OrganizationSchema />
      </LayoutDefault>
    );
  }
});
