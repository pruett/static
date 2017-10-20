const _ = require("lodash");
const AddButton = require("components/molecules/products/add_button/add_button");
const Breadcrumbs = require("components/atoms/breadcrumbs/breadcrumbs");
const CollectionDetails = require("components/molecules/products/collection_details/collection_details");
const Darcel = require("components/molecules/products/darcel/darcel");
const DetailsContainer = require("components/molecules/products/details_container/details_container");
const Img = require("components/atoms/images/img/img");
const InsuranceDrawer = require("components/molecules/insurance_drawer/insurance_drawer");
const LensDetails = require("components/atoms/products/lens_details/lens_details");
const LensDetailsContainer = require("components/molecules/products/lens_details_container/lens_details_container");
const LiteraryCallout = require("components/molecules/literary_callout/literary_callout");
const LowBridgeFitDetails = require("components/molecules/products/low_bridge_fit_details/low_bridge_fit_details");
const ProductAttributes = require("components/molecules/products/attributes/attributes");
const ProductCrossSells = require("components/molecules/products/product_cross_sells/product_cross_sells");
const ProductImageSlide = require("components/molecules/products/slides/product_image/product_image");
const React = require("react/addons");
const SliderActive = require("components/molecules/sliders/active/active");
const TechnicalDetails = require("components/molecules/products/technical_details/technical_details");
const ATC = require("./components/atc/atc");
const Mixins = require("components/mixins/mixins");
const ProductSchema = require("components/atoms/structured_data/product/product");
const ImageObjectSchema = require("components/atoms/structured_data/image_object/image_object");

const gridWrapper = require("components/utilities/grid_wrapper");
const {
  getNextVariant,
  VARIANTS,
} = require("components/utilities/products/variants");

require("./frames.scss");

module.exports = React.createClass({
  displayName: "cProductFrames",
  BLOCK_CLASS: "c-product-frames",
  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.context,
    Mixins.conversion,
    Mixins.dispatcher,
    Mixins.scrolling,
    Mixins.image,
  ],

  propTypes: {
    activeColorIndex: React.PropTypes.number,
    activeProduct: React.PropTypes.object,
    applePay: React.PropTypes.object,
    callouts: React.PropTypes.array,
    colors: React.PropTypes.array,
    expandDrawer: React.PropTypes.bool,
    technicalDetails: React.PropTypes.array,
    photoEnabled: React.PropTypes.bool,
    photoVariant: React.PropTypes.string,
    photoV2Enabled: React.PropTypes.bool,
  },

  getDefaultProps() {
    return {
      activeColorIndex: 0,
      activeProduct: {},
      applePay: {},
      callouts: [],
      colors: [],
      content: {},
      expandDrawer: false,
      htoMode: false,
      photoEnabled: false,
      photoVariant: "",
      photoV2Enabled: false,
      technicalDetails: [],
      variantTypes: {
        eyeglasses: ["rx", "prog_rx"],
        sunglasses: ["non_rx", "rx", "prog_rx"],
      },
      staffGallery: false,
    };
  },

  componentWillReceiveProps(nextProps) {
    if (nextProps.selectedVariantType !== this.props.selectedVariantType) {
      this.setState({ educationVariant: nextProps.selectedVariantType });
    }
  },

  getInitialState() {
    return {
      activeImageIndex: 0,
      educationVariant: VARIANTS.rx,
      expandDrawer: this.props.expandDrawer,
      hasScrolled: false,
      atcStepIndex: 0,
      atcStepChanged: false,
      showAtc: false,
    };
  },

  getStaticClasses() {
    const baseHrClasses = `${this.BLOCK_CLASS}__details-hr
      u-bss u-btw0 u-blw0 u-bbw1 u-brw0 u-bc--light-gray-alt-1`;

    return {
      block: `${this.BLOCK_CLASS}
        u-clearfix
        u-oh--900`,
      container: "u-pr",
      header: `u-pr u-oh`,
      main: `${this.BLOCK_CLASS}__main u-grid -maxed u-mla u-mra`,
      slider: "u-mla u-mra u-w12c u-w11c--900",
      productImageSlide: `${this.BLOCK_CLASS}__product-image-slide`,
      attributesAddButtons:
        "u-clearfix u-mb48 u-pr u-tac u-mw600 u-mla--600 u-mra--600",
      beforeDetailsHr: `${baseHrClasses} u-mb0`,
      afterDetailsHr: `${baseHrClasses} u-mt0--900`,
      lowBridgeFitDetailsHr: `${baseHrClasses} u-mt0--900`,
      supplementSection: `u-mt48 u-mb54 u-clearfix u-tal`,
      literaryCalloutReplacement: `
        ${this.BLOCK_CLASS}__literary-callout-replacement
        u-hr
        u-wauto
        u-cb`,
      addButton: `u-dib u-pr
        u-w100p u-wauto--720`,
      htoButton: "u-tar",
      addButtons: `${this.BLOCK_CLASS}__add-buttons
        u-w100p u-wauto--600
        u-mt24 u-mt0--1200
        u-p0--600 u-pb12--1200
        u-tac
        u-dib`,
      addToFavorites: "u-pa u-r0 u-pt2 u-b0 u-t0 u-mt12 u-mt8--600 u-mr18--600",
      oonCallout: `
        u-ffss u-mra u-mla u-tac u-color--dark-gray-alt-3 u-lh24
        u-mb10--600`,
      oonLink:
        "u-reset--button u-fws u-dib u-di--600 u-color--blue u-link--hover",
      divider: `
        ${this.BLOCK_CLASS}__divider
        u-color-bg--light-gray
        u-ffss u-fs12 u-fws u-color--dark-gray-alt-2
        u-mt18 u-mb18
        u-pr`,
      collectionLogoWrapper: `
        u-tac
        u-mla u-mra
        u-w8c u-w4c--600 u-w3c--900
        u-mb8 u-mb12--600
        `,
      collectionLogo: `u-w100p`,
    };
  },

  classesWillUpdate() {
    const canHto = this.getFeature("homeTryOn");
    const isLowBridgeFit = this.props.activeProduct.is_low_bridge_fit;
    const htoOnly = this.props.htoMode && this.inExperiment('pdpAtcHtoMode', 'htoOnly');
    const htoPrimary = this.props.htoMode && _.includes(this.getExperimentVariant('pdpAtcHtoMode'), 'hto');

    return {
      addButtons: {
        "u-pt30--1200": isLowBridgeFit,
        "u-pt18--1200": !isLowBridgeFit,
      },
      addButton: {
        "u-mw50p--600": canHto && !htoOnly,
        "u-fr--600": canHto && !htoPrimary,
      },
      htoButton: {
        "u-pr4--600": !htoOnly,
        "u-pt8 u-pt0--600": !htoPrimary,
        "u-pb8 u-pb0--600": htoPrimary && !htoOnly,
      },
      purchaseButton: {
        "u-tal u-pl4--600": canHto,
      },
      header: {
        "u-pb24 u-pb0--900": this.shouldShowAtc(),
      },
      oonCallout: {
        "u-mt24": !htoOnly,
        "u-mt18 u-mt6--1200": htoOnly,
      }
    };
  },

  getBreadcrumbLinks(path) {
    // Drop the colorway at the end.
    const urlPieces = _.dropRight(path.split("/"));

    return _.reduce(
      urlPieces,
      (acc, piece, i) => {
        const link = { text: this.formatPathDashes(piece) };

        if (i < urlPieces.length - 1) {
          // Unless it's the last piece of the path, build an href value.
          link.href = `${i < 1 ? "" : acc[i - 1].href}/${piece}`;
        }

        return acc.concat(link);
      },
      []
    );
  },

  formatPathDashes(string) {
    return string.replace(/--/g, "‑").replace(/-/g, " "); // Replace double dash with non-breaking dash (U+2011).
  }, // Replace single dash with single space.

  renderDefaultSlides(colorData, classes, acc, type, i) {
    const imageSet = _.get(
      colorData,
      `variants.${this.props.selectedVariantType}.image_set.clear_fill.${type}`,
      _.get(colorData, `image_set.clear_fill.${type}`)
    );

    if (imageSet) {
      const displayName = _.get(colorData, "display_name", "");
      const displayColor = _.startCase(_.get(colorData, "color", ""));

      acc.push(
        <ProductImageSlide
          key={`${type}-${this.props.activeColorIndex}`}
          cssModifier={this.classes.productImageSlide}
          imageSet={imageSet}
          altText={`${_.startCase(type)} of ${displayName} in ${displayColor}`}
        />
      );
    }

    return acc;
  },

  getSlides() {
    const classes = this.getClasses();
    const colorData = this.props.activeProduct;

    return _.reduce(
      ["front", "angle", "side"],
      this.renderDefaultSlides.bind(this, colorData, classes),
      []
    );
  },


  manageChangeActiveImageIndex(newIndex) {
    this.setState({ activeImageIndex: newIndex });
  },

  componentDidUpdate(prevProps, prevState) {
    if (
      this.state.expandDrawer &&
      !prevState.expandDrawer &&
      !this.state.hasScrolled
    ) {
      this.scrollToNode(document.querySelector(".c-insurance-drawer"), {
        time: 500,
        easing: "linear",
      });
      this.setState({ hasScrolled: true });
    }
  },

  shouldShowOonMessaging() {
    return _.includes(
      ["showPDP", "showBoth"],
      this.getExperimentVariant("oonMessaging")
    );
  },

  toggleOonDrawer(evt) {
    evt.preventDefault();

    const action = this.state.expandDrawer ? "close" : "open";
    this.clickInteraction(`${action}InsuranceDrawer`);

    this.setState({ expandDrawer: !this.state.expandDrawer });
  },

  handleClickBuyInstead(evt) {
    this.clickInteraction('buyInstead');
    this.commandDispatcher('frameProduct', 'switchToPurchaseMode');
  },

  toggleAtc() {
    if (!this.state.showAtc) {
      this.scrollToNode(document.querySelector(`.${this.BLOCK_CLASS}`), {
        time: 500,
      });
    } else {
      this.trackInteraction(this.getAtcAnalyticsSlug("closeAtc"));
    }
    this.setState({ showAtc: !this.state.showAtc });
  },

  isActiveColorFavorited() {
    return this.props.favorites.indexOf(this.props.activeProduct.id) > -1;
  },

  getActiveVariants() {
    const color = this.props.activeProduct;
    const active = _.get(this.props.variantTypes, color.assembly_type, []);
    return _.pick(color.variants, active);
  },

  getLowestPrice() {
    const lowestPrice = _.reduce(
      this.getActiveVariants(),
      function(acc, attrs) {
        if (attrs.price_cents < acc || !acc) {
          return attrs.price_cents;
        } else {
          return acc;
        }
      },
      null
    );

    return parseInt(this.convert("cents", "dollars", lowestPrice), 10);
  },

  getMinPrice() {
    let price = this.getLowestPrice();
    if (price === "0.00") {
      price = (parseInt(this.getFeature("basePriceCents"), 10) / 100).toFixed();
    }

    return price;
  },

  MONOCLE_ID: 1240,
  getLensType() {
    if (this.props.activeProduct.id === this.MONOCLE_ID) {
      // monocle product id
      return "a prescription lens";
    } else if (this.props.activeProduct.assembly_type === "eyeglasses") {
      return "prescription lenses";
    } else if (this.props.activeProduct.polarized_lenses) {
      return "polarized lenses";
    }
  },

  getProductPurchaseProps() {
    const props = _.pick(
      this.props.activeProduct,
      "assembly_type",
      "color",
      "display_name",
      "clip_on",
      "gender",
      "id",
      "variants",
      "visible",
      "description_callout"
    );

    if (this.props.photoV2Enabled) {
      // Override click if in experiment.
      props.handleCtaClick = this.toggleAtc;
    }

    return _.assign(props, {
      addedVia: "pdp",
      analyticsCategory: "addButtonPdp",
      applePay: this.props.applePay,
      cssModifier: `${this.classes.addButton} ${this.classes.purchaseButton}`,
      eligibleForPopover:
        !this.props.activeProduct.is_sun || _.get(this.props, "applePay.isApplePayCapable"),
      manageChangeSelectedVariantType: this.props.manageChangeSelectedVariantType,
      photoEnabled: this.props.photoEnabled,
      photoVariant: this.props.photoVariant,
      size: "large",
      text: "Add to cart",
    });
  },

  getProductHTOProps() {
    const props = _.pick(
      this.props.activeProduct,
      "assembly_type",
      "color",
      "display_name",
      "gender",
      "id",
      "variants",
      "visible"
    );

    return _.assign(props, {
      addedVia: "pdp",
      analyticsCategory: "addButtonPdp",
      cssModifier: `${this.classes.addButton} ${this.classes.htoButton}`,
      cart: _.get(this.props, "session.cart", {}),
      variantTypes: "hto",
      size: "large",
    });
  },

  scrollToLearning(i) {
    this.scrollToNode(document.querySelectorAll(`.js-learning-${i}`)[1], {
      time: 500,
    });
  },

  getAtcAnalyticsSlug(target, action = "click") {
    return `photoPdp-${action}-${_.camelCase(target)}`;
  },

  getAtcProps() {
    const props = _.pick(
      this.props,
      "activeColorIndex",
      "colors",
      "applePay",
      "manageAddItem",
      "selectedVariantType"
    );

    // Link up handlers + add analytics.
    props.stepIndex = this.state.atcStepIndex;
    props.stepHasChanged = this.state.atcStepChanged;
    props.toggleAtc = this.toggleAtc;
    props.manageAddItem = attrs => {
      this.trackInteraction(
        this.getAtcAnalyticsSlug(`add-${this.props.selectedVariantType}`)
      );
      this.props.manageAddItem(attrs);
    };
    props.manageChangeStepIndex = index => {
      this.trackInteraction(this.getAtcAnalyticsSlug(`step${index}`));
      this.setState({ atcStepIndex: index, atcStepChanged: true });
    };
    props.scrollToLearning = i => {
      this.trackInteraction(this.getAtcAnalyticsSlug(`learnMore${i}`, "click"));
      this.scrollToNode(document.querySelectorAll(`.js-learning-${i}`)[1], {
        time: 500,
      });
    };

    props.manageClickSelectLenses = () => {
      this.trackInteraction(this.getAtcAnalyticsSlug(`selectLenses`));
      this.setState({ atcStepIndex: 1, atcStepChanged: true });
    };

    props.manageApplePay = attrs => {
      this.trackInteraction(
        this.getAtcAnalyticsSlug(`applePay-${this.props.selectedVariantType}`)
      );
      this.props.manageApplePay(attrs);
    };
    props.handleClickChoice = variant => {
      this.trackInteraction(
        this.getAtcAnalyticsSlug(`variantOption-${variant}`)
      );
      this.props.manageChangeSelectedVariantType(
        getNextVariant(this.props.selectedVariantType, variant)
      );
    };

    return props;
  },

  getInitialSelectedVariant(props) {
    const variantTypes = _.get(
      this.props.variantTypes,
      props.assembly_type,
      []
    );
    return _.find(variantTypes, variant => {
      return _.get(props.variants, `${variant}.in_stock`);
    });
  },

  getHeadturnProps() {
    // Try to use the active color if it has a headturn.
    // Otherwise, use the first color with a headturn.
    const sourceColor = this.colorHasHeadturn(this.props.activeProduct)
      ? this.props.activeProduct
      : _.find(this.props.colors, (color) => {
        return this.colorHasHeadturn(color);
      });

    if(sourceColor) {
      return {
        analyticsCategory: sourceColor.analytics_category,
        alt: `${sourceColor.display_name} in ${_.startCase(sourceColor.color)}`,
        urls: _.map(sourceColor.sized_headturn_image_set, function(imageSet, key) {
          const { modes, images } = imageSet;
          return {
            size: key,
            image: images.map(image => `${modes.fill}/${image}`),
          }
        })
      };
    }
  },

  colorHasHeadturn(color) {
    return _.every(["s", "m", "l"], key => {
      return _.has(color, `sized_headturn_image_set.${key}.images`);
    });
  },

  getCollectionLogoProps(collectionContent) {
    return {
      url: collectionContent.logo_img,
      widths: [400, 500, 600, 700, 800, 900],
    };
  },

  collectionLogoSizes: [
    {
      breakpoint: 0,
      width: "80vw",
    },
    {
      breakpoint: 600,
      width: "70vw",
    },
    {
      breakpoint: 900,
      width: "25vw",
    },
  ],

  // Check if PDP is for the monocole, our only 'genderless' product
  // hence, only one product id
  isMonocle() {
    return this.props.activeProduct.id === this.MONOCLE_ID;
  },

  renderCollectionLogo(collectionContent) {
    const logoSrc = this.getSrcSet(
      this.getCollectionLogoProps(collectionContent)
    );
    const sizes = this.getImgSizes(this.collectionLogoSizes);
    return (
      <div className={this.classes.collectionLogoWrapper}>
        <Img
          srcSet={logoSrc}
          sizes={sizes}
          alt=""
          cssModifier={this.classes.collectionLogo}
        />
      </div>
    );
  },

  renderLensDetails() {
    const displayShapes = _.get(this.props, "colors[0].display_shape");
    const gender = _.get(this.props, "colors[0].gender");

    const LensDetailsWithData = LensDetailsContainer(LensDetails);
    return (
      <LensDetailsWithData
        selectedVariantType={this.state.educationVariant}
        handleButtonClick={variant => {
          this.trackInteraction(this.getAtcAnalyticsSlug(`learn-${variant}`));
          this.setState({
            educationVariant: getNextVariant(
              this.state.educationVariant,
              variant
            ),
          });
        }}
        gender={gender}
        displayShapes={displayShapes}
      />
    );
  },

  shouldShowAtc() {
    return (
      this.props.photoV2Enabled &&
      !this.props.activeProduct.is_sun &&
      this.state.showAtc
    );
  },

  getAddToFavoritesProps() {
    return this.props.showFavorites
      ? {
          cssModifier: this.classes.addToFavorites,
          product_id: this.props.activeProduct.id,
          isFavorited: this.isActiveColorFavorited(),
        }
      : null;
  },

  render() {
    this.classes = this.getClasses();

    const activeColor = this.props.activeProduct;
    const collectionContent = this.props.content.collectionContent;
    const sliderId = `${this.BLOCK_CLASS}__image-slider`;
    const recommendations = this.props.activeProduct.recommendations || [];
    const technicalDetails = _.get(this.props, 'content.details.bullet_points', []);

    const htoPrimary = this.props.htoMode && _.includes(this.getExperimentVariant('pdpAtcHtoMode'), 'hto');
    const htoOnly = this.props.htoMode && this.inExperiment('pdpAtcHtoMode', 'htoOnly');

    return (
      <div className={this.classes.block} id="pdp__frame">
        <div className={`${this.shouldShowAtc() ? "u-dn u-db--900" : ""}`}>
          <Breadcrumbs links={this.getBreadcrumbLinks(activeColor.path)} />
        </div>
        <header className={this.classes.header}>
          {this.shouldShowAtc() && <ATC {...this.getAtcProps()} />}

          <main className={this.classes.main}>

            <SliderActive
              id={sliderId}
              aria-label="Product images"
              capabilities={this.props.capabilities}
              children={this.getSlides()}
              cssModifier={this.classes.slider}
              initialActiveIndex={this.state.activeImageIndex}
              manageChangeActiveIndex={this.manageChangeActiveImageIndex}
              showDots={true}
            />

            {collectionContent &&
              Boolean(_.get(collectionContent, "logo")) &&
              this.renderCollectionLogo(collectionContent)}

            <section className={this.classes.attributesAddButtons}>

              <ProductAttributes
                activeColorIndex={this.props.activeColorIndex}
                addToFavoritesProps={this.getAddToFavoritesProps()}
                colors={this.props.colors}
                hideMessage={htoOnly}
                htoMode={this.props.htoMode}
                lowestPrice={this.getLowestPrice()}
                lensType={this.getLensType()}
                manageChangeColor={this.props.manageChangeColor}
                selectedVariantType={this.props.selectedVariantType}
                swatchAriaControls={sliderId}
              />

              <div className={this.classes.addButtons}>
                {!htoOnly && !htoPrimary &&
                  <AddButton
                    {...this.getProductPurchaseProps()}
                    primary={true} />}
                {this.getFeature("homeTryOn") &&
                  <AddButton
                    {...this.getProductHTOProps()}
                    cssModifier={this.getProductHTOProps().cssModifier}
                    primary={htoPrimary}
                  />}
                {!htoOnly && htoPrimary &&
                  <AddButton
                    {...this.getProductPurchaseProps()}
                    primary={false} />}
              </div>

              {!this.shouldShowAtc() &&
                this.shouldShowOonMessaging() &&
                !htoOnly &&
                <div className={this.classes.oonCallout}>
                  <span children="Save with your FSA, HSA, or vision insurance. " />
                  <button
                    className={this.classes.oonLink}
                    onClick={this.toggleOonDrawer}
                    children="Here’s how."
                  />
                </div>}

              {htoOnly &&
                <div className={this.classes.oonCallout}>
                  <span children="Looking to purchase? " />
                  <button
                    className={this.classes.oonLink}
                    onClick={this.handleClickBuyInstead}
                    children={`Buy from $${this.getLowestPrice()}`}
                  />
                </div>}

            </section>

            {!this.shouldShowAtc() &&
              this.shouldShowOonMessaging() &&
              <InsuranceDrawer
                handleClose={this.toggleOonDrawer}
                isOpen={this.state.expandDrawer}
              />}

          </main>
        </header>

        {collectionContent &&
          Boolean(_.get(collectionContent, "content")) &&
          <div>
            <CollectionDetails {...collectionContent} />
            <hr className={this.classes.beforeDetailsHr} />
          </div>}

        {!this.isMonocle()
          ? <DetailsContainer
              activeProduct={this.props.activeProduct}
              fitThumbnail={_.get(this.props, 'content.fitImages.thumbnail')}
              headturns={this.getHeadturnProps()}
              photoV2Enabled={this.props.photoV2Enabled}
              staffGallery={this.props.staffGallery}
              technicalDetails={technicalDetails}
            />
          : gridWrapper(
              <Darcel content={_.get(this.props, "content.contentDarcel", {})} />
            )}

        {activeColor.is_low_bridge_fit &&
          !_.isEmpty(this.props.content.lowBridgeFit) &&
          gridWrapper([
            <LowBridgeFitDetails
              key="supplementSection"
              activeColor={activeColor}
              content={this.props.content.lowBridgeFit}
              cssModifier={this.classes.supplementSection}
            />,
            <hr
              className={this.classes.lowBridgeFitDetailsHr}
              key="supplementSectionHr"
            />,
          ])}

        {!this.props.photoV2Enabled &&
          technicalDetails.length > 0 &&
          !this.isMonocle() &&
          gridWrapper(
            <TechnicalDetails details={technicalDetails} />
          )}

        {this.props.photoV2Enabled && this.renderLensDetails()}

        {this.getFeature("freeReturns") && this.getFeature("freeShipping")
          ? gridWrapper(
              <LiteraryCallout
                photoV2Enabled={this.props.photoV2Enabled}
                label="Our Promise"
                headline="Free shipping and free returns, always"
                copy={`We have a 30-day, no-questions-asked return policy for all our frames \
    as well as a one-year, no-scratch guarantee for our lenses; we’ll \
    replace your scratched lenses for free within the first 12 months.`}
              />
            )
          : gridWrapper(
              <hr className={this.classes.literaryCalloutReplacement} />
            )}

        {recommendations.length > 0 &&
          !this.isMonocle() &&
          gridWrapper(
            <ProductCrossSells
              baseProduct={activeColor}
              products={recommendations}
            />
          )}

        <ProductSchema product={this.props.activeProduct} lowestPrice={this.getMinPrice()} />

        {_.map(this.getSlides(), (slide, index) => (
          <ImageObjectSchema key={index} contentUrl={slide.props.imageSet.original} description={slide.props.altText} />
        ))}

      </div>
    );
  },
});
