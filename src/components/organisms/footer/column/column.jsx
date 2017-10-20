const React = require("react/addons");
const Mixins = require("components/mixins/mixins");
const FooterCategory = require(
  "components/organisms/footer/category/category"
);

module.exports = React.createClass({
  displayName: "FooterColumn",
  BLOCK_CLASS: "c-footer",
  mixins: [Mixins.classes],
  propTypes: {
    column: React.PropTypes.object.isRequired
  },
  getStaticClasses: function() {
    return {
      linkColumn: `${this.BLOCK_CLASS}__link-column u-list-reset`
    };
  },
  render: function() {
    const classes = this.getClasses();

    return (
      <ul className={classes.linkColumn}>
        {this.props.column.categories.map((category, i) => (
          <FooterCategory key={i} category={category} />
        ))}
      </ul>
    );
  }
});
