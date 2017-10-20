const React = require('react/addons');
const _ = require('lodash');

const Callout = require('components/molecules/collections/sunscapades/callout/callout');
const Carousel = require('components/molecules/collections/utility/carousel/carousel');
const Hero = require('components/molecules/collections/sunscapades/hero/hero');

const Mixins = require('components/mixins/mixins');

require('./sunscapades.scss');


module.exports = React.createClass({
  displayName: 'OrganismsCollectionsSunscapades',

  BLOCK_CLASS: 'c-sunscapades',

  mixins: [
    Mixins.classes,
    Mixins.scrolling,
    Mixins.dispatcher
  ],

  propTypes: {
    image_overrides: React.PropTypes.array,
    callout_blocks: React.PropTypes.array,
    impression_ids: React.PropTypes.array,
    hero: React.PropTypes.object
  },

  getInitialState: function () {
    return {
      animated: []
    }
  },

  getDefaultProps: function () {
    return {
      image_overrides: [],
      callout_blocks: [],
      impression_ids: [],
      hero: {}
    };
  },

  componentDidMount: function () {
    this.addScrollListener(this.animateRefs);
    this.handleProductImpressions()
  },

  injectImpressions: function(matchedFrame, frameGroup, index) {
    const impressions = frameGroup.genders.map( gender => {
      const gendered = (_.find(matchedFrame.gendered_details, {gender: gender}))
      if (gendered) {
        const product_id = gendered.product_id;
        return {
          brand: 'Warby Parker',
          list: 'Sunscapades',
          category: 'Sunglasses',
          collections: [
            { slug: 'Sunscapades'}
          ],
          color: matchedFrame.color,
          name: matchedFrame.display_name,
          gender: gender,
          id: product_id,
          position: (index + 1)
        };
      }
    });

    return impressions;
  },

  reduceImpressions: function(idGroup, index) {
    const frames = _.get(this.props, '__data.products');
    const reduced = _.reduce(idGroup, (impressions, frameGroup) => {
      const matchedFrame = _.pick(frames, frameGroup.id)[frameGroup.id];
      if (matchedFrame) {
        impressions.push(this.injectImpressions(matchedFrame, frameGroup, index));
      }
      return impressions;
    }, []);

    return _.flatten(reduced);
  },

  handleProductImpressions: function () {
    const impressionIDs = this.props.impression_ids;
    const finalImpressions = _.reduce(impressionIDs, (impressions, idGroup, index) => {
      impressions.push(this.reduceImpressions(idGroup, index));
      return impressions;
    }, []);

    this.commandDispatcher('analytics', 'pushProductEvent', {
      type: 'productImpression',
      products: _.flatten(finalImpressions)
    });
  },

  animateRefs: function () {
    for (const key in this.refs) {
      const ref = this.refs[key];
      if (this.refIsInViewport(ref)) {
        const animatedRefs = this.state.animated;
        animatedRefs.push(key);
        this.setState({animated: animatedRefs});
      }
    }
  },

  getStaticClasses: function () {
    return {
      block: `${this.BLOCK_CLASS} u-pb60 u-pb84--600`,
      framesGrid: 'u-mw1440 u-mla u-mra u-tac u-pl12 u-pr12 u-pr48--900 u-pl48--900 u-pt12 u-pt0--600',
      cssModifierImageWrapper: `
        ${this.BLOCK_CLASS}__css-modifier-image-wrapper
      `
    };
  },

  reduceFrames: function (idGroup) {
    const frameData = _.get(this.props, '__data.products');
    const reduced = _.reduce(idGroup, (frameGroup, id) => {
      const pickedFrame = frameData[id]
      const imageOverride = this.getImageOverride(id);
      if (pickedFrame) {
        pickedFrame.product_id = id;
        if (imageOverride) {
          pickedFrame.image = imageOverride;
        }
        frameGroup.push(pickedFrame);
      }
      return frameGroup;
    }, []);

    return reduced;
  },

  prepareFrames: function (group) {
    const frameIDs = _.get(this.props, `frame_rows[${group}]`);

    const finalFrames = _.reduce(frameIDs, (acc, idGroup) => {
      acc.push(this.reduceFrames(idGroup));
      return acc;
    }, []);

    return finalFrames;

  },

  getImageOverride: function (id) {
    // Override product imagery with custom CMS imagery
    const imageOverrideLookup = this.props.image_overrides || {};
    const imageOverride = (_.find(imageOverrideLookup, {key: id}))
    if (imageOverride) {
      return imageOverride.src
    }
  },

  renderFrames: function (group, classes, startingIndex) {
    const preparedFrames = this.prepareFrames(group);

    const frameChildren = preparedFrames.map((frameGroup, i) => {
      if (frameGroup.length > 0) {
        return <Carousel
          products={frameGroup}
          cssModifierImageWrapper={classes.cssModifierImageWrapper}
          gaPosition={startingIndex + i}
          gaCollectionSlug={'Sunscapades'}
          key={i} />
      } else {
        return false
      }
    });

    return(frameChildren);
  },

  getAnimatedState: function (key) {
    if (this.state.animated.indexOf(key) >= 0) {
      return true
    } else {
      return false
    }
  },

  render: function () {
    const classes = this.getClasses();
    const firstCallout = _.find(this.props.callout_blocks, {lookup: 'first'} );
    const secondCallout = _.find(this.props.callout_blocks, {lookup: 'second'});
    const thirdCallout = _.find(this.props.callout_blocks, {lookup: 'third'});
    const fourthCallout = _.find(this.props.callout_blocks, {lookup: 'fourth'});
    const hero = this.props.hero

    return (
      <div className={classes.block}>
        <Hero {...hero} />
        <div className={classes.framesGrid} children={this.renderFrames('one', classes, 1)} />
        <Callout {...firstCallout} key={'first'} ref={'first'} animate={this.getAnimatedState('first')} />
        <div className={classes.framesGrid} children={this.renderFrames('two', classes, 3)} />
        <Callout {...secondCallout} key={'second'} ref={'second'} animate={this.getAnimatedState('second')} />
        <div className={classes.framesGrid} children={this.renderFrames('three', classes, 5)} />
        <Callout {...thirdCallout} key={'third'} ref={'third'} animate={this.getAnimatedState('third')} />
        <div className={classes.framesGrid} children={this.renderFrames('four', classes, 7)} />
        <Callout {...fourthCallout} key={'fourth'} ref={'fourth'} animate={this.getAnimatedState('fourth')} />
        <div className={classes.framesGrid} children={this.renderFrames('five', classes, 9)} />
      </div>
    );
  }

});
