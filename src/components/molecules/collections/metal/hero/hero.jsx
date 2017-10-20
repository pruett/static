const _ = require('lodash');
const React = require('react/addons');

const Picture = require('components/atoms/images/picture/picture');

const Mixins = require('components/mixins/mixins');

require('./hero.scss');

module.exports = React.createClass({
  displayName: 'MoleculesCollectionsMetalHero',

  BLOCK_CLASS: 'c-metal-hero',

  mixins: [
    Mixins.classes,
    Mixins.image,
    Mixins.dispatcher,
    Mixins.analytics,
    Mixins.context
  ],

  propTypes: {
    version: React.PropTypes.string,
    images: React.PropTypes.array,
    frame_labels: React.PropTypes.array,
    copy: React.PropTypes.object,
    renderLabels: React.PropTypes.func,
    cssModifier: React.PropTypes.string,
    cssModifierCopy: React.PropTypes.string
  },

  getDefaultProps: function () {
    return {
      version: '',
      images: [],
      frame_labels: [],
      copy: {},
      cssModifier: 'u-mb72 u-mb96--900',
      cssModifierCopy: 'u-w11c u-w10c--600 u-w4c--900'
    };
  },

  // Helpers
  getStaticClasses: function () {
    return {
      block:`
        ${this.BLOCK_CLASS}
        ${this.props.cssModifier}
        u-mw1440
        u-mla u-mra
        u-pr
      `,
      copyBlock: `
        ${this.BLOCK_CLASS}__copy-block
        ${this.props.cssModifierCopy}
        u-mla u-mra
        u-mt42 u-mt0--900
        u-tac
        u-pa--900 u-center-y--900
      `,
      pictureWrapper: `
        ${this.BLOCK_CLASS}__picture-wrapper
      `,
      header: 'u-fs40 u-fs48--900 u-type-metal u-color-metal u-reset u-mb18 u-mb12--900',
      body: 'u-fs16 u-reset u-color-metal u-mb18 u-lh30',
      image: 'u-w100p u-db',
      labelWrapper: `
        u-dn u-dib--900
        u-pa
        u-b0 u-r0
        u-pb24 u-pr24
      `,
      frameLabel: 'c-metal-sun__link-modifier',
      pricing: 'u-fs16 u-fws u-color-metal u-reset u-mt12 u-mt0--600',
      picture: 'u-db'
    };
  },

  getPictureAttrs: function (classes) {
    const images = this.props.images || [];

    return {
      sources: [
        {
          url: this.getImageBySize(images, 'desktop-sd'),
          quality: this.getQualityBySize(images, 'desktop-sd'),
          widths: this.getImageWidths(900, 2200, 5),
          mediaQuery: '(min-width: 900px)'
        },
        {
          url: this.getImageBySize(images, 'tablet'),
          quality: this.getQualityBySize(images, 'desktop-sd'),
          widths: this.getImageWidths(700, 1400, 5),
          mediaQuery: '(min-width: 600px)'
        },
        {
          url: this.getImageBySize(images, 'mobile'),
          quality: this.getQualityBySize(images, 'desktop-sd'),
          widths: this.getImageWidths(300, 800, 5),
          mediaQuery: '(min-width: 0px)'
        }
      ],
      img: {
        alt: 'Warby Parker Metal Collection',
        className: classes.image
      }
    };
  },

  // Renders
  renderImages: function (classes) {
    const pictureAttrs = this.getPictureAttrs(classes);
    const labels = this.props.frame_labels;
    const hasLabels = labels.length > 0;

    return (
      <div className={classes.pictureWrapper}>
        <Picture className={classes.picture} children={this.getPictureChildren(pictureAttrs)} />
        { hasLabels && this.props.renderLabels(classes, labels) }
      </div>
    );
  },

  renderCopy: function (classes) {
    const copy = this.props.copy || {};
    const locale = this.getLocale('country');
    const price = _.get(this.props, `copy.price[${locale}]`);

    return (
      <div className={classes.copyBlock}>
        <h1 children={copy.header} className={classes.header} />
        <p children={copy.body} className={classes.body} />
        <p children={price} className={classes.pricing} />
      </div>
    );
  },

  render: function () {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        { this.renderImages(classes) }
        { this.renderCopy(classes) }
      </div>
    );
  }

});
