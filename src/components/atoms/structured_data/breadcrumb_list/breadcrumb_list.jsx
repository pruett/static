/* 
  This is an implementation of the BreadcrumbList schema from
  Schema.org (see http://schema.org/BreadcrumbList). Its purpose
  is to markup breadcrumb information in the body of a web page so
  that it displays correctly in search engines like Google, Bing,
  Yahoo, etc.; thus improving the site's Seach Engine Optimization.
*/

const _ = require("lodash");
const React = require("react/addons");
const Helper = require("components/utilities/structured_data/helper");

const getListItems = links => {
  return _.map(links, (link, index) => ({
    "@type": "ListItem",
    position: index + 1,
    item: {
      "@id": link.href || _.kebabCase(link.text),
      url: link.href || '#',
      name: link.text
    }
  }));
};

const getSchema = props => {
  return JSON.stringify(
    _.omitBy({
      "@context": "http://schema.org",
      "@type": "BreadcrumbList",
      "@id": "#breadcrumb-list",
      itemListElement: getListItems(props.links)
    }, _.isEmpty)
  );
};

const BreadcrumbListSchema = props => {
  props = _.pick(props, _.keys(BreadcrumbListSchema.propTypes));
  return (
    <script type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: Helper.sanitize(getSchema(props)) }} />
  );
};

BreadcrumbListSchema.propTypes = {
  links: React.PropTypes.arrayOf(
    React.PropTypes.shape({
      href: React.PropTypes.string,
      text: React.PropTypes.string
    })
  )
};

BreadcrumbListSchema.defaultProps = {
  links: []
};

module.exports = BreadcrumbListSchema;
