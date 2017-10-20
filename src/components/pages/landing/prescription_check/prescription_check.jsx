const _ = require('lodash');
const React = require('react/addons');
const LayoutDefault = require('components/layouts/layout_default/layout_default');
const PrescriptionCheck = require(
  'components/organisms/landing/prescription_check/prescription_check'
);
const SoftwareApplicationSchema = require(
  'components/atoms/structured_data/software_application/software_application'
);

const Mixins = require('components/mixins/mixins');

module.exports = React.createClass({
  CONTENT_PATH: '/prescription-check-app-landing',

  mixins: [
    Mixins.context,
    Mixins.dispatcher,
    Mixins.routing
  ],

  statics: {
    route: function () {
      return {
        path: '/prescription-check-app',
        handler: 'PrescriptionCheck',
        title: 'Prescription Check app'
      };
    }
  },

  receiveStoreChanges: function () {
    return [
      'geo',
      'prescriptionCheck',
      'regions',
      'fetch'
    ];
  },

  fetchVariations: function () {
    return [this.CONTENT_PATH];
  },

  getStoreChangeHandlers: function () {
    return {
      'fetch': 'iTunesSearchAPI'
    };
  },

  getInitialState: function () {
    return {
      iTunesSearchResults: {
        results: []
      }
    };
  },

  componentDidMount: function () {
    this.commandDispatcher('fetch', 'fetch', 'iTunesSearchAPI',
      'https://itunes.apple.com/lookup?id=1209102842');
  },

  iTunesSearchAPI: function(fetchStore) {
    const iTunesSearchResults = _.get(fetchStore, 'iTunesSearchAPI.data', {});
    this.setState({iTunesSearchResults: JSON.parse(iTunesSearchResults)});
  },

  render: function () {
    const content = this.getContentVariation(this.CONTENT_PATH) || {};
    const iTunesSearchResults = _.head(this.state.iTunesSearchResults.results);

    return (
      <LayoutDefault cssModifier={'-full-page'} {...this.props}>
        <PrescriptionCheck {...content}
          inRetailRadius={this.requestDispatcher('geo', 'inRetailRadius')}
          quizState={this.getStore('prescriptionCheck').quiz}
          isNativeAppCapable={_.get(this.props, 'appState.client.isNativeAppCapable')}
          regions={
            (this.getStore('regions').locales[this.getLocale('country')] || {}).regionOptGroups
          }
        />

        {!_.isEmpty(iTunesSearchResults) &&
          <SoftwareApplicationSchema
            aggregateRating={{
              ratingValue: iTunesSearchResults.averageUserRating,
              ratingCount: iTunesSearchResults.userRatingCount
            }}
            availableOnDevice={_.join(iTunesSearchResults.supportedDevices)}
            datePublished={iTunesSearchResults.currentVersionReleaseDate}
            description={iTunesSearchResults.description}
            downloadURL={iTunesSearchResults.trackViewUrl}
            fileSize={Math.floor(iTunesSearchResults.fileSizeBytes/1024/1024) + 'MB'}
            inLanguage={_.head(iTunesSearchResults.languageCodesISO2A)}
            installUrl={iTunesSearchResults.trackViewUrl}
            name={iTunesSearchResults.trackName}
            offers={{
              url: iTunesSearchResults.trackViewUrl,
              price: iTunesSearchResults.price,
              priceCurrency: iTunesSearchResults.currency
            }}
            releaseNotes={iTunesSearchResults.releaseNotes}
            softwareVersion={iTunesSearchResults.version}
            url={iTunesSearchResults.sellerUrl}
          />}
      </LayoutDefault>
    );
  }

});
