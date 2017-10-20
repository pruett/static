const React = require("react/addons");
const { find } = require("lodash");
const Picture = require("components/atoms/images/picture/picture");

const { isProgRx, isPhoto } = require("components/utilities/products/variants");
const gridWrapper = require("components/utilities/grid_wrapper");

const Mixins = require("components/mixins/mixins");

require("./lens_details.scss");

module.exports = React.createClass({
  displayName: "AtomsProductsLensDetails",

  BLOCK_CLASS: "c-product-lens-details",

  TRANSITIONS_LP_PATH: "/light-responsive",

  mixins: [Mixins.classes, Mixins.dispatcher, Mixins.image],

  propTypes: {
    choices: React.PropTypes.array,
    borderBottom: React.PropTypes.bool,
    label: React.PropTypes.string,
    diagramImages: React.PropTypes.array,
    flip: React.PropTypes.bool,
    header: React.PropTypes.string,
    cssModifierTransition: React.PropTypes.string,
  },

  getDefaultProps() {
    return {
      choices: [],
      borderBottom: false,
      label: "",
      diagramImages: [],
      flip: false,
      header: "",
      cssModifierTransition: "",
    };
  },

  getStaticClasses() {
    return {
      block: `${this.BLOCK_CLASS}`,
      wrapper: `
        u-mla u-mra
        u-pt36 u-pb36
        u-pt60--900 u-pb60--900
        u-pr
        u-mw1440 u-mla u-mra
      `,
      imageWrapper: `
        ${this.BLOCK_CLASS}__image-wrapper
        u-oh
        u-mb30 u-mb0--900 u-pr
      `,
      image: `
        ${this.BLOCK_CLASS}__image
        u-w100p u-pa u-center-y
      `,
      sectionWrapper: `
        ${this.BLOCK_CLASS}__section-wrapper
        u-pl60--1200 u-w11c
        u-mla u-mra
      `,
      copyWrapper: `u-tal`,
      sectionHeader: `
        u-tac u-tal--900
        u-fs20 u-fs24--600 u-fs26--900 u-fs30--1200
        u-fws u-ffs
        u-mb30 u-mt48--600 u-mt0--900
      `,
      buttonContainer: `u-tac u-tal--900`,
      borderBottom: `${this.BLOCK_CLASS}__border-bottom`,
      button: `
        ${this.BLOCK_CLASS}__button
        u-reset u-ml4 u-mr4 u-fws u-fs12 u-mb6`,
      bullet: `
        ${this.BLOCK_CLASS}__bullet
        u-mb12 u-ffss
        u-fs16 u-fs18--900
      `,
      bulletList: `
        ${this.BLOCK_CLASS}__bullet-list
        u-reset
        u-pt12 u-pr
        u-w7c--600 u-w12c--900 u-mla u-mra
      `,
      imagerySection: `${this.BLOCK_CLASS}__imagery-section u-w6c--900 `,
      detailSection: `${this
        .BLOCK_CLASS}__detail-section u-w6c--900 u-pa--900 u-center-y--900`,
      transitionsLink: `u-pl18 u-fws`,
      separator: `
        ${this.BLOCK_CLASS}__separator
        u-w12c
        u-mla u-mra
      `,
      flexWrapper: `${this.BLOCK_CLASS}__flex-wrapper u-pr--900`,
      reset: `u-reset`,
    };
  },

  classesWillUpdate() {
    return {
      imagerySection: {
        "u-pr--900 u-l6c--900": this.props.flip,
        "u-l0--900": !this.props.flip,
      },
      detailSection: {
        "u-r0--900": !this.props.flip,
        "u-l0--900": this.props.flip,
      },
      button: {
        "-short": this.props.label === "prescription_offerings",
        "-long": this.props.label === "lens_offerings",
      },
    };
  },

  getActiveClass(variants) {
    return variants.indexOf(this.props.selectedVariantType) > -1
      ? "-active"
      : "";
  },

  getPictureAttrs(images) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, "desktop-sd"),
          widths: this.getImageWidths(800, 1200, 5),
          mediaQuery: "(min-width: 900px)",
        },
        {
          url: this.getImageBySize(images, "tablet"),
          widths: this.getImageWidths(700, 1200, 5),
          mediaQuery: "(min-width: 600px)",
        },
        {
          url: this.getImageBySize(images, "mobile"),
          widths: this.getImageWidths(300, 800, 5),
          mediaQuery: "(min-width: 0px)",
        },
      ],
      img: {
        alt: "Warby Parker",
        className: "u-db u-w11c u-w10c--600 u-w12c--900",
      },
    };
  },

  renderImagery(classes) {
    const images = this.props.diagramImages || [];
    const imageChildren = images.map((imageGroup, i) => {
      let isActive;
      if (this.props.label === "prescription_offerings") {
        isActive =
          isProgRx(this.props.selectedVariantType) && i === 1 ? "-active" : "";
      } else {
        isActive =
          isPhoto(this.props.selectedVariantType) && i === 1 ? "-active" : "";
      }

      const cssModifierPosition = i === 0 ? "-bottom" : "-top";
      const cssModifierOrientation = this.props.flip ? "-flip" : "";
      const pictureAttrs = this.getPictureAttrs(imageGroup);
      const cssModifierTransition = this.props.cssModifierTransition;

      const cssModifiers = `
        ${classes.image}
        ${cssModifierPosition}
        ${cssModifierOrientation}
        ${isActive}
        ${i === 1 ? cssModifierTransition : ""}
      `
        .replace(/\s+/g, " ")
        .trim();

      return (
        <Picture
          cssModifier={cssModifiers}
          children={this.getPictureChildren(pictureAttrs)}
          key={i}
        />
      );
    });
    return <div className={classes.imageWrapper} children={imageChildren} />;
  },

  renderCopy(classes) {
    const activeSection = find(
      this.props.choices,
      choice => choice.variants.indexOf(this.props.selectedVariantType) > -1
    );
    const bulletpoints = (activeSection && activeSection.bulletPoints) || [];

    const bullets = bulletpoints.map((bulletPoint, i) => {
      return <li className={classes.bullet} children={bulletPoint} key={i} />;
    });

    return (
      <div className={classes.sectionWrapper}>
        <div className={classes.copyWrapper}>
          <div children={this.props.header} className={classes.sectionHeader} />
          <div
            children={this.renderButtons(classes)}
            className={classes.buttonContainer}
          />
          <div className={classes.bulletList}>
            <ul children={bullets} className={classes.reset} />
            {activeSection.key === "photo" &&
              <a
                href={this.TRANSITIONS_LP_PATH}
                children="Learn more"
                target={"_blank"}
                className={classes.transitionsLink}
              />}
          </div>
        </div>
      </div>
    );
  },

  renderButtons(classes) {
    const buttonChildren = this.props.choices.map((button, i) => {
      return (
        <button
          className={`${classes.button} ${this.getActiveClass(
            button.variants
          )}`}
          children={button.text}
          key={i}
          onClick={() => this.props.handleButtonClick(button.key)}
        />
      );
    });
    return buttonChildren;
  },

  renderBorderBottom(classes) {
    return <div className={classes.borderBottom} />;
  },

  render() {
    const classes = this.getClasses();

    return (
      <div className={classes.block} key={this.props.key}>
        <div className={classes.wrapper}>
          <div className={classes.flexWrapper}>
            <div
              className={classes.imagerySection}
              children={this.renderImagery(classes)}
            />
            <div
              className={classes.detailSection}
              children={this.renderCopy(classes)}
            />
          </div>
        </div>
        {this.props.borderBottom &&
          gridWrapper(<div className={classes.separator} />)}
      </div>
    );
  },
});
