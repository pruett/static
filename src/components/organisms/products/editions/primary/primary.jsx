import _ from "lodash";
import React from "react/addons";
import { makeStartCase } from "hedeia/common/utils/string_formatting";
import ProductImageSlide from "components/molecules/products/slides/product_image/product_image";
import SliderActive from "components/molecules/sliders/active/active";
import AddToCart from "components/molecules/products/add_to_cart/add_to_cart";
import AddToCartWithApplePay from "components/molecules/products/add_to_cart_with_apple_pay/add_to_cart_with_apple_pay";
import Img from "components/atoms/images/img/img";
import ColorSwatches from "components/molecules/products/color_swatches/color_swatches";
import Mixins from "components/mixins/mixins";

import "./primary.scss";

const PRODUCT_SLIDE_IMAGES = {
  quality: 80,
  sizes: "(min-width: 1440px) 636px, (min-width: 900px) 50vw, 90vw",
  widths: [300, 600, 900, 1200]
};

module.exports = React.createClass({
  BLOCK_CLASS: "c-editions-primary",

  mixins: [Mixins.classes, Mixins.context, Mixins.dispatcher, Mixins.image],

  propTypes: {
    activeIndex: React.PropTypes.number,
    addToCart: React.PropTypes.func.isRequired,
    addToCartWithApplePay: React.PropTypes.func.isRequired,
    applePay: React.PropTypes.object,
    applePaySupported: React.PropTypes.bool,
    capabilities: React.PropTypes.object,
    changeQuantity: React.PropTypes.func.isRequired,
    editionsProduct: React.PropTypes.object,
    hasVariants: React.PropTypes.bool,
    freeShippingAndReturns: React.PropTypes.bool,
    schemaItemType: React.PropTypes.string,
    showMulti: React.PropTypes.bool,
    selectedQuantity: React.PropTypes.number
  },

  getDefaultProps() {
    return { applePay: {} };
  },

  getStaticClasses() {
    return {
      block: "u-tac",
      row: "u-grid__row",
      imageCol: `u-grid__col -col-middle u-w12c u-w7c--900 u-pb4x3 u-pb2x1--900 u-h0 u-mb12 u-pr`,
      carouselCol: `u-grid__col -col-middle u-w12c u-w7c--900 u-mb12 u-mb0--900 u-pr`,
      productImage: `${this.BLOCK_CLASS}__product-image u-pa u-center`,
      carouselImage: `${this.BLOCK_CLASS}__carousel-image u-pb4x3 u-h0`,
      detailsCol: `u-grid__col -col-middle u-w12c u-w5c--900 u-h0--900 u-pb2x1--900 u-pr`,
      detailsContainer: `${this
        .BLOCK_CLASS}__details-container u-pa--900 u-w100p u-center--900`,
      price: `u-mt0 u-mb6 u-fs24 u-fws u-ffs`,
      displayName: `u-mt0 u-mb6 u-fs24 u-fs30--900 u-fs40--1200 u-fws u-ffs`,
      color: `u-mt4 u-mt8--1200 u-fsi u-ffs u-color--dark-gray-alt-2 u-fwn u-fs18`,
      subtitle: `u-mt0 u-mb24 u-fs16 u-fs20--900 u-fs24--1200 u-fsi u-ffs u-color--dark-gray-alt-3`,
      addToCartSection: `${this
        .BLOCK_CLASS}__add-to-cart-section u-tac u-dib u-mb24`,
      purchaseNotice: `u-mt0 u-mb36 u-fs16 u-fsi u-ffs u-color--dark-gray-alt-3`
    };
  },

  getProductImage(images) {
    return images != null ? images.front : undefined;
  },

  getImgSrcSet(url, options) {
    const { quality, widths } = options;

    return widths
      .map(w => `${url}?width=${w}&quality=${quality} ${w}w`)
      .join(",");
  },

  componentDidMount() {
    const { editionsProduct } = this.props;

    if (
      this.getProductImage(
        editionsProduct != null ? editionsProduct.images : undefined
      )
    ) {
      return this.commandDispatcher("analytics", "pushProductEvent", {
        type: "productDetail",
        products: editionsProduct,
        eventMetadata: {
          list: `PDP_editions_${editionsProduct.class_key}`
        }
      });
    }
  },

  formatPrice(cents) {
    return (cents / 100).toFixed(2);
  },

  render() {
    const classes = this.getClasses();

    const {
      addToCart,
      addToCartWithApplePay,
      applePay,
      applePaySupported,
      changeQuantity,
      editionsProduct,
      hasVariants,
      schemaItemType,
      showMulti,
      selectedQuantity
    } = this.props;

    const {
      author,
      color,
      description,
      display_name,
      images,
      in_stock,
      price_cents,
      subtitle
    } = _.get(editionsProduct, `products[${this.props.activeIndex}]`, {});

    const addToCartProps = { addToCart, changeQuantity, selectedQuantity };

    const productImage = this.getProductImage(images);
    const formattedPrice = this.formatPrice(price_cents);

    const displayName = hasVariants
      ? _.get(editionsProduct, "group.name")
      : display_name;

    const hasMultipleImages = _.entries(images).length > 1;

    let sortedProductImages;
    if (hasMultipleImages) {
      // construct array with image keyed "front" ordered last
      sortedProductImages = _(images)
        .map((url, k) => ({ url, order: k === "front" ? 99 : 0 }))
        .sortBy("order")
        .value();
    }

    return (
      <section
        className={classes.block}
        itemScope={true}
        itemType={`http://schema.org/${schemaItemType}`}
      >
        <div className={classes.row}>
          {hasMultipleImages && showMulti ? (
            <div className={classes.carouselCol}>
              <SliderActive
                id="editions-product-slider"
                aria-label="Editions product images"
                capabilities={this.props.capabilities}
                cssModifier={classes.slider}
                initialActiveIndex={sortedProductImages.length - 1}
                showDots={true}
              >
                {_.map(sortedProductImages, (x, i) => {
                  return (
                    <ProductImageSlide
                      key={`editionsProduct-${i}`}
                      cssModifier={classes.carouselImage}
                      srcSet={this.getImgSrcSet(x.url, PRODUCT_SLIDE_IMAGES)}
                      altText={`${displayName}-${i}`}
                    />
                  );
                })}
              </SliderActive>
            </div>
          ) : productImage ? (
            <div className={classes.imageCol}>
              <Img
                alt={displayName}
                cssModifier={classes.productImage}
                itemProp="image"
                srcSet={this.getImgSrcSet(productImage, PRODUCT_SLIDE_IMAGES)}
              />
            </div>
          ) : null}
          <div className={classes.detailsCol}>
            <div className={classes.detailsContainer}>
              <p
                className={classes.price}
                itemProp="offers"
                itemScope={true}
                itemType="http://schema.org/Offer"
              >
                <span
                  children="$"
                  content={this.getLocale().currency}
                  itemProp="priceCurrency"
                />
                <span
                  children={formattedPrice}
                  content={formattedPrice}
                  itemProp="price"
                />
              </p>
              <h1
                children={displayName}
                className={classes.displayName}
                itemProp="name"
              />
              <p
                children={subtitle}
                className={classes.subtitle}
                content={author}
                itemProp="author"
              />
              {hasVariants && (
                <div>
                  <ColorSwatches
                    activeFrameAssemblyIndex={this.props.activeIndex}
                    frameAssemblies={editionsProduct.products}
                    version="nonEyewear"
                    handleColorChange={this.props.handleColorChange}
                  />
                  <h3 className={classes.color}>{makeStartCase(color)}</h3>
                </div>
              )}
              <div className={classes.addToCartSection}>
                {applePaySupported && in_stock ? (
                  <AddToCartWithApplePay
                    {...addToCartProps}
                    addToCartWithApplePay={addToCartWithApplePay}
                    errors={applePay.errors}
                  />
                ) : (
                  <AddToCart {...addToCartProps} inStock={in_stock} />
                )}
              </div>
              {this.props.freeShippingAndReturns && (
                <p
                  children="Free shipping and free returns"
                  className={classes.purchaseNotice}
                />
              )}
            </div>
          </div>
        </div>
      </section>
    );
  }
});
