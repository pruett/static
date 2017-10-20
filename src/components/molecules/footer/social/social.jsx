const _ = require("lodash");
const React = require("react/addons");
const IconFacebook = require("components/atoms/icons/social/facebook/facebook");
const IconInstagram = require("components/atoms/icons/social/instagram/instagram");
const IconYoutube = require("components/atoms/icons/social/youtube/youtube");
const IconTwitter = require("components/atoms/icons/social/twitter/twitter");
const Mixins = require("components/mixins/mixins");

require("./social.scss");

module.exports = React.createClass({
  displayName: "FooterSocial",
  BLOCK_CLASS: "c-footer-social",
  ANALYTICS_CATEGORY: "footerSocial",
  mixins: [Mixins.analytics, Mixins.classes],
  propTypes: {
    social: React.PropTypes.object
  },
  getDefaultProps: function() {
    return {};
  },
  getStaticClasses: function() {
    return {
      block: this.BLOCK_CLASS,
      list: `u-list-reset u-df u-flexd--r u-ai--c u-jc--sb`,
      item: `${this.BLOCK_CLASS}__item`,
      icon: ` ${this.BLOCK_CLASS}__icon `,
      link: `${this.BLOCK_CLASS}__link`
    };
  },
  render: function() {
    if (!_.isObject(this.props.social)) return false;

    const classes = this.getClasses();
    const social = this.props.social;
    const socialNetworks = {
      facebook: IconFacebook,
      instagram: IconInstagram,
      youtube: IconYoutube,
      twitter: IconTwitter
    };
    const icons = _.map(socialNetworks, (icon, network) => {
      if (_.get(social, `${network}.show`)) {
        return (
          <li className={`${classes.item} -${network}`}>
            <a
              href={_.get(social, `${network}.link`)}
              target="_blank"
              className={classes.link}
              onClick={this.clickInteraction.bind(this, network)}
            >
              {React.createElement(socialNetworks[network], {
                cssModifier: classes.icon
              })}
            </a>
          </li>
        );
      } else {
        return false;
      }
    });

    return (
      <div className={classes.block}>
        <ul className={classes.list} children={icons} />
      </div>
    );
  }
});
