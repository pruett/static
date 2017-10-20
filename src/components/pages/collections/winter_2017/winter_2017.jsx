const React = require("react/addons");
const _ = require("lodash");

const LayoutDefault = require("components/layouts/layout_default/layout_default");

const Mixins = require("components/mixins/mixins");
const DATA = require("./data.json");

const {
  transformDeepArray,
} = require("components/utilities/collections/helpers");

module.exports = React.createClass({
  displayName: "PagesCollectionsWinter2017",

  CONTENT_PATH: "/landing-page/winter-2017",

  getContentPath: function() {
    const params = this.getRouteParams();
    return (
      this.CONTENT_PATH + (params["version"] ? `/${params["version"]}` : "")
    );
  },

  mixins: [Mixins.context, Mixins.dispatcher, Mixins.routing],

  statics: {
    route: function() {
      return {
        path: "/winter-2017/{version?}",
        handler: "Winter2017",
        title: "Winter 2017",
      };
    },
  },

  fetchVariations: function() {
    return [this.getContentPath()];
  },

  render: function() {
    const content = this.getContentVariation(this.getContentPath());
    const products = transformDeepArray(_.get(content, "__data.products", []));
    const frameData = _.defaults(products, DATA); // Ensure all data present.

    return (
      <LayoutDefault cssModifier={"-full-page"} {...this.props}>
        {!_.isEmpty(content) && <h1 children={"winter"} {...frameData} />}
      </LayoutDefault>
    );
  },
});
