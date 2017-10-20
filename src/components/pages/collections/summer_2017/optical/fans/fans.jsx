const React = require('react/addons');
const _ = require('lodash');

const LayoutDefault = require('components/layouts/layout_default/layout_default');
const Summer2017 = require('components/organisms/collections/summer_2017/summer_2017');

const Mixins = require('components/mixins/mixins');


module.exports = React.createClass({
  displayName: 'PagesCollectionsSummer2017OpticalFans',

  CONTENT_PATH: '/landing-page/summer-2017',

  mixins: [
    Mixins.context,
    Mixins.dispatcher,
    Mixins.routing,
  ],

  statics: {
    route: function () {
      return {
        path: '/summer-2017',
        handler: 'Summer2017',
        title: 'Warby Parker Summer 2017'
      };
    }
  },

  fetchVariations: function () {
    return [this.CONTENT_PATH];
  },

  render: function () {
    const content = this.getContentVariation(this.CONTENT_PATH);
    const contentFetched = !(_.isEmpty(content));

    if (contentFetched) {
      const page = _.find(content.pages, {key: 'fans_optical'});
      return (
        <LayoutDefault cssModifier={'-full-page'} {...this.props} >
          <Summer2017
            frame_data={_.get(content, '__data.products')}
            version={'fans'}
            identifier={'summer2017'}
            page={page} />
        </LayoutDefault>
      );
    } else {
      return false;
    }
  }

});
