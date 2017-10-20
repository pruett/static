const _ = require('lodash');
const React = require('react/addons');

const BuyableFrame = require('components/molecules/products/buyable_frame_v2/buyable_frame_v2');
const ResponsivePicture = require(
  'components/atoms/images/responsive_picture_v2/responsive_picture_v2'
);

const Mixins = require('components/mixins/mixins');

require('./kits.scss');

module.exports = React.createClass({

  BLOCK_CLASS: 'c-starter-kits',

  mixins: [
    Mixins.classes
  ],

  propTypes: {
    favorites: React.PropTypes.array,
    timesKitGroupsHaveShown: React.PropTypes.number,
    kits: React.PropTypes.array,
    showFavorites: React.PropTypes.bool
  },

  getDefaultProps: function() {
    return {
      analyticsCategory: '',
      heroSizes: {
        mobile: [
          { break: 0, image: 320 },
          { break: 321, image: 414 },
          { break: 415, image: 600 }
        ],
        tablet: [
          { break: 600, image: 1440 }
        ]
      },
      favorites: [],
      timesKitGroupsHaveShown: 0,
      kits: [],
      showFavorites: false
    };
  },

  getStaticClasses: function() {
    return {
      kitHero: `
        ${this.BLOCK_CLASS}__hero
        u-pr
        u-oh
        u-mla u-mra
        u-mb60 u-mb72--600
      `,
      kitHeroImg: `
        ${this.BLOCK_CLASS}__hero-img
        u-pa--600
        u-t50p u-l50p
        u-ttn50n50--600
        u-mwnone--600
      `,
      kitCopy: `
        u-pa u-center
      `,
      kitTitle: `
        u-m0
        u-ffs u-fws
        u-fs30 u-fs40--600
      `,
      kitDescription: `
        ${this.BLOCK_CLASS}__description
        u-mt4 u-mt8--600 u-mb0
        u-fs16 u-fs18--600
        u-lh24 u-lh26--600
        u-color--dark-gray-alt-3
      `,
      productsGrid: `
        u-grid
      `,
      products: `
        u-grid__row
      `
    };
  },

  renderKit: function(classes, allowTooltip, kit, i) {
    return (
      <div key={`${kit.gender}-${kit.fit}-${i}`}>
        <div className={classes.kitHero}>
          <ResponsivePicture
            sizes={this.props.heroSizes}
            sourceImages={kit.images}
            cssModifier={classes.kitHeroImg} />
          <div className={classes.kitCopy}>
            <h2 className={classes.kitTitle} children={kit.title} />
            <p className={classes.kitDescription} children={kit.description} />
          </div>
        </div>
        <div className={classes.productsGrid}>
          <div className={classes.products}>
            {kit.products.map(function(product, j) {
              return (
                <BuyableFrame
                  key={product.product_id}
                  addedVia={
                    `hto-starter-kit-${[kit.gender, kit.fit, kit.title].map(_.camelCase).join('_')}`
                  }
                  analyticsCategory={this.props.analyticsCategory}
                  cart={_.get(this.props, 'session.cart', {})}
                  canHto={true}
                  canPurchase={false}
                  canFavorite={this.props.showFavorites}
                  isFavorite={_.includes(this.props.favorites, product.product_id)}
                  product={product}
                  showQuickAddTooltip={!(i || j) && allowTooltip} />
              );
            }, this)}
          </div>
        </div>
      </div>
    );
  },

  render: function() {
    const classes = this.getClasses();
    const allowTooltip = this.props.timesKitGroupsHaveShown < 2;

    if (_.size(this.props.kits)) {
      return (
        <div>
          {this.props.kits.map(this.renderKit.bind(this, classes, allowTooltip))}
        </div>
      );
    }
    else {
      // No kits to render
      return null;
    }
  }

});
