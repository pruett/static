/* 
  This is an implementation of the WebSite schema from
  Schema.org (see http://schema.org/WebSite). Its purpose is
  to markup web site information in the body of a web page so
  that it displays correctly in search engines like Google, Bing,
  Yahoo, etc.; thus improving the site's Seach Engine Optimization.
*/

const _ = require("lodash");
const React = require("react/addons");
const Helper = require("components/utilities/structured_data/helper");

const getSchema = props => {
  return JSON.stringify(
    _.omitBy(_.merge({}, WebSiteSchema.defaultProps, props, {
      "@context": "http://schema.org",
      "@type": "WebSite",
      "@id": "#website"
    }), _.isEmpty)
  );
};

const WebSiteSchema = props => {
  props = _.pick(props, _.keys(WebSiteSchema.propTypes));
  return (
    <script type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: Helper.sanitize(getSchema(props)) }} />
  );
};

WebSiteSchema.propTypes = {
  name: React.PropTypes.string,
  url: React.PropTypes.string,
  potentialAction: React.PropTypes.arrayOf(
    React.PropTypes.shape({
      "@type": React.PropTypes.string,
      target: React.PropTypes.string,
      "query-input": React.PropTypes.string
    })
  )
};

WebSiteSchema.defaultProps = {
  name: "Warby Parker",
  url: "https://www.warbyparker.com",
  potentialAction: [
    {
      "@type": "SearchAction",
      target: "https://www.warbyparker.com/eyeglasses/men?color={color}",
      "query-input": "name=color"
    },
    {
      "@type": "SearchAction",
      target: "https://www.warbyparker.com/eyeglasses/men?width={width}",
      "query-input": "name=width"
    },
    {
      "@type": "SearchAction",
      target: "https://www.warbyparker.com/eyeglasses/men?shape={shape}",
      "query-input": "name=shape"
    },
    {
      "@type": "SearchAction",
      target: "https://www.warbyparker.com/eyeglasses/women?color={color}",
      "query-input": "name=color"
    },
    {
      "@type": "SearchAction",
      target: "https://www.warbyparker.com/eyeglasses/women?width={width}",
      "query-input": "name=width"
    },
    {
      "@type": "SearchAction",
      target: "https://www.warbyparker.com/eyeglasses/women?shape={shape}",
      "query-input": "name=shape"
    },
    {
      "@type": "SearchAction",
      target: "https://www.warbyparker.com/eyeglasses/women?material={material}",
      "query-input": "name=material"
    },
    {
      "@type": "SearchAction",
      target: "https://www.warbyparker.com/sunglasses/men?color={color}",
      "query-input": "name=color"
    },
    {
      "@type": "SearchAction",
      target: "https://www.warbyparker.com/sunglasses/men?width={width}",
      "query-input": "name=width"
    },
    {
      "@type": "SearchAction",
      target: "https://www.warbyparker.com/sunglasses/men?shape={shape}",
      "query-input": "name=shape"
    },
    {
      "@type": "SearchAction",
      target: "https://www.warbyparker.com/sunglasses/women?color={color}",
      "query-input": "name=color"
    },
    {
      "@type": "SearchAction",
      target: "https://www.warbyparker.com/sunglasses/women?width={width}",
      "query-input": "name=width"
    },
    {
      "@type": "SearchAction",
      target: "https://www.warbyparker.com/sunglasses/women?shape={shape}",
      "query-input": "name=shape"
    },
    {
      "@type": "SearchAction",
      target: "https://www.warbyparker.com/sunglasses/women?material={material}",
      "query-input": "name=material"
    }
  ]
};

module.exports = WebSiteSchema;
