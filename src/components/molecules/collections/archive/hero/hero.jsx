const React = require("react/addons");
const _ = require("lodash");

const Picture = require("components/atoms/images/picture/picture");

const Mixins = require("components/mixins/mixins");

module.exports = React.createClass({
  displayName: "ArchiveCollectionHero",

  propTypes: {
    classes: React.PropTypes.object,
    copy: React.PropTypes.array,
    price: React.PropTypes.object,
    logo: React.PropTypes.array,
    static_images: React.PropTypes.array
  },

  mixins: [Mixins.dispatcher, Mixins.analytics, Mixins.image, Mixins.context],

  getInitialState() {
    return {
      isStatic: true
    };
  },

  getDefaultProps() {
    return {
      classes: {},
      copy: [],
      price: {},
      logo: [],
      static_images: []
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
        className: this.props.classes.image
      }
    };
  },

  getLogoAttrs(images) {
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
        className: this.props.classes.logo
      }
    };
  },

  renderPrice() {
    return _.get(this.props, `price[${this.getLocale("country")}]`);
  },

  render() {
    const { copy, static_images, classes, logo } = this.props;

    return (
      <div className={classes.block}>
        <div className={classes.imageWrapper}>
          <Picture
            children={this.getPictureChildren(
              this.getHeroPictureAttrs(static_images)
            )}
          />
          <div className={classes.logoWrapper}>
            <Picture
              children={this.getPictureChildren(this.getHeroPictureAttrs(logo))}
            />
          </div>
        </div>
        <div className={classes.copyWrapper}>
          <div children={copy[0]} className={classes.copyTop} />
          <div children={copy[1]} className={classes.copyBottom} />
          <div children={this.renderPrice()} className={classes.pricing} />
        </div>
        <div className={classes.divider} />
      </div>
    );
  }
});
