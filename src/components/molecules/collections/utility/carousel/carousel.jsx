const React = require("react/addons");
const _ = require("lodash");

const Swatches = require("components/molecules/products/color_swatches/color_swatches");
const Img = require("components/atoms/images/img/img");

const Mixins = require("components/mixins/mixins");

const ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

require("./carousel.scss");

module.exports = React.createClass({
  displayName: "CollectionUtilityCarousel",

  BLOCK_CLASS: "c-collection-utility-carousel",

  SHOP_LINK_LOOKUP: {
    m: "Shop Men",
    f: "Shop Women"
  },

  GA_GENDER_LOOKUP: {
    m: "Men",
    f: "Women"
  },

  IMAGE_SIZES: [
    {
      breakpoint: 0,
      width: "80vw"
    },
    {
      breakpoint: 600,
      width: "60vw"
    }
  ],

  mixins: [Mixins.classes, Mixins.image, Mixins.analytics, Mixins.dispatcher],

  propTypes: {
    products: React.PropTypes.array,
    version: React.PropTypes.string,
    gaCollectionSlug: React.PropTypes.string,
    gaListModifier: React.PropTypes.string,
    gaPosition: React.PropTypes.number,
    gaCategory: React.PropTypes.string,
    cssModifier: React.PropTypes.string,
    cssModifierImageWrapper: React.PropTypes.string,
    cssModifierFrameName: React.PropTypes.string,
    cssModifierShopLink: React.PropTypes.string
  },

  getInitialState: function() {
    return {
      activeIndex: 0
    };
  },

  getDefaultProps: function() {
    return {
      products: [],
      version: "fans",
      gaListModifier: "WarbyParker",
      gaPosition: 0,
      gaCollectionSlug: "Warby Parker",
      gaCategory: "LandingPage",
      cssModifier: "u-dib u-w100p u-w5c--600 u-mb48",
      cssModifierImageWrapper: "",
      cssModifierFrameName: "u-fws u-fs24 u-ffs u-mb18",
      cssModifierShopLink: "u-pb6 u-bbss u-bbw2 u-bbw0--900 u-bc--blue u-fws"
    };
  },

  getStaticClasses: function() {
    return {
      block: `
        c-collection-utility-carousel
        ${this.props.cssModifier}
      `,
      copyWrapper: `
        ${this.BLOCK_CLASS}__copy-wrapper
        u-h0 u-pr
      `,
      imageBlockWrapper: "u-pr",
      imageWrapper: `
        u-h0 u-pb3x1
        ${this.props.cssModifierImageWrapper}
      `,
      image: "u-pa u-t0 u-l0 u-w100p",
      linkWrapper: "u-tac",
      shopLink: `
        ${this.BLOCK_CLASS}__shop-link
        ${this.props.cssModifierShopLink}
      `,
      swatchWrapper: "u-tac u-mb18",
      frameName: `
        ${this.props.cssModifierFrameName}
        u-reset
        u-tac
      `,
      soldOut: `u-fs16 u-fws`
    };
  },

  handleColorChange: function(newIndex) {
    this.setState({ activeIndex: newIndex });
  },

  handleProductClick: function(gaData = {}) {
    this.trackInteraction(
      `${this.props.gaCategory}-clickShop${this.GA_GENDER_LOOKUP[
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
        list: gaData.list
      }
    });
  },

  getImageProps: function(activeProduct) {
    return {
      url: activeProduct.image,
      widths: this.getImageWidths(300, 600, 4)
    };
  },

  getLinkChildren: function(details, classes) {
    const activeProduct = this.props.products[this.state.activeIndex];
    const children = details.map((detail, i) => {
      const gaData = {
        color: activeProduct.color,
        name: activeProduct.display_name,
        collections: [
          {
            slug: this.props.gaCollectionSlug
          }
        ],
        list: this.props.gaListModifier,
        type: activeProduct.assembly_type,
        sku: activeProduct.sku,
        gender: detail.gender,
        id: detail.product_id,
        path: detail.path,
        position: this.props.gaPosition
      };

      const href = _.startsWith(detail.path, "/")
        ? detail.path
        : `/${detail.path}`;
      return (
        <a
          children={this.SHOP_LINK_LOOKUP[detail.gender]}
          href={href}
          key={i}
          onClick={this.handleProductClick.bind(this, gaData)}
          className={classes.shopLink}
        />
      );
    });

    return children;
  },

  renderImagery: function(classes) {
    const activeProduct = this.props.products[this.state.activeIndex];
    const imgSrcSet = this.getSrcSet(this.getImageProps(activeProduct));
    const imgSizes = this.getImgSizes(this.IMAGE_SIZES);
    const image = (
      <ReactCSSTransitionGroup
        transitionName={"-transition-toggle"}
        transitionAppear={false}
      >
        <Img
          srcSet={imgSrcSet}
          sizes={imgSizes}
          alt={`Warby Parker ${activeProduct.display_name} Frame`}
          key={activeProduct.color}
          cssModifier={classes.image}
        />
      </ReactCSSTransitionGroup>
    );

    if (this.props.version === "fans") {
      // Use links to direct users to PDPs
      return <div className={classes.imageWrapper} children={image} />;
    } else {
      // The image itself will be a link
      const search = { gender: this.props.version };
      const genderedDetails =
        _.find(activeProduct.gendered_details, search) || {};
      const gaData = {
        color: activeProduct.color,
        name: activeProduct.display_name,
        collections: [
          {
            slug: activeProduct.gaCollectionSlug
          }
        ],
        list: this.props.gaListModifier,
        type: activeProduct.assembly_type,
        sku: activeProduct.sku,
        gender: genderedDetails.gender,
        id: genderedDetails.product_id,
        path: genderedDetails.path,
        position: this.props.gaPosition
      };
      return (
        <div className={classes.imageWrapper}>
          <a
            href={genderedDetails.path}
            children={image}
            onClick={this.handleProductClick.bind(this, gaData)}
          />
        </div>
      );
    }
  },

  renderLinks: function(classes) {
    if (this.props.version !== "fans") {
      return false;
    }

    const activeProduct = this.props.products[this.state.activeIndex];
    if (activeProduct.sold_out) {
      return this.renderSoldOut(classes);
    }
    const details = activeProduct.gendered_details || [];
    const linkChildren = this.getLinkChildren(details, classes);

    return <div className={classes.linkWrapper} children={linkChildren} />;
  },

  renderSwatches: function(classes) {
    return (
      <div className={classes.swatchWrapper}>
        <Swatches
          frameAssemblies={this.props.products}
          handleColorChange={this.handleColorChange}
          gaCollectionSlug={this.props.gaCollectionSlug}
          gaListModifier={this.props.gaListModifier}
          position={this.props.gaPosition}
          activeFrameAssemblyIndex={this.state.activeIndex}
        />
      </div>
    );
  },

  renderSoldOut: function(classes) {
    return <div children="Sold out" className={classes.soldOut} />;
  },

  render: function() {
    const classes = this.getClasses();
    const activeProduct = this.props.products[this.state.activeIndex];

    return (
      <div className={classes.block}>
        <div
          className={classes.imageBlockWrapper}
          children={this.renderImagery(classes)}
        />
        <div className={classes.copyWrapper}>
          <h3
            children={activeProduct.display_name}
            className={classes.frameName}
          />
        </div>
        {this.renderSwatches(classes)}
        {this.renderLinks(classes)}
      </div>
    );
  }
});
