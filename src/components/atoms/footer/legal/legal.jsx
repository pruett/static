const _ = require("lodash");
const React = require("react/addons");
const Mixins = require("components/mixins/mixins");

require("./legal.scss");

module.exports = React.createClass({
  displayName: "FooterLegal",
  BLOCK_CLASS: "c-footer-legal",
  ANALYTICS_CATEGORY: "footerLegal",
  mixins: [Mixins.analytics, Mixins.classes],
  getStaticClasses: function() {
    return {
      block: (
        `
        ${this.BLOCK_CLASS}
        u-list-reset
        u-reset u-fs12
        u-df u-flexd--r u-ai--c u-jc--c u-jc--fe--1200
      `
      ),
      item: (
        `
        ${this.BLOCK_CLASS}__item
        u-dib
        u-mt0 u-mb0 u-mr8 u-ml8
        u-ml18--900 u-mr0--900
      `
      ),
      link: (
        `
        ${this.BLOCK_CLASS}__link
        u-color--dark-gray-alt-3
      `
      )
    };
  },
  render: function() {
    const classes = this.getClasses();
    const legal = this.props.legal || {};

    return (
      <ul className={classes.block}>
        {_.map(legal.links, link => (
          <li className={classes.item} key={link.title}>
            <a
              href={link.route}
              onClick={this.clickInteraction.bind(this, link.title)}
              className={classes.link}
              children={link.title}
            />
          </li>
        ))}
      </ul>
    );
  }
});
