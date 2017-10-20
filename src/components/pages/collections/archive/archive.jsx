const React = require("react/addons");
const _ = require("lodash");

const LayoutDefault = require("components/layouts/layout_default/layout_default");
const ArchiveCollection = require("components/organisms/collections/archive/archive");
const Mixins = require("components/mixins/mixins");
const DATA = require("./data.json");
const {
  transformDeepArray
} = require("components/utilities/collections/helpers");

module.exports = React.createClass({
  displayName: "PagesCollectionsArchive",

  CONTENT_PATH: "/landing-page/archive",

  mixins: [Mixins.context, Mixins.dispatcher, Mixins.routing],

  statics: {
    route: function() {
      return {
        path: "/archive-edition",
        handler: "Archive",
        title: "Archive"
      };
    }
  },

  fetchVariations: function() {
    return [this.CONTENT_PATH];
  },

  render: function() {
    const content = this.getContentVariation(this.CONTENT_PATH);
    const contentFetched = !_.isEmpty(content);
    const products = transformDeepArray(_.get(content, "__data.products", []));
    const frameData = _.defaults(products, DATA); // Ensure all data present.

    return (
      <LayoutDefault cssModifier={"-full-page"} {...this.props}>
        {contentFetched && (
          <ArchiveCollection
            content={content}
            frame_data={frameData}
            version="fans"
          />
        )}
      </LayoutDefault>
    );
  }
});
