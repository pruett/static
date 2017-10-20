const React = require("react/addons");
const _ = require("lodash");

const Mixins = require("components/mixins/mixins");

const ImpressionsMixin = require("components/mixins/collections/ga_impressions_mixin");
const Picture = require("components/atoms/images/picture/picture");

require("./employee_grid.scss");

module.exports = React.createClass({
  displayName: "MoleculesCollectionsSummer2017Callout",

  BLOCK_CLASS: "c-sculpted-series-employee-grid",

  mixins: [
    Mixins.classes,
    Mixins.dispatcher,
    Mixins.analytics,
    Mixins.image,
    ImpressionsMixin
  ],

  propTypes: {
    desktop_link_modifier: React.PropTypes.string,
    touts: React.PropTypes.array,
    sold_out: React.PropTypes.bool,
    ga_position: React.PropTypes.number,
    hero: React.PropTypes.object
  },

  getDefaultProps() {
    return {
      desktop_link_modifier: "",
      touts: [],
      sold_out: false,
      ga_position: 0,
      hero: {}
    };
  },

  getStaticClasses() {
    return {
      block: `${this.BLOCK_CLASS}`,
      contentWrapper: `${this.BLOCK_CLASS}__content-wrapper u-pb72--900`,
      hero: `
        u-tac u-pt60 u-pb60 u-pt72--900 u-pb60--900
        u-bbw1--600 u-bbss--600 u-bc--light-gray`,
      header: `
        ${this.BLOCK_CLASS}__header
        u-mla u-mra
        u-fws u-color--black u-fs24 u-mb18
        u-futura-heavy`,
      body: `
        u-color--black u-fs14 u-fs16--900 u-lh24
        u-w9c u-w6c--600 u-mla u-mra u-futura-book
      `,
      copy: `
        ${this.BLOCK_CLASS}__copy
        u-pa--600 u-center--600 u-center-y--900 u-tal--600
      `,
      flexWrapper: `
        ${this.BLOCK_CLASS}__flex-wrapper
        u-df u-flexw--w
      `,
      image: `u-w100p u-db`,
      tout: `
        ${this.BLOCK_CLASS}__tout
        u-w12c u-w6c--900 u-dib
      `,
      copyWrapper: `
        ${this.BLOCK_CLASS}__copy-wrapper
        u-tac u-w12c u-w6c--600 u-dib u-pt48 u-pb48
      `,
      imageWrapper: `${this
        .BLOCK_CLASS}__image-wrapper u-w12c u-w6c--600 u-dib`,
      frameName: `
        u-futura-heavy
        ${this.BLOCK_CLASS}__frame-name
        u-fs16 u-fs18--900 u-color--black u-reset u-mb8
      `,
      bullet: `u-color--black u-fs16 u-futura-book`,
      shopLink: `
        ${this.BLOCK_CLASS}__shop-link
        u-futura-book
        u-fs12 u-color--black u-ls3
      `,
      bulletWrapper: `u-mb6`,
      soldOut: `u-fs16 u-color--black`,
      mobileBulletWrapper: `u-fs14 u-color--black u-mb6 u-futura-book u-mb6`
    };
  },

  getPictureAttrs(images, classes) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, "desktop-sd"),
          widths: this.getImageWidths(900, 2200, 5),
          mediaQuery: "(min-width: 900px)"
        },
        {
          url: this.getImageBySize(images, "tablet"),
          widths: this.getImageWidths(700, 1400, 5),
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
        className: classes.image
      }
    };
  },

  renderTouts(classes) {
    const touts = this.props.touts.map((tout, i) => {
      return this.renderTout(tout, classes, i);
    });
    return touts;
  },

  renderDesktopBullet(bullet, classes, i) {
    return <div children={bullet} className={classes.bullet} key={i} />;
  },

  renderMobileBullets(bullets) {
    return _.join(bullets, " ");
  },

  renderTout(tout, classes, i) {
    const image = this.getPictureAttrs(tout.images, classes);

    return (
      <div className={classes.tout} key={i}>
        <div className={`${classes.imageWrapper} ${tout.css_modifier_order}`}>
          <Picture
            className={classes.picture}
            children={this.getPictureChildren(image)}
          />
        </div>
        <div
          className={`${classes.copyWrapper} ${tout.css_modifier_order} ${tout.css_modifier_arrow} u-pr`}
        >
          <div className={classes.copy}>
            <div children={tout.display_name} className={classes.frameName} />
            <div className={"u-dn u-db--600"}>
              <div
                className={classes.bulletWrapper}
                children={tout.copy.map((bullet, i) => {
                  return this.renderDesktopBullet(bullet, classes, i);
                })}
              />
            </div>
            <div className={"u-db u-dn--600"}>
              <div
                className={classes.mobileBulletWrapper}
                children={this.renderMobileBullets(tout.copy)}
              />
            </div>

            {this.renderShopLink(tout, classes)}
          </div>
        </div>
      </div>
    );
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

  renderShopLink(tout, classes) {
    const frameData = this.getMatchedFrameData(tout.id);
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
        position: tout.ga_position,
        sku: frameData.sku
      };
      return (
        <a
          href={frameData.path}
          onClick={this.handleLinkClick.bind(this, gaData)}
          dangerouslySetInnerHTML={{
            __html: `SHOP THE FRAME <span class='u-fs20'>&rsaquo;</span>`
          }}
          className={classes.shopLink}
        />
      );
    }
  },

  render() {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <div className={classes.contentWrapper}>
          <div className={classes.hero}>
            <div children={this.props.hero.header} className={classes.header} />
            <div children={this.props.hero.body} className={classes.body} />
          </div>
          <div className={classes.flexWrapper}>
            {this.renderTouts(classes)}
          </div>
        </div>
      </div>
    );
  }
});
