const React = require('react/addons');
const _ = require('lodash');

const Picture = require('components/atoms/images/picture/picture');
const Img = require('components/atoms/images/img/img');

const Mixins = require('components/mixins/mixins');

require('./hero.scss');


module.exports = React.createClass({
  displayName: 'SunscapadesHero',

  BLOCK_CLASS: 'c-sunscapades-hero',

  mixins: [
    Mixins.image,
    Mixins.classes,
    Mixins.context
  ],

  IMG_SIZES: {
    vespa: [
      {
        breakpoint: 600,
        width: '33vw'
      },
      {
        breakpoint: 900,
        width: '25vw'
      }
    ],
    camera: [
      {
        breakpoint: 900,
        width: '33vw'
      }
    ],
    logo: [
      {
        breakpoint: 0,
        width: '66vw'
      },
      {
        breakpoint: 600,
        width: '33vw'
      }
    ]
  },

  propTypes: {
    camera_image: React.PropTypes.string,
    copy: React.PropTypes.string,
    model_images: React.PropTypes.array,
    vespa_image: React.PropTypes.string,
    logo: React.PropTypes.string
  },

  getDefaultProps: function () {
    return {
      camera_image: '',
      copy: '',
      model_images: [],
      vespa_image: '',
      logo: ''
    };
  },

  getImageProps: function (img) {
    return {
      url: img,
      widths: this.getImageWidths(300, 600, 4)
    };
  },

  getStaticClasses: function () {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-mw1440
        u-pr
        u-mb48 u-mb60--600 u-mb0--900
        u-w100p
        u-mla u-mra
      `,
      copyWrapper: `
        ${this.BLOCK_CLASS}__copy-wrapper
        u-pa
        u-tac
        u-w10c u-w6c--600 u-w3c--900
        u-mla u-mra
      `,
      copy: 'u-fs18 u-lh26',
      pricing: 'u-fws',
      vespaImage: `
        ${this.BLOCK_CLASS}__vespa-image
        u-pa
        u-dn u-db--600
      `,
      cameraImage: `
        ${this.BLOCK_CLASS}__camera-image
        u-pa
        u-dn u-db--900
      `,
      modelImage: `
        ${this.BLOCK_CLASS}__model-image
        u-pa
      `,
      logo: `
        ${this.BLOCK_CLASS}__logo
      `,
      wrapper: `
        ${this.BLOCK_CLASS}__wrapper
      `
    }
  },

  getRegionalPricing: function () {
    const locale = this.getLocale('country');

    return _.get(this.props, `pricing[${locale}]`);
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
        className: classes.modelImage
      }
    };
  },

  renderModelImagery: function (classes) {
    const pictureAttrs = this.getPictureAttrs(this.props.model_images, classes);

    return (
      <Picture className={classes.picture}
                children={this.getPictureChildren(pictureAttrs)} />
    );
  },

  renderVespaImagery: function (classes) {
    const imgSrcSet = this.getSrcSet(this.getImageProps(this.props.vespa_image));
    const imgSizes = this.getImgSizes(this.IMG_SIZES.vespa);
    return (
      <Img srcSet={imgSrcSet}
           sizes={imgSizes}
           alt={'Warby Parker'}
           cssModifier={classes.vespaImage} />
    );
  },

  renderCameraImagery: function (classes) {
    const imgSrcSet = this.getSrcSet(this.getImageProps(this.props.camera_image));
    const imgSizes = this.getImgSizes(this.IMG_SIZES.camera);
    return (
      <Img srcSet={imgSrcSet}
           sizes={imgSizes}
           alt={'Warby Parker'}
           cssModifier={classes.cameraImage} />
    );
  },

  renderCopy: function (classes) {
    const imgSrcSet = this.getSrcSet(this.getImageProps(this.props.logo));
    const imgSizes = this.getImgSizes(this.IMG_SIZES.logo);
    return (
      <div className={classes.copyWrapper}>
        <Img srcSet={imgSrcSet}
             sizes={imgSizes}
             alt={'Warby Parker'}
             cssModifier={classes.logo} />
        <p children={this.props.copy} className={classes.copy} />
        <h3 children={this.getRegionalPricing()} className={classes.pricing} />
      </div>
    );
  },

  render: function () {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <div className={classes.wrapper} />
        {this.renderCopy(classes)}
        {this.renderVespaImagery(classes)}
        {this.renderCameraImagery(classes)}
        {this.renderModelImagery(classes)}
      </div>
    );
  }

});

