const React = require("react/addons");
const _ = require("lodash");

const Picture = require("components/atoms/images/picture/picture");
const CollectionFrame = require("components/molecules/collections/utility/frame/frame");

const Mixins = require("components/mixins/mixins");
const ImpressionsMixin = require("components/mixins/collections/ga_impressions_mixin");

require("./concentric_collection.scss");

module.exports = React.createClass({
  BLOCK_CLASS: "c-concentric-collection",
  propTypes: {
    content: React.PropTypes.object,
    version: React.PropTypes.string,
    identifier: React.PropTypes.string,
    frame_data: React.PropTypes.array
  },

  componentDidMount() {
    this.handleProductImpressions();
  },

  shouldReduce: function() {
    return true;
  },

  handleProductImpressions: function() {
    const impressions = this.buildImpressions(
      this.props.content.ga_impression_ids,
      this.shouldReduce
    );

    this.commandDispatcher("analytics", "pushProductEvent", {
      type: "productImpression",
      products: impressions
    });
  },

  mixins: [
    Mixins.classes,
    Mixins.image,
    ImpressionsMixin,
    Mixins.dispatcher,
    Mixins.context,
    Mixins.analytics
  ],

  FRAME_COLOR_LOOKUP: {
    68258: "Crystal and Blue Jay with Striped Indigo temples",
    68314: "Crystal and Oak Barrel with Oak Barrel temples",
    68342: "Crystal and Plum with Onyx Tortoise temples",
    68370: "Crystal and Cognac Tortoise with Cognac Tortoise temples"
  },

  getDefaultProps() {
    return {
      content: {},
      identifier: "concentricCollection",
      version: "fans",
      frame_data: []
    };
  },

  getPictureAttrs(images) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, "desktop-sd"),
          widths: this.getImageWidths(700, 1800, 5),
          quality: this.getQualityBySize(images, "desktop-sd"),
          mediaQuery: "(min-width: 900px)"
        },
        {
          url: this.getImageBySize(images, "tablet"),
          widths: this.getImageWidths(400, 1800, 5),
          quality: this.getQualityBySize(images, "tablet"),
          mediaQuery: "(min-width: 600px)"
        },
        {
          url: this.getImageBySize(images, "mobile"),
          widths: this.getImageWidths(300, 800, 5),
          quality: this.getQualityBySize(images, "mobile"),
          mediaQuery: "(min-width: 0px)"
        }
      ],
      img: {
        alt: "Warby Parker Concentric Collection",
        className: "u-w100p u-db"
      }
    };
  },

  getStaticClasses() {
    return {
      block: `${this.BLOCK_CLASS} u-pb72`,
      calloutWrapper: `u-mw1440 u-mla u-mra u-pr u-oh`,
      calloutCopyWrapper: `
        ${this.BLOCK_CLASS}__callout-copy-wrapper
        u-tac u-pa--900 u-center-y--900
      `,
      calloutCircle: `
        ${this.BLOCK_CLASS}__callout-circle
        u-mb12
      `,
      calloutCopy: `
        ${this.BLOCK_CLASS}__callout-copy
        u-fs16 u-fs16--900
        u-mla u-mra
        u-mb36 u-mb48--600
      `,
      calloutImageWrapper: `
        ${this.BLOCK_CLASS}__callout-image-wrapper
      `,
      calloutLink: `
        ${this.BLOCK_CLASS}__callout-link
        u-color--dark-gray u-fs12 u-fs16--900
        u-bbss u-bbw1 u-bbw0--900 u-bc--white
      `,
      calloutFrameName: `
        u-fws
      `,
      frameInfoWrapper: `
        ${this.BLOCK_CLASS}__frame-info-wrapper
      `,
      frameModifier: `u-w12c u-w6c--600 u-mb60`,
      frameWrapper: `u-tac u-mla u-mra u-mw1440 u-grid u-pt36 u-pt72--600`,
      heroImageWrapper: `
        ${this.BLOCK_CLASS}__hero-image-wrapper
      `,
      heroWrapper: `
        ${this.BLOCK_CLASS}__hero-wrapper
        u-mla u-mra u-mw1440
        u-mb12 u-pr
      `,
      heroCopyWrapper: `
        ${this.BLOCK_CLASS}__hero-copy-wrapper
        u-tac u-mla u-mra
        u-pt24
        u-pa--1200 u-center-y--1200
      `,
      heroBody: `
        ${this.BLOCK_CLASS}__hero-body
        u-reset
        u-mla u-mra
        u-fs16 u-fs16--900
        u-mb12 u-mb24--900
      `,
      heroHeader: `
        ${this.BLOCK_CLASS}__hero-header
        u-mla u-mra
        u-w8c u-w3c--600
        u-reset
        u-fs30 u-fs40--900
        u-fwb
        u-ffs
        u-mb12
      `,
      heroPricing: `
        ${this.BLOCK_CLASS}__hero-pricing
        u-reset
        u-mla u-mra
        u-fs16 u-fs16--900
        u-w6c u-w7c--600 u-w2c--900
      `,
      cssModifierFrameColor: `
        ${this.BLOCK_CLASS}__frame-color-modifier
        u-mla u-mra
        u-fsi u-ffs u-fs14 u-fs16--900
      `
    };
  },

  getColorOverride(frameData) {
    // Override frame colors with correct casing
    frameData.color = this.FRAME_COLOR_LOOKUP[frameData.product_id];
    return frameData;
  },

  injectFrameData: function(frame, classes) {
    // Inject frame data from DB if frame isn't sold out
    // If there is no matching frame provided by API, assume the frame is sold out
    const matchedFrameData = _.pick(this.props.frame_data, frame.id)[frame.id];
    if (!frame.sold_out && matchedFrameData) {
      const frameData = this.getColorOverride(matchedFrameData);
      return (
        <CollectionFrame
          {...frameData}
          version={this.props.version}
          isLinkedFrame={false}
          showGenderedLinks={true}
          gaCollectionSlug={this.props.identifier}
          gaPosition={frame.position}
          gaList={this.props.identifier}
          cssModifierBlock={classes.frameModifier}
          cssModifierFrameColor={classes.cssModifierFrameColor}
        />
      );
    } else {
      return (
        <CollectionFrame
          {...frame}
          isSoldOut={true}
          cssModifierBlock={classes.frameModifier}
          cssModifierFrameColor={classes.cssModifierFrameColor}
        />
      );
    }
  },

  renderFrames: function(frames = [], classes) {
    const frameChildren = frames.map(frame => {
      return this.injectFrameData(frame, classes);
    });
    return <div className={classes.frameWrapper} children={frameChildren} />;
  },

  getRegionalPricing(price = {}) {
    const locale = this.getLocale("country");
    if (locale) {
      return price[`${locale}`];
    } else {
      return price["US"];
    }
  },

  handleCalloutLinkClick(gaData = {}) {
    const gender = this.GA_GENDER_LOOKUP[gaData.gender];
    this.trackInteraction(`LandingPage-clickShop${gender}-${gaData.sku}`);

    this.commandDispatcher("analytics", "pushProductEvent", {
      type: "productClick",
      products: gaData,
      eventMetadata: {
        list: "concentricCollection"
      }
    });
  },

  renderHero(classes) {
    const hero = this.props.content.hero || {};
    const heroImage = this.getPictureAttrs(hero.image || {});
    const pricing = this.getRegionalPricing(hero.price);

    return (
      <div className={classes.heroWrapper}>
        <div className={classes.heroImageWrapper}>
          <Picture className={classes.picture} children={this.getPictureChildren(heroImage)} />
        </div>
        <div className={classes.heroCopyWrapper}>
          <h1 children={hero.header} className={classes.heroHeader} />
          <div className={classes.heroBody} children={hero.body} />
          <div className={classes.heroPricing} children={pricing} />
        </div>
      </div>
    );
  },

  renderFrameInfo(callout, classes) {
    if (callout.sold_out) return false;

    const frameInfo = this.matchFrames(callout);
    if (_.isEmpty(frameInfo)) {
      return false;
    } else {
      const genderedDetails = _.find(frameInfo.gendered_details, { gender: callout.gender }) || {};
      const gaData = {
        brand: "Warby Parker",
        category: "eyeglasses",
        collections: [{ slug: "concentricCollection" }],
        color: frameInfo.color,
        gender: callout.gender,
        id: genderedDetails.product_id,
        name: frameInfo.display_name,
        position: callout.position,
        sku: frameInfo.sku
      };
      return (
        <div className={`${classes.frameInfoWrapper} ${callout.css_modifier}`}>
          <a
            href={genderedDetails.path}
            className={classes.calloutLink}
            onClick={this.handleCalloutLinkClick.bind(this, gaData)}
          >
            <span children={frameInfo.display_name} className={classes.calloutFrameName} />
            <span children={` in ${callout.frame_color}`} />
          </a>
        </div>
      );
    }
  },

  renderCallout(callout = {}, classes) {
    const calloutImage = this.getPictureAttrs(callout.image);
    return (
      <div className={classes.calloutWrapper}>
        <div className={`${classes.calloutCopyWrapper} ${callout.css_modifier}`}>
          <img src={callout.circle_icon} className={classes.calloutCircle} />
          <div
            className={`${classes.calloutCopy} ${callout.css_modifier}`}
            children={callout.copy}
          />
        </div>
        <div className={classes.calloutImageWrapper}>
          <Picture className={classes.picture} children={this.getPictureChildren(calloutImage)} />
        </div>
        {this.renderFrameInfo(callout, classes)}
      </div>
    );
  },

  render() {
    const classes = this.getClasses();
    const callouts = this.props.content.callout_blocks || [];
    const calloutTop = _.find(callouts, { key: "top" });
    const calloutBottom = _.find(callouts, { key: "bottom" });
    const groupedFrames = _.groupBy(this.props.content.frames, frame => {
      return frame.section;
    });

    return (
      <div className={classes.block}>
        {this.renderHero(classes)}
        <div children={this.renderFrames(groupedFrames[1], classes)} />
        {calloutTop && this.renderCallout(calloutTop, classes)}
        <div children={this.renderFrames(groupedFrames[2], classes)} />
        {calloutBottom && this.renderCallout(calloutBottom, classes)}
      </div>
    );
  }
});
