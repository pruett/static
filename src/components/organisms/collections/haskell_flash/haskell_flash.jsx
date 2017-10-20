const React = require('react/addons');
const _ = require('lodash');

const Picture = require('components/atoms/images/picture/picture');
const CTA = require('components/atoms/buttons/cta/cta');
const CollectionFrame = require('components/molecules/collections/utility/frame/frame');

const Mixins = require('components/mixins/mixins');

require('./haskell_flash.scss');


module.exports = React.createClass({
  displayName: 'OrganismsHaskellFlash',

  BLOCK_CLASS: 'c-haskell-flash',

  COLOR_OVERRIDES: {
    64387: 'Crystal with Flash Mirrored Electric Blue lenses',
    64392: 'Crystal with Flash Mirrored Electric Green lenses',
    64396: 'Crystal with Flash Mirrored Iridescent lenses',
    64394: 'Crystal with Flash Mirrored Electric Pink lenses',
    64398: 'Crystal with Flash Mirrored Silver lenses',
    64389: 'Crystal with Flash Mirrored Dusk lenses'
  },

  mixins: [
    Mixins.classes,
    Mixins.context,
    Mixins.image,
    Mixins.analytics,
    Mixins.dispatcher
  ],

  propTypes: {
    footer: React.PropTypes.object,
    hero: React.PropTypes.object,
    ids: React.PropTypes.array
  },

  getDefaultProps: function () {
    return {
      footer: {},
      hero: {},
      ids: []
    };
  },

  componentDidMount: function () {
    this.handleProductImpressions();
  },

  handleProductImpressions: function () {
    const finalImpressions = this.reduceImpressions()

    this.commandDispatcher('analytics', 'pushProductEvent', {
      type: 'productImpression',
      products: finalImpressions
    });
  },

  reduceImpressions: function () {
    const ids = this.props.ids || [];
    const frames = _.get(this.props, 'frames', []);
    const reduced = _.reduce(ids, (acc, id, index) => {
      const matchedFrame = _.find(frames,  {product_id: id});
      if (matchedFrame) {
        acc.push(this.getImpressions(matchedFrame, index));
      }
      return acc
    }, []);

    return _.flatten(reduced);
  },

  getImpressions: function (frame, index) {
    const impressions = frame.gendered_details.map( detail => {
        return {
          brand: 'Warby Parker',
          list: 'HaskellFlash',
          category: 'Sunglasses',
          collections: [
            { slug: 'HaskellFlash'}
          ],
          color: frame.color,
          name: frame.display_name,
          gender: detail.gender,
          id: detail.product_id,
          position: (index + 1)
        };
    })
    return impressions;
  },

  getStaticClasses: function () {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-mw1440 u-mla u-mra
      `,
      cssModifierFramesGrid: `
        u-grid u-tac u-mla u-mra
      `,
      footerWrapper: `
        u-grid u-w12c u-tac
        u-mb48 u-mb72--600 u-mb96--900
      `,
      footerContent: `
        u-btss u-btw1
        u-bc--light-gray
        u-pt36 u-pt60--600 u-pt84--900
      `,
      cta: `
        ${this.BLOCK_CLASS}__cta
      `,
      header: `
        u-fs24 u-fs40--900
        u-ffs
        u-fws
        u-reset
        u-mb24 u-mb36--900
      `,
      image: `u-w100p`,
      heroWrapper: `
        u-mb120--900
        u-pr
      `,
      copyWrapper: `
        u-tac
        u-pa--900
        u-center-y--900
        u-w5c--900
        u-mb60 u-mb84--600 u-mb0--900
      `,
      heroHeader: `
        ${this.BLOCK_CLASS}__hero-header
        u-fs30 u-fs40--600 u-fs55--900
        u-mla u-mra
        u-ffs
        u-fws
        u-reset u-pt30
        u-mb12 u-mb6--600 u-mb24--900
      `,
      heroBody: `
        u-w10c u-w8c--600 u-w9c--900
        u-lh26
        u-tac u-mla u-mra
        u-reset
        u-mb12 u-mb24--900
      `,
      price: `
        u-fs16 u-fwb u-reset
        u-mb48 u-mb60--600
      `,
      divider: `
        ${this.BLOCK_CLASS}__divider
        u-mla u-mra
        u-color-bg--light-gray
        u-dn--900
      `,
      cssModifierFrameBlock: `
        u-w11c u-w6c--600 u-w5c--900
        u-mb84 u-mb96--900
        u-mr24--900 u-ml24--900
      `,
      cssModifierFrameName: `
        u-ffs u-fs22 u-fs24--900
        u-fws u-mb18 u-mb16--600
        u-pt24 u-pt18--600
      `,
      cssModifierFrameColor: `
        u-ffs
        u-fs16 u-fs18--900 u-fsi u-mb18
      `
    };
  },

  getPictureAttrs: function (classes, images = []) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, 'desktop-sd'),
          quality: this.getQualityBySize(images, 'desktop-sd'),
          widths: this.getImageWidths(900, 2200, 6),
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

  getColorOverrides: function (frame) {
    // Override color attr from DB with custom copy
    if (this.COLOR_OVERRIDES[frame.product_id]) {
      frame.color = this.COLOR_OVERRIDES[frame.product_id];
    }

    return frame;
  },

  buildFrameData: function (frames, id){
    const pickedFrame = _.find(frames, {product_id: id});
    if (!_.isEmpty(pickedFrame)) {
      pickedFrame.product_id = id;
      const finalFrame = this.getColorOverrides(pickedFrame);
      return finalFrame;
    }
  },

  renderFrames: function (options = {}) {
    const {ids} = this.props;
    const frames = _.get(this.props, 'frames', []);
    const pickedFrames = ids.map(id => this.buildFrameData(frames, id));
    const frameChildren = pickedFrames.map((frame, i) => {
      return (<CollectionFrame
                {...frame}
                renderLinks={true}
                gaList={'haskellFlash'}
                gaCollectionSlug={'haskellFlash'}
                cssModifierFrameName={options.cssModifierFrameName}
                cssModifierFrameColor={options.cssModifierFrameColor}
                gaPosition={options.gaStartingPosition + i}
                key={i}
                cssModifierBlock={options.cssModifierFrame} />);
    });

    return (
      <div className={options.cssModifierFramesGrid} children={frameChildren} />
    );
  },

  renderHero: function (classes) {
    const hero = this.props.hero || {};
    const pictureAttrs = this.getPictureAttrs(classes, hero.image);
    const locale = this.getLocale('country');
    const price = hero.pricing[locale];

    return (
      <div className={classes.heroWrapper}>
        <Picture
          className={classes.picture}
          children={this.getPictureChildren(pictureAttrs)} />
        <div className={classes.copyWrapper}>
          <h1 children={hero.header} className={classes.heroHeader} />
          <p children={hero.body} className={classes.heroBody} />
          <div children={price} className={classes.price} />
          <div className={classes.divider} />
        </div>
      </div>
    );

  },

  renderFooter: function (classes) {
    const footer = this.props.footer || {};
    return (
      <div className={classes.footerWrapper}>
        <div className={classes.footerContent}>
          <h2 children={footer.header} className={classes.header} />
          <CTA
            tagName={'a'}
            href={footer.link}
            children={footer.value}
            cssModifier={classes.cta}
            analyticsSlug={'LandingPage-clickLink-shopNow'}
          />
        </div>
      </div>
    );
  },

  render: function () {
    const classes = this.getClasses();
    const framesOne = {
      cssModifierFramesGrid: classes.cssModifierFramesGrid,
      cssModifierFrame: classes.cssModifierFrameBlock,
      cssModifierFrameName: classes.cssModifierFrameName,
      cssModifierFrameColor: classes.cssModifierFrameColor,
      framesGroupIndex: 0,
      gaStartingPosition: 1
    };

    return (
      <div className={classes.block}>
        {this.renderHero(classes)}
        {this.renderFrames(framesOne)}
        {this.renderFooter(classes)}
      </div>
    );
  }

});

