const React = require("react/addons");
const _ = require("lodash");

const Picture = require("components/atoms/images/picture/picture");
const Carousel = require("components/molecules/collections/utility/carousel/carousel");

const ImpressionsMixin = require("components/mixins/collections/ga_impressions_mixin");
const Mixins = require("components/mixins/mixins");

require("./generic_grid.scss");

module.exports = React.createClass({
  displayName: "OrganismsCollectionsGenericGrid",

  BLOCK_CLASS: "c-generic-grid",

  mixins: [
    Mixins.classes,
    Mixins.context,
    Mixins.image,
    Mixins.analytics,
    Mixins.dispatcher,
    ImpressionsMixin
  ],

  propTypes: {
    frames: React.PropTypes.array,
    ga_impression_ids: React.PropTypes.array,
    hero: React.PropTypes.object,
    version: React.PropTypes.string,
    gaCollectionSlug: React.PropTypes.string,
    gaListModifier: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      frames: [],
      ga_impression_ids: [],
      hero: {},
      version: "fans",
      gaCollectionSlug: "",
      gaListModifier: ""
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
      block: `
        ${this.BLOCK_CLASS}
        u-mw1440 u-mla u-mra
        u-pb60
      `,
      cssModifiersFramesGrid: `
        u-mw1440 u-mla u-mra u-tac
        u-pl24 u-pr24 u-pr48--900 u-pl48--900 u-pt12 u-pt0--600
      `,
      cssModifiersFramesBlock: `
        u-mr12--600 u-ml12--600
        u-mr48--1200 u-ml48--1200
        u-dib u-w100p u-w5c--600 u-mb72 u-mb84--1200
      `,
      header: `
        u-fs24 u-fs40--900
        u-ffs
        u-fws
        u-reset
        u-mb24 u-mb36--900
      `,
      image: `u-w100p`,
      heroWrapper: `
        ${this.BLOCK_CLASS}__hero-wrapper
        u-mb120--900
        u-pr
      `,
      copyWrapper: `
        u-tac
        u-pa--900
        u-center-y--900
        u-w5c--900
        u-mb60 u-mb84--600 u-mb0--900
      `,
      heroHeader: `
        ${this.BLOCK_CLASS}__hero-header
        u-fs30 u-fs40--600 u-fs55--900
        u-mla u-mra
        u-ffs
        u-fws
        u-reset u-pt30
        u-mb12 u-mb6--600 u-mb24--900
      `,
      heroBody: `
        u-w10c u-w8c--600 u-w9c--900
        u-lh26 u-fs18--900
        u-tac u-mla u-mra
        u-reset
        u-mb12 u-mb24--900
      `,
      price: `
        u-fs16 u-fwb u-reset
        u-mb48 u-mb60--600
      `,
      divider: `
        ${this.BLOCK_CLASS}__divider
        u-mla u-mra
        u-color-bg--light-gray
        u-dn--900
      `,
      cssModifierFrameBlock: `
        u-w11c u-w6c--600 u-w5c--900
        u-mb84 u-mb96--900
        u-mr24--900 u-ml24--900
      `,
      cssModifierFrameName: `
        u-ffs u-fs22 u-fs24--900
        u-fws u-mb18 u-mb16--600
        u-pt24 u-pt18--600
      `,
      cssModifierFrameColor: `
        u-ffs
        u-fs16 u-fs18--900 u-fsi u-mb18
      `
    };
  },

  getPictureAttrs(classes, images = []) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, "desktop-sd"),
          quality: this.getQualityBySize(images, "desktop-sd"),
          widths: this.getImageWidths(900, 2200, 6),
          mediaQuery: "(min-width: 900px)"
        },
        {
          url: this.getImageBySize(images, "tablet"),
          quality: this.getQualityBySize(images, "desktop-sd"),
          widths: this.getImageWidths(700, 1400, 5),
          mediaQuery: "(min-width: 600px)"
        },
        {
          url: this.getImageBySize(images, "mobile"),
          quality: this.getQualityBySize(images, "desktop-sd"),
          widths: this.getImageWidths(300, 800, 5),
          mediaQuery: "(min-width: 0px)"
        }
      ],
      img: {
        alt: "Warby Parker Metal Collection",
        className: classes.image
      }
    };
  },

  renderHero(classes) {
    const hero = this.props.hero || {};
    const pictureAttrs = this.getPictureAttrs(classes, hero.image);
    const locale = this.getLocale("country");
    const price = hero.pricing[locale];

    return (
      <div className={classes.heroWrapper}>
        <Picture
          className={classes.picture}
          children={this.getPictureChildren(pictureAttrs)}
        />
        <div className={classes.copyWrapper}>
          <h1 children={hero.header} className={classes.heroHeader} />
          <p children={hero.body} className={classes.heroBody} />
          <div children={price} className={classes.price} />
          <div className={classes.divider} />
        </div>
      </div>
    );
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
          cssModifierImageWrapper={classes.cssModifierImageWrapper}
          gaCollectionSlug={this.props.gaCollectionSlug}
          gaListModifier={this.props.gaListModifier}
        />
      );
    });

    return <div children={frameChildren} />;
  },

  render() {
    const classes = this.getClasses();
    const groupedFrames = _.groupBy(this.props.frames, frame => {
      return frame.section;
    });

    return (
      <div className={classes.block}>
        {this.renderHero(classes)}
        <div
          className={classes.cssModifiersFramesGrid}
          children={this.prepareFrames(groupedFrames[1], classes, 1)}
        />
      </div>
    );
  }
});
