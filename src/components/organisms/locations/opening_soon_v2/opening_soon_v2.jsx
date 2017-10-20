const React = require("react/addons");
const _ = require("lodash");
const Hero = require("components/organisms/locations/opening_soon_v2/hero/hero");
const TryBeforeBuy = require("components/molecules/eye_sun/try_before_buy/try_before_buy");
const GlassesNav = require("components/molecules/glasses_nav/glasses_nav");
const Mixins = require("components/mixins/mixins");

module.exports = React.createClass({
  BLOCK_CLASS: "c-opening-soon",

  mixins: [Mixins.classes, Mixins.callout, Mixins.analytics],

  propTypes: {
    location: React.PropTypes.object,
    breadcrumbs: React.PropTypes.array,
    retailEmailCapture: React.PropTypes.shape({
      emailCaptureErrors: React.PropTypes.object,
      isEmailCaptureSuccessful: React.PropTypes.bool
    })
  },

  getStaticClasses() {
    return {
      grid: `u-grid -maxed u-mla u-mra`,
      row: `u-pt48 u-pb48 u-pt72--900 u-pb72--900 u-tac`,
      glassesRow: `u-pt48 u-pb8 u-pt72--900 u-pb12--900 u-bbw1 u-bbss u-bc--light-gray  u-tac`,
      locationRow: `u-pt48 u-pb24  u-pt72--900 u-pb28--900  u-tac`,
      heading: `u-tac u-fws u-ffs u-fs24 u-fs30--900 u-fs34--1200 u-mt0`,
      copy: `u-fs16 u-fs18--900 u-mb36`,
      cta: `u-button -button-modular -button-blue u-fws u-ffss u-fs16`
    };
  },

  getAddress(address) {
    return `${address.street_address},
            ${address.locality}, ${address.region_code}`;
  },

  render() {
    const loc = this.props.location;
    if (!loc) return false;

    const classes = this.getClasses();
    const cmsContent = loc.cms_content;
    const heroProps = _.get(cmsContent, "opening_soon.hero_v2");
    const tryBeforeBuyProps = _.get(cmsContent, "opening_soon.try_before_buy");
    const glassesNavProps = _.get(cmsContent, "opening_soon.glasses_nav");
    const allLocsProps = _.get(cmsContent, "opening_soon.all_locations");

    const glassesNavHeading = _.has(
      cmsContent,
      "opening_soon.glasses_nav.heading"
    ) ? (
      <h1 className={classes.heading}>{glassesNavProps.heading}</h1>
    ) : null;

    return (
      <section>
        <Hero
          {...heroProps}
          retailEmailCapture={this.props.retailEmailCapture}
          breadcrumbs={this.props.breadcrumbs}
          storeName={_.get(cmsContent, "name", "")}
          address={_.get(loc, "address", {})}
          locationShortName={_.get(loc, "short_name", "N/A")}
          gmaps_url={_.get(cmsContent, "map_details.url")}
        />
        <section className={classes.grid}>
          <div className={`${classes.row} u-bbw1 u-bbss u-bc--light-gray`}>
            <TryBeforeBuy {...tryBeforeBuyProps} />
          </div>
        </section>
        <section className={classes.grid}>
          <div className={classes.glassesRow}>
            {glassesNavHeading}
            <GlassesNav {...glassesNavProps} />
          </div>
        </section>
        <section className={classes.grid}>
          <div className={classes.locationRow}>
            <h1 className={classes.heading}>{allLocsProps.heading}</h1>
            <p className={classes.copy}>{allLocsProps.copy}</p>
            <a
              href={allLocsProps.cta_url}
              className={classes.cta}
              onClick={this.trackInteraction.bind(
                this,
                "retailComingSoon-click-seeAll"
              )}
              children={allLocsProps.cta_text}
            />
          </div>
        </section>
      </section>
    );
  }
});
