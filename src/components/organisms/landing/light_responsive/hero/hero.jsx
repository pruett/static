const React = require("react/addons");
const Mixins = require("components/mixins/mixins");

require("./hero.scss");

module.exports = React.createClass({
  displayName: "LightResponsiveLandingHero",

  mixins: [Mixins.classes, Mixins.context, Mixins.analytics],

  BLOCK_CLASS: "c-light-responsive-hero",

  getStaticClasses: function() {
    return {
      block: "u-tac",
      downArrow: `${this.BLOCK_CLASS}__down-arrow`,
      heading:
        "u-ffs u-fws u-color--dark-gray u-mb24 u-fs36 u-fs55--600 u-fs80--900",
      desc: "u-fs16 u-fs18--900 u-ffss u-color--dark-gray-alt-3 u-mt0 u-mb24",
      linkContainer: `${this
        .BLOCK_CLASS}__link-container u-m0a u-df u-jc--sb u-w12c u-w10c--600`,
      link: "u-fs16 u-fws",
      colHeader: "u-grid__col u-w10c u-w8c--600 u-w9c--900"
    };
  },

  handleLinkClick: function(wpEvent = "", cb, e) {
    if (cb) {
      e.preventDefault();
      cb();
    }
    this.trackInteraction(`LightResponsiveLanding-click-${wpEvent}`);
  },

  renderLink: function(link = {}, classes, cb = null) {
    return (
      <a
        href={link.path}
        onClick={this.handleLinkClick.bind(this, link.wpEvent, cb)}
        className={classes.link}
      >
        {link.copy}
        {link.svg &&
          <svg
            width={link.svg.width}
            height={link.svg.height}
            viewBox={`0 0 ${link.svg.width} ${link.svg.height}`}
            className="u-ml8"
          >
            <title>Scroll to section</title>
            <g className={classes.downArrow}>
              <path d={link.svg.path} />
            </g>
          </svg>}
      </a>
    );
  },

  render: function() {
    const classes = this.getClasses();
    const { heading, description, buyOnline, nearestStore } = this.props.data;

    return (
      <div className={classes.block}>
        <div className="u-grid__row">
          <div className="u-grid__col u-w12c u-w10c--600 u-w8c--900">
            <h1 className={classes.heading}>
              {heading}
            </h1>
          </div>
        </div>
        <div className="u-grid__row">
          <div className="u-grid__col u-w12c u-w10c--600 u-w7c--900">
            <p className={classes.desc}>
              {description}
            </p>
          </div>
        </div>
        <div className="u-grid__row">
          <div className="u-grid__col u-w12c">
            <div className={classes.linkContainer}>
              {this.renderLink(
                buyOnline,
                classes,
                this.props.scrollableClickHandler
              )}
              {this.renderLink(nearestStore, classes)}
            </div>
          </div>
        </div>
      </div>
    );
  }
});
