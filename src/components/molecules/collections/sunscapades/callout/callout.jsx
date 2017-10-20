const React = require('react/addons');

const Img = require('components/atoms/images/img/img');
const Picture = require('components/atoms/images/picture/picture');
const Video = require('../video/video');

const Mixins = require('components/mixins/mixins');

require('./callout.scss');

module.exports = React.createClass({

  displayName: 'CollectionSunscapadesCallout',

  BLOCK_CLASS: 'c-sunscapades-callout',

  IMAGE_SIZES: [
    {
      breakpoint: 900,
      width: '30vw'
    }
  ],

  GA_GENDER_LOOKUP: {
    m: 'Men',
    f: 'Women'
  },

  mixins: [
    Mixins.classes,
    Mixins.image,
    Mixins.analytics,
    Mixins.dispatcher
  ],

  propTypes: {
    animate: React.PropTypes.bool,
    background_image: React.PropTypes.array,
    css_modifier: React.PropTypes.string,
    cta: React.PropTypes.object,
    ga_position: React.PropTypes.number,
    main_image: React.PropTypes.array,
    product_image: React.PropTypes.string,
    video: React.PropTypes.string,
    lookup: React.PropTypes.string
  },

  getDefaultProps: function () {
    return {
      animate: false,
      background_image: [],
      css_modifier: '',
      cta: {},
      ga_position: 0,
      lookup: '',
      main_image: [],
      product_image: ''
    };
  },

  getStaticClasses: function () {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-oh
        u-pr
        u-mb18 u-mb48--900
        u-pb60--900 u-pt60--900
        u-mw1440 u-mla u-mra
      `,
      image: `
        ${this.BLOCK_CLASS}__image
        u-w12c
      `,
      mainImageWrapper: `
        ${this.BLOCK_CLASS}__image-wrapper
        ${this.props.css_modifier}
      `,
      backgroundImageWrapper: `
        ${this.BLOCK_CLASS}__background-image-wrapper
        ${this.props.css_modifier}
        u-dn u-db--900
      `,
      frameName: `
        u-fws u-color--dark-gray
      `,
      frameColor: `
        u-color--dark-gray
      `,
      linkWrapper: `
        ${this.BLOCK_CLASS}__link-wrapper
        ${this.props.css_modifier}
      `,
      productImage: `
        ${this.BLOCK_CLASS}__product-image
        ${this.props.css_modifier}
        u-dn u-db--900
        u-pa
      `,
      links: `
        ${this.BLOCK_CLASS}__links
        u-pb6
        u-bbss u-bbw2 u-bbw0--900 u-bc--dark-gray
      `
    };
  },

  classesWillUpdate: function () {
    return {
      block: {
        'u-mb48--600': this.props.lookup === 'first',
        'u-mb12--600': this.props.lookup === 'second',
        'u-mb48--600': this.props.lookup === 'third'

      },
      mainImageWrapper: {'-animate': this.props.animate},
      backgroundImageWrapper: {'-animate': this.props.animate}
    }
  },

  getImageProps: function (img) {
    return {
      url: img,
      widths: this.getImageWidths(300, 600, 4)
    };
  },

  getPictureAttrs: function (images, classes) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, 'desktop-sd'),
          widths: this.getImageWidths(900, 2200, 5),
          mediaQuery: '(min-width: 900px)'
        },
        {
          url: this.getImageBySize(images, 'tablet'),
          widths: this.getImageWidths(700, 1400, 5),
          mediaQuery: '(min-width: 600px)'
        },
        {
          url: this.getImageBySize(images, 'mobile'),
          widths: this.getImageWidths(300, 800, 5),
          mediaQuery: '(min-width: 0px)'
        }
      ],
      img: {
        alt: 'Warby Parker',
        className: classes.image
      }
    };
  },

  getBackgroundAttrs: function (images, classes) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, 'desktop-sd'),
          widths: this.getImageWidths(900, 2200, 5),
          mediaQuery: '(min-width: 900px)'
        }
      ],
      img: {
        alt: 'Warby Parker',
        className: classes.image
      }
    };
  },

  handleProductClick: function (link = {}) {
    this.trackInteraction(`LandingPage-clickShop${this.GA_GENDER_LOOKUP[link.ga_gender]}-${link.ga_sku}`);

    const productImpression = {
      brand: 'Warby Parker',
      category: 'sunglasses',
      collections: [
        {slug: 'Sunscapades'}
      ],
      color: link.frame_color,
      gender: link.ga_gender,
      id: link.ga_id,
      list: 'Sunscapades',
      name: link.ga_name,
      position: link.ga_position,
      sku: link.ga_sku
    };

    this.commandDispatcher('analytics', 'pushProductEvent', {
      type: 'productClick',
      products: productImpression
    });

  },

  renderLink: function (classes) {
    const link = this.props.cta;
    return (
      <div className={classes.linkWrapper}>
        <a href={link.path} onClick={this.handleProductClick.bind(this, link)} className={classes.links}>
          <span className={classes.frameName} children={link.frame_name} />
          <span className={classes.frameColor} children={`in ${link.frame_color}`} />
        </a>
      </div>
    );
  },

  renderProductImage: function (img, classes) {
    const imgSrcSet = this.getSrcSet(this.getImageProps(img));
    const imgSizes = this.getImgSizes(this.IMAGE_SIZES);

    return (
      <Img srcSet={imgSrcSet}
           sizes={imgSizes}
           alt={'Warby Parker'}
           cssModifier={classes.productImage} />
    );
  },

  renderVideo: function (video, classes) {
    return (
      <div className={classes.videoWrapper}>
        <Video src={this.props.video} cssModifier={this.props.css_modifier} />
      </div>
    )
  },

  render: function () {
    const classes = this.getClasses();
    const pictureAttrs = this.getPictureAttrs(this.props.main_image, classes);
    const backgroundAttrs = this.getBackgroundAttrs(this.props.background_image, classes);

    return (
      <div className={classes.block}>
        <div className={classes.mainImageWrapper}>
          <Picture className={classes.picture} children={this.getPictureChildren(pictureAttrs)} />
        </div>
        <div className={classes.backgroundImageWrapper}>
          <Picture className={classes.picture} children={this.getPictureChildren(backgroundAttrs)} />
        </div>
        {this.renderLink(classes)}
        {this.props.product_image && this.renderProductImage(this.props.product_image, classes)}
        {this.props.video && this.renderVideo(this.props.video, classes)}
      </div>
    );
  }

});
