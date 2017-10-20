const React = require("react/addons");
const Markdown = require("components/molecules/markdown/markdown");
const Mixins = require("components/mixins/mixins");

require("./details.scss");

module.exports = React.createClass({
  displayName: "LightResponsiveDetails",

  BLOCK_CLASS: "c-light-responsive-details",

  mixins: [Mixins.classes, Mixins.analytics],

  getStaticClasses() {
    return {
      block: "u-grid -maxed u-ma u-mb54",
      row: `${this.BLOCK_CLASS}__row u-grid__row u-mb48 u-pr u-ai--c`,
      colImage: `
        ${this.BLOCK_CLASS}__col-image
        u-grid__col u-pr
        u-w12c--600
        u-w6c--600 u-l0c--600
        u-w5c--900 u-l1c--900
      `,
      colCopy: `
        ${this.BLOCK_CLASS}__col-copy
        u-grid__col u-pr
        u-w12c
        u-w6c--600 u-l0c--600
        u-w4c--900 u-l2c--900
      `,
      figure: "u-m0",
      figureTitle: ` ${this
        .BLOCK_CLASS}__figure-title u-fs20 u-fws u-ffss u-pr u-mb24 u-mt24 u-mt0--600`,
      figureImg: "u-w100p",
      caption: "u-fs14 u-fs16--900 u-color--dark-gray-alt-2 u-ffs u-fsi u-mt18",
      bullet: `${this
        .BLOCK_CLASS}__bullet u-pl30 u-fs16 u-fs18--900 u-color--dark-gray-alt-3 u-mt12 u-mb12 u-mt16--600 u-mb16--600`,
      list: `${this.BLOCK_CLASS}__list u-list-reset`,
      link: "u-fs16 u-fws u-db u-mt24 u-pl30"
    };
  },

  renderBullets(bullets, classes) {
    return bullets.map((bullet, i) => {
      return (
        <Markdown
          tagName={"li"}
          rawMarkdown={bullet}
          key={i}
          cssBlock={`${classes.bullet} noop`}
        />
      );
    });
  },

  renderDetail(
    { header, image, caption, bullets, flip, link } = {},
    index,
    classes
  ) {
    return (
      <div className={classes.row} key={index}>
        <div
          style={{ order: `${flip ? 1 : 0}` }}
          className={`${classes.colImage} ${flip ? "-flip" : ""}`}
        >
          <figure className={classes.figure}>
            <img src={image} className={classes.figureImg} />
            <figcaption className={classes.caption}>
              {caption}
            </figcaption>
          </figure>
        </div>
        <div className={`${classes.colCopy} ${flip ? "-flip" : ""}`}>
          <div>
            <h2 className={classes.figureTitle} children={header} />
            <ul
              className={classes.list}
              children={this.renderBullets(bullets, classes)}
            />
            {link &&
              <a
                href={link.path}
                children={link.copy}
                className={classes.link}
                onClick={this.trackInteraction.bind(
                  this,
                  `LightResponsiveLanding-click-${link.event}`
                )}
              />}
          </div>
        </div>
      </div>
    );
  },

  render() {
    const classes = this.getClasses();

    return (
      <section className={classes.block}>
        {this.props.data.map((data, i) => this.renderDetail(data, i, classes))}
      </section>
    );
  }
});
