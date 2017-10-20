const React = require('react/addons');
const _ = require('lodash');

const Picture = require('components/atoms/images/picture/picture');
const CollectionFrame = require('components/molecules/collections/utility/frame/frame');
const Callout = require('components/molecules/collections/summer_2017/callout/callout');
const Markdown = require('components/molecules/markdown/markdown');

const Mixins = require('components/mixins/mixins');
const ImpressionsMixin = require('components/mixins/collections/ga_impressions_mixin');

require('./summer_2017.scss');

module.exports = React.createClass({

  displayName: 'OrganismsCollectionsSummer2017',

  BLOCK_CLASS: 'c-summer-2017',

  mixins: [
    Mixins.classes,
    Mixins.context,
    Mixins.dispatcher,
    ImpressionsMixin,
    Mixins.image
  ],

  propTypes: {
    frame_data: React.PropTypes.object,
    identifier: React.PropTypes.string,
    page: React.PropTypes.object,
    version: React.PropTypes.string,
  },

  getDefaultProps: function () {
    return {
      identifier: '',
      frame_data: {},
      page: {
        frames: [],
        callouts: []
      },
      version: 'fans'
    };
  },

  componentDidMount: function () {
    this.handleProductImpressions();
  },

  shouldReduce: function (product) {
    return product.type === 'callout' && this.props.version === 'fans' && !product.sold_out;
  },

  handleProductImpressions: function () {
    const joinedProducts = this.joinProducts();
    const impressions = this.buildImpressions(joinedProducts, this.shouldReduce);

    this.commandDispatcher('analytics', 'pushProductEvent', {
      type: 'productImpression',
      products: impressions
    });
  },

  joinProducts: function () {
    const {frames, callouts} = this.props.page || {}
    const joined = frames.concat(callouts);
    const sorted = _.orderBy(joined, 'position', 'asc');
    const finalSorted = _.reject(sorted, product => {return product.sold_out});
    return finalSorted;
  },

  getStaticClasses: function () {
    return {
      block: `${this.BLOCK_CLASS}`,
      copyBlockWrapper: `
        u-mb60
        u-pb24--600 u-pt24--600
      `,
      copyBlock: `
        u-reset
        u-tac u-mla u-mra
        u-color--gray
        u-fs20 u-lh30
        u-w10c u-w9c--600 u-w7c--900
        `,
      frameWrapper: `u-tac u-mla u-mra u-mw1440 u-grid`,
      frameModifier: `u-w12c u-w6c--600 u-mb60`,
      heroCopyWrapper: `
        ${this.BLOCK_CLASS}__hero-copy-wrapper
        u-pa--900 u-center-y--900
        u-color-bg--white
        u-pt12 u-pt36--600
      `,
      heroWrapper: `u-mla u-mra u-mw1440 u-pr u-tac u-mb60`,
      heroImage: `u-w100p`,
      heroHeader: `
        ${this.BLOCK_CLASS}__hero-text-header
        u-reset
        u-fwb
        u-fs50 u-fs40--900 u-fs55--1200
      `,
      heroSubheader: `
        ${this.BLOCK_CLASS}__hero-text-subheader
        u-reset
        u-fwb
        u-fs24 u-fs30--900
        u-mb36
      `,
      heroDivider: `
        ${this.BLOCK_CLASS}__hero-divider
        u-mla u-mra
        u-mb36
      `,
      heroPricing: `
        ${this.BLOCK_CLASS}__hero-pricing
        u-reset
        u-mla u-mra
        u-fs20 u-fs24--1200
        u-ffs
        u-w8c u-w10c--900 u-w9c--1200
      `
    }
  },

  getRegionalPricing: function (pricing) {
    const locale = this.getLocale('country');

    return pricing[`${locale}`];
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
        className: classes.heroImage
      }
    };
  },

  injectFrameData: function (frame, classes) {
    // Inject frame data from DB if frame isn't sold out
    // If there is no matching frame provided by API, assume the frame is sold out
    const matchedFrameData = (_.pick(this.props.frame_data, frame.id))[frame.id];
    if (!frame.sold_out && matchedFrameData) {
      return <CollectionFrame
        {...matchedFrameData}
        version={this.props.version}
        isLinkedFrame={false}
        showGenderedLinks={true}
        gaCollectionSlug={this.props.identifier}
        gaPosition={frame.position}
        gaList={this.props.identifier}
        cssModifierBlock={classes.frameModifier} />
    } else {
      return <CollectionFrame {...frame} isSoldOut={true} />
    }
  },

  renderFrames: function (frames=[], classes) {
    const frameChildren = frames.map(frame => {return this.injectFrameData(frame, classes)});
    return (
      <div className={classes.frameWrapper} children={frameChildren} />
    );
  },

  renderCallout: function (callout) {
    // pass frame data blob down with callout for analytics
    if (!callout) return
    const matchedFrame = this.getMatchedFrameData(callout.id);
    return <Callout
      {...callout}
      gaPosition={callout.position}
      identifier={this.props.identifier}
      version={this.props.version}
      frameData={matchedFrame} />
  },

  renderHero: function (classes) {
    const hero = _.get(this.props, 'page.hero');
    const pictureAttrs = this.getPictureAttrs(hero.image, classes);
    return (
      <div className={`${classes.heroWrapper} ${hero.css_modifier}`}>
        <Picture className={classes.picture} children={this.getPictureChildren(pictureAttrs)} />
        <div className={`${classes.heroCopyWrapper} ${hero.css_modifier}`}>
          <h1 children={hero.header} className={`${classes.heroHeader} ${hero.css_modifier}`} />
          <h2 children={hero.subheader} className={`${classes.heroSubheader} ${hero.css_modifier}`}/>
          <div className={`${classes.heroDivider} ${hero.css_modifier}`} />
          <p children={this.getRegionalPricing(hero.pricing)} className={classes.heroPricing} />
        </div>
      </div>
    );
  },

  renderCopyBlock: function (copyBlock, classes) {
    if (!copyBlock) return;
    return (
      <div className={classes.copyBlockWrapper} >
        <Markdown
          rawMarkdown={copyBlock.copy}
          className={classes.copyBlock}
          cssBlock={'u-reset'} />
      </div>
    );
  },

  render: function () {
    const classes = this.getClasses();
    const {frames, callouts, copy_blocks} = this.props.page || {}
    const groupedFrames = _.groupBy(frames, frame => {
      return frame.section;
    });

    return (
      <div className={classes.block}>
        {this.renderHero(classes)}
        <div children={this.renderFrames(groupedFrames[1], classes)} />
        <div children={this.renderCopyBlock(copy_blocks[0], classes)} />
        {this.renderCallout(callouts[0])}
        <div children={this.renderFrames(groupedFrames[2], classes)} />
        <div children={this.renderCopyBlock(copy_blocks[1], classes)} />
        {this.renderCallout(callouts[1])}
        <div children={this.renderFrames(groupedFrames[3], classes)} />
        {this.renderCallout(callouts[2])}
        <div children={this.renderFrames(groupedFrames[4], classes)} />
        <div children={this.renderCopyBlock(copy_blocks[2], classes)} />
        {this.renderCallout(callouts[3])}
        <div children={this.renderFrames(groupedFrames[5], classes)} />
      </div>
    );
  }

});
