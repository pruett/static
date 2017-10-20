/* 
  This is an implementation of the WebPage schema from
  Schema.org (see http://schema.org/WebPage). Its purpose is
  to markup web page information in the body of a web page so
  that it displays correctly in search engines like Google, Bing,
  Yahoo, etc.; thus improving the site's Seach Engine Optimization.
*/

const _ = require("lodash");
const React = require("react/addons");
const Helper = require("components/utilities/structured_data/helper");

const getLink = link => {
  if (_.startsWith(link.href, '/')) {
    return 'https://www.warbyparker.com' + link.href;
  }
  return 'https://www.warbyparker.com#' + _.kebabCase(link.text);
};

const getItemList = navigation => {
  let count = 1;
  const itemList = [];

  _.map(navigation, (menu) => (
    _.map(menu.categories, (category) => (
      _.map(category.links, (link) => (
        itemList.push({
          "@type": "SiteNavigationElement",
          name: link.text,
          url: getLink(link),
          position: count++
        })
      ))
    ))
  ));

  return itemList;
};

const getSchema = props => {
  return JSON.stringify(
    _.omitBy({
      "@context": "http://schema.org",
      "@type": "WebPage",
      "@id": "#webpage",
      name: props.name,
      url: props.url,
      headline: props.name,
      description: props.description,
      mainEntityOfPage: {
        "@type": "WebPage",
        "@id": props.url
      },
      mainEntity: {
        "@type": "ItemList",
        "itemListElement": getItemList(props.navigation)
      }
    }, _.isEmpty)
  );
};

const WebPageSchema = props => {
  props = _.pick(props, _.keys(WebPageSchema.propTypes));
  return (
    <script type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: Helper.sanitize(getSchema(props)) }} />
  );
};

WebPageSchema.propTypes = {
  name: React.PropTypes.string,
  url: React.PropTypes.string,
  description: React.PropTypes.string,
  navigation: React.PropTypes.array
};

WebPageSchema.defaultProps = {
  name: "Warby Parker",
  url: "https://www.warbyparker.com",
  description: "Warby Parker was founded with a rebellious spirit and a lofty objective: to offer designer eyewear at a revolutionary price, while leading the way for socially conscious businesses.",
  navigation: []
};

module.exports = WebPageSchema;
