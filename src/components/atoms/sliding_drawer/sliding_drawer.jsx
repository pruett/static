const _ = require('lodash');
const React = require('react/addons');

const IconX = require('components/quanta/icons/thin_x/thin_x');

const Mixins = require('components/mixins/mixins');

require('./sliding_drawer.scss');

module.exports = React.createClass({
  BLOCK_CLASS: 'c-sliding-drawer',

  mixins: [
    Mixins.classes,
  ],

  getDefaultProps: function () {
    return {
      'children': null,
      'cssModifier': '',
      'isOpen': false,
      'handleClose': _.noop,
    };
  },

  getInitialState: function () {
    return {
      'isOpen': this.props.isOpen,
    };
  },

  getStaticClasses: function () {
    return {
      'animated': `${this.BLOCK_CLASS}__animated u-db u-pr
        u-btw1 u-btss u-bc--light-gray-alt-1`,
      'block': `${this.BLOCK_CLASS} ${this.props.cssModifier} u-oh`,
      'close': 'u-button-reset u-pa u-mt18 u-mr18 u-r0',
      'content': 'u-mt36 u-mla u-mra u-w10c u-w8c--600',
      'icon': 'u-mt4 u-mt8--720 u-fill--dark-gray-alt-2',
    };
  },

  classesWillUpdate: function () {
    return {
      'block': {
        '-open': this.props.isOpen,
      },
    };
  },

  render: function () {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <div className={classes.animated}>
          <button type='button'
            aria-label="Close"
            className={classes.close}
            onClick={this.props.handleClose}>
            <IconX cssModifier={classes.icon} />
          </button>
          <div className={classes.content} children={this.props.children} />
        </div>
      </div>
    );
  }
});