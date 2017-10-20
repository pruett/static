/* 
  This is an implementation of the Organization schema from
  Schema.org (see http://schema.org/Organization). Its purpose
  is to markup software application information in the body of a web
  page so as to better display app details in search engines like Google,
  Bing, Yahoo, etc.; thereby improving our site's Seach Engine Optimization.
*/

const _ = require("lodash");
const React = require("react/addons");
const Helper = require("components/utilities/structured_data/helper");

const getSchema = props => {
  return JSON.stringify(
    _.omitBy(_.merge({}, OrganizationSchema.defaultProps, props, {
      "@context": "http://schema.org",
      "@type": "Organization",
      "@id":"#organization"
    }), _.isEmpty)
  );
};

const OrganizationSchema = props => {
  props = _.pick(props, _.keys(OrganizationSchema.propTypes));
  return (
    <script type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: Helper.sanitize(getSchema(props)) }} />
  );
};

OrganizationSchema.propTypes = {
  name: React.PropTypes.string,
  url: React.PropTypes.string,
  logo: React.PropTypes.string,
  sameAs: React.PropTypes.array,
  address: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    addressLocality: React.PropTypes.string,
    addressRegion: React.PropTypes.string,
    postalCode: React.PropTypes.string,
    streetAddress: React.PropTypes.string
  }),
  contactPoint: React.PropTypes.objectOf({
    "@type": React.PropTypes.string,
    contactOption: React.PropTypes.string,
    contactType: React.PropTypes.string,
    telephone: React.PropTypes.string
  })
};

OrganizationSchema.defaultProps = {
  name: "Warby Parker",
  url: "https://www.warbyparker.com",
  logo: "https://www.warbyparker.com/assets/img/logos/warby_parker.svg",
  sameAs: [
    "https://www.facebook.com/warbyparker",
    "https://www.instagram.com/warbyparker",
    "https://www.youtube.com/warbyparker",
    "https://twitter.com/warbyparker"
  ],
  address: {
    "@type": "PostalAddress",
    addressLocality: "New York",
    addressRegion: "NY",
    postalCode: "10013",
    streetAddress: "161 Avenue of the Americas, 6th floor"
  },
  contactPoint: {
    "@type": "ContactPoint",
    contactOption: "TollFree",
    contactType: "Customer Service",
    telephone: "+1.888.492.7297"
  }
};

module.exports = OrganizationSchema;
