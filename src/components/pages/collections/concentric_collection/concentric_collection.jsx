const React = require("react/addons");
const _ = require("lodash");

const ConcentricCollection = require("components/organisms/collections/concentric_collection/concentric_collection");
const LayoutDefault = require("components/layouts/layout_default/layout_default");

const Mixins = require("components/mixins/mixins");

module.exports = React.createClass({
  displayName: "PagesCollectionsConcentricCollection",

  CONTENT_PATH: "/landing-page/concentric-collection",

  mixins: [Mixins.context, Mixins.dispatcher, Mixins.routing],

  statics: {
    route: function() {
      return {
        path: "/concentric-collection",
        handler: "Concentric",
        title: "Concentric Collection"
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
          <ConcentricCollection
            content={content}
            frame_data={frameData}
            version="fans"
          />}
      </LayoutDefault>
    );
  }
});
