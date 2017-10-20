/* 
  This is an implementation of the Mobile Application schema from
  Schema.org (see http://schema.org/MobileApplication). Its purpose is
  to markup software application information in the body of a web page so
  as to better display app details in search engines like Google, Bing,
  Yahoo, etc.; thus improving the site's Seach Engine Optimization.
*/

const _ = require("lodash");
const React = require("react/addons");
const Helper = require("components/utilities/structured_data/helper");

const getSchema = props => {
  return JSON.stringify(
    _.omitBy(_.merge({}, SoftwareApplicationSchema.defaultProps, props, {
      "@context": "http://schema.org",
      "@type": "SoftwareApplication",
      "@id": _.kebabCase(props.name) + "#software-application"
    }), _.isEmpty)
  );
};

const SoftwareApplicationSchema = props => {
  props = _.pick(props, _.keys(SoftwareApplicationSchema.propTypes));
  return (
    <script type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: Helper.sanitize(getSchema(props)) }} />
  );
};

SoftwareApplicationSchema.propTypes = {
  aggregateRating: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    ratingValue: React.PropTypes.string,
    bestRating: React.PropTypes.string,
    ratingCount: React.PropTypes.string
  }),
  applicationCategory: React.PropTypes.string,
  applicationSubCategory: React.PropTypes.string,
  author: React.PropTypes.string,
  availableOnDevice: React.PropTypes.string,
  copyrightHolder: React.PropTypes.objectOf({
    "@type" : React.PropTypes.string,
    name: React.PropTypes.string,
    url: React.PropTypes.string
  }),
  copyrightYear: React.PropTypes.string,
  creator: React.PropTypes.objectOf({
    "@type" : React.PropTypes.string,
    name: React.PropTypes.string,
    url: React.PropTypes.string
  }),
  datePublished: React.PropTypes.string,
  description: React.PropTypes.string,
  downloadURL: React.PropTypes.string,
  fileFormat: React.PropTypes.string,
  fileSize: React.PropTypes.string,
  image: React.PropTypes.string,
  inLanguage: React.PropTypes.string,
  installUrl: React.PropTypes.string,
  name: React.PropTypes.string,
  offers: React.PropTypes.objectOf({
    "@type" : React.PropTypes.string,
    url: React.PropTypes.string,
    price: React.PropTypes.number,
    priceCurrency: React.PropTypes.string
  }),
  operatingSystem: React.PropTypes.string,
  permissions: React.PropTypes.string,
  publisher: React.PropTypes.objectOf({
    "@type" : React.PropTypes.string,
    name: React.PropTypes.string,
    url: React.PropTypes.string
  }),
  releaseNotes: React.PropTypes.string,
  screenshot: React.PropTypes.string,
  softwareVersion: React.PropTypes.string,
  "@type": React.PropTypes.string,
  url: React.PropTypes.string
};

SoftwareApplicationSchema.defaultProps = {
  aggregateRating: {
    "@type": "AggregateRating",
    ratingValue: 5.0,
    bestRating: 5.0,
    ratingCount: 1
  },
  applicationCategory: "Medical",
  applicationSubCategory: "Health & Fitness",
  author: "Warby Parker",
  availableOnDevice: "iPhone, iPad, and iPod touch",
  copyrightHolder: {
    "@type" : "Organization",
    name: "Warby Parker",
    url: "https://www.warbyparker.com"
  },
  copyrightYear: (new Date()).getFullYear().toString(),
  creator: {
    "@type" : "Organization",
    name: "Warby Parker",
    url: "https://www.warbyparker.com"
  },
  datePublished: "",
  description: "",
  downloadURL: "",
  fileFormat: "application/zip",
  fileSize: "",
  image: "",
  inLanguage: "en",
  installUrl: "",
  name: "",
  offers: {
    "@type" : "Offer",
    url: "",
    price: 0,
    priceCurrency: "USD"
  },
  operatingSystem: "iOS 10.0 and up",
  permissions: "Full Internet Access",
  publisher: {
    "@type" : "Organization",
    name: "Warby Parker",
    url: "https://www.warbyparker.com"
  },
  releaseNotes: "",
  screenshot: "",
  softwareVersion: "",
  "@type": "MedicalApplication",
  url: ""
};

module.exports = SoftwareApplicationSchema;
