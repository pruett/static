const React = require('react/addons');
const LayoutDefault = require('components/layouts/layout_default/layout_default');
const LensesLanding = require('components/organisms/landing/lenses_landing/lenses_landing');

const Mixins = require('components/mixins/mixins');

module.exports = React.createClass({
  CONTENT_PATH: '/lenses-landing',

  mixins: [
    Mixins.context,
    Mixins.dispatcher,
    Mixins.routing
  ],

  statics: {
    route: function () {
      return {
        path: '/lenses',
        handler: 'LensesLanding',
        title: 'Lenses'
      };
    }
  },

  fetchVariations: function () {
    return [this.CONTENT_PATH];
  },

  render: function () {
    const content = this.getContentVariation(this.CONTENT_PATH) || {};

    return (
      <LayoutDefault cssModifier={'-full-page'} {...this.props}>
        <LensesLanding {...content} />
      </LayoutDefault>
    );
  }
});
