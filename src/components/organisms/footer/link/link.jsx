const React = require("react/addons");
const Mixins = require("components/mixins/mixins");

module.exports = React.createClass({
  displayName: "FooterLink",
  BLOCK_CLASS: "c-footer",
  ANALYTICS_CATEGORY: "footerNavigation",
  propTypes: {
    link: React.PropTypes.object.isRequired
  },
  mixins: [Mixins.analytics, Mixins.classes],
  getStaticClasses: function() {
    return {
      item: (
        `
        ${this.BLOCK_CLASS}__link-list-item
        u-dib u-db--600 u-w6c u-w12c--600
        u-vat
        u-pr18 u-p0--600
      `
      ),
      link: (
        `
        ${this.BLOCK_CLASS}__link
        u-db u-fs16 u-fs14--600 u-fwn u-ffss
        u-color--dark-gray-alt-3
        u-mb18 u-mb10--600
      `
      )
    };
  },
  render: function() {
    const classes = this.getClasses();

    return (
      <li className={classes.item}>
        <a
          className={classes.link}
          href={this.props.link.href}
          onClick={this.clickInteraction.bind(this, this.props.link.text)}
          children={this.props.link.text}
        />
      </li>
    );
  }
});
