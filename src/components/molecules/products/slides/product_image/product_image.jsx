const React = require('react/addons');
const Img = require('components/atoms/images/img/img');
const Mixins = require('components/mixins/mixins');
const { assign } = require('lodash');

require("../product_slide.scss");

module.exports = React.createClass({
  BLOCK_CLASS: "c-product-slide--product-image",

  mixins: [Mixins.classes],

  propTypes: {
    altText: React.PropTypes.string,
    cssModifier: React.PropTypes.string,
    imageSet: React.PropTypes.object,
    sizes: React.PropTypes.string,
    srcSet: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      cssModifier: "",
      sizes: "100vw",
      versionTwo: false,
    };
  },

  getStaticClasses() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        ${this.props.cssModifier}
      `,
      content: `
        ${this.BLOCK_CLASS}__content
      `
    };
  },

  classesWillUpdate() {
    return {
      block: {
        '-v2': this.props.versionTwo,
      },
      content: {
        '-v2 u-h100p u-mwnone u-w100p--600 u-wauto--900': this.props.versionTwo,
        '-v1': !this.props.versionTwo
      }
    };
  },

  render() {
    const classes = this.getClasses();

    const { imageSet, sizes, srcSet } = this.props;
    const imgProps = { imageSet, sizes, srcSet };

    return (
      <div className={classes.block}>
        <Img
          {...imgProps}
          alt={this.props.altText}
          cssModifier={classes.content}
        />
      </div>
    );
  }
});
