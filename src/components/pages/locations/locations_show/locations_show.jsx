const React = require("react/addons");
const _ = require("lodash");
const LayoutDefault = require("components/layouts/layout_default/layout_default");
const RetailLocation = require("components/organisms/locations/location/location");
const RetailLocationV2 = require("components/organisms/locations/location_v2/location_v2");
const OpeningSoon = require("components/organisms/locations/opening_soon/opening_soon");
const OpeningSoonV2 = require("components/organisms/locations/opening_soon_v2/opening_soon_v2");
const Mixins = require("components/mixins/mixins");

module.exports = React.createClass({
  MODULES: {
    appointments: "/retail/responsive-appointment-global",
    services: "/retail/services",
    shopLinks: "/retail/shop-links"
  },

  mixins: [Mixins.context, Mixins.dispatcher, Mixins.routing],

  statics: {
    route() {
      return {
        path: "/retail/{city_slug}/{location_slug}",
        handler: "Locations"
      };
    }
  },

  fetchVariations() {
    return _.values(this.MODULES);
  },

  receiveStoreChanges() {
    return [
      "retail",
      "retailEmailCapture",
      "appointments",
      "content",
      "session"
    ];
  },

  getBreadcrumbs() {
    const retailStore = this.getStore("retail");
    const storeName = _.get(retailStore, "location.cms_content.name");
    if (!storeName) {
      return [];
    }

    return [
      {
        text: "Locations",
        href: "/retail"
      },
      { text: _.startCase(storeName) }
    ];
  },

  render() {
    const retail = this.getStore("retail");
    const appointments = this.getStore("appointments");
    const session = this.getStore("session");
    const { retailDetailVersion } = retail;

    if (!retail.location) return false;

    return (
      <LayoutDefault
        {...this.props}
        cssModifier={`-full-page ${retail.nearbyLocations.length
          ? "c-location-v2 -withNearbyLocations"
          : ""}`}
      >
        {retail.hasLaunched &&
          retailDetailVersion === "v2" &&
          (retail.location.cms_content.hero_carousel ? (
            <RetailLocationV2
              currentStatus={retail.currentStatus}
              appointments={
                retail.location.offers_eye_exams ? appointments : false
              }
              isOpenDaily={retail.isOpenDaily}
              location={retail.location}
              nearbyLocations={retail.nearbyLocations}
              services={this.getContentVariation(this.MODULES.services)}
              session={session}
              shopLinks={this.getContentVariation(this.MODULES.shopLinks)}
            />
          ) : (
            <RetailLocation
              {...this.props}
              location={retail.location}
              nearbyLocations={retail.nearbyLocations}
              services={this.getContentVariation(this.MODULES.services)}
              shopLinks={this.getContentVariation(this.MODULES.shopLinks)}
              currentStatus={retail.currentStatus}
              isOpenDaily={retail.isOpenDaily}
              breadcrumbs={this.getBreadcrumbs()}
            />
          ))}

        {retail.hasLaunched &&
          retailDetailVersion !== "v2" && (
            <RetailLocation
              {...this.props}
              location={retail.location}
              nearbyLocations={retail.nearbyLocations}
              services={this.getContentVariation(this.MODULES.services)}
              shopLinks={this.getContentVariation(this.MODULES.shopLinks)}
              currentStatus={retail.currentStatus}
              isOpenDaily={retail.isOpenDaily}
              breadcrumbs={this.getBreadcrumbs()}
            />
          )}

        {!retail.hasLaunched &&
          retailDetailVersion === "v2" && (
            <OpeningSoonV2
              retailEmailCapture={this.getStore("retailEmailCapture")}
              location={retail.location}
              breadcrumbs={this.getBreadcrumbs()}
            />
          )}

        {!retail.hasLaunched &&
          retailDetailVersion !== "v2" && (
            <OpeningSoon
              retailEmailCapture={this.getStore("retailEmailCapture")}
              location={retail.location}
              breadcrumbs={this.getBreadcrumbs()}
            />
          )}
      </LayoutDefault>
    );
  }
});
