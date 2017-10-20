const React = require('react/addons');
const LayoutDefault = require('components/layouts/layout_default/layout_default');
const SolarEclipse = require('components/organisms/static/solar_eclipse/solar_eclipse');

const Mixins = require('components/mixins/mixins');


module.exports = React.createClass({
  CONTENT_PATH: '/solar-eclipse',

  mixins: [
    Mixins.context,
    Mixins.dispatcher,
    Mixins.routing
  ],

  statics: {
    route: function () {
      return {
        path: '/solar-eclipse',
        handler: 'SolarEclipse',
        title: 'Solar Eclipse '
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
        <SolarEclipse {...content} />
      </LayoutDefault>
    );
  }
});
