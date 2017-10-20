const React = require("react/addons");
const _ = require("lodash");

const Mixins = require("components/mixins/mixins");
const ImpressionsMixin = require("components/mixins/collections/ga_impressions_mixin");

const Picture = require("components/atoms/images/picture/picture");
const ShoppableFrame = require("components/atoms/collections/off_white/shoppable_frame/shoppable_frame");
const MarqueeFrame = require("components/atoms/collections/off_white/marquee_frame/marquee_frame");
const Hero = require("components/atoms/collections/off_white/hero/hero");
const LifestyleSection = require("components/atoms/collections/off_white/lifestyle_section/lifestyle_section");

require("./off_white.scss");

module.exports = React.createClass({
  displayName: "OffWhite",

  BLOCK_CLASS: "c-off-white",

  componentDidMount() {
    this.handleProductImpressions();
  },

  shouldReduce() {
    return false;
  },

  handleProductImpressions() {
    const impressions = this.buildImpressions(
      this.props.content.ga_impression_ids,
      this.shouldReduce
    );

    this.commandDispatcher("analytics", "pushProductEvent", {
      type: "productImpression",
      products: impressions
    });
  },

  propTypes: {
    content: React.PropTypes.object,
    version: React.PropTypes.string
  },

  mixins: [
    Mixins.classes,
    Mixins.image,
    Mixins.scrolling,
    ImpressionsMixin,
    Mixins.dispatcher,
    Mixins.analytics
  ],

  getDefaultProps() {
    return {
      content: {},
      identifier: "offWhite",
      version: "fans"
    };
  },

  getStaticClasses() {
    return {
      block: this.BLOCK_CLASS,
      framesGrid: `${this
        .BLOCK_CLASS}__frames-grid u-pr4 u-pl4 u-pl18--600 u-pr18--600 u-mla u-mra u-mw1440`,
      footerImage: `u-mla u-mra u-mw1440 u-mt72 u-mt120--900 u-mb36 u-mb84--900`
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
          widths: this.getImageWidths(400, 900, 5),
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
        alt: "Warby Parker",
        className: "u-w100p u-db"
      }
    };
  },

  handleClickMarqueeFrame(frame) {
    this.trackInteraction(
      `LandingPage-clickLink-${_.camelCase(frame.caption)}`
    );
    this.scrollToNode(this.refs[frame.ref], {
      offset: -125,
      time: 500
    });
  },

  renderFramesGrid(frames, classes) {
    const children = frames.map((frame, i) => {
      return (
        <MarqueeFrame
          onClick={this.handleClickMarqueeFrame.bind(this, frame)}
          {...frame}
          key={i}
          inViewport={true}
        />
      );
    });

    return (
      <div children={children} className={classes.framesGrid} ref="marquee" />
    );
  },

  render() {
    const hero = this.props.content.hero || {};
    const classes = this.getClasses();
    const framesGrid = this.props.content.frames_grid || [];
    const shoppableFrames = this.props.content.shoppable_frames || {};
    const lifestyleSections = this.props.content.lifestyle_sections || {};
    const footerImage = this.getPictureAttrs(
      this.props.content.footer_image || {}
    );

    const smallShoppableFrame = _.find(shoppableFrames, { key: "small" }) || {};
    const smallLifestyleSection =
      _.find(lifestyleSections, { key: "small" }) || {};

    const mediumShoppableFrame =
      _.find(shoppableFrames, { key: "medium" }) || {};
    const mediumLifestyleSection =
      _.find(lifestyleSections, { key: "medium" }) || {};

    const largeShoppableFrame = _.find(shoppableFrames, { key: "large" }) || {};
    const largeLifestyleSection =
      _.find(lifestyleSections, { key: "large" }) || {};

    return (
      <div>
        <Hero {...hero} />
        {this.renderFramesGrid(framesGrid, classes)}
        <LifestyleSection {...smallLifestyleSection} />
        <div ref="small">
          <ShoppableFrame {...smallShoppableFrame} />
        </div>
        <LifestyleSection {...mediumLifestyleSection} />
        <div ref="medium">
          <ShoppableFrame {...mediumShoppableFrame} />
        </div>
        <LifestyleSection {...largeLifestyleSection} />
        <div ref="large">
          <ShoppableFrame {...largeShoppableFrame} />
        </div>
        <div className={classes.footerImage}>
          <Picture
            className={classes.picture}
            children={this.getPictureChildren(footerImage)}
          />
        </div>
      </div>
    );
  }
});
