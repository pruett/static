const React = require("react/addons");
const _ = require("lodash");

const Picture = require("components/atoms/images/picture/picture");
const Hero = require("components/molecules/collections/archive/hero/hero");
const ImpressionsMixin = require("components/mixins/collections/ga_impressions_mixin");
const Carousel = require("components/molecules/collections/utility/carousel/carousel");

const Mixins = require("components/mixins/mixins");
const Drift = require("components/molecules/collections/utility/drift/drift");
const ProductHighlight = require("components/molecules/collections/archive/product_highlight/product_highlight");

const styleFunc = require("./styles/styles");

const BLOCK_CLASS = "c-archive";
require("./archive.scss");

const CLASSES = styleFunc(BLOCK_CLASS);
const GENDER_LOOKUP = {
  f: "Women",
  m: "Men"
};

module.exports = React.createClass({
  displayName: "ArchiveCollection",

  BLOCK_CLASS: "c-archive",

  propTypes: {
    content: React.PropTypes.object,
    version: React.PropTypes.string
  },

  mixins: [Mixins.dispatcher, Mixins.analytics, Mixins.image, ImpressionsMixin],
  getInitialState() {
    return {
      isMobile: false,
      isDesktop: false
    };
  },

  componentDidMount() {
    this.checkSize();
    window.addEventListener("resize", _.debounce(this.checkSize, 200));
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

  checkSize() {
    const isMobile = window.matchMedia("(max-width: 599px)").matches;
    if (isMobile !== this.state.isMobile) {
      this.setState({ isMobile: isMobile });
    }

    const isDesktop = window.matchMedia("(min-width: 900px)").matches;
    if (isDesktop !== this.state.isDesktop) {
      this.setState({ isDesktop });
    }
  },

  getDefaultProps() {
    return {
      content: {},
      identifier: "archive",
      version: "fans"
    };
  },

  getFooterPictureAttrs(images) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, "desktop-sd"),
          widths: this.getImageWidths(900, 1600, 5),
          quality: this.getQualityBySize(images, "desktop-sd"),
          mediaQuery: "(min-width: 900px)",
          sizes: "(min-width: 1440px) 1440px, 70vw"
        },
        {
          url: this.getImageBySize(images, "tablet"),
          quality: this.getQualityBySize(images, "tablet"),
          widths: this.getImageWidths(600, 1350, 5),
          mediaQuery: "(min-width: 600px)",
          sizes: "60vw"
        },
        {
          url: this.getImageBySize(images, "mobile"),
          quality: this.getQualityBySize(images, "tablet"),
          widths: this.getImageWidths(300, 900, 5),
          mediaQuery: "(min-width: 0px)",
          sizes: "100vw"
        }
      ],
      img: {
        alt: "Warby Parker",
        className: CLASSES.FOOTER.image
      }
    };
  },

  getPrimaryPictureAttrs(images) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, "tablet"),
          quality: this.getQualityBySize(images, "tablet"),
          widths: this.getImageWidths(400, 1200, 10),
          mediaQuery: "(min-width: 600px)",
          sizes: "(min-width: 1440px) 1080px, 50vw"
        },
        {
          url: this.getImageBySize(images, "mobile"),
          quality: this.getQualityBySize(images, "mobile"),
          widths: this.getImageWidths(300, 900, 5),
          mediaQuery: "(min-width: 0px)",
          sizes: "100vw"
        }
      ],
      img: {
        alt: "Warby Parker",
        className: CLASSES.SLIDE.image
      }
    };
  },

  handleLinkClick(ga = {}) {
    this.trackInteraction(
      `archive-clickShop${GENDER_LOOKUP[ga.gender]}-${ga.sku}`
    );

    const productData = {
      brand: "Warby Parker",
      category: ga.type,
      collections: [{ slug: "archive" }],
      color: ga.color,
      gender: ga.gender,
      id: ga.id,
      list: "archive",
      name: ga.name,
      position: ga.position,
      sku: ga.sku
    };

    this.commandDispatcher("analytics", "pushProductEvent", {
      type: "productClick",
      eventMetadata: {
        list: ga.list
      },
      products: productData
    });
  },

  renderSlider({ slides, frame, description, links }) {
    const [first, ...rest] = slides;
    const picture = this.getPrimaryPictureAttrs(first);
    return (
      <Drift
        disabled={!this.state.isMobile}
        indexDidUpdate={() => this.trackInteraction(`archive-swipe-${frame}`)}
      >
        {({
          propsContainer,
          propsSlides,
          propsSlide,
          index,
          indexLast,
          goToSlide
        }) => (
          <div>
            <div className={CLASSES.container}>
              <div className={CLASSES.slider} {...propsContainer()}>
                <div className={CLASSES.slides} {...propsSlides()}>
                  <div
                    className={CLASSES.SLIDE.wrapper}
                    {...propsSlide("main")}
                  >
                    <Picture
                      children={this.getPictureChildren(picture)}
                      cssModifier={CLASSES.SLIDE.picture}
                    />
                  </div>
                  <div className={CLASSES.SLIDE.wrapper}>
                    {rest.map((image, i) => {
                      return (
                        <div
                          key={i}
                          {...propsSlide(`secondary${i}`)}
                          className={CLASSES.SLIDE.secondary(rest.length)}
                        >
                          <Picture
                            key="image"
                            children={this.getPictureChildren(
                              this.getPrimaryPictureAttrs(image)
                            )}
                            cssModifier={CLASSES.SLIDE.picture}
                          />
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>
              {this.state.isMobile && (
                <div className={CLASSES.dots}>
                  {[...Array(indexLast + 1)].map((v, i) => {
                    return (
                      <button
                        className={CLASSES.dot(index === i)}
                        key={i}
                        onClick={() => goToSlide(i)}
                      />
                    );
                  })}
                </div>
              )}
              {frame &&
              description && (
                <span className={CLASSES.caption}>
                  <span className={CLASSES.SLIDE.frame} children={frame} />
                  <span
                    children={description}
                    className={CLASSES.SLIDE.color}
                  />
                </span>
              )}
              <div className={CLASSES.SLIDE.linkWrapper}>
                {links &&
                  links.map((link, i) => {
                    return (
                      <a
                        className={CLASSES.SLIDE.link}
                        key={i}
                        children={link.text}
                        href={link.path}
                        onClick={this.handleLinkClick.bind(this, link.ga)}
                      />
                    );
                  })}
              </div>
            </div>
          </div>
        )}
      </Drift>
    );
  },

  __matchFrame: function(frame = {}) {
    // Look up frame data, return uninjected object
    const frameData = _.get(this.props, "frame_data");
    const matchedFrame = _.pick(frameData, frame.id)[frame.id];
    if (matchedFrame) {
      return { ...matchedFrame, ...frame };
    } else {
      return { ...frame, sold_out: true };
    }
  },

  prepareFrames(frameSection, startingIndex) {
    const classes = CLASSES.FRAMES || {};
    const frameChildren = frameSection.map((frameGroup, i) => {
      const frames = frameGroup.frame_info || [];
      return (
        <Carousel
          products={frames.map(this.__matchFrame)}
          key={i}
          cssModifier={classes.cssModifierFrameBlock}
          gaPosition={startingIndex + i}
          gaListModifier={"archive"}
          cssModifierImageWrapper={classes.cssModifierImageWrapper}
          cssModifierFrameName={classes.cssModifierFrameName}
          cssModifierShopLink={classes.cssModifierShopLink}
          gaCollectionSlug={"archive"}
        />
      );
    });

    return <div children={frameChildren} />;
  },

  renderFooter() {
    const { footer = {} } = this.props.content || {};
    const classes = CLASSES.FOOTER || {};
    return (
      <div className={classes.wrapper}>
        <div className={classes.imageWrapper}>
          <Picture
            children={this.getPictureChildren(
              this.getFooterPictureAttrs(footer.image)
            )}
          />
        </div>
        <div className={classes.copyWrapper}>
          <div children={footer.title} className={classes.title} />
          <div children={footer.body} className={classes.body} />
        </div>
      </div>
    );
  },

  render() {
    const [first, second, third] = this.props.content.sliders;
    const hero = this.props.content.hero || {};
    const productHighlight = this.props.content.product_highlight || {};
    const groupedFrames = _.groupBy(this.props.content.frames, frame => {
      return frame.section;
    });

    return (
      <div className={CLASSES.block}>
        <Hero {...hero} classes={CLASSES.HERO} />
        <div
          className={CLASSES.cssModifierFramesGrid}
          children={this.prepareFrames(groupedFrames[1], 1)}
        />
        {first && <div children={first.map(this.renderSlider)} />}
        <div
          className={CLASSES.cssModifierFramesGrid}
          children={this.prepareFrames(groupedFrames[2], 4)}
        />
        <ProductHighlight
          {...productHighlight}
          classes={CLASSES.PRODUCT_HIGHLIGHT}
        />
        {second && <div children={second.map(this.renderSlider)} />}
        <div
          className={CLASSES.cssModifierFramesGrid}
          children={this.prepareFrames(groupedFrames[3], 7)}
        />
        {third && <div children={third.map(this.renderSlider)} />}
        <div
          className={CLASSES.cssModifierFramesGrid}
          children={this.prepareFrames(groupedFrames[4], 10)}
        />
        {this.renderFooter()}
      </div>
    );
  }
});
