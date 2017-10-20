/* 
  This is an implementation of the Product schema from
  Schema.org (see http://schema.org/Product). Its purpose is
  to markup product information in the body of a web page so
  that it displays correctly in search engines like Google, Bing,
  Yahoo, etc.; thus improving the site's Seach Engine Optimization.
*/

const _ = require("lodash");
const React = require("react/addons");
const Helper = require("components/utilities/structured_data/helper");
const { conversion } = require("components/mixins/mixins");

const getAdditionalProperties = props => {
  const additionalProperties = [];

  _.map(props.colors, (color, index) => (
    additionalProperties.push(
      {
        "@type": "PropertyValue",
        name: "Color",
        value: color.color
      }
    )
  ));

  _.forOwn(props.product.measurements, (value, key) => (
    additionalProperties.push(
      {
        "@type": "PropertyValue",
        name: key,
        value: value
      }
    ) 
  ));

  if (props.product.gender) {
    additionalProperties.push(
      {
        "@type": "PropertyValue",
        name: "Gender",
        value: getGender()
      }
    )
  }

  const width = (props.product.width_group || props.product.width);
  if (width) {
    additionalProperties.push(
      {
        "@type": "PropertyValue",
        name: "Width",
        value: width
      }
    )
  }

  return additionalProperties;
};

const getGender = gender => {
  return gender === "m" ? "Male" : "Female";
};

const getImageUrl = product => {
  const imageUrl = _.get(product, "image", "");
  const originalImageUrl = _.get(product, "image_set.fill.front.original", "");
  const orientationImageUrl = _.get(product, "image_set.orientation.front", "");
  const assemblyType = _.get(product, "assembly_type", "");

  if (!_.isEmpty(imageUrl)) {
    return imageUrl;
  } else if (!_.isEmpty(originalImageUrl)) {
    return originalImageUrl;
  } else if (!_.isEmpty(orientationImageUrl)) {
    return "//i.warbycdn.com/-/c/" + orientationImageUrl;
  } else if (assemblyType.indexOf("sun") > -1) {
    return "//i.warbycdn.com/v/c/assets/gallery/image/placeholder-sun/2/2b4f45a631.jpg";
  } else {
    return "//i.warbycdn.com/v/c/assets/gallery/image/placeholder-optical/3/19610096e7.jpg";
  }
};

const getSku = product => {
  return _.toString(product.id || product.product_id);
};

const getMaterial = product => {
  const pdpDetailsCmsIdentifier = _.get(product, "pdp_details_cms_identifier", "");
  const material = _.get(product, "attributes.material", {});

  if (!_.isEmpty(pdpDetailsCmsIdentifier)) {
    return pdpDetailsCmsIdentifier;
  } else if (!_.isEmpty(material)) {
    return _.keys(material).join();
  }
};

const getCategory = product => {
  const assemblyType = _.get(product, "assembly_type", "");

  if (!_.isEmpty(assemblyType)) {
    if (assemblyType.indexOf("sun") > -1) {
      return "Apparel & Accessories > Clothing Accessories > Sunglasses";
    } else {
      return "Health & Beauty > Personal Care > Vision Care > Eyeglasses";
    }
  }
};

const getReleaseDate = product => {
  const release_date = _.get(product, "release_date", []);
  if (!_.isEmpty(release_date)) {
    return _.head(_.values(release_date));
  }

  const collections = _.get(product, "collections", []);
  return _.head(_.map(collections, (collection, index) => {
    return collection.release_date;
  }));
};

const getAggregateOffer = variants => {
  if (_.isEmpty(variants)) {
    return;
  }

  const prices = [];
  const offers = [];

  _.forOwn(variants, (value, key) => {
    let price = conversion.convert("cents", "dollars", value.price_cents);

    prices.push(price);

    offers.push({
      "@type": "Offer",
      priceCurrency: "USD",
      price: price,
      itemCondition: "http://schema.org/NewCondition",
      availability: (value.in_stock ? "http://schema.org/InStock" : "http://schema.org/OutOfStock")
    });
  });

  return {
    "@type": "AggregateOffer",
    seller: {
      "@type": "Organization",
      name: "Warby Parker"
    },
    priceCurrency: "USD",
    highPrice: _.max(prices),
    lowPrice: _.min(prices),
    offerCount: offers.length,
    offers: offers
  };
};

const getLowestPrice = props => {
  const color = props.colors[props.activeColorIndex] || {};
  const active = _.get(props.variantTypes, color.assembly_type, []);
  const lowestPrice = _.reduce(
    _.pick(color.variants, active),
    function(acc, attrs) {
      if (attrs.price_cents < acc || !acc) {
        return attrs.price_cents;
      } else {
        return acc;
      }
    },
    null
  );

  let price = conversion.convert("cents", "dollars", lowestPrice);
  if (price === "0.00" && props.lowestPrice > 0) {
    price = parseInt(props.lowestPrice, 10).toFixed(2);
  }

  return price;
};

const getRelatedProducts = props => {
  return _.map(props.product.recommendations, (recommendation, index) => ({
    "@type": "Product",
    url: recommendation.path,
    offers: {
      "@type": "Offer",
      priceCurrency: "USD",
      price: getLowestPrice(props),
      name: recommendation.display_name
    }
  }));
};

const getSchema = props => {
  return JSON.stringify(
    _.omitBy({
      "@context": "http://schema.org",
      "@type": "Product",
      "@id": _.kebabCase(props.product.path),
      name: props.product.display_name,
      description: props.product.description,
      brand: {
        "@type": "Brand",
        name: "Warby Parker"
      },
      sku: getSku(props.product),
      color: props.product.color,
      url: props.product.path,
      mainEntityOfPage: props.product.path,
      image: getImageUrl(props.product),
      material: getMaterial(props.product),
      category: getCategory(props.product),
      releaseDate: getReleaseDate(props.product),
      audience: {
        "@type": "PeopleAudience",
        suggestedGender: getGender(props.product.gender)
      },
      additionalProperty: getAdditionalProperties(props),
      offers: getAggregateOffer(props.product.variants),
      isRelatedTo: getRelatedProducts(props)
    }, _.isEmpty)
  );
};

const ProductSchema = props => {
  props = _.pick(props, _.keys(ProductSchema.propTypes));
  return (
    <script type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: Helper.sanitize(getSchema(props)) }} />
  );
};

ProductSchema.propTypes = {
  product: React.PropTypes.object,
  colors: React.PropTypes.array,
  lowestPrice: React.PropTypes.number
};

ProductSchema.defaultProps = {
  product: {},
  colors: [],
  lowestPrice: 0
};

module.exports = ProductSchema;
