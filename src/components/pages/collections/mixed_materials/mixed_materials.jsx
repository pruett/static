const React = require("react/addons");
const _ = require("lodash");

const LayoutDefault = require("components/layouts/layout_default/layout_default");
const MixedMaterials = require("components/organisms/collections/mixed_materials/mixed_materials");
const GenericGrid = require("components/organisms/collections/generic_grid/generic_grid");

const Mixins = require("components/mixins/mixins");

module.exports = React.createClass({
  displayName: "PagesCollectionsMixedMaterials",

  CONTENT_PATH: "/landing-page/mixed-materials",

  mixins: [Mixins.context, Mixins.dispatcher, Mixins.routing],

  statics: {
    route: function() {
      return {
        path: "/mixed-materials",
        handler: "MixedMaterials",
        title: "Mixed Materials"
      };
    }
  },

  fetchVariations: function() {
    return [this.CONTENT_PATH];
  },

  renderChildren: function(content) {
    const variant = this.getExperimentVariant("mixedMaterialsLandingPage");

    const frameData = _.get(content, "__data.products");
    if (variant === "original") {
      return <MixedMaterials {...content.control} frame_data={frameData} />;
    } else {
      return (
        <GenericGrid
          {...content.grid}
          gaListModifier="mixedMaterials"
          gaCollectionSlug="mixedMaterials"
          identifier="mixedMaterials"
          frame_data={frameData}
        />
      );
    }
  },

  render: function() {
    const content = this.getContentVariation(this.CONTENT_PATH);
    const contentFetched = !_.isEmpty(content);

    return (
      <LayoutDefault cssModifier={"-full-page"} {...this.props}>
        {contentFetched && this.renderChildren(content)}
      </LayoutDefault>
    );
  }
});
