const React = require("react/addons");
const _ = require("lodash");

const Picture = require("components/atoms/images/picture/picture");

const Mixins = require("components/mixins/mixins");

require("./shoppable_callout.scss");

module.exports = React.createClass({
  displayName: "MoleculesCollectionsSculptedSeriesShoppableCallout",

  BLOCK_CLASS: "c-sculpted-series-shoppable-callout",

  mixins: [
    Mixins.classes,
    Mixins.context,
    Mixins.image,
    Mixins.analytics,
    Mixins.dispatcher
  ],

  propTypes: {
    animate: React.PropTypes.bool,
    css_modifier_frame_name: React.PropTypes.string,
    display_name: React.PropTypes.string,
    images: React.PropTypes.object,
    frameData: React.PropTypes.object,
    flip: React.PropTypes.bool,
    frame_image: React.PropTypes.string,
    ga_position_frame: React.PropTypes.number,
    ga_position_image: React.PropTypes.number,
    sold_out: React.PropTypes.bool
  },

  getDefaultProps() {
    return {
      animate: false,
      css_modifier_frame_name: "u-color--black",
      display_name: "",
      frameData: {},
      images: [],
      flip: false,
      frame_image: "",
      ga_position_frame: 0,
      ga_position_image: 0,
      sold_out: false
    };
  },

  getInitialState() {
    return {
      animate: false
    };
  },

  toggleAnimationState() {
    this.setState({
      animate: !this.state.animate
    });
  },

  setTimer() {
    this.interval = window.setInterval(this.toggleAnimationState, 5000);
  },

  componentDidMount() {
    if (this.props.animate) {
      this.setTimer();
    }
  },
  componentWillUnmount() {
    window.clearInterval(this.interval);
  },

  getStaticClasses() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-mb60 u-mb96--600 u-mb72--900
      `,
      flexWrapper: `
        ${this.BLOCK_CLASS}__flex-wrapper
      `,
      mediaWrapper: `
        ${this.BLOCK_CLASS}__media-wrapper
        u-w12c
        u-pr u-w6c--600 u-mla u-mra
        u-w6c--900 u-dib
        u-mb36--600 u-mb0--900
      `,
      frameWrapper: `
        ${this.BLOCK_CLASS}__frame-wrapper
        u-w11c u-w6c--600 u-mla u-mra
        u-dib
      `,
      media: `
        ${this.BLOCK_CLASS}__media
        u-mb48 u-mb0--900
      `,
      topImage: `
        u-w12c
      `,
      bottomImage: `
        u-w12c
      `,
      topPictureWrapper: `
        ${this.BLOCK_CLASS}__top-picture-wrapper
        u-pa u-t0 u-l0
      `,
      bottomPictureWrapper: `
        ${this.BLOCK_CLASS}__bottom-picture-wrapper u-pr
      `,
      frameName: `
        ${this.BLOCK_CLASS}__frame-name
        ${this.props.css_modifier_frame_name}
        u-futura-light u-fs12 u-ls2
        u-pa
      `,
      link: `
        ${this.BLOCK_CLASS}__link
        u-futura-demi
        u-ls3
        u-fs14
        u-color--black
        u-fws
      `,
      frameInfoWrapper: `
        ${this.BLOCK_CLASS}__frame-info-wrapper
        u-pr
      `,
      overlayWrapper: `
        ${this.BLOCK_CLASS}__overlay-wrapper
        u-w12c
        u-pa u-t0
      `,
      overlay: `u-w12c`
    };
  },

  handleLinkClick(gaData) {
    this.trackInteraction(`LandingPage-clickShopWomen-${gaData.sku}`);
    const productImpression = {
      brand: "Warby Parker",
      category: gaData.type,
      collections: [{ slug: gaData.collections }],
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

  renderTopPicture(images, classes) {
    const topPicture = this.getPictureAttrs(images.top, classes.topImage);
    return (
      <div className={classes.topPictureWrapper}>
        <div children={this.props.display_name} className={classes.frameName} />
        <Picture
          className={classes.picture}
          children={this.getPictureChildren(topPicture)}
        />
      </div>
    );
  },

  renderAnimatedPicture(images, classes) {
    const topPicture = this.getPictureAttrs(images.top, classes.topImage);
    const overlay = this.getPictureAttrs(images.overlay, classes.overlay);
    return (
      <div className={classes.topPictureWrapper}>
        <div children={this.props.display_name} className={classes.frameName} />
        <Picture
          className={classes.picture}
          children={this.getPictureChildren(topPicture)}
        />
        <div className={classes.overlayWrapper}>
          <Picture
            className={classes.picture}
            children={this.getPictureChildren(overlay)}
          />
        </div>
      </div>
    );
  },

  getKlass(classes) {
    if (this.props.sold_out || _.isEmpty(this.props.frameData)) {
      return classes.wrapperSoldOut;
    } else {
      return classes.wrapper;
    }
  },

  renderMedia(classes) {
    const images = this.props.images;
    const bottomPicture = this.getPictureAttrs(
      images.bottom,
      classes.bottomImage
    );

    return (
      <div className={classes.media}>
        <div className={classes.bottomPictureWrapper}>
          <Picture
            className={classes.picture}
            children={this.getPictureChildren(bottomPicture)}
          />
        </div>
        {this.renderImageOverlay(images, classes)}
      </div>
    );
  },

  renderImageOverlay(images, classes) {
    const frameData = this.props.frameData;
    const gaData = {
      brand: "Warby Parker",
      type: "sunglasses",
      collections: "sculptedSeries",
      color: frameData.color,
      gender: "f",
      id: frameData.product_id,
      name: frameData.display_name,
      position: this.props.ga_position_image,
      sku: frameData.sku
    };
    if (this.props.sold_out || _.isEmpty(frameData)) {
      return (
        <div>
          {this.props.animate
            ? this.renderAnimatedPicture(images, classes)
            : this.renderTopPicture(images, classes)}
        </div>
      );
    } else {
      return (
        <a
          href={this.props.sold_out ? null : frameData.path}
          onClick={this.handleLinkClick.bind(this, gaData)}
        >
          {this.props.animate
            ? this.renderAnimatedPicture(images, classes)
            : this.renderTopPicture(images, classes)}
        </a>
      );
    }
  },

  classesWillUpdate() {
    return {
      mediaWrapper: {
        "-flip": this.props.flip
      },
      topPictureWrapper: {
        "-flip": this.props.flip
      },
      overlayWrapper: {
        "-hide": !this.state.animate,
        "-show": this.state.animate
      },
      bottomPictureWrapper: {
        "-flip": this.props.flip
      }
    };
  },

  renderFrame(classes) {
    const frameData = this.props.frameData;

    return (
      <div className={classes.frameInfoWrapper}>
        <img src={this.props.frame_image} className={"u-w11c"} />
        <div className={"u-tac u-mt8 u-mt18--900"}>
          {this.renderShopLink(frameData.product_id, classes)}
        </div>
      </div>
    );
  },

  renderShopLink(id, classes) {
    const frameData = this.props.frameData;
    if (this.props.sold_out || _.isEmpty(frameData)) {
      return <div children={"Sold out"} className={classes.soldOut} />;
    } else {
      const gaData = {
        brand: "Warby Parker",
        type: "sunglasses",
        collections: "sculptedSeries",
        color: frameData.color,
        gender: "f",
        id: frameData.product_id,
        name: frameData.display_name,
        position: this.props.ga_position_frame,
        sku: frameData.sku
      };
      return (
        <a
          href={frameData.path}
          onClick={this.handleLinkClick.bind(this, gaData)}
          dangerouslySetInnerHTML={{
            __html: `SHOP ${this.props
              .display_name} <span class='u-fs20'>&rsaquo;</span>`
          }}
          className={classes.link}
        />
      );
    }
  },

  render() {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <div className={classes.flexWrapper}>
          <div
            className={classes.mediaWrapper}
            children={this.renderMedia(classes)}
          />
          <div
            className={classes.frameWrapper}
            children={this.renderFrame(classes)}
          />
        </div>
      </div>
    );
  }
});
