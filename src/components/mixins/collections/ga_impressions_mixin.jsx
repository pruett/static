const _ = require("lodash");

module.exports = {
  GA_GENDER_LOOKUP: {
    m: "Men",
    f: "Women"
  },
  // A set of helpers to build GA product impressions for collections pages.
  // Expects the calling component to have access to a `version` prop of 'm', 'f',
  // or 'fans'

  buildImpressions: function(products = [], shouldReduce) {
    // Function to build callout impressions.
    // Expects an array of product objects, representing frames or callouts generally
    // Gendered details of certain products might require a reduce, so this function
    // Accepts a `shouldReduce` function, invoked per product to determine eligibility
    // to reduce.

    if (!products) return;

    if (!shouldReduce) {
      shouldReduce = product =>
        this.props.version === "fans" && !product.sold_out;
    }

    const reducedImpressions = _.reduce(
      products,
      (impressions, product, i) => {
        if (shouldReduce(product)) {
          const calloutImpressions = this.reduceCalloutImpressions(
            product.genders,
            product,
            i
          );
          impressions.push(_.flatten(calloutImpressions));
        } else if (!product.sold_out) {
          const frameImpressions = this.buildFrameImpression(product.id, i);
          impressions.push(frameImpressions);
        }
        return impressions;
      },
      []
    );
    return _.compact(_.flatten(reducedImpressions));
  },

  reduceCalloutImpressions: function(genderList, product, i) {
    const calloutImpressions = _.reduce(
      product.genders,
      (acc, gender) => {
        return this.reduceGenderedImpressions(acc, gender, product, i);
      },
      []
    );

    return calloutImpressions;
  },

  reduceGenderedImpressions: function(acc, gender, product, i) {
    const impression = this.buildCalloutImpression(gender, product, i);
    acc.push(impression);
    return acc;
  },

  buildCalloutImpression: function(gender, product, index) {
    const genderedDetails = this.getGenderedDetails(gender, product.id);
    const impression = this.buildImpression(genderedDetails, product.id, index);
    return impression;
  },

  buildImpression: function(genderedDetails, id, index) {
    // Build the final impression object, ultimately pushed to the dataLayer
    const matchedFrame = this.getMatchedFrameData(id);

    return {
      brand: "Warby Parker",
      list: this.props.identifier,
      category: matchedFrame.assembly_type,
      collections: [{ slug: this.props.identifier }],
      color: matchedFrame.color,
      name: matchedFrame.display_name,
      gender: genderedDetails.gender,
      id: genderedDetails.product_id,
      position: index + 1
    };
  },

  buildFrameImpression: function(id, index) {
    if (this.props.version === "fans") {
      const matchedFrame = this.getMatchedFrameData(id);
      if (!_.isEmpty(matchedFrame)) {
        const impressions = matchedFrame.gendered_details.map(detail => {
          return this.buildImpression(detail, id, index);
        });
        return impressions;
      }
    } else {
      const genderedDetails = this.getGenderedDetails(this.props.version, id);
      const impression = this.buildImpression(genderedDetails, id, index);
      return impression;
    }
  },

  getMatchedFrameData: function(id) {
    // Safely picks a frame by its ID
    const frame_data = this.props.frame_data;
    const matchedFrame = _.pick(frame_data, id)[id];
    return matchedFrame || {};
  },

  getGenderedDetails: function(gender, id) {
    // Pick frame using gender and ID, returns gendered_details
    const matchedFrame = this.getMatchedFrameData(id);
    const gendered_details = _.find(matchedFrame.gendered_details, {
      gender: gender
    });
    return gendered_details || {};
  },

  buildBaseImpression: function(options = {}) {
    return {
      brand: "Warby Parker",
      category: options.category,
      collections: [{ slug: options.identifier }],
      color: options.color,
      gender: options.gender,
      id: options.id,
      list: options.identifier,
      name: options.name,
      position: options.position,
      sku: options.sku
    };
  },

  // Helpers for handling sold out/lookups in carousel components
  matchFrames: function(frame = {}) {
    // Look up frame data, return uninjected object
    const frameData = _.get(this.props, "frame_data");
    const matchedFrame = _.pick(frameData, frame.id)[frame.id];
    if (matchedFrame) {
      return matchedFrame;
    } else {
      // assume frame is sold out
      frame.sold_out = true;
      return frame;
    }
  },

  injectFrameGroup: function(frameGroup) {
    // Inject frame data from DB into frame group if not sold out.
    const injectedFrames = frameGroup.frame_info.map(frame => {
      if (!frame.sold_out) {
        return this.matchFrames(frame);
      } else {
        console.log("sold out, returning frame", frame);
        return frame;
      }
    });

    return injectedFrames;
  }
};
