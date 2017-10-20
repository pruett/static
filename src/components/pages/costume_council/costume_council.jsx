const React = require("react/addons");
const _ = require("lodash");
const LayoutDefault = require("components/layouts/layout_default/layout_default");
const CostumeCouncil = require("components/organisms/landing/costume_council/costume_council");
const Mixins = require("components/mixins/mixins");

module.exports = React.createClass({
  displayName: "PagesCostumeCouncil",

  mixins: [Mixins.context, Mixins.dispatcher, Mixins.routing],

  statics: {
    route: function() {
      return {
        path: "/costume-council",
        handler: "CostumeCouncil",
        title: "Costume Council"
      };
    }
  },

  render: function() {
    return (
      <LayoutDefault
        {...this.props}
        cssModifier={
          "c-costume-council -full-page u-color-bg--light-gray-alt-5 u-df--900 u-ai--c u-jc--c"
        }
      >
        <CostumeCouncil />
      </LayoutDefault>
    );
  }
});
