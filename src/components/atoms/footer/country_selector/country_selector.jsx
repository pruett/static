const _ = require("lodash");
const React = require("react/addons");
const Mixins = require("components/mixins/mixins");

require("./country_selector.scss");

module.exports = React.createClass({
  displayName: "FooterCountrySelector",
  BLOCK_CLASS: "c-footer-country-selector",
  ANALYTICS_CATEGORY: "footerCountrySelector",
  mixins: [Mixins.analytics, Mixins.classes, Mixins.context],
  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-db
        u-list-reset
      `,
      item: `
        ${this.BLOCK_CLASS}__item
        u-dib
      `,
      link: `
        ${this.BLOCK_CLASS}__link
        u-color--dark-gray-alt-3
        u-dib
        u-p10
        u-fs10 u-fs12--600
        u-link--nav
      `
    };
  },
  render: function() {
    const classes = this.getClasses();
    const country = this.getLocale("country");

    const countries = this.props.countries || {};

    return (
      <ul className={classes.block}>
        {_.map(countries.links, link => (
          <li className={classes.item} key={link.title}>
            <a
              href={link.route}
              children={link.title}
              onClick={this.clickInteraction.bind(this, link.title)}
              className={
                link.code === country ? `${classes.link} -active` : classes.link
              }
            />
          </li>
        ))}
      </ul>
    );
  }
});
