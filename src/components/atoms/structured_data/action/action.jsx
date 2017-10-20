const _ = require("lodash");
const React = require("react/addons");
const Helper = require("components/utilities/structured_data/helper");

const getSchema = props => {
  return JSON.stringify(
    _.omitBy(_.merge({}, ActionSchema.defaultProps, props, {
      "@context": "http://schema.org",
      "@id": _.kebabCase(props.name) + "#" + _.kebabCase(props.type),
      "@type": props.type,
      image: Helper.formatUrl(props.image),
      object: {
        image: Helper.formatUrl(props.object.image),
        priceRange: Helper.formatPriceRange(props.object.priceRange),
        telephone: Helper.formatPhone(props.object.telephone)
      },
      target: {
        urlTemplate: Helper.formatUrl(props.target.urlTemplate)
      },
      type: '',
      url: Helper.formatUrl(props.url)
    }), _.isEmpty)
  );
};

const ActionSchema = props => {
  props = _.pick(props, _.keys(ActionSchema.propTypes));
  return (
    <script type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: Helper.sanitize(getSchema(props)) }} />
  );
};

ActionSchema.propTypes = {
  actionStatus: React.PropTypes.string,
  agent: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    name: React.PropTypes.string,
    url: React.PropTypes.string
  }),
  description: React.PropTypes.string,
  endTime: React.PropTypes.string,
  image: React.PropTypes.string,
  instrument: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    name: React.PropTypes.string
  }),
  location: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    address: React.PropTypes.objectOf({
      "@type": React.PropTypes.string,
      addressLocality: React.PropTypes.string,
      addressRegion: React.PropTypes.string,
      postalCode: React.PropTypes.string,
      streetAddress: React.PropTypes.string,
      addressCountry: React.PropTypes.string
    }),
    name: React.PropTypes.string
  }),
  name: React.PropTypes.string,
  object: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    address: React.PropTypes.objectOf({
      "@type": React.PropTypes.string,
      addressLocality: React.PropTypes.string,
      addressRegion: React.PropTypes.string,
      postalCode: React.PropTypes.string,
      streetAddress: React.PropTypes.string,
      addressCountry: React.PropTypes.string
    }),
    image: React.PropTypes.string,
    name: React.PropTypes.string,
    priceRange: React.PropTypes.string,
    telephone: React.PropTypes.string
  }),
  participant: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    name: React.PropTypes.string
  }),
  result: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    name: React.PropTypes.string
  }),
  startTime: React.PropTypes.string,
  target: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    actionPlatform: React.PropTypes.array,
    inLanguage: React.PropTypes.string,
    urlTemplate: React.PropTypes.string
  }),
  type: React.PropTypes.string,
  url: React.PropTypes.string
};

ActionSchema.defaultProps = {
  actionStatus: "Proposed",
  agent: {
    "@type": "Organization",
    name: "Warby Parker",
    url: "https://www.warbyparker.com"
  },
  description: "",
  endTime: "",
  image: "",
  instrument: {
    "@type": "WebPage",
    name: "Webpage"
  },
  location: {
    "@type": "Place",
    address: {
      "@type": "PostalAddress",
      streetAddress: "",
      addressLocality: "",
      addressRegion: "",
      postalCode: "",
      addressCountry: "US"
    },
    name: ""
  },
  name: "",
  object: {
    "@type": "Store",
    address: {
      "@type": "PostalAddress",
      streetAddress: "",
      addressLocality: "",
      addressRegion: "",
      postalCode: "",
      addressCountry: "US"
    },
    image: "",
    name: "",
    priceRange: "",
    telephone: ""
  },
  participant: {},
  result: {
    "@type": "EventReservation",
    name: "Book an eye exam"
  },
  startTime: "",
  target: {
    "@type": "EntryPoint",
    actionPlatform: [
      "http://schema.org/DesktopWebPlatform",
      "http://schema.org/IOSPlatform"
    ],
    inLanguage: "en-US",
    urlTemplate: "https://www.warbyparker.com"
  },
  type: "ReserveAction",
  url: "https://www.warbyparker.com"
};

module.exports = ActionSchema;
