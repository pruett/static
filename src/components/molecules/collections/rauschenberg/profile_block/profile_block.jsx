const React = require('react/addons');

const Markdown = require('components/molecules/markdown/markdown');
const Picture = require('components/atoms/images/picture/picture');

const Mixins = require('components/mixins/mixins');

require('./profile_block.scss');


module.exports = React.createClass({
  displayName: 'MoleculesCollectionsRauschenbergProfileBlock',

  BLOCK_CLASS: 'c-rauschenberg-profile-block',

  mixins: [
    Mixins.classes,
    Mixins.dispatcher,
    Mixins.context,
    Mixins.image,
    Mixins.analytics
  ],

  propTypes: {
    artist: React.PropTypes.array,
    caption: React.PropTypes.string,
    detail: React.PropTypes.object,
    quote: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      artist: [],
      caption: '',
      detail: {},
      quote: ''
    };
  },

  getStaticClasses() {
    return {
      block: `${this.BLOCK_CLASS} u-oh u-mb84 u-tac u-mla u-mra`,
      grayWrapper: `
        ${this.BLOCK_CLASS}__gray-wrapper
        u-mw1440 u-mla u-mra
        u-pr
      `,
      quoteWrapper: `
        ${this.BLOCK_CLASS}__quote-wrapper
        u-pa u-center-y
        u-w6c
      `,
      quote: `
        ${this.BLOCK_CLASS}__quote
        u-pr
      `,
      artistWrapper: `
        ${this.BLOCK_CLASS}__artist-wrapper
        u-pa u-center-y--600
      `,
      artistImage: `
        u-w100p
      `,
      mobileQuote: `
        ${this.BLOCK_CLASS}__mobile-quote
        u-tar u-pr12 u-pt12
        u-dn--600
      `,
      mobileInfoWrapper: `
        u-dn--900
        u-pt36 u-pt48--600
      `,
      mobileInfo: `
        u-reset u-fs14 u-lh24
        u-w9c u-mla u-mra u-mb24
      `,
      mobileLink: `
        u-fws
      `,
      citation: `
        u-fs14 u-tar u-pt4
        u-dn u-db--600
      `,
      desktopInfoWrapper: `
        u-tal u-fs18 u-lh30 u-dn u-db--900
      `,
      desktopTopCopy: `
        u-reset u-pt24 u-mb24
      `,
      desktopBottomCopy: `
        u-reset u-mb24
      `,
      price: `
        u-fws u-fs16 u-reset
      `
    };
  },

  getPictureAttrs(images, cssModifier) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, 'desktop-sd'),
          widths: this.getImageWidths(700, 1200, 5),
          mediaQuery: '(min-width: 900px)'
        },
        {
          url: this.getImageBySize(images, 'tablet'),
          widths: this.getImageWidths(400, 900, 5),
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
        className: cssModifier
      }
    };
  },

  getRegionalPricing() {
    const locale = this.getLocale('country');
    if (locale === 'US') {
      return 'Starting at $95';
    } else {
      return 'Starting at $150';
    }
  },

  render() {
    const classes = this.getClasses();
    const artist = this.getPictureAttrs(this.props.artist, classes.artistImage);
    const details = this.props.detail || {};

    return (
      <div className={classes.block}>
        <div className={classes.grayWrapper}>
          <div className={classes.quoteWrapper}>
            <img src={this.props.quote} className={classes.quote} />
            <div className={classes.desktopInfoWrapper}>
              <p children={details.top} className={classes.desktopTopCopy} />
              <p children={details.bottom} className={classes.desktopBottomCopy} />
              <div children={this.getRegionalPricing()} className={classes.price} />
            </div>
          </div>
          <div className={classes.artistWrapper}>
            <Picture className={classes.picture} children={this.getPictureChildren(artist)} />
            <Markdown
              rawMarkdown={this.props.caption}
              className={classes.citation}
              cssBlock={'u-reset'} />
          </div>
        </div>
        <div className={classes.mobileQuoteWrapper}>
          <Markdown
            rawMarkdown={this.props.caption}
            className={classes.mobileQuote}
            cssBlock={'u-reset'} />
        </div>
        <div className={classes.mobileInfoWrapper}>
          <p children={details.bottom} className={classes.mobileInfo} />
          <div children={'Starting at $95'} className={classes.price} />
        </div>
      </div>
    );
  }

});
