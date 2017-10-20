const React = require('react/addons');
const ExternalSvg = require('components/atoms/images/external_svg/external_svg');

require('./app_store_download.scss');

module.exports = React.createClass({
  BLOCK_CLASS: 'c-icon-app-store-download',

  getDefaultProps: function() {
    return {
      altText: 'Download on the App Store',
      cssUtility: '',
      cssModifier: ''
    };
  },

  render: function() {
    return (
      <ExternalSvg
        altText={this.props.altText}
        cssModifier={`${this.props.cssModifier} ${this.props.cssUtility}`}
        parentClass={this.BLOCK_CLASS} />
    );
  }
});
