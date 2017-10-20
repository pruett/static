const React = require("react/addons");
const _ = require("lodash");

const Carousel = require("components/molecules/collections/utility/carousel/carousel");
const Video = require("components/molecules/collections/utility/video/video");
const Picture = require("components/atoms/images/picture/picture");
const Img = require("components/atoms/images/img/img");
const Drift = require("components/molecules/collections/utility/drift/drift");
const TypeKit = require("components/atoms/scripts/typekit/typekit");

const ImpressionsMixin = require("components/mixins/collections/ga_impressions_mixin");
const Mixins = require("components/mixins/mixins");

const CollectionConstants = require("components/utilities/collections/constants");

const style = require("./style/style");

require("./fall_2017.scss");

const BLOCK_CLASS = "c-fall-2017";
const CLASSES = style(BLOCK_CLASS);

const VIDEO_URL = "https://www.warbyparker.com/assets/img/videos/fall-2017";

module.exports = React.createClass({
  displayName: "OrganismsCollectionsFall2017",

  BLOCK_CLASS,

  mixins: [
    Mixins.dispatcher,
    Mixins.image,
    ImpressionsMixin,
    Mixins.context,
    Mixins.analytics,
    Mixins.scrolling
  ],

  propTypes: {
    callouts_top: React.PropTypes.object,
    callouts_bottom: React.PropTypes.object,
    frame_data: React.PropTypes.array,
    frames: React.PropTypes.array,
    ga_impression_ids: React.PropTypes.array,
    hero: React.PropTypes.object,
    identifier: React.PropTypes.string,
    version: React.PropTypes.string,
    frames_position_middle: React.PropTypes.bool,
    logo: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      callouts_top: {},
      callouts_bottom: {},
      frame_data: [],
      frames: [],
      logo: "",
      ga_impression_ids: [],
      hero: {},
      identifier: "fall2017",
      version: "fans",
      frames_position_middle: true
    };
  },

  getInitialState() {
    return {
      isMobile: false,
      isDesktop: false
    };
  },

  componentDidMount() {
    this.handleProductImpressions();

    this.checkSize();
    window.addEventListener("resize", _.debounce(this.checkSize, 200));
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

  handleProductImpressions() {
    this.commandDispatcher("analytics", "pushProductEvent", {
      type: "productImpression",
      products: this.buildImpressions(this.props.ga_impression_ids, () => false)
    });
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

  getSecondaryPictureAttrs(images, count = 1) {
    const isFirst = count === 1;
    const min = isFirst ? 205 : 159;
    const max = (isFirst ? 387 : 275) * 1.5;

    return {
      sources: [
        {
          url: this.getImageBySize(images, "tablet"),
          widths: this.getImageWidths(min, max, 10),
          quality: this.getQualityBySize(images, "tablet"),
          mediaQuery: "(min-width: 600px)",
          sizes: `(min-width: 1440px) ${max}px, ${isFirst ? "25vw" : "19vw"}`
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

  getHeroPictureAttrs(images) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, "desktop-sd"),
          widths: this.getImageWidths(900, 2200, 5),
          quality: this.getQualityBySize(images, "desktop-sd"),
          mediaQuery: "(min-width: 900px)",
          sizes: "(min-width: 1440px) 1440px, 100vw"
        },
        {
          url: this.getImageBySize(images, "tablet"),
          quality: this.getQualityBySize(images, "tablet"),
          widths: this.getImageWidths(600, 1350, 5),
          mediaQuery: "(min-width: 600px)",
          sizes: "100vw"
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
        className: CLASSES.HERO.image
      }
    };
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

  renderFrames(frames = this.props.frames) {
    return (
      <div className={CLASSES.grid}>
        <div className={CLASSES.row}>
          {frames.map((frameGroup, i) =>
            <Carousel
              products={frameGroup.map(this.__matchFrame)}
              key={i}
              cssModifierFrameName={CLASSES.frameName}
              cssModifier={CLASSES.carousel}
              gaPosition={i}
              gaListModifier={"fall2017"}
              gaCollectionSlug={"fall2017"}
            />
          )}
        </div>
      </div>
    );
  },

  handleLinkClick(gaData) {
    this.trackInteraction(
      `LandingPage-clickShop${CollectionConstants.GA_GENDER_LOOKUP[gaData.gender]}-${gaData.sku}`
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
        list: "fall2017"
      }
    });
  },

  renderHero() {
    const { image, header, body } = this.props.hero || {};

    return (
      <div className={CLASSES.HERO.wrapper}>
        <div className={CLASSES.HERO.imageWrapper}>
          <Picture children={this.getPictureChildren(this.getHeroPictureAttrs(image))} />
          {this.state.isDesktop && [
            <Video
              sources={{
                desktop: `${VIDEO_URL}/WP FALL VIDEO PORTRAIT_322X396_08.mp4`
              }}
              posters={{ desktop: "" }}
              key={1}
              autoPlay
              muted
              loop
              css_modifier={CLASSES.HERO.videoOne}
              playsInline
            />,
            <Video
              posters={{ desktop: "" }}
              sources={{
                desktop: `${VIDEO_URL}/fall-2017/WP FALL VIDEO PORTRAIT_302X390_02.mp4`
              }}
              key={2}
              autoPlay
              muted
              loop
              css_modifier={CLASSES.HERO.videoTwo}
              playsInline
            />
          ]}
        </div>
        <div className={CLASSES.HERO.copyWrapper}>
          <Img
            srcSet={this.getSrcSet({
              url: this.props.logo,
              widths: this.getImageWidths(200, 400, 3),
              quality: 100
            })}
            sizes={this.getImgSizes([
              {
                breakpoint: 0,
                width: "200px"
              },
              {
                breakpoint: 600,
                width: "220px"
              }
            ])}
            cssModifier={CLASSES.HERO.logo}
            alt="Fall 2017 Logo"
          />
          <p children={body} className={CLASSES.HERO.body} />
        </div>
        <hr className={CLASSES.HERO.hr} />
        <div className={CLASSES.HERO.links}>
          {this.props.sections.map((section, index) => {
            return (
              <a
                className={CLASSES.HERO.link(index)}
                href={`#${_.kebabCase(section)}`}
                onClick={e => {
                  e.preventDefault();
                  this.scrollToNode(document.querySelector(`#${_.kebabCase(section)}`));
                }}
                children={section}
                key={section}
              />
            );
          })}
        </div>
      </div>
    );
  },

  getVideo(image, isShowing) {
    const videoProps = image.reduce(
      (memo, { size, image, video }) => {
        memo.posters[size] = image;
        memo.sources[size] = video;
        if (size === "tablet") {
          // Use tablet version for desktop.
          memo.posters["desktop"] = image;
          memo.sources["desktop"] = video;
        }
        return memo;
      },
      { posters: {}, sources: {} }
    );

    return (
      <Video
        {...videoProps}
        autoPlay={!this.state.isMobile || (this.state.isMobile && isShowing)}
        muted
        loop
        css_modifier_block={CLASSES.SLIDE.video}
        key="video"
        playsInline
      />
    );
  },

  getPicture(image, count) {
    const picture = this.getSecondaryPictureAttrs(image, count);
    return (
      <Picture
        key="image"
        children={this.getPictureChildren(picture)}
        cssModifier={CLASSES.SLIDE.picture}
      />
    );
  },

  renderSlider({ slides, frame, description, frames = [], invert, stacked }) {
    const [first, ...rest] = slides;
    const picture = this.getPrimaryPictureAttrs(first);
    return (
      <Drift
        disabled={!this.state.isMobile}
        indexDidUpdate={() => this.trackInteraction(`fall2017-swipe-${frame}`)}
      >
        {({ propsContainer, propsSlides, propsSlide, index, indexLast, goToSlide }) =>
          <div>
            <div className={CLASSES.container}>
              <div className={CLASSES.slider} {...propsContainer()}>
                <div className={CLASSES.slides(invert)} {...propsSlides()}>
                  <div className={CLASSES.SLIDE.wrapper} {...propsSlide("main")}>
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
                          className={CLASSES.SLIDE.secondary(rest.length, stacked)}
                          children={
                            image[0].video
                              ? this.getVideo(image, index === i + 1)
                              : this.getPicture(image, rest.length)
                          }
                        />
                      );
                    })}
                    {frame &&
                      description &&
                      <span className={CLASSES.caption(stacked)}>
                        <span className={CLASSES.frame} children={frame} />
                        <span children={description} />
                      </span>}
                  </div>
                </div>
              </div>
              {this.state.isMobile &&
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
                </div>}
            </div>
            {this.renderFrames(frames)}
          </div>}
      </Drift>
    );
  },

  render() {
    const [top, bottom] = this.props.sliders;
    const [firstSection, secondSection] = this.props.sections;
    return (
      <div className={CLASSES.block}>
        <TypeKit typeKitModifier="jsl1ymy" />
        {this.renderHero()}

        {top && <div id={_.kebabCase(firstSection)} children={top.map(this.renderSlider)} />}
        {this.props.frames_position_middle && this.renderFrames()}
        {bottom && <div id={_.kebabCase(secondSection)} children={bottom.map(this.renderSlider)} />}
        {!this.props.frames_position_middle && this.renderFrames()}
      </div>
    );
  }
});
