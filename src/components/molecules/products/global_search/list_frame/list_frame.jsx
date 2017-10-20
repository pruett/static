const _ = require("lodash");
const React = require("react/addons");
const Img = require("components/atoms/images/img/img");

const Mixins = require("components/mixins/mixins");

const CSSTransitionGroup = React.addons.CSSTransitionGroup;

module.exports = React.createClass({
  BLOCK_CLASS: "c-list-frame",

  mixins: [Mixins.classes, Mixins.dispatcher, Mixins.image],

  propTypes: {
    active: React.PropTypes.bool,
    analyticsCategory: React.PropTypes.string,
    cssModifier: React.PropTypes.string,
    manageProductClick: React.PropTypes.func,
    manageGenderClick: React.PropTypes.func,
    product: React.PropTypes.object,
    widths: React.PropTypes.array,
    sizes: React.PropTypes.array
  },

  getDefaultProps: function() {
    return {
      active: false,
      analyticsCategory: "frameList",
      cssModifier: "",
      manageProductClick: function() {},
      manageGenderClick: function() {},
      product: {},
      widths: [104, 208, 280, 560],
      sizes: [
        { breakpoint: 0, width: "104px" },
        { breakpoint: 600, width: "280px" }
      ]
    };
  },

  shouldComponentUpdate: function(nextProps) {
    return this.props.active !== nextProps.active;
  },

  getStaticClasses: function() {
    return {
      block: `
        ${this.props.cssModifier}
        u-grid__col u-w12c u-w4c--600 u-w3c--900
        u-reset--button
        u-pt24 u-pr u-vab
        u-mb24--600
      `,
      row: `
        u-grid__row
        u-tal u-tac--600
      `,
      imageContainer: `
        u-grid__col u-w4c u-w12c--600
        u-mt2
      `,
      image: `
        u-pr6--600 u-pl6--600
      `,
      details: `
        u-grid__col u-w8c u-w12c--600
        u-h48 u-h60--600
        u-pr
      `,
      name: `
        u-reset
        u-fs18 cb u-ffs u-fws
        u-color--dark-gray
      `,
      color: `
        u-reset
        u-fs18 u-ffs u-fsi u-ttc
        u-color--dark-gray-alt-2
      `,
      divider: `
        u-grid__col u-w12c
        u-pt24 u-dn--600
      `,
      links: `
        u-pa u-w100p
        u-t50p u-ttyn50 u-mtn6
        u-l0--600 u-r0--600 u-t0--600 u-tyn--600 u-mt24--600
        u-ffss u-fs16 u-fws
      `,
      link: `
        u-color--blue
        u-link--hover
        u-fs14 u-fs16--600
        u-mr30
        u-ml12--600 u-mr12--600
      `,
      rule: `
        u-bw0 u-bbw1 u-bbw0--600
        u-bc--light-gray u-bss
      `
    };
  },

  getLinkText: function(gender) {
    if (gender === "m") return "Shop Men";
    else if (gender === "f") return "Shop Women";
    else return "Shop now";
  },

  handleGenderClick: function(event) {
    event.stopPropagation();
    this.props.manageGenderClick(this.props.product);
  },

  handleProductClick: function() {
    this.props.manageProductClick(this.props.product);
  },

  renderLink: function(classes, detail, index) {
    return (
      <a
        key={index}
        href={`/${detail.path}`}
        onClick={this.handleGenderClick}
        children={this.getLinkText(detail.gender)}
        className={classes.link}
      />
    );
  },

  render: function() {
    const classes = this.getClasses();
    const product = this.props.product || {};
    const genderedDetails = this.props.product.gendered_details || [];
    const links = _.map(genderedDetails, this.renderLink.bind(this, classes));
    const srcSetAttrs = { url: product.image, widths: this.props.widths };
    const srcSet = this.getSrcSet(srcSetAttrs);

    const { display_name, color } = product;

    return (
      <button
        className={classes.block}
        type="button"
        href={`/${product.path}`}
        onClick={this.handleProductClick}
      >
        <div className={classes.row}>
          <div className={classes.imageContainer}>
            <Img
              cssModifier={classes.image}
              alt={`${display_name} in ${product.color}`}
              srcSet={srcSet}
              sizes={this.getImgSizes(this.props.sizes)}
            />
          </div>
          <div className={classes.details}>
            <CSSTransitionGroup transitionName="-transition-fade--fast">
              {!this.props.active
                ? <div key="body">
                    <h3 className={classes.name} children={display_name} />
                    <span className={classes.color} children={color} />
                  </div>
                : <div
                    key="links"
                    className={classes.links}
                    children={links}
                  />}
            </CSSTransitionGroup>
          </div>
          <div className={classes.divider}>
            <hr className={classes.rule} />
          </div>
        </div>
      </button>
    );
  }
});
