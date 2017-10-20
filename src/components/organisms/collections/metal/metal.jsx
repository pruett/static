const React = require('react/addons');
const _ = require('lodash');

const TypeKit = require('components/atoms/scripts/typekit/typekit');
const Picture = require('components/atoms/images/picture/picture');
const Hero = require('components/molecules/collections/metal/hero/hero');
const Callout = require('components/molecules/collections/metal/callout/callout');
const CollectionFrame = require('components/molecules/collections/utility/frame/frame');

const Mixins = require('components/mixins/mixins');

require('./metal.scss');


module.exports = React.createClass({
  displayName: 'OrganismsCollectionsMetal',

  BLOCK_CLASS: 'c-metal',

  TYPEKIT_ID: 'jkq7diy',

  COLOR_OVERRIDE_IDS: [62171, 62173, 62168],

  FRAME_COLOR_LOOKUP: {
    // Override PC color with custom lens colors
    62171: 'Flash Mirrored Violet Lenses',
    62173: 'Flash Reflective Flame Lenses',
    62168: 'Flash Mirrored Cobalt Lenses'
  },

  propTypes: {
    version: React.PropTypes.string,
    content: React.PropTypes.object
  },

  getDefaultProps: function () {
    return {
      content: {},
      version: 'optical'
    };
  },

  mixins: [
    Mixins.classes,
    Mixins.image,
    Mixins.analytics,
    Mixins.dispatcher
  ],

  componentDidMount: function () {
    this.getProductImpressions();
  },

  getStaticClasses: function () {
    return {
      block: this.BLOCK_CLASS,
      image: 'u-w100p u-db',
      lifeStyleWrapper: 'u-mla u-mra u-mw1440 u-pr u-mb72 u-mb96--900',
      lifeStyleWrapperSun: 'u-mla u-mra u-mw1440 u-pr',
      labelWrapper: `
        u-pa
        u-b0 u-r0
        u-pb24 u-pr24
      `,
      frameLabel: `${this.BLOCK_CLASS}__link-modifier`,
      cssModifierFramesGridTwoUp: 'u-mw1440 u-mla u-mra u-tac u-pl36--600 u-pr36--600 u-w8c--900 u-mb24 u-mb36--900 u-metal-container',
      cssModifierFramesGridThreeUp: 'u-mw1440 u-mla u-mra u-tac u-pl36--600 u-pr36--600 u-w12c--900 u-mb24 u-mb36--900 u-metal-container -three',
      cssModifierFrameBlockTwoUp: 'u-w11c u-w6c--600 u-mb60 u-mb60--600',
      cssModifierFrameBlockThreeUp: 'u-w11c u-w6c--600 u-w4c--900 u-mb60 u-mb60--600',
      cssModifierFinalCallout: 'u-mb0',
      cssModifierFinalCalloutPadded: `
        u-pl12 u-pr12 u-pb12
        u-pl36--600 u-pr36--600 u-pb36--600
        u-pl72--1200 u-pr72--1200 u-pb60--1200
      `,
      cssModifierCallout: 'u-mb72 u-mb96--900',
      cssModifierHeroSun: 'u-mb0 -sun',
      cssModifierHeroCopySun: `${this.BLOCK_CLASS}__hero-copy-sun`,
      cssModifierHeroCopyOptical: `${this.BLOCK_CLASS}__hero-copy-optical`,
      picture: 'u-db'
    };
  },

  getHeroContent: function () {
    return _.get(this.props.content, `hero[${this.props.version}]`, {});
  },

  getFrameColorOverrides: function (frame) {
    const id = frame.product_id;

    if (this.COLOR_OVERRIDE_IDS.indexOf(id) >= 0) {
      frame.color = this.FRAME_COLOR_LOOKUP[id];
    }

    return frame;
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

  getProductImpressions: function () {
    const ids = _.flatten(_.get(this.props, `content.frame_groups[${this.props.version}]`, []));
    const frames = _.get(this.props, 'content.__data.products');
    const finalImpressions = ids.map((id, i) => {
      const matchedFrame = (_.pick(frames, id))[id];
      const impressions = matchedFrame.gendered_details.map( detail => {
        return {
          brand: 'Warby Parker',
          category: matchedFrame.assembly_type,
          collections: [
            {
              slug: 'Metal'
            }
          ],
          color: matchedFrame.color,
          gender: detail.gender,
          id: detail.product_id,
          list: 'MetalCollection',
          name: matchedFrame.display_name,
          position: (i + 1),
          url: detail.path

        }
      })
      return impressions;
    });

    this.commandDispatcher('analytics', 'pushProductEvent', {
      type: 'productImpression',
      products: _.flatten(finalImpressions)
    });

  },

  handleLabelClick: function (label = {}) {
    const ga = label.ga || {};
    const genderLookup = {f: 'Women', m: 'Men'};
    const productClick = {
      type: 'productClick',
      products: [
        {
          brand: 'Warby Parker',
          category: 'Eyeglasses',
          list: 'MetalCollection',
          id: ga.product_id,
          name: ga.name,
          collections: [
            {
              slug: 'Metal'
            }
          ],
          color: ga.color,
          gender: ga.gender,
          position: ga.position,
          sku: ga.sku,
          url: ga.url
        }
      ]
    };

    this.commandDispatcher('analytics', 'pushProductEvent', productClick);
    this.trackInteraction(`LandingPage-clickShop${genderLookup[ga.gender]}Callout-${ga.sku}`);
  },

  renderPicture: function (classes, images = []) {
    const pictureAttrs = this.getPictureAttrs(classes, images);

    return (
      <Picture className={classes.picture} children={this.getPictureChildren(pictureAttrs)} />
    );
  },

  renderLifestyleImagery: function (classes, cssModifier = '', key) {
    const lifeStyleImages = _.get(this.props, 'content.lifestyle_images');
    const matchedImagery = (_.find(lifeStyleImages, {key: key})) || {};
    const labels = matchedImagery.frame_labels;

    return (
      <div className={cssModifier}>
        {this.renderPicture(classes, matchedImagery.images)}
        {labels && this.renderLabels(classes, labels)}
      </div>
    );
  },

  renderLabels: function (classes, labels = []) {
    const labelChildren = labels.map((label, i) => {
      return (
        <span key={i}>
          <a key={i}
             onClick={this.handleLabelClick.bind(this, label)}
             href={label.path}
             className={label.css_modifier_label}>
            <span
              children={label.name}
              className={`${classes.frameLabel} ${label.css_modifier_name}`} />
            <span
              children={' ' + `in ${label.color}`}
              className={label.css_modifier_color} />
          </a>
        </span>
      );
    });

    return <div className={classes.labelWrapper} children={labelChildren} />
  },

  renderCallout: function (key = '', cssModifier = '') {
    const callouts = _.get(this.props, 'content.callout_blocks', []);
    const calloutData = _.find(callouts, {key: key});

    if (!calloutData) {
      return false;
    }

    return (
      <Callout {...calloutData} cssModifierBlock={cssModifier} />
    );
  },

  renderFrames: function (options = {}) {
    const frameGroups = _.get(this.props, `content.frame_groups[${this.props.version}]`);
    const ids = frameGroups[options.framesGroupIndex];
    const frames = _.get(this.props, 'content.__data.products', {});
    const pickedFrames = ids.map(id => {
      const pickedFrame = frames[id];
      if (!_.isEmpty(pickedFrame)) {
        pickedFrame.product_id = id;
        return this.getFrameColorOverrides(pickedFrame);
      }
    })
    const frameChildren = pickedFrames.map((frame, i) => {
      return (<CollectionFrame
                {...frame}
                renderLinks={true}
                gaList={'metalCollection'}
                gaCollectionSlug={'metalCollection'}
                gaPosition={options.gaStartingPosition + i}
                key={i}
                cssModifierBlock={options.cssModifierFrame} />);
    });

    return (
      <div className={options.cssModifierFramesGrid} children={frameChildren} />
    );
  },

  renderOptical: function (classes) {
    const heroContent = this.getHeroContent();
    const version = this.props.version;
    const framesOne = {
      cssModifierFramesGrid: classes.cssModifierFramesGridTwoUp,
      cssModifierFrame: classes.cssModifierFrameBlockTwoUp,
      framesGroupIndex: 0,
      gaStartingPosition: 1
    };
    const framesTwo = {
      cssModifierFramesGrid: classes.cssModifierFramesGridTwoUp,
      cssModifierFrame: classes.cssModifierFrameBlockTwoUp,
      framesGroupIndex: 1,
      gaStartingPosition: 3
    };
    const framesThree = {
      cssModifierFramesGrid: classes.cssModifierFramesGridTwoUp,
      cssModifierFrame: classes.cssModifierFrameBlockTwoUp,
      framesGroupIndex: 2,
      gaStartingPosition: 5
    };
    const framesFour = {
      cssModifierFramesGrid: classes.cssModifierFramesGridTwoUp,
      cssModifierFrame: classes.cssModifierFrameBlockTwoUp,
      framesGroupIndex: 3,
      gaStartingPosition: 7
    };

    return (
      <div>
        <Hero
          {...heroContent}
          version={this.props.version}
          renderLabels={this.renderLabels}
          cssModifierCopy={classes.cssModifierHeroCopyOptical}
          handleLabelClick={this.handleLabelClick} />
          { this.renderFrames(framesOne) }
          { this.renderLifestyleImagery(classes, classes.lifeStyleWrapper, 'optical_first') }
          { this.renderFrames(framesTwo) }
          { this.renderLifestyleImagery(classes, classes.lifeStyleWrapper, 'optical_second') }
          { this.renderFrames(framesThree) }
          { this.renderCallout(`${version}_first`, classes.cssModifierCallout) }
          { this.renderFrames(framesFour) }
          { this.renderCallout(`${version}_second`, classes.cssModifierFinalCalloutPadded) }
      </div>
    );
  },

  renderSun: function (classes) {
    const heroContent = this.getHeroContent();
    const version = this.props.version;
    const framesOne = {
      cssModifierFramesGrid: classes.cssModifierFramesGridThreeUp,
      cssModifierFrame: classes.cssModifierFrameBlockThreeUp,
      framesGroupIndex: 0,
      gaStartingPosition: 1
    };
    const framesTwo = {
      cssModifierFramesGrid: classes.cssModifierFramesGridTwoUp,
      cssModifierFrame: classes.cssModifierFrameBlockTwoUp,
      framesGroupIndex: 1,
      gaStartingPosition: 4
    };
    const framesThree = {
      cssModifierFramesGrid: classes.cssModifierFramesGridTwoUp,
      cssModifierFrame: classes.cssModifierFrameBlockTwoUp,
      framesGroupIndex: 2,
      gaStartingPosition: 7
    };

    return (
      <div>
        <Hero
          {...heroContent}
          version={this.props.version}
          cssModifier={classes.cssModifierHeroSun}
          cssModifierCopy={classes.cssModifierHeroCopySun}
          renderLabels={this.renderLabels}
          handleLabelClick={this.handleLabelClick} />
          { this.renderCallout(`${version}_first`, classes.cssModifierCallout) }
          { this.renderFrames(framesOne)}
          { this.renderLifestyleImagery(classes, classes.lifeStyleWrapper, 'sun_first') }
          { this.renderFrames(framesTwo)}
          { this.renderLifestyleImagery(classes, classes.lifeStyleWrapperSun, 'sun_second') }
          { this.renderCallout(`${version}_second`, classes.cssModifierCallout) }
          { this.renderFrames(framesThree)}
          { this.renderCallout(`${version}_third`, classes.cssModifierFinalCalloutPadded) }
      </div>
    );
  },

  renderContent: function (classes) {
    if (this.props.version === 'sun') {
      return this.renderSun(classes);
    } else {
      return this.renderOptical(classes);
    }
  },

  render: function () {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <TypeKit typeKitModifier={this.TYPEKIT_ID} />
        {this.renderContent(classes)}
      </div>
    );
  }

});
