const React = require("react/addons");

const TypeKit = require("components/atoms/scripts/typekit/typekit");
const Picture = require("components/atoms/images/picture/picture");
const EmployeeGrid = require("components/molecules/collections/sculpted_series/employee_grid/employee_grid");
const ShoppableCallout = require("components/molecules/collections/sculpted_series/shoppable_callout/shoppable_callout");
const ImpressionsMixin = require("components/mixins/collections/ga_impressions_mixin");

const Mixins = require("components/mixins/mixins");

require("./sculpted_series.scss");

module.exports = React.createClass({
  displayName: "OrganismsCollectionsSculptedSeries",

  BLOCK_CLASS: "c-sculpted-series",

  TYPEKIT_ID: "vpy8dgl",

  mixins: [
    Mixins.classes,
    Mixins.context,
    Mixins.image,
    Mixins.analytics,
    Mixins.dispatcher,
    ImpressionsMixin
  ],

  getInitialState() {
    return {
      fadedRefs: []
    };
  },

  propTypes: {
    employee_grid: React.PropTypes.object,
    hero: React.PropTypes.object,
    identifier: React.PropTypes.string,
    shoppable_callouts: React.PropTypes.array,
    frame_data: React.PropTypes.array,
    variant: React.PropTypes.string,
    version: React.PropTypes.string,
    ga_impression_ids: React.PropTypes.object
  },

  getDefaultProps() {
    return {
      employee_grid: {},
      hero: {},
      shoppable_callouts: [],
      frame_data: {},
      variant: "",
      version: "f",
      identifier: "sculptedSeries",
      ga_impression_ids: {}
    };
  },

  componentDidMount() {
    this.handleProductImpressions();
  },

  shouldReduce() {
    return false;
  },

  handleProductImpressions() {
    const impressions = this.buildImpressions(
      this.props.ga_impression_ids[`${this.props.variant}`],
      this.shouldReduce
    );

    this.commandDispatcher("analytics", "pushProductEvent", {
      type: "productImpression",
      products: impressions
    });
  },

  getStaticClasses() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-mb48
      `,
      hero: `
        u-mb24 u-mb140--900
      `,
      heroWrapper: `
        ${this.BLOCK_CLASS}__hero-wrapper
        u-pr
      `,
      heroCopyWrapperMobile: `
        ${this.BLOCK_CLASS}__hero-copy-wrapper-mobile
        u-tac u-w12c
        u-color--black
        u-pt48 u-pb24
        u-dn--600
      `,
      heroBody: `
        u-futura-book
        u-fs14 u-lh24
        u-w9c u-mla u-mra
      `,
      heroPrice: `
        u-fs14 u-lh24
        u-futura-heavy
      `,
      heroImageWrapper: `
        ${this.BLOCK_CLASS}__hero-image-wrapper
        u-pr
        u-w12c
      `,
      heroBottomImage: `
        ${this.BLOCK_CLASS}__hero-bottom-image
        u-w100p u-db
        u-pa u-t0 u-l0
      `,
      heroTopImage: `
        ${this.BLOCK_CLASS}__hero-top-image
        u-w100p u-db
        u-pa u-t0 u-l0
      `,
      heroHeader: `
        ${this.BLOCK_CLASS}__hero-header
        u-reset
        u-fs14 u-lh24 u-color--black
        u-futura-heavy
      `,
      heroFrameName: `
        ${this.BLOCK_CLASS}__hero-frame-name
        u-pa u-fs12 u-ls2 u-futura-light
      `,
      topImageWrapper: `
        ${this.BLOCK_CLASS}__top-image-wrapper
      `,
      heroBodyTabletWrapper: `
        ${this.BLOCK_CLASS}__hero-body-tablet-wrapper
        u-dn u-db--600 u-dn--900 u-tac u-w7c u-w8c--600 u-mla u-mra
        u-fs14 u-lh24 u-pt120
        u-mb48--600 u-mb0--900
        u-color--black
        u-futura-book
      `,
      heroHeaderTablet: `
        ${this.BLOCK_CLASS}__hero-header-tablet
        u-futura-heavy u-tac
        u-fs36
        u-dn u-db--600 u-dn--900 u-pa u-center-y
      `,
      heroHeaderDesktop: `
        ${this.BLOCK_CLASS}__hero-header-desktop
        u-mb12
        u-w8c u-fs44 u-mla u-mra
        u-futura-heavy
      `,
      heroCopyWrapperDesktop: `
        ${this.BLOCK_CLASS}__hero-copy-wrapper-desktop
        u-dn u-db--900
        u-pa
        u-tac u-w4c
      `,
      heroBodyDesktop: `
        u-fs16 u-color--black u-lh26
        u-w10c u-mla u-mra u-tac
        u-futura-book
      `,
      heroPriceDesktop: `
        u-fs16 u-color--black u-lh26
        u-futura-heavy
      `,
      divider: `
        ${this.BLOCK_CLASS}__divider
        u-mw1440 u-mla u-mra
      `,
      shoppableCallouts: `
        u-mw1440
        u-mla u-mra
        u-pr72--900 u-pl72--900
        u-mb72 u-mb140--900
        u-pt18--600
        u-pt24--900
      `
    };
  },

  handleLinkClick(gaData) {
    this.trackInteraction(`LandingPage-clickShopWomen-${gaData.sku}`);

    const productImpression = {
      brand: "Warby Parker",
      category: gaData.type,
      collections: gaData.collections,
      color: gaData.color,
      gender: gaData.gender,
      id: gaData.id,
      name: gaData.name,
      position: gaData.position,
      sku: gaData.sku
    };

    this.commandDispatcher("analytics", "pushProductEvent", {
      type: "productClick",
      products: productImpression,
      eventMetadata: {
        list: "sculptedSeries"
      }
    });
  },

  getRegionalPricing(price = {}) {
    const locale = this.getLocale("country");
    if (locale) {
      return price[`${locale}`];
    } else {
      return price["US"];
    }
  },

  getPictureAttrs(images, cssModifier) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, "desktop-sd"),
          widths: this.getImageWidths(700, 1200, 5),
          mediaQuery: "(min-width: 900px)"
        },
        {
          url: this.getImageBySize(images, "tablet"),
          widths: this.getImageWidths(400, 900, 5),
          mediaQuery: "(min-width: 600px)"
        },
        {
          url: this.getImageBySize(images, "mobile"),
          widths: this.getImageWidths(300, 800, 5),
          mediaQuery: "(min-width: 0px)"
        }
      ],
      img: {
        alt: "Warby Parker",
        className: cssModifier
      }
    };
  },

  renderHeroOverlay(topPicture, hero, classes) {
    if (hero.sold_out) {
      return (
        <div className={classes.topImageWrapper}>
          <Picture
            className={classes.picture}
            children={this.getPictureChildren(topPicture)}
          />
          <span children={hero.frame_name} className={classes.heroFrameName} />
        </div>
      );
    } else {
      return (
        <a href={hero.path} onClick={this.handleLinkClick.bind(this, hero.ga)}>
          <div className={classes.topImageWrapper}>
            <Picture
              className={classes.picture}
              children={this.getPictureChildren(topPicture)}
            />
            <span
              children={hero.frame_name}
              className={classes.heroFrameName}
            />
          </div>
        </a>
      );
    }
  },

  renderHero(hero, classes) {
    const price = hero.price;
    const priceText = this.getRegionalPricing(price);
    const images = hero.images;
    const topPicture = this.getPictureAttrs(images.top, classes.heroTopImage);
    const bottomPicture = this.getPictureAttrs(
      images.bottom,
      classes.heroBottomImage
    );

    return (
      <div className={classes.hero}>
        <div className={classes.heroWrapper}>
          <div className={classes.divider}>
            <div className={classes.heroImageWrapper}>
              <Picture
                className={classes.picture}
                children={this.getPictureChildren(bottomPicture)}
              />
              <div className={classes.topImageWrapper}>
                {this.renderHeroOverlay(topPicture, hero, classes)}
              </div>
            </div>
            <div className={classes.heroCopyWrapperMobile}>
              <h1 className={classes.heroHeader} children={hero.header} />
              <p className={classes.heroBody} children={hero.body} />
              <div className={classes.heroPrice} children={priceText} />
            </div>
            <div className={classes.heroHeaderTablet} children={hero.header} />
            <div className={classes.heroCopyWrapperDesktop}>
              <h1
                className={classes.heroHeaderDesktop}
                children={hero.header}
              />
              <p className={classes.heroBodyDesktop} children={hero.body} />
              <div className={classes.heroPriceDesktop} children={priceText} />
            </div>
          </div>
        </div>
        <div className={classes.heroBodyTabletWrapper}>
          <p className={classes.heroBodyTablet} children={hero.body} />
          <div className={classes.heroPrice} children={priceText} />
        </div>
      </div>
    );
  },

  injectFrameData(callout) {
    return this.getMatchedFrameData(callout.id);
  },

  getFrameData(callout) {
    if (!callout.sold_out) {
      return this.injectFrameData(callout);
    } else {
      return {};
    }
  },

  renderShoppableCallout(callout, i) {
    const frameData = this.getFrameData(callout);

    return (
      <ShoppableCallout
        {...callout}
        ref={`callout_${i}`}
        key={i}
        frameData={frameData}
      />
    );
  },

  render() {
    const classes = this.getClasses();
    const hero = this.props.hero;
    const shoppableCallouts = this.props.shoppable_callouts || [];

    return (
      <div className={classes.block}>
        <TypeKit typeKitModifier={this.TYPEKIT_ID} />
        <div children={this.renderHero(hero, classes)} />
        <div
          className={classes.shoppableCallouts}
          children={shoppableCallouts.map((callout, i) => {
            return this.renderShoppableCallout(callout, i);
          })}
        />
        {this.props.variant === "employeeGrid" &&
          <EmployeeGrid
            {...this.props.employee_grid}
            frame_data={this.props.frame_data}
          />}
      </div>
    );
  }
});
