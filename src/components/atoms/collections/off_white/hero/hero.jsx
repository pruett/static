const React = require("react/addons");

const Img = require("components/atoms/images/img/img");
const Picture = require("components/atoms/images/picture/picture");

const Mixins = require("components/mixins/mixins");

require("./hero.scss");

module.exports = React.createClass({
  displayName: "OffWhiteHero",

  BLOCK_CLASS: "c-off-white-hero",

  LOGO_SIZES: [
    {
      breakpoint: 0,
      width: "80vw"
    },
    {
      breakpoint: 600,
      width: "90vw"
    }
  ],

  getDefaultProps() {
    return {
      image: [],
      logo: "",
      copy_left: "",
      copy_right: ""
    };
  },

  propTypes: {
    image: React.PropTypes.array,
    logo: React.PropTypes.string,
    copy_left: React.PropTypes.string,
    copy_right: React.PropTypes.string
  },

  mixins: [Mixins.classes, Mixins.image],

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

  getStaticClasses() {
    return {
      block: `${this
        .BLOCK_CLASS} u-mla u-mra u-mw1440 u-mb24 u-mb48--600 u-mb72--900`,
      copyLeft: `u-dib u-reset`,
      copyRight: `u-dib u-reset`,
      copyWrapper: `
        ${this.BLOCK_CLASS}__copy-wrapper
        u-w11c u-w10c--600 u-w11c--900 u-mla u-mra u-tal 
        u-fs14 u-fs16--600 u-fs24--900
        u-fwb u-color--black 
        u-lh16 u-lh22--600 u-lh24--900
        u-mt72--600 u-mt80--900
      `,
      leftWrapper: `u-dib u-w6c--600 u-mb18 u-mt24 u-mb0--600 u-mt0--600 u-pr36--900`,
      rightWrapper: `u-dib u-w6c--600 u-pl24--600 u-pr24--900 u-pl36--900`,
      picture: `u-db`,
      pictureWrapper: `u-pr ${this.BLOCK_CLASS}__picture-wrapper`,
      logo: `
        ${this.BLOCK_CLASS}__logo
        u-w11c u-pa u-center-x
      `
    };
  },

  getLogoProps: function() {
    return {
      url: this.props.logo,
      widths: this.getImageWidths(300, 1200, 4)
    };
  },

  render() {
    const classes = this.getClasses();
    const pictureAttrs = this.getPictureAttrs(this.props.image);
    const logoSrcSet = this.getSrcSet(this.getLogoProps());
    const logoSizes = this.getImgSizes(this.LOGO_SIZES);

    return (
      <div className={classes.block}>
        <div className={classes.pictureWrapper}>
          <Picture
            className={classes.picture}
            children={this.getPictureChildren(pictureAttrs)}
          />
          <Img
            srcSet={logoSrcSet}
            sizes={logoSizes}
            alt={"Warby Parker & Off White Logo"}
            cssModifier={classes.logo}
          />
        </div>
        <div className={classes.copyWrapper}>
          <div className={classes.leftWrapper}>
            <p className={classes.copyLeft} children={this.props.copy_left} />
          </div>
          <div className={classes.rightWrapper}>
            <p className={classes.copyRight} children={this.props.copy_right} />
          </div>
        </div>
      </div>
    );
  }
});
