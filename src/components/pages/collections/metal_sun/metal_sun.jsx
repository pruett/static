const React = require('react/addons');
const _ = require('lodash');

const LayoutDefault = require('components/layouts/layout_default/layout_default');
const MetalCollection = require('components/organisms/collections/metal/metal')

const Mixins = require('components/mixins/mixins');


module.exports = React.createClass({
  displayName: 'PagesCollectionsMetalSun',

  CONTENT_PATH: '/landing-page/metal',

  mixins: [
    Mixins.context,
    Mixins.dispatcher,
    Mixins.routing,
    Mixins.classes
  ],

  statics: {
    route: function () {
      return {
        path: '/metal-sunglasses',
        handler: 'Metal',
        title: 'Metal Sunglasses'
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
        { contentFetched && <MetalCollection version={'sun'} content={content} /> }
      </LayoutDefault>
    );
  }

});
