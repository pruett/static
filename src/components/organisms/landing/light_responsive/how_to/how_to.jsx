const React = require("react/addons");
const Picture = require("components/atoms/images/picture/picture");
const Mixins = require("components/mixins/mixins");

require("./how_to.scss");

module.exports = React.createClass({
  displayName: "LightResponsiveHowTo",

  mixins: [Mixins.classes, Mixins.image],

  BLOCK_CLASS: "c-light-responsive-how-to",

  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-pr u-oh u-mw1440 u-mla u-mra u-tac u-tal--900 u-pt72--900 u-pb72--900
      `,
      colRight: `${this.BLOCK_CLASS}__column-right u-pr u-fr--900 u-h100p--900`,
      content: `
        ${this.BLOCK_CLASS}__content
        u-pa--900 u-center--900
        u-pt36 u-pt48--600 u-pt0--900
        u-pr24--900 u-mw100p u-mla u-mra
        u-mb24 u-mb36--600 u-mb0--900
      `,
      colLeft: `${this.BLOCK_CLASS}__column-left u-pr u-fl--900 u-h100p--900`,
      description:
        "u-fs16 u-fs18--900 u-ffss u-mt0 u-color--dark-gray-alt-3 u-mb30",
      deviceImage: "u-pa u-l0 u-r0 u-t0 u-b0",
      heading: "u-fs28 u-fs36--900 u-mt0 u-mb24 u-mb36--900 u-ffs u-fws",
      listContainer: "u-list-reset",
      title: "u-fs20 u-fws u-ffss u-mb8",
      imageContainer: `
        ${this.BLOCK_CLASS}__image-container
        u-pr u-pa--900 u-oh u-r0 u-t0
        u-mla u-mra
      `,
      slideImage: `
        ${this.BLOCK_CLASS}__slide
        u-pa u-l0 u-r0 u-t0 u-b0
      `
    };
  },

  getPictureAttrs: function(urls) {
    return {
      sources: [
        {
          url: urls.desktop,
          widths: [1000, 2000],
          sizes: "1000px",
          quality: 80,
          mediaQuery: "(min-width: 900px)"
        },
        {
          url: urls.tablet,
          widths: [540, 1080],
          sizes: "540px",
          quality: 80,
          mediaQuery: "(min-width: 600px)"
        },
        {
          url: urls.mobile,
          widths: [280, 560],
          sizes: "280px",
          quality: 80,
          mediaQuery: "(min-width: 0px)"
        }
      ]
    };
  },

  classesWillUpdate: function() {
    return {
      slideImage: {
        "u-dn": typeof window !== "object"
      }
    };
  },

  render: function() {
    const classes = this.getClasses();
    const { heading, points, slideUrls, deviceUrls } = this.props.data;

    return (
      <div className={classes.block}>
        <div className={classes.colRight}>
          <div className={classes.content}>
            <h1 className={classes.heading}>
              {heading}
            </h1>
            <ul className={classes.listContainer}>
              {points.map((point, i) => {
                return (
                  <li key={i}>
                    <h2 className={classes.title}>
                      {point.title}
                    </h2>
                    <p className={classes.description}>
                      {point.description}
                    </p>
                  </li>
                );
              })}
            </ul>
          </div>
        </div>
        <div className={classes.colLeft}>
          <div className={classes.imageContainer}>
            {slideUrls.map((urls, i) => {
              return (
                <Picture
                  key={i}
                  cssModifier={`${classes.slideImage} -slide-${i}`}
                  children={this.getPictureChildren(this.getPictureAttrs(urls))}
                />
              );
            })}

            <Picture
              cssModifier={classes.deviceImage}
              children={this.getPictureChildren(
                this.getPictureAttrs(deviceUrls)
              )}
            />
          </div>
        </div>
      </div>
    );
  }
});
