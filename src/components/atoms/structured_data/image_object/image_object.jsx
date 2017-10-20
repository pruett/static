/* 
  This is an implementation of the Image Object schema from
  Schema.org (see http://schema.org/ImageObject). Its purpose
  is to markup image information in the body of a web page so
  that it displays correctly in search engines like Google, Bing,
  Yahoo, etc.; thus improving the site's Seach Engine Optimization.
*/

const _ = require("lodash");
const React = require("react/addons");
const Helper = require("components/utilities/structured_data/helper");

const getSchema = props => {
  return JSON.stringify(
    _.omitBy(_.merge({}, ImageObjectSchema.defaultProps, props, {
      "@context": "http://schema.org",
      "@type": "ImageObject",
      "@id": props.contentUrl
    }), _.isEmpty)
  );
};

const ImageObjectSchema = props => {
  props = _.pick(props, _.keys(ImageObjectSchema.propTypes));
  return (
    <script type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: Helper.sanitize(getSchema(props)) }} />
  );
};

ImageObjectSchema.propTypes = {
  author: React.PropTypes.string,
  contentUrl: React.PropTypes.string,
  description: React.PropTypes.string
};

ImageObjectSchema.defaultProps = {
  author: "",
  contentUrl: "",
  description: ""
};

module.exports = ImageObjectSchema;
