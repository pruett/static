const React = require('react/addons');
const _ = require('lodash');

const LayoutDefault = require('components/layouts/layout_default/layout_default');

const HaskellFlash = require('components/organisms/collections/haskell_flash/haskell_flash');

const Mixins = require('components/mixins/mixins');


module.exports = React.createClass({
  displayName: 'PagesHaskellFlash',

  CONTENT_PATH: '/haskell-flash',

  mixins: [
    Mixins.context,
    Mixins.dispatcher,
    Mixins.routing,
  ],

  statics: {
    route: function () {
      return {
        path: '/haskell-flash',
        handler: 'HaskellFlash',
        title: 'Warby Parker Haskell'
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
        { contentFetched && <HaskellFlash {...content} />}
      </LayoutDefault>
    );
  }

});
