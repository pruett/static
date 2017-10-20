const React = require("react/addons");

const Img = require("components/atoms/images/img/img");

const Mixins = require("components/mixins/mixins");
const ImpressionsMixin = require("components/mixins/collections/ga_impressions_mixin");

require("./shoppable_frame.scss");

module.exports = React.createClass({
  displayName: "OffWhiteShoppableFrame",

  BLOCK_CLASS: "c-off-white-shoppable-frame",

  Frame_SIZES: [
    {
      breakpoint: 0,
      width: "33vw"
    }
  ],

  mixins: [
    Mixins.classes,
    Mixins.image,
    Mixins.dispatcher,
    Mixins.analytics,
    ImpressionsMixin
  ],

  propTypes: {
    alt_text: React.PropTypes.string,
    frame_name: React.PropTypes.string,
    ga: React.PropTypes.object,
    image: React.PropTypes.string,
    sold_out: React.PropTypes.bool,
    sold_out_text: React.PropTypes.string,
    shop_links: React.PropTypes.array
  },

  getDefaultProps() {
    return {
      alt_text: "",
      frame_name: "",
      ga: {},
      image: "",
      sold_out: false,
      shop_links: []
    };
  },

  getFrameProps: function() {
    return {
      url: this.props.image,
      widths: this.getImageWidths(300, 1800, 8),
      quality: 100
    };
  },

  getStaticClasses() {
    return {
      block: `${this.BLOCK_CLASS} u-mla u-mra u-mw1440`,
      arrow: `${this.BLOCK_CLASS}__arrow`,
      copyWrapper: `u-w9c u-w7c--600 u-mla u-mra u-pl24--900`,
      frameImageWrapper: `
        ${this.BLOCK_CLASS}__frame-image-wrapper
        u-w11c u-w8c--600 u-mla u-mra u-tac
        u-mb24 u-mb36--600 u-mb72--900
      `,
      frameImage: `u-w12c`,
      frameName: `
        ${this.BLOCK_CLASS}__frame-name
        u-fs16 u-fs48--900
        u-color--black u-fwb
        u-mb18 u-mb24--600 u-mb36--900
      `,
      link: `${this.BLOCK_CLASS}__link u-fs16 u-fwb u-color--black`,
      linkWrapper: `${this
        .BLOCK_CLASS}__link-wrapper u-mb12 u-mb18--600 u-mb30--900
        u-pr
      `,
      shopLinksWrapper: `${this.BLOCK_CLASS}__shop-links-wrapper`,
      soldOut: `${this.BLOCK_CLASS}__sold-out u-color--black u-fwb u-fs16`,
      svg: `${this.BLOCK_CLASS}__svg`,
      svgWrapper: `${this.BLOCK_CLASS}__svg-wrapper`
    };
  },

  handleLinkClick(ga = {}) {
    const gender = this.GA_GENDER_LOOKUP[ga.gender];
    const name = `"${this.props.ga.name}"`;
    this.trackInteraction(`LandingPage-clickShop${gender}-${ga.sku}`);
    const productImpression = {
      brand: "Warby Parker",
      category: "sunglasses",
      collections: [{ slug: "offWhite" }],
      color: this.props.ga.color,
      gender: ga.gender,
      id: ga.id,
      name: name,
      position: this.props.ga.position,
      sku: ga.sku
    };

    this.commandDispatcher("analytics", "pushProductEvent", {
      type: "productClick",
      products: productImpression,
      eventMetadata: {
        list: "offWhite"
      }
    });
  },

  renderShopLinks(classes) {
    const children = this.props.shop_links.map((link, i) => {
      return (
        <div className={classes.linkWrapper} key={i}>
          <a
            href={link.href}
            className={classes.link}
            onClick={this.handleLinkClick.bind(this, link)}
          >
            <span children={link.text} />
            <span className={classes.svgWrapper}>
              <svg
                viewBox="0 0 208 168"
                height="12px"
                width="17px"
                strokeWidth={"1"}
                fillRule={"evenodd"}
                xmlns="http://www.w3.org/2000/svg"
                className={classes.svg}
              >
                <polygon points="110.63005 15.9798495 166.164449 73.0674444 0 73.0674444 0 94.9798827 166.164449 94.9798827 110.63005 152.323601 125.953632 168 208 84.0027839 125.956349 0" />
              </svg>
            </span>
          </a>
        </div>
      );
    });

    if (this.props.sold_out) {
      const soldOutText = this.props.sold_out_text || "Sold out";
      return <h1 className={classes.soldOut} children={soldOutText} />;
    } else {
      return children;
    }
  },

  render() {
    const frameSrcSet = this.getSrcSet(this.getFrameProps());
    const frameSizes = this.getImgSizes(this.FRAME_SIZES);
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <div className={classes.frameImageWrapper}>
          <Img
            srcSet={frameSrcSet}
            sizes={frameSizes}
            alt={this.props.alt_text}
            cssModifier={classes.frameImage}
          />
        </div>
        <div className={classes.copyWrapper}>
          <div
            children={`"${this.props.frame_name}"`}
            className={classes.frameName}
          />
          <div className={classes.shopLinksWrapper}>
            {this.renderShopLinks(classes)}
          </div>
        </div>
      </div>
    );
  }
});
