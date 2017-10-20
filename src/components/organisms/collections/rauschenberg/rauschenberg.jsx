const React = require('react/addons');
const _ = require('lodash');

const TypeKit = require('components/atoms/scripts/typekit/typekit');
const Markdown = require('components/molecules/markdown/markdown');
const Picture = require('components/atoms/images/picture/picture');
const ProfileBlock = require('components/molecules/collections/rauschenberg/profile_block/profile_block');
const FrameCallout = require('components/molecules/collections/rauschenberg/frame_callout/frame_callout');

const ImpressionsMixin = require('components/mixins/collections/ga_impressions_mixin');
const Mixins = require('components/mixins/mixins');

require('./rauschenberg.scss');


module.exports = React.createClass({
  displayName: 'OrganismsCollectionsRauschenberg',

  BLOCK_CLASS: 'c-rauschenberg',

  TYPEKIT_ID: 'jkq7diy',

  mixins: [
    Mixins.classes,
    Mixins.scrolling,
    Mixins.dispatcher,
    Mixins.image,
    ImpressionsMixin
  ],

  propTypes: {
    copy_blocks: React.PropTypes.array,
    frame_callouts: React.PropTypes.array,
    frame_data: React.PropTypes.object,
    hero: React.PropTypes.object,
    profile_block: React.PropTypes.object,
    version: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      copy_blocks: [],
      frame_callouts: [],
      frame_data: {},
      hero: {},
      profile_block: {},
      version: 'fans'
    };
  },

  getStaticClasses() {
    return {
      block: `${this.BLOCK_CLASS} u-tac u-pb60--900`,
      copyBlock: `${this.BLOCK_CLASS}__copy-block`,
      copyBlockHeader: `
        ${this.BLOCK_CLASS}__copy-block-header
        u-reset u-fs24 u-fs34--900 u-mb18 u-mla u-mra
      `,
      copyWrapper: `
        ${this.BLOCK_CLASS}__copy-wrapper
        u-pa u-center
        u-w10c u-w8c--600 u-w7c--900
      `,
      heroImage: `u-w100p u-db`,
      heroLogo: `
        ${this.BLOCK_CLASS}__hero-logo
        u-w9c u-pt48 u-pb36 u-w4c--600
        u-pt0--900 u-pb0--900
        u-pa--900
        u-center--900
      `,
      heroWrapper: `u-pr u-tac u-mla u-mra`,
      markDown: `u-reset`,
      mobileHeroCopy: `
        u-dn--900 u-reset u-fs14 u-lh24
        u-w9c u-mla u-mra u-mb48
      `,
      topCopy: `
        u-reset u-fs14 u-fs18--900
        u-lh24 u-lh30--900 u-mla u-mra
        u-mb18 u-mb24--900
      `,
      bottomCopy: `
        u-reset u-fs14 u-fs18--900
        u-lh24 u-lh30--900 u-mla u-mra
      `,
      profileBlock: `${this.BLOCK_CLASS}__profile-block u-mb120`,
      header: `${this.BLOCK_CLASS}__header`
    };
  },

  getPictureAttrs(images, cssModifier) {
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
        className: cssModifier
      }
    };
  },

  renderCopyBlock(copyBlock, classes, renderMarkdown) {
    return (
      <div className={`${classes.copyBlock} ${copyBlock.css_modifier} u-pr`}>
        <div className={classes.copyWrapper}>
          <h2 children={copyBlock.title}
            className={`${classes.copyBlockHeader} ${copyBlock.css_modifier} ${classes.header} `} />
          {this.renderTopCopy(classes, copyBlock.top, renderMarkdown)}
          <Markdown
            rawMarkdown={copyBlock.bottom}
            className={classes.bottomCopy}
            cssBlock={classes.markDown} />
        </div>
      </div>
    );
  },

  renderTopCopy(classes, copy, renderMarkdown) {
    // Markdown doesn't render out <sup> tags...
    if (renderMarkdown) {
      return (
        <Markdown
          rawMarkdown={copy}
          className={classes.topCopy}
          cssBlock={classes.markDown} />
      );
    } else {
      const sanitizedHTML = {
        __html: 'Robert Rauschenberg was one of the most influential American artists of the 20<sup>th</sup> century—a prolific and original genius across many mediums.'
      };
      return (
        <div dangerouslySetInnerHTML={sanitizedHTML} className={classes.topCopy} />
      )
    }
  },

  getFrameData(id) {
    return(_.pick(this.props.frame_data, id))[id];
  },

  renderHero(classes) {
    const hero = this.props.hero;
    const pictureAttrs = this.getPictureAttrs(hero.image, classes.heroImage)

    return (
      <div className={classes.heroWrapper}>
        <Picture className={classes.picture} children={this.getPictureChildren(pictureAttrs)} />
        <img src={hero.logo} className={classes.heroLogo} />
        <p className={classes.mobileHeroCopy} children={hero.mobile_copy} />
      </div>
    );
  },

  renderFrameCallouts() {
    const frameCallouts = this.props.frame_callouts || [];
    // All frames sold out as of 6/15
    const frameChildren = frameCallouts.map( (frame, i) =>{
      frame.image = frame.frame_image;
      frame.display_name = frame.frame_name;
      frame.color = frame.frame_color;

      return (
        <FrameCallout
          key={i}
          gaPosition={i + 1}
          isSoldOut={true}
          frameData={frame}
          {...frame} />
      );
    })

    return frameChildren;
  },

  render() {
    const classes = this.getClasses();
    const copyBlocks = this.props.copy_blocks;

    return (
      <div className={classes.block}>
        <TypeKit typeKitModifier={this.TYPEKIT_ID} />
        {this.renderHero(classes)}
        <ProfileBlock {...this.props.profile_block} />
        <div children={this.renderFrameCallouts()} />
        {this.renderCopyBlock(copyBlocks[0], classes, false)}
        {this.renderCopyBlock(copyBlocks[1], classes, true)}
      </div>
    );
  }

});
