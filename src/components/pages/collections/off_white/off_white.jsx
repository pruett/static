const React = require("react/addons");
const _ = require("lodash");

const OffWhite = require("components/organisms/collections/off_white/off_white");
const LayoutDefault = require("components/layouts/layout_default/layout_default");

const Mixins = require("components/mixins/mixins");

module.exports = React.createClass({
  displayName: "PagesCollectionsOffWhite",

  CONTENT_PATH: "/landing-page/off-white",

  mixins: [Mixins.context, Mixins.dispatcher, Mixins.routing],

  statics: {
    route: function() {
      return {
        path: "/off-white",
        handler: "OffWhite",
        title: "Off White"
      };
    }
  },

  fetchVariations: function() {
    return [this.CONTENT_PATH];
  },

  render: function() {
    const content = this.getContentVariation(this.CONTENT_PATH);
    const contentFetched = !_.isEmpty(content);
    const frameData = _.get(content, "__data.products");

    return (
      <LayoutDefault cssModifier={"-full-page"} {...this.props}>
        {contentFetched &&
          <OffWhite content={content} frame_data={frameData} version="fans" />}
      </LayoutDefault>
    );
  }
});
