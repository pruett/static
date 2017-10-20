const _ = require("lodash");
const React = require("react/addons");
const Markdown = require("components/molecules/markdown/markdown");
const Mixins = require("components/mixins/mixins");

require("./help.scss");

module.exports = React.createClass({
  displayName: "FooterHelp",
  BLOCK_CLASS: "c-footer-help",
  ANALYTICS_CATEGORY: "footerHelp",
  mixins: [Mixins.analytics, Mixins.classes, Mixins.dispatcher],
  getStaticClasses: function() {
    return {
      block: `${this.BLOCK_CLASS} u-m0a`,
      list: (
        `
        ${this.BLOCK_CLASS}__list
        u-w9c u-m0a u-p0
        u-df u-flexd--r u-ai--c u-jc--sa
        u-pr
      `
      ),
      title: (
        `${this.BLOCK_CLASS}__title
        u-ffs u-fws u-fs20 u-mt0 u-mb18
        u-color--dark-gray`
      ),
      icon: `${this.BLOCK_CLASS}__icon`,
      copy: `u-fs14 u-fwn u-mb18 u-color--dark-gray-alt-3`,
      link: (
        `
        ${this.BLOCK_CLASS}__link
        u-color--dark-gray-alt-3
        u-df u-flexd--c u-ai--c u-jc--c
      `
      ),
      linkTitle: `u-mt4 u-fs14 u-fwn u-ffss`,
      image: `${this.BLOCK_CLASS}__image`,
      markdown: `${this.BLOCK_CLASS}__markdown`
    };
  },
  componentDidMount: function() {
    if (this.props.analyticsSlug) {
      this.ANALYTICS_CATEGORY = this.props.analyticsSlug;
    }

    if (this.props.trackImpressions) {
      const help = this.props.help || {};
      _.map(help.links, this.handleImpression);
    }
  },
  handleImpression: function(link) {
    this.impressionInteraction(link.title);
  },
  handleClick: function(title, evt) {
    if (!_.isString(title)) return;

    this.clickInteraction(title, evt);

    if (title.toLowerCase() === "chat") {
      evt.preventDefault();
      this.commandDispatcher("livechat", "openChat");
    }
  },
  render: function() {
    if (!_.isObject(this.props.help)) return false;

    const classes = this.getClasses();
    const help = this.props.help || {};

    return (
      <div className={classes.block}>

        <h4 className={classes.title} children={help.title} />

        <Markdown
          rawMarkdown={help.copy}
          className={classes.copy}
          cssBlock={classes.markdown}
        />

        <ul className={classes.list}>
          {_.map(help.links, link => (
            <li className={classes.item} key={link.title}>
              <a
                onClick={this.handleClick.bind(this, link.title)}
                href={link.route}
                className={classes.link}
              >
                <span className={classes.icon}>
                  <img
                    src={link.image}
                    alt={`${link.title} icon`}
                    className={classes.image}
                    role="presentation"
                  />
                </span>
                <span className={classes.linkTitle} children={link.title} />
              </a>
            </li>
          ))}
        </ul>

      </div>
    );
  }
});
