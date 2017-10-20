const React = require("react/addons");
const _ = require("lodash");

const SculptedSeries = require("components/organisms/collections/sculpted_series/sculpted_series");
const LayoutDefault = require("components/layouts/layout_default/layout_default");

const Mixins = require("components/mixins/mixins");

module.exports = React.createClass({
  displayName: "PagesCollectionsSculptedSeries",

  CONTENT_PATH: "/landing-page/sculpted-series",

  mixins: [Mixins.context, Mixins.dispatcher, Mixins.routing],

  statics: {
    route: function() {
      return {
        path: "/sculpted-series",
        handler: "SculptedSeries",
        title: "Sculpted Series"
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
    const variant =
      this.getExperimentVariant("sculptedSeriesEmployeeGrid") || "original";

    return (
      <LayoutDefault cssModifier={"-full-page"} {...this.props}>
        {contentFetched &&
          <SculptedSeries
            key={variant}
            {...content}
            variant={variant}
            frame_data={frameData}
          />}
      </LayoutDefault>
    );
  }
});
