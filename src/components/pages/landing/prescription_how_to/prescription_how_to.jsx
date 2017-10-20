const _ = require('lodash');
const React = require('react/addons');
const LayoutDefault = require('components/layouts/layout_default/layout_default');
const PrescriptionHowTo = require(
  'components/organisms/landing/prescription_how_to/prescription_how_to'
);
const Mixins = require('components/mixins/mixins');

module.exports = React.createClass({
  displayName: 'PagesPrescriptionHowTo',

  CONTENT_PATH: '/prescription-how-to',

  mixins: [
    Mixins.context,
    Mixins.dispatcher,
    Mixins.routing
  ],

  statics: {
    route: function () {
      return {
        path: '/how-to-get-a-prescription',
        handler: 'PrescriptionHowTo',
        title: 'How to get a prescription'
      };
    }
  },

  fetchVariations: function () {
    return [this.CONTENT_PATH];
  },

  render: function () {
    const content = this.getContentVariation(this.CONTENT_PATH) || {};

    return (
      <LayoutDefault cssModifier={'-full-page'} {...this.props} >
        <PrescriptionHowTo {...content} />
      </LayoutDefault>
    );
  }

});
