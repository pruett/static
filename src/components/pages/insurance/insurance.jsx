const React = require("react/addons");
const _ = require("lodash");

const LayoutDefault = require("components/layouts/layout_default/layout_default");

const Insurance = require("components/organisms/landing/insurance/insurance");

const Mixins = require("components/mixins/mixins");

module.exports = React.createClass({
  displayName: "PagesInsurance",

  CONTENT_PATH: "/insurance",

  mixins: [Mixins.context, Mixins.dispatcher, Mixins.routing],

  statics: {
    route: function() {
      return {
        path: "/insurance",
        handler: "Insurance",
        title: "Insurance",
      };
    },
  },

  fetchVariations: function() {
    return [this.CONTENT_PATH];
  },

  receiveStoreChanges: function() {
    return ["geo"];
  },

  render: function() {
    const content = this.getContentVariation(this.CONTENT_PATH);
    const contentFetched = !_.isEmpty(content);
    const geo = this.getStore("geo");
    const nearbyExams = _.some(geo.nearbyStores, store => {
      return store.info.offers_eye_exams;
    });
    const allowInsurancePurchase = true; // this will be an experiment flag

    return (
      <LayoutDefault cssModifier={"-full-page"} {...this.props}>
        {contentFetched && (
          <Insurance
            {...content}
            nearbyExams={nearbyExams}
            allowInsurancePurchase={allowInsurancePurchase}
          />
        )}
      </LayoutDefault>
    );
  },
});
