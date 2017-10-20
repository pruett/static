const React = require('react/addons');

const Picture = require('components/atoms/images/picture/picture');
const Markdown = require('components/molecules/markdown/markdown');
const CollectionFrame = require('components/molecules/collections/utility/frame/frame');

const Mixins = require('components/mixins/mixins');

require('./frame_callout.scss');


module.exports = React.createClass({
  displayName: 'MoleculesCollectionsRauschenbergFrameCallout',

  BLOCK_CLASS: 'c-rauschenberg-frame-callout',

  mixins: [
    Mixins.classes,
    Mixins.dispatcher,
    Mixins.image
  ],

  propTypes: {
    artist: React.PropTypes.array,
    artwork: React.PropTypes.array,
    caption_desktop: React.PropTypes.string,
    caption_mobile: React.PropTypes.string,
    detail: React.PropTypes.object,
    frameData: React.PropTypes.object,
    frame_align_modifier: React.PropTypes.string,
    gaPosition: React.PropTypes.number,
    isSoldOut: React.PropTypes.bool,
    quote: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      artist: [],
      artwork: [],
      caption_desktop: '',
      caption_mobile: '',
      detail: {},
      frameData: {},
      frame_align_modifier: '',
      gaPosition: 0,
      isSoldOut: false,
      quote: ''
    };
  },

  getStaticClasses() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-mb84 u-mb120--900
        u-pl24--900 u-pr24--900
        u-mw1440 u-mla u-mra
      `,
      cssModifierFrame: `
        ${this.BLOCK_CLASS}__frame-modifier
        ${this.props.frame_align_modifier}
        u-pr u-w11c u-w11c--900 u-mb60 u-mb0--900
      `,
      cssModifierFrameColor: `u-ffs u-fs16 u-fs18--900 u-fsi u-mb18`,
      cssModifierFrameName: `
        u-ffs u-fs22 u-fs24--900
        u-fws u-mb8 u-mb16--600 u-mt18
      `,
      flexWrapper: `${this.BLOCK_CLASS}__flex-wrapper`,
      flexChild: `${this.BLOCK_CLASS}__flex-child`,
      frame: `
        ${this.BLOCK_CLASS}__flex-child
        ${this.props.frame_align_modifier}
        u-w12c u-w8c--600 u-w6c--900 u-dib
        u-mb36 u-mb0--900
        u-pr
        u-mla u-mra
      `,
      artwork: `
        ${this.BLOCK_CLASS}__flex-child
        ${this.props.frame_align_modifier}
        u-w12c u-w6c--600 u-dib
        u-mla u-mra
        u-pr
      `,
      image: `${this.BLOCK_CLASS}__image ${this.props.frame_align_modifier}`,
      captionDesktop: `u-dn u-db--900`,
      captionMobile: `u-dn--900`,
      markDown: `u-reset`,
      copyWrapper: `
        u-mla u-mra u-mt8
        ${this.BLOCK_CLASS}__copy-wrapper
        ${this.props.frame_align_modifier}
      `
    };
  },

  classesWillUpdate() {
    return {
      cssModifierFrame: {
        'u-w12c--900': this.props.frame_align_modifier === '-flip',
        'u-w11c--900': this.props.frame_align_modifier !== '-flip'
      }
    }
  },

  getPictureAttrs(images, cssModifier) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, 'desktop-sd'),
          widths: this.getImageWidths(1000, 1400, 5),
          mediaQuery: '(min-width: 900px)'
        },
        {
          url: this.getImageBySize(images, 'tablet'),
          widths: this.getImageWidths(700, 1000, 5),
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

  render() {
    const classes = this.getClasses();
    const pictureAttrs = this.getPictureAttrs(this.props.artwork, classes.image);

    return (
      <div className={classes.block}>
        <div className={classes.flexWrapper}>
          <div className={classes.frame}>
            <CollectionFrame
            {...this.props.frameData}
            gaPosition={this.props.gaPosition}
            isSoldOut={this.props.isSoldOut}
            cssModifierFrameColor={classes.cssModifierFrameColor}
            cssModifierFrameName={classes.cssModifierFrameName}
            cssModifierBlock={classes.cssModifierFrame}
            isSoldOut={true}
            gaCollectionSlug='Rauschenberg'
            />
          </div>
          <div className={classes.artwork}>
            <Picture className={classes.picture} children={this.getPictureChildren(pictureAttrs)} />
            <div className={classes.copyWrapper}>
              <Markdown
                rawMarkdown={this.props.caption_desktop}
                className={classes.captionDesktop}
                cssBlock={classes.markDown} />
              <Markdown
                rawMarkdown={this.props.caption_mobile}
                className={classes.captionMobile}
                cssBlock={classes.markDown} />
            </div>
          </div>
        </div>
      </div>
    );
  }

});
