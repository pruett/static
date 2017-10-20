/* 
  This is an implementation of the Local Business schema from
  Schema.org (see http://schema.org/LocalBusiness). Its purpose
  is to markup local business information in the body of a web page
  so that it displays correctly in search engines like Google, Bing,
  Yahoo, etc.; thus improving the site's Seach Engine Optimization.
*/

const _ = require("lodash");
const React = require("react/addons");
const Helper = require("components/utilities/structured_data/helper");

const getOpeningHours = openingHours => {
  const store = _.find(openingHours, {name: "Store"});
  const hours = _.get(store, "hours", []);
  return formatHours(hours);
};

const formatHours = hours => {
  return _.map(hours, (time, day) => {
    if (!(time.open && time.close && day)) {
      return null;
    }

    const open = formatTime(time.open);
    const close = formatTime(time.close);
    if (!(open && close)) {
      return null;
    }

    day = _.startCase(day.slice(0, 2));
    return `${day} ${open}-${close}`;
  });
};

const formatTime = time => {
  const pieces = time.split(":");
  if (!(pieces.length > 1)) {
    return null;
  }

  let hours = pieces[0];
  if (time.match(/p\.?m/gi)) {
    hours = parseInt(hours) + 12;
  }

  const minutesTimeOfDay = pieces[1].split(/(\s|a|p)/gi);
  if (!(minutesTimeOfDay.length > 1)) {
    return null;
  }

  const minutes = minutesTimeOfDay[0];
  return `${hours}:${minutes}`;
};

const getSchema = props => {
  return JSON.stringify(
    _.omitBy(_.merge({}, LocalBusinessSchema.defaultProps, props, {
      "@context": "http://schema.org",
      "@id": _.kebabCase(props.name) + "#" + _.kebabCase(props.type),
      "@type": props.type,
      contactPoint: {
        telephone: Helper.formatPhone(props.telephone)
      },
      image: Helper.formatUrl(props.image),
      openingHours: getOpeningHours(props.openingHours),
      photo: {
        url: Helper.formatUrl(props.image)
      },
      priceRange: Helper.formatPriceRange(props.priceRange),
      telephone: Helper.formatPhone(props.telephone),
      type: '',
      url: Helper.formatUrl(props.url)
    }), _.isEmpty)
  );
};

const LocalBusinessSchema = props => {
  props = _.pick(props, _.keys(LocalBusinessSchema.propTypes));
  return (
    <script type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: Helper.sanitize(getSchema(props)) }} />
  );
};

LocalBusinessSchema.propTypes = {
  address: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    addressLocality: React.PropTypes.string,
    addressRegion: React.PropTypes.string,
    postalCode: React.PropTypes.string,
    streetAddress: React.PropTypes.string,
    addressCountry: React.PropTypes.string
  }),
  brand: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    name: React.PropTypes.string
  }),
  contactPoint: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    contactOption: React.PropTypes.string,
    contactType: React.PropTypes.string,
    telephone: React.PropTypes.string
  }),
  description: React.PropTypes.string,
  geo: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    latitude: React.PropTypes.string,
    longitude: React.PropTypes.string
  }),
  hasMap: React.PropTypes.string,
  image: React.PropTypes.string,
  name: React.PropTypes.string,
  openingHours: React.PropTypes.array,
  photo: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    url: React.PropTypes.string
  }),
  priceRange: React.PropTypes.string,
  telephone: React.PropTypes.string,
  type: React.PropTypes.string,
  url: React.PropTypes.string
};

LocalBusinessSchema.defaultProps = {
  address: {
    "@type": "PostalAddress",
    addressLocality: "",
    addressRegion: "",
    postalCode: "",
    streetAddress: "",
    addressCountry: "US"
  },
  brand: {
    "@type": "Brand",
    name: "Warby Parker"
  },
  contactPoint: {
    "@type": "ContactPoint",
    contactOption: "TollFree",
    contactType: "Customer Service",
    telephone: "+1.888.492.7297"
  },
  description: "Warby Parker was founded with a rebellious spirit and a lofty objective: to offer designer eyewear at a revolutionary price, while leading the way for socially conscious businesses.",
  geo: {
    "@type": "GeoCoordinates",
    latitude: "",
    longitude: ""
  },
  hasMap: "",
  image: "https://i.warbycdn.com/v/c/assets/retail/image/hero-m/2/1834133631.jpg",
  name: "Warby Parker",
  openingHours: [],
  photo: {
    "@type": "Photograph",
    url: "https://i.warbycdn.com/v/c/assets/retail/image/hero-m/2/1834133631.jpg"
  },
  priceRange: "95",
  telephone: "+1.888.492.7297",
  type: "LocalBusiness",
  url: "https://www.warbyparker.com"
};

module.exports = LocalBusinessSchema;
