const _ = require("lodash");
const React = require("react/addons");
const Mixins = require("components/mixins/mixins");
const Picture = require("components/atoms/images/picture/picture");
const Markdown = require("components/molecules/markdown/markdown");

require("./callout.scss");

module.exports = React.createClass({
  displayName: "GlossaryCallout",

  BLOCK_CLASS: "c-glossary-callout",

  mixins: [Mixins.analytics, Mixins.classes, Mixins.context, Mixins.image],

  getStaticClasses: function() {
    return {
      bgColorWrapper: `${this.BLOCK_CLASS}__bg-color-wrapper`,
      pictureWrapper: "u-pr u-mw1440 u-m0a u-mbn5",
      copyContainer: `${this.BLOCK_CLASS}__copy-container u-pa--900 u-center-y--900 u-ml48--900 u-tac u-m0a u-mt48 u-mt0--900 u-mb48 u-mb0--900 u-color--white--900`,
      headline: "u-fs36 u-fs40--900 u-ffs u-fws u-mb18 u-mt0",
      copy: "u-color--dark-gray-alt-3 u-color--white--900"
    };
  },

  render: function() {
    const sources = [
      {
        media: "900px",
        url: this.props.desktop
      },
      {
        media: "700px",
        url: this.props.tablet
      }
    ];
    const classes = this.getClasses();

    return (
      <div className={classes.bgColorWrapper}>
        <div className={classes.pictureWrapper}>
          <Picture>
            {_.map(sources, (source, i) => (
              <source
                key={i}
                media={`(min-width: ${source.media})`}
                srcSet={`${source.url}?quality=70`}
              />
            ))}
            <img
              srcSet={`${this.props.mobile}?quality=70`}
              alt={"Eyewear A-Z"}
            />
          </Picture>

          <div className={classes.copyContainer}>
            <Markdown
              cssModifiers={{ h1: classes.headline }}
              rawMarkdown={this.props.headline}
            />
            <Markdown
              cssModifiers={{ p: classes.copy }}
              rawMarkdown={this.props.copy}
            />
          </div>
        </div>
      </div>
    );
  }
});
