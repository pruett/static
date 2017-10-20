const _ = require("lodash");
const React = require("react/addons");
const Mixins = require("components/mixins/mixins");
const FooterLink = require("components/organisms/footer/link/link");

module.exports = React.createClass({
  displayName: "FooterCategory",
  BLOCK_CLASS: "c-footer",
  mixins: [Mixins.classes, Mixins.analytics],
  propTypes: {
    category: React.PropTypes.object.isRequired
  },
  getStaticClasses: function() {
    return {
      category: (
        `
        ${this.BLOCK_CLASS}__category
        u-pr
        u-pt30 u-pb12 u-pl18
        u-ml18 u-mr18
        u-p0--600 u-m0--600
        u-bss u-btw0 u-brw0 u-blw0 u-bbw1 u-bc--light-gray
        u-bbw0--600
      `
      ),
      categoryHeader: (
        `
        u-fs16 u-fws u-ffss
        u-fs12--600 u-ls1_5--600 u-ttu--600
        u-mt0
      `
      ),
      categoryLinkList: (
        `
        ${this.BLOCK_CLASS}__category-link-list
        u-p0 u-m0
      `
      )
    };
  },
  render: function() {
    const classes = this.getClasses();

    return (
      <li className={classes.category}>
        <h4 className={classes.categoryHeader}>{this.props.category.name}</h4>
        <ul className={classes.categoryLinkList}>
          {this.props.category.links.map((link, i) => (
            <FooterLink key={i} link={link} />
          ))}
        </ul>
      </li>
    );
  }
});
