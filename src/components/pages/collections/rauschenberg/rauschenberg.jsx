const React = require('react/addons');
const _ = require('lodash');

const LayoutDefault = require('components/layouts/layout_default/layout_default');
const Rauschenberg = require('components/organisms/collections/rauschenberg/rauschenberg');

const Mixins = require('components/mixins/mixins');


module.exports = React.createClass({
  displayName: 'PagesCollectionsRauschenberg',

  CONTENT_PATH: '/landing-page/rauschenberg',

  mixins: [
    Mixins.context,
    Mixins.dispatcher,
    Mixins.routing,
  ],

  statics: {
    route: function () {
      return {
        path: '/rauschenberg',
        handler: 'Rauschenberg',
        title: 'Rauschenberg'
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
        { contentFetched && <Rauschenberg
            {...content}
            frame_data={_.get(content, '__data.products')}
            version={'fans'}
            identifier={'Rauschenberg'} /> }
      </LayoutDefault>
    );
  }

});
