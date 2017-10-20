const React = require("react/addons");
const Mixins = require("components/mixins/mixins");
const Markdown = require("components/molecules/markdown/markdown");

require("./definition.scss");

module.exports = React.createClass({
  displayName: "GlossaryDefinition",

  BLOCK_CLASS: "c-glossary-definition",

  mixins: [Mixins.classes],

  propTypes: {
    alt_text: React.PropTypes.string,
    description: React.PropTypes.string,
    dynamicRef: React.PropTypes.func,
    handleClick: React.PropTypes.func,
    handleMarkdownClick: React.PropTypes.func,
    image: React.PropTypes.string,
    is_medical_condition: React.PropTypes.bool,
    term: React.PropTypes.string
  },

  getStaticClasses: function() {
    return {
      item: `${this.BLOCK_CLASS}__item u-w9c u-mw50p--900 u-m0a u-bss u-btw0 u-brw0 u-blw0 u-bbw1 u-bc--blue`,
      image: "u-db u-m0a u-mt48",
      term: "u-fs30 u-ffs u-fws u-mt0 u-mb30 u-color--dark-gray",
      definition: "u-m0",
      desc: "u-fs16 u-ffss u-color--dark-gray-alt-3"
    };
  },

  render: function() {
    const classes = this.getClasses();
    const {
      alt_text,
      description,
      dynamicRef,
      handleClick,
      handleMarkdownClick,
      image,
      is_medical_condition,
      term
    } = this.props;

    const defnType = is_medical_condition
      ? "http://schema.org/MedicalCondition"
      : "http://schema.org/Thing";

    return (
      <div
        ref={dynamicRef}
        className={classes.item}
        itemScope
        itemType={defnType}
      >
        <dt>
          <a onClick={handleClick}>
            <h2 itemProp="name" className={classes.term}>{term}</h2>
          </a>
        </dt>
        <dd itemProp="description" className={classes.definition}>
          <Markdown
            rawMarkdown={description}
            handleClick={handleMarkdownClick}
            className={classes.desc}
          />
          {image &&
            <div
              itemProp="image"
              itemScope
              itemType="http://schema.org/ImageObject"
            >
              <img
                className={classes.image}
                src={image}
                alt={alt_text ? alt_text : term}
                itemProp="contentUrl"
              />
            </div>}
        </dd>
      </div>
    );
  }
});
