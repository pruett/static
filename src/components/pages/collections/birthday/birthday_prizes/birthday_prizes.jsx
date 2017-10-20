const React = require('react/addons');
const LayoutDefault = require('components/layouts/layout_default/layout_default');
const Prizes = require('components/organisms/birthday/prizes/prizes');
const Mixins = require('components/mixins/mixins');

module.exports = React.createClass({
  displayName: 'PagesCollectionsBirthday',

  CONTENT_PATH: '/birthday-prizes',

  mixins: [
    Mixins.context,
    Mixins.dispatcher,
    Mixins.routing
  ],

  statics: {
    route: function () {
      return {
        path: '/7',
        handler: 'BirthdayPrizes',
        title: '7th-birthday bonanza'
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
        <Prizes {...content} />
      </LayoutDefault>
    );
  }

});
