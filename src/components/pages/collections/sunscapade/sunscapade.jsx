const React = require('react/addons');
const _ = require('lodash');

const LayoutDefault = require('components/layouts/layout_default/layout_default');
const Sunscapades = require('components/organisms/collections/sunscapades/sunscapades');

const Mixins = require('components/mixins/mixins');


module.exports = React.createClass({
  displayName: 'PagesCollectionsSunscapades',

  CONTENT_PATH: '/landing-page/sunscapades',

  mixins: [
    Mixins.context,
    Mixins.dispatcher,
    Mixins.routing,
  ],

  statics: {
    route: function () {
      return {
        path: '/sunscapades',
        handler: 'Sunscapades',
        title: 'Warby Parker'
      };
    }
  },

  fetchVariations: function () {
    return [this.CONTENT_PATH];
  },

  render: function () {
    const content = this.getContentVariation(this.CONTENT_PATH);
    const contentFetched = !(_.isEmpty(content));

    return (
      <LayoutDefault cssModifier={'-full-page'} {...this.props} >
        { contentFetched && <Sunscapades {...content} /> }
      </LayoutDefault>
    );
  }

});
