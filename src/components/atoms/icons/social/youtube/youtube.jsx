const React = require("react/addons");
const ExternalSvg = require(
  "components/atoms/images/external_svg/external_svg"
);

require("./youtube.scss");

module.exports = React.createClass({
  BLOCK_CLASS: "c-youtube-icon",
  displayName: "IconSocialYoutube",
  propTypes: {
    altText: React.PropTypes.string,
    cssUtility: React.PropTypes.string,
    cssModifier: React.PropTypes.string
  },
  getDefaultProps: function() {
    return {
      altText: "Youtube",
      cssUtility: "",
      cssModifier: ""
    };
  },
  render: function() {
    return (
      <ExternalSvg
        altText={this.props.altText}
        cssModifier={`${this.props.cssModifier} ${this.props.cssUtility}`}
        parentClass={this.BLOCK_CLASS}
      />
    );
  }
});
