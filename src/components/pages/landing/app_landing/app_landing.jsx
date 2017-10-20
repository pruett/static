const React = require('react/addons');
const LayoutDefault = require('components/layouts/layout_default/layout_default');
const AppLanding = require('components/organisms/landing/app_landing/app_landing');

const Mixins = require('components/mixins/mixins');

module.exports = React.createClass({
  CONTENT_PATH: '/app-landing',

  mixins: [
    Mixins.context,
    Mixins.dispatcher,
    Mixins.routing
  ],

  statics: {
    route: function () {
      return {
        path: '/app',
        handler: 'AppLanding',
        title: 'Mobile App'
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
        <AppLanding {...content} />
      </LayoutDefault>
    );
  }

});
