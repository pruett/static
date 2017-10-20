const React = require("react/addons");
const _ = require("lodash");

const Carousel = require("components/molecules/collections/utility/carousel/carousel");
const Video = require("components/molecules/collections/utility/video/video");
const Picture = require("components/atoms/images/picture/picture");
const Slider = require("components/molecules/collections/utility/slider/slider");
const TypeKit = require("components/atoms/scripts/typekit/typekit");

const ImpressionsMixin = require("components/mixins/collections/ga_impressions_mixin");
const Mixins = require("components/mixins/mixins");

const CollectionConstants = require("components/utilities/collections/constants");

require("./mixed_materials.scss");

module.exports = React.createClass({
  displayName: "OrganismsCollectionsMixedMaterials",

  BLOCK_CLASS: "c-mixed-materials",

  mixins: [
    Mixins.classes,
    Mixins.dispatcher,
    Mixins.image,
    ImpressionsMixin,
    Mixins.context,
    Mixins.analytics
  ],

  propTypes: {
    bike_video: React.PropTypes.object,
    bottom_callout: React.PropTypes.object,
    callout_addie: React.PropTypes.object,
    callout_hayes: React.PropTypes.object,
    carousel_hayes: React.PropTypes.object,
    copy_blocks: React.PropTypes.array,
    frame_data: React.PropTypes.array,
    elliot_video: React.PropTypes.object,
    frames: React.PropTypes.array,
    ga_impression_ids: React.PropTypes.array,
    hero: React.PropTypes.object,
    identifier: React.PropTypes.string,
    middle_callout: React.PropTypes.object,
    version: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      bike_video: {},
      bottom_callout: {},
      carousel_hayes: {},
      copy_blocks: [],
      frame_data: [],
      elliot_video: {},
      frames: [],
      ga_impression_ids: [],
      hero: {},
      identifier: "mixedMaterials",
      middle_callout: {},
      version: "fans"
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
      this.props.ga_impression_ids,
      this.shouldReduce
    );

    this.commandDispatcher("analytics", "pushProductEvent", {
      type: "productImpression",
      products: impressions
    });
  },

  getStaticClasses() {
    return {
      block: `${this.BLOCK_CLASS} u-tac u-mla u-mra u-pb48 u-pb0--1200`,
      bikeVideoWrapper: `u-mw1440 u-mla u-mra`,
      calloutFrameLabel: `u-fws u-fs16 u-mb6`,
      calloutInfo: `u-dib u-w6c u-mla u-mra`,
      calloutLink: `
        ${this.BLOCK_CLASS}__bottom-callout-link
        u-fws u-pb6 u-bbss u-bbw2 u-bbw0--900
      `,
      calloutLinkWrapper: `u-w10c u-mla u-mra u-pt24`,
      calloutWrapper: `u-dn u-db--600 u-mb72 u-mw1440 u-mla u-mra u-mb96--600 u-mt48--600 u-mb140--1200`,
      copyBlock: `${this
        .BLOCK_CLASS}__copy-block u-pr u-mw1440 u-mla u-mra u-mb96--600 u-mb180--1200`,
      copyBlockWrapper: `
        ${this.BLOCK_CLASS}__copy-block-wrapper
        u-center u-pa u-w11c
      `,
      copyBlockBody: `
        ${this.BLOCK_CLASS}__copy-block-body
        u-reset u-color--black u-fs24 u-fs40--1200 u-ffs u-mla u-mra
      `,
      cssModifierImageWrapper: `
        ${this.BLOCK_CLASS}__css-modifier-image-wrapper
      `,
      cssModifiersFramesBlock: `
        u-mr12--600 u-ml12--600
        u-mr48--1200 u-ml48--1200
        u-dib u-w100p u-w5c--600 u-mb48
      `,
      cssModifiersFramesGrid: `
        u-mw1440 u-mla u-mra u-tac
        u-pl24 u-pr24 u-pr48--900 u-pl48--900 u-pt12 u-pt0--600
      `,
      elliotVideoWrapper: `
        u-dn--600
      `,
      frameDetails: `u-fws u-mt18 u-mb8`,
      heroCopyWrapper: `${this.BLOCK_CLASS}__hero-copy-wrapper`,
      heroImage: `u-w100p u-db`,
      heroHeader: `
        ${this.BLOCK_CLASS}__hero-header
        u-reset u-color--black
        u-fwb u-ffss
        u-fs22 u-fs50--900
        u-pt30 u-pt36--600 u-pb18
        u-pa--900 u-center-x--900
      `,
      heroBody: `
        ${this.BLOCK_CLASS}__hero-body
        u-reset u-color--black
        u-pt72--900 u-pt96--1200
        u-w9c
        u-mla u-mra u-fs24 u-fs40--1200
        u-ffs
      `,
      heroPricing: `
        ${this.BLOCK_CLASS}__hero-pricing
        u-reset u-color--black
        u-fs24 u-fs40--1200
        u-ffs u-pt36
      `,
      heroImageWrapper: `
        ${this.BLOCK_CLASS}__hero-image-wrapper
      `,
      heroWrapper: `
        u-pr u-mw1440 u-mla u-mra u-mb60 u-mb96--600 u-mb180--1200
      `,
      mediaWrapper: `u-w6c u-dib u-pl12 u-pr12 u-pl18--600 u-pr18--600`,
      mobileSliderWrapper: `
        u-dn--600 u-mb84
      `,
      shoppableCalloutWrapper: `
        u-mla u-mra u-mw1440 u-pt48 u-pt96--1200 u-mb72--600 u-mb140--1200
      `,
      twoUpCalloutWrapper: `
        u-dn u-db--600 u-pr48 u-pl48 u-mb48
      `
    };
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

  getRegionalPricing(pricing = {}) {
    const locale = this.getLocale("country");
    if (locale) {
      return pricing[`${locale}`];
    } else {
      return pricing["US"];
    }
  },

  prepareFrames(frameSection, classes, startingIndex) {
    const frameChildren = frameSection.map((frameGroup, i) => {
      const injectedFrameGroup = this.injectFrameGroup(frameGroup);
      return (
        <Carousel
          products={injectedFrameGroup}
          key={i}
          cssModifier={classes.cssModifiersFramesBlock}
          gaPosition={startingIndex + i}
          gaListModifier={"mixedMaterials"}
          cssModifierImageWrapper={classes.cssModifierImageWrapper}
          gaCollectionSlug={"mixedMaterials"}
        />
      );
    });

    return <div children={frameChildren} />;
  },

  handleLinkClick(gaData) {
    this.trackInteraction(
      `LandingPage-clickShop${CollectionConstants.GA_GENDER_LOOKUP[
        gaData.gender
      ]}-${gaData.sku}`
    );

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
        list: "mixedMaterials"
      }
    });
  },

  getCalloutLinkChildren(position, links, classes) {
    return links.gendered_details.map((detail, i) => {
      const gaData = {
        color: links.color,
        name: links.display_name,
        collections: [
          {
            slug: "mixedMaterials"
          }
        ],
        list: "mixedMaterials",
        type: links.assembly_type,
        sku: links.sku,
        gender: detail.gender,
        id: detail.product_id,
        path: detail.path,
        position: position
      };

      return (
        <a
          children={CollectionConstants.SHOP_LINK_LOOKUP[detail.gender]}
          className={classes.calloutLink}
          key={i}
          onClick={this.handleLinkClick.bind(this, gaData, detail)}
          href={detail.path}
        />
      );
    });
  },

  getSlideChildren(block = []) {
    const children = block.images.map((image, i) => {
      return (
        <div key={i}>
          <img src={image} className={"u-w12c"} />
        </div>
      );
    });

    return children;
  },

  getCalloutDetails(callout, classes) {
    return (
      <div
        children={`${callout.frame_name} in ${callout.frame_color}`}
        className={classes.frameDetails}
      />
    );
  },

  renderCopyBlock(copyBlock, classes) {
    return (
      <div className={`${classes.copyBlock} ${copyBlock.css_modifier}`}>
        <div className={classes.copyBlockWrapper}>
          <p children={copyBlock.copy} className={classes.copyBlockBody} />
        </div>
      </div>
    );
  },

  renderHero(classes) {
    const hero = this.props.hero || {};
    const picture = this.getPictureAttrs(hero.image, classes.heroImage);
    return (
      <div className={classes.heroWrapper}>
        <div className={classes.heroImageWrapper}>
          <Picture
            className={classes.picture}
            children={this.getPictureChildren(picture)}
          />
        </div>
        <div className={classes.heroCopyWrapper}>
          <h1 children={hero.header} className={classes.heroHeader} />
          <p children={hero.body} className={classes.heroBody} />
          <div
            children={this.getRegionalPricing(hero.price)}
            className={classes.heroPricing}
          />
        </div>
      </div>
    );
  },

  renderStaticCallout(calloutData, classes) {
    if (!calloutData) {
      return false;
    }
    const frameData = this.props.frame_data;

    const linkChildren = calloutData.links.map((link, i) => {
      const linkDetails = _.pick(frameData, link.id)[link.id];
      if (!linkDetails) {
        return false;
      }
      return (
        <div key={i} className={classes.calloutInfo}>
          <div
            className={classes.calloutFrameLabel}
            children={`${linkDetails.display_name} in ${linkDetails.color}`}
          />
          <div
            children={this.getCalloutLinkChildren(
              link.position,
              linkDetails,
              classes
            )}
          />
        </div>
      );
    });

    return (
      <div className={classes.calloutWrapper}>
        <img src={calloutData.image} />
        <div className={classes.calloutLinkWrapper} children={linkChildren} />
      </div>
    );
  },

  renderMobileSlider(slider, classes) {
    if (!slider) {
      return false;
    }
    return (
      <div className={classes.mobileSliderWrapper}>
        <Slider
          links={slider.links}
          showArrows={false}
          info={slider.info}
          slides={this.getSlideChildren(slider)}
        />
      </div>
    );
  },

  renderStillCallout(callout, classes) {
    const picture = this.getPictureAttrs(callout.image);

    return (
      <div className={classes.mediaWrapper}>
        <Picture
          className={classes.picture}
          children={this.getPictureChildren(picture)}
        />
        <div children={this.getCalloutDetails(callout, classes)} />
        <div
          children={this.getCalloutLinkChildren(0, callout.links, classes)}
        />
      </div>
    );
  },

  renderVideoCallout(callout, classes) {
    return (
      <div className={classes.mediaWrapper}>
        <Video
          {...callout.video}
          autoPlay={true}
          renderPlayButton={false}
          gaLabel={"mixedMaterials"}
        />
        <div children={this.getCalloutDetails(callout, classes)} />
        <div
          children={this.getCalloutLinkChildren(0, callout.links, classes)}
        />
      </div>
    );
  },

  renderTwoUpCallout(twoUpCallout, classes) {
    if (!twoUpCallout) {
      return false;
    }
    const callouts = twoUpCallout.map(callout => {
      if (callout.format === "still") {
        return this.renderStillCallout(callout, classes);
      } else {
        return this.renderVideoCallout(callout, classes);
      }
    });

    return <div className={classes.twoUpCalloutWrapper} children={callouts} />;
  },

  renderShoppableCallout(callout, classes) {
    const slider = callout.slider;
    const twoUpCallout = callout.two_up;
    return (
      <div className={classes.shoppableCalloutWrapper}>
        {this.renderMobileSlider(slider, classes)}
        {this.renderTwoUpCallout(twoUpCallout, classes)}
      </div>
    );
  },

  render() {
    const classes = this.getClasses();
    const copyBlocks = this.props.copy_blocks;
    const groupedFrames = _.groupBy(this.props.frames, frame => {
      return frame.section;
    });
    const middleCallout = this.props.middle_callout;
    const bottomCallout = this.props.bottom_callout;
    const bikeVideo = this.props.bike_video;
    const elliotVideo = this.props.elliot_video;
    const calloutHayes = this.props.callout_hayes;
    const calloutAddie = this.props.callout_addie;

    return (
      <div className={classes.block}>
        <TypeKit typeKitModifier="jsl1ymy" />
        {this.renderHero(classes)}
        <div
          className={classes.cssModifiersFramesGrid}
          children={this.prepareFrames(groupedFrames[1], classes, 1)}
        />
        {this.renderShoppableCallout(calloutHayes, classes)}
        {this.renderCopyBlock(copyBlocks[0], classes)}
        <div className={classes.bikeVideoWrapper}>
          <Video
            autoPlay={true}
            renderPlayButton={false}
            gaLabel={"mixedMaterials"}
            {...bikeVideo}
          />
        </div>
        <div
          className={classes.cssModifiersFramesGrid}
          children={this.prepareFrames(groupedFrames[2], classes, 5)}
        />
        {this.renderShoppableCallout(calloutAddie, classes)}
        {this.renderCopyBlock(copyBlocks[1], classes)}
        {this.renderStaticCallout(middleCallout, classes)}
        <div className={classes.elliotVideoWrapper}>
          <Video
            autoPlay={true}
            renderPlayButton={false}
            gaLabel={"mixedMaterials"}
            {...elliotVideo}
          />
        </div>
        <div
          className={classes.cssModifiersFramesGrid}
          children={this.prepareFrames(groupedFrames[3], classes, 10)}
        />
        {this.renderStaticCallout(bottomCallout, classes)}
      </div>
    );
  }
});
