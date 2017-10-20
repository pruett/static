const React = require("react/addons");

const Mixins = require("components/mixins/mixins");

require('./inline_submit.scss');


module.exports = React.createClass({

  BLOCK_CLASS: 'c-inline-submit',

  mixins: [
    Mixins.analytics,
    Mixins.context,
    Mixins.classes
  ],

  propTypes: {
    analyticsSlug: React.PropTypes.string,
    cssArrow: React.PropTypes.string,
    cssArrowColor: React.PropTypes.string,
    cssBackground: React.PropTypes.string,
    cssModifier: React.PropTypes.string
  },

  getDefaultProps: function() {
    return {
      analyticsSlug: '',
      cssArrow: 'u-mt4 u-mb1 u-ml4 u-mr4',
      cssArrowColor: 'u-stroke--white',
      cssBackground: 'u-color-bg--blue',
      cssModifier: ''
    };
  },

  getStaticClasses: function() {
    return {
      block: `
        ${this.props.cssModifier}
        ${this.props.cssBackground}
        u-pr
        u-pt12 u-pb10 u-pl10 u-pr10
        u-bw0
      `,
      arrow: `
        ${this.BLOCK_CLASS}__arrow
        ${this.props.cssArrow}
      `,
      arrowGroup: `
        ${this.BLOCK_CLASS}__arrow-group
        ${this.props.cssArrowColor}
      `
    };
  },

  handleClick: function(evt) {
    this.trackInteraction(this.props.analyticsSlug);
    if (typeof this.props.onClick === 'function') {
      this.props.onClick(evt);
    }
  },

  render: function() {
    const classes = this.getClasses();

    return (
      <button className={classes.block} onClick={this.handleClick}>
        <svg className={classes.arrow}>
          <g className={classes.arrowGroup}>
            <path d="M0 7.75h19M13 15l6-7-6-7" />
          </g>
        </svg>
      </button>
    );
  }
});
