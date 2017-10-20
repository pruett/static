const React = require('react/addons');
const _ = require('lodash');

const Markdown = require('components/molecules/markdown/markdown');
const Img = require('components/atoms/images/img/img');
const Picture = require('components/atoms/images/picture/picture');

const Mixins = require('components/mixins/mixins');

require('./callout.scss');


module.exports = React.createClass({
  displayName: 'MoleculesCollectionsMetalCallout',

  BLOCK_CLASS: 'c-metal-callout',

  propTypes: {
    version: React.PropTypes.string,
    images: React.PropTypes.array,
    links: React.PropTypes.array,
    copy: React.PropTypes.object,
    has_logo: React.PropTypes.bool,
    logo_src: React.PropTypes.string,
    is_padded_div: React.PropTypes.bool,
    cssModifierBlock: React.PropTypes.string
  },

  getDefaultProps: function () {
    return {
      version: '',
      images: [],
      copy: {},
      links: [],
      has_logo: false,
      logo_src: '',
      is_padded_div: false,
      cssModifierBlock: 'u-mb72 u-mb96--900'
    };
  },

  mixins: [
    Mixins.classes,
    Mixins.image,
    Mixins.analytics
  ],

  LOGO_SIZES: [
    {
      breakpoint: 0,
      width: '80vw'
    },
    {
      breakpoint: 600,
      width: '60vw'
    }
  ],

  getStaticClasses: function () {
    const cssModifierCopy = _.get(this.props, 'copy.css_modifier');

    return {
      block:`
        ${this.BLOCK_CLASS}
        ${this.props.cssModifierBlock}
        u-mw1440
        u-mla u-mra
        u-pr
      `,
      copyBlock: `
        ${this.BLOCK_CLASS}__copy-block
        ${cssModifierCopy}
        u-mla u-mra
        u-pa
        u-tac
      `,
      image: 'u-w100p u-db',
      picture: 'u-db',
      header: 'u-fs40 u-fs48--900 u-type-metal u-color-metal u-reset u-mb18',
      logoHeader: 'u-fs24 u-type-metal u-color-metal',
      body: 'u-fs16 u-reset u-lh30 u-color-metal',
      link: `
        ${this.BLOCK_CLASS}__link
        u-color--blue u-bbss u-bbw1 u-bbw0--900 u-bc--blue
        u-pb6 u-fws u-fs16 u-fs18--900
      `,
      linkWrapper: `
        u-mt24
      `,
      logo: 'u-w6c u-w4c--600 u-mla u-mra u-mb36 u-mb24--900'
    };
  },

  classesWillUpdate: function () {
    const isPaddedDiv = this.props.is_padded_div;

    return {
      block: {
        'u-pl12 u-pr12 u-pl36--600 u-pr36--600 u-pl72--900 u-pr72--900': isPaddedDiv
      }
    };
  },

  getPictureAttrs: function () {
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
        className: this.classes.image
      }
    };
  },

  handleClickLink: function (slug = '') {
    this.trackInteraction(slug);
  },

  getHeaderClass: function (hasLogo) {
    // The presence of a logo determines the styling for a header
    if (hasLogo) {
      return this.classes.logoHeader;
    } else {
      return this.classes.header;
    }
  },

  getLogoProps: function () {
    return {
      url: this.props.logo_src,
      widths: this.getImageWidths(300, 600, 4)
    };
  },

  renderCopy: function () {
    const copy = this.props.copy || {};
    const hasLinks = _.get(this.props, 'links.length') > 0;
    const hasLogo = this.props.has_logo;

    return (
      <div className={this.classes.copyBlock}>
        <h2 children={copy.header} className={this.getHeaderClass(hasLogo)} />
        { hasLogo && this.renderLogo() }
        <Markdown
          rawMarkdown={copy.body}
          cssBlock={'u-reset'}
          className={this.classes.body} />
        { hasLinks && this.renderLinks() }
      </div>
    );
  },

  renderLogo: function () {
    const logoSrcSet = this.getSrcSet(this.getLogoProps());
    const logoSizes = this.getImgSizes(this.LOGO_SIZES);

    return (
      <Img srcSet={logoSrcSet}
           sizes={logoSizes}
           alt={'Warby Parker Bennett Frame'}
           cssModifier={this.classes.logo} />
    );
  },

  renderLinks: function () {
    const links = this.props.links || [];
    const linkChildren = links.map((link, i) => {
      return (
        <a children={link.copy}
          key={i}
          href={link.href}
          className={this.classes.link}
          onClick={this.handleClickLink.bind(this, link.ga_slug)} />
      );
    });

    return (
      <div className={this.classes.linkWrapper} children={linkChildren} />
    );
  },

  render: function () {
    this.classes = this.getClasses();
    const pictureAttrs = this.getPictureAttrs();

    return (
      <div className={this.classes.block}>
        <Picture className={this.classes.picture} children={this.getPictureChildren(pictureAttrs)} />
        { this.renderCopy() }
      </div>
    );
  }

});
