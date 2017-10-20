const React = require("react/addons");
const Slider = require("components/molecules/collections/utility/slider/slider");
const Mixins = require("components/mixins/mixins");

require("./lifestyle_section.scss");

module.exports = React.createClass({
  BLOCK_CLASS: "c-off-white-lifestyle-section",

  mixins: [Mixins.classes, Mixins.image],

  propTypes: {
    css_modifier: React.PropTypes.string,
    desktop_tablet_images: React.PropTypes.object,
    slider: React.PropTypes.object
  },

  getDefaultProps() {
    return {
      css_modifier: "",
      desktop_tablet_images: {
        left: {},
        right: {}
      },
      slider: []
    };
  },

  getStaticClasses() {
    return {
      block: `
        ${this.BLOCK_CLASS} 
        ${this.props.css_modifier}
        u-mla u-mra u-mw1440
      `,
      background: `${this.BLOCK_CLASS}__background u-pr`,
      desktopTabletImageWrapper: `u-dn u-db--600`,
      mobileImageWrapper: `u-db u-dn--600`,
      mobileImage: `${this.BLOCK_CLASS}__mobile-image`,
      label: `${this.BLOCK_CLASS}__label
        u-pa u-fwb
      `,
      leftDesktopTabletImage: `
        u-pa
        ${this.BLOCK_CLASS}__left-desktop-tablet-image
      `,
      rightDesktopTabletImage: `
        u-pa ${this.BLOCK_CLASS}__right-desktop-tablet-image
      `
    };
  },

  renderDesktopTabletImages(classes) {
    const images = this.props.desktop_tablet_images || {};
    return (
      <div className={classes.desktopImages}>
        <img
          src={images.left.src}
          className={`${classes.leftDesktopTabletImage} ${images.left
            .css_modifier}`}
        />
        <img
          src={images.right.src}
          className={`${classes.rightDesktopTabletImage} ${images.right
            .css_modifier}`}
        />
        <div
          className={`${classes.label} ${images.css_modifier_label}`}
          children={`"${images.label}"`}
        />
      </div>
    );
  },

  getSlideChildren(block = {}) {
    const children = block.images.map((image, i) => {
      return (
        <div key={i}>
          <img src={image} className={"u-w12c"} />
        </div>
      );
    });

    return children;
  },

  renderMobileImages(classes) {
    const slider = this.props.slider;
    return (
      <div className={classes.mobileImage}>
        <div className={classes.mobileSliderWrapper}>
          <Slider
            arrowImageLeft="https://i.warbycdn.com/v/c/assets/off-white/image/carousel-arrow-left/1/46e478b54a.png"
            arrowImageRight="https://i.warbycdn.com/v/c/assets/off-white/image/carousel-arrow-right/1/400b97181c.png"
            showFrameInfo={false}
            useImageArrows={true}
            showLinks={false}
            showNav={false}
            links={slider.links}
            width={"90%"}
            showArrows={true}
            info={slider.info}
            slides={this.getSlideChildren(slider)}
          />
        </div>
      </div>
    );
  },

  render() {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <div className={classes.background}>
          <div className={classes.desktopTabletImageWrapper}>
            {this.renderDesktopTabletImages(classes)}
          </div>
          <div className={classes.mobileImageWrapper}>
            {this.renderMobileImages(classes)}
          </div>
        </div>
      </div>
    );
  }
});
