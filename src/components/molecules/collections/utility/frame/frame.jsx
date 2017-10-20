const React = require('react/addons');
const _ = require('lodash');

const Img = require('components/atoms/images/img/img');

const Mixins = require('components/mixins/mixins');

require('./frame.scss');

module.exports = React.createClass({
  displayName: 'MoleculesCollectionsUtilityFrame',

  BLOCK_CLASS: 'c-collection-frame',

  propTypes: {
    assembly_type: React.PropTypes.string,
    color: React.PropTypes.string,
    cssModifierBlock: React.PropTypes.string,
    cssModifierFrameColor: React.PropTypes.string,
    cssModifierFrameName: React.PropTypes.string,
    cssModifierShopLink: React.PropTypes.string,
    display_name: React.PropTypes.string,
    frameAltText: React.PropTypes.string,
    gaCategory: React.PropTypes.string,
    gaCollectionSlug: React.PropTypes.string,
    gaList: React.PropTypes.string,
    gaPosition: React.PropTypes.number,
    gendered_details: React.PropTypes.array,
    gendered_links: React.PropTypes.array,
    image: React.PropTypes.string,
    isLinkedFrame: React.PropTypes.bool,
    renderLinks: React.PropTypes.bool,
    showGenderedLinks: React.PropTypes.bool,
    sku: React.PropTypes.string,
    isSoldOut: React.PropTypes.bool,
    version: React.PropTypes.string
  },

  getDefaultProps: function () {
    return {
      assembly_type: '',
      color: '',
      cssModifierBlock: 'u-w11c u-w6c--600 u-mb60 u-vat',
      cssModifierFrameColor: 'u-ffs u-fs16 u-fs18--900 u-fsi',
      cssModifierFrameName: 'u-ffs u-fs22 u-fs24--900 u-fws u-mb8 u-mb16--600',
      cssModifierShopLink: 'u-fws u-pb6 u-bbss u-bbw1 u-bbw0--900',
      display_name: '',
      frameAltText: 'Warby Parker Glasses',
      gaCategory: 'LandingPage',
      gaCollectionSlug: '',
      gaList: '',
      gaPosition: 0,
      gendered_details: [],
      gendered_links: ['f', 'm'],
      image: '',
      isLinkedFrame: true,
      renderLinks: false,
      showGenderedLinks: false,
      sku: '',
      isSoldOut: false,
      version: 'fans'
    };
  },

  mixins: [
    Mixins.classes,
    Mixins.image,
    Mixins.analytics,
    Mixins.dispatcher
  ],

  IMAGE_SIZES: [
    {
      breakpoint: 0,
      width: '80vw'
    },
    {
      breakpoint: 600,
      width: '60vw'
    }
  ],

  SHOP_LINK_TEXT: {
    f: 'Shop Women',
    m: 'Shop Men'
  },

  GENDER_LOOKUP: {
    f: 'Women',
    m: 'Men'
  },

  getImageProps: function () {
    return {
      url: this.props.image,
      widths: this.getImageWidths(300, 600, 4),
      quality: 100
    };
  },

  getStaticClasses: function () {
    return {
      block: `
        ${this.BLOCK_CLASS}
        ${this.props.cssModifierBlock}
        u-dib u-tac
      `,
      frameName: `
        ${this.props.cssModifierFrameName}
      `,
      frameColor: `
        ${this.props.cssModifierFrameColor}
      `,
      image: `
        u-w11c
      `,
      shopLinksWrapper: `
        u-mt8
      `,
      shopLink: `
        ${this.props.cssModifierShopLink}
        ${this.BLOCK_CLASS}__shop-link
      `,
      isSoldOut: `
        u-fws u-fs16
      `
    };
  },

  handleProductClick: function (gaData={}) {
    this.trackInteraction(`${this.props.gaCategory}-clickShop${this.GENDER_LOOKUP[gaData.gender]}-${gaData.sku}`);

    const productData = {
      brand: 'Warby Parker',
      category: gaData.type,
      collections: gaData.collections,
      color: gaData.color,
      gender: gaData.gender,
      id: gaData.id,
      list: gaData.list,
      name: gaData.name,
      position: gaData.position,
      sku: gaData.sku
    };

    this.commandDispatcher('analytics', 'pushProductEvent', {
      type: 'productClick',
      eventMetadata: {
        list: gaData.list
      },
      products: productData
    });

  },

  renderImage: function (classes) {
    const imgSrcSet = this.getSrcSet(this.getImageProps());
    const imgSizes = this.getImgSizes(this.IMAGE_SIZES);
    const img = (
      <Img srcSet={imgSrcSet}
        sizes={imgSizes}
        alt={this.props.frameAltText}
        cssModifier={classes.image} />
    )

    // Some designs require that the gendered versions of landing pages allow
    // users to click directly on frame images to link to PDPS. Other designs
    // require gendered versions to display links, and not have a clickable
    // image.
    if (this.props.version === 'fans' || !this.props.isLinkedFrame) {
      return img;
    }

    const search = { gender: this.props.version };
    const genderedDetails = _.find(this.props.gendered_details, search) || {};
    const gaData = {
      color: this.props.color,
      name: this.props.display_name,
      collections: [
        {
          slug: this.props.gaCollectionSlug
        }
      ],
      list: this.props.gaList,
      type: this.props.assembly_type,
      sku: this.props.sku,
      gender: genderedDetails.gender,
      id: genderedDetails.product_id,
      path: genderedDetails.path,
      position: this.props.gaPosition
    };
    return (
      <a
        href={`/${genderedDetails.path}`}
        children={img}
        onClick={this.handleProductClick.bind(this, gaData)} />
    );
  },

  renderDetails: function (classes) {
    const frameName = this.props.display_name || '';
    const frameColor = this.props.color || '';

    return (
      <div className={classes.frameDetailsWrapper}>
        <div children={frameName} className={classes.frameName} />
        <div children={frameColor} className={classes.frameColor} />
      </div>
    );
  },

  renderLinks: function (classes) {
    if (this.props.isSoldOut) {
      return <div children={this.renderisSoldOut(classes)} />;
    } else {
      return <div children={this.renderShopLinks(classes)} />;
    }
  },

  renderisSoldOut: function (classes) {
    const link = <span children={'Sold out'} className={classes.isSoldOut} />;
    return <div children={link} className={classes.shopLinksWrapper} />
  },

  renderShopLinks: function (classes) {
    if (this.props.version !== 'fans' && !this.props.showGenderedLinks) {
      // A gendered page, but we don't want shop links displayed
      return false;
    } else if (this.props.version === 'fans') {
      // Fans page, so display shop links for any gendered frame variants
      const links = this.props.gendered_details;
      const fansLinkChildren = this.getLinkChildren(links, classes);
      return <div children={fansLinkChildren} className={classes.shopLinksWrapper} />
    } else {
      // Gendered page, so display the link for the corresponding gendered variant
      const links = _.compact(
        [_.find(this.props.gendered_details, {gender: this.props.version})]
      );
      if (links.length < 1) {
        return false;
      }
      const genderedLinkChildren = this.getLinkChildren(links, classes);
      return <div children={genderedLinkChildren} className={classes.shopLinksWrapper} />
    }

  },

  getShopLinkText: function (gender='') {
    if (this.props.version !== 'fans') {
      return 'Shop now';
    } else {
      return this.SHOP_LINK_TEXT[gender];
    }
  },

  getLinkChildren: function (links, classes) {
    const linkChildren = links.map((detail, i) => {
      const gaData = {
        color: this.props.color,
        name: this.props.display_name,
        collections: [
          {
            slug: this.props.gaCollectionSlug
          }
        ],
        list: this.props.gaList,
        type: this.props.assembly_type,
        sku: this.props.sku,
        gender: detail.gender,
        id: detail.product_id,
        path: detail.path,
        position: this.props.gaPosition
      };

      return (
        <a
          href={`/${detail.path}`}
          className={classes.shopLink}
          children={this.getShopLinkText(detail.gender)}
          onClick={this.handleProductClick.bind(this, gaData)}
          key={i} />
      );
    });

    return linkChildren;
  },

  render: function () {
    const classes = this.getClasses();
    return (
      <div className={classes.block}>
        { this.renderImage(classes) }
        { this.renderDetails(classes) }
        { this.renderLinks(classes) }
      </div>
    );
  }

});
