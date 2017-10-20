const React = require("react/addons");

const Mixins = require("components/mixins/mixins");

require("./footer.scss");

module.exports = React.createClass({
  displayName: "LightResponsiveLandingFooter",

  mixins: [Mixins.classes, Mixins.context, Mixins.analytics],

  BLOCK_CLASS: "c-light-responsive-footer",

  getStaticClasses: function() {
    return {
      block: `${this.BLOCK_CLASS} u-grid -maxed u-ma u-tac u-mt60 u-mb60`,
      row: "u-grid__row",
      colHeader: "u-grid__col u-w11c",
      colImage: "u-grid__col u-w4c u-w2c--600",
      colBody: "u-grid__col u-w12c u-w8c--600 u-w5c--900 u-mla u-mra u-db",
      colLinks: "u-grid__col u-w12c u-mla u-mra u-db",
      header: `u-fs26 u-fs30--900 u-fws u-ffs`,
      link: "u-fws",
      button: `
        ${this.BLOCK_CLASS}__button
        -button-blue u-button -button-medium
        u-ml6 u-mr6
        u-fs16 u-fs16--600 u-ffss u-fws u-pt2
      `,
      footerImg: `${this.BLOCK_CLASS}__footer-img`,
      body: "u-lh26 u-fs16 u-fs18--900 u-mt0 u-mb30 u-color--dark-gray-alt-3"
    };
  },

  handleLinkClick: function(wpEvent = "") {
    this.trackInteraction(`LightResponsiveLanding-click-${wpEvent}`);
  },

  renderBody: function(classes, { copy, wpEventHelp, wpEventChat }) {
    return (
      <p className={classes.body}>
        <span>
          {copy}
        </span>
        <a
          href={"mailto:help@warbyparker.com"}
          className={classes.link}
          onClick={this.handleLinkClick.bind(this, wpEventHelp)}
        >
          {` help@warbyparker.com `}
        </a>
        <span>{` or `}</span>
        <a
          href={"#livechat"}
          className={classes.link}
          onClick={this.handleLinkClick.bind(this, wpEventChat)}
        >
          chat
        </a>
        <span>{` us now! `}</span>
      </p>
    );
  },

  renderLinks: function(links, classes) {
    const linkChildren = links.map((link, i) => {
      return (
        <a
          children={link.copy}
          href={link.path}
          key={i}
          onClick={this.handleLinkClick.bind(this, link.wpEvent)}
          className={classes.button}
        />
      );
    });

    return linkChildren;
  },

  render: function() {
    const classes = this.getClasses();
    const { image, header, links } = this.props.data;

    return (
      <section className={classes.block}>
        <div className={classes.row}>
          <div className={classes.colImage}>
            <img
              src={image}
              className={classes.footerImg}
              alt="Warby Parker Frames"
            />
          </div>
          <div className={classes.colHeader}>
            <h1 className={classes.header} children={header} />
          </div>
          <div
            className={classes.colBody}
            children={this.renderBody(classes, this.props.data)}
          />
          <div
            className={classes.colLinks}
            children={this.renderLinks(links, classes)}
          />
        </div>
      </section>
    );
  }
});
