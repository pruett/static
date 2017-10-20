// Active Experiments
// photoCopy

const React = require('react/addons');

const IconCheckmark = require('components/quanta/icons/checkmark/checkmark');

const Mixins = require('components/mixins/mixins');
require('./upsell_checkbox.scss');


module.exports = React.createClass({
  displayName: 'UpsellCheckbox',

  propTypes: {
    cssModifier: React.PropTypes.string,
    cssModifierInput: React.PropTypes.string,
    labelDescription: React.PropTypes.string,
    labelTitle: React.PropTypes.string,
    onChange: React.PropTypes.func,
    price: React.PropTypes.string,
    photoVariant: React.PropTypes.string,
  },

  getDefaultProps: function () {
    return {
      cssModifier: '',
      cssModifierInput: '',
      labelDescription: 'Lenses that change from clear to dark grey in the sun (rain or shine)',
      labelTitle: 'Light-responsive lenses',
      price: '$100',
      photoVariant: false,
    }
  },

  BLOCK_CLASS: 'c-upsell-checkbox',


  mixins: [
    Mixins.dispatcher,
    Mixins.classes
  ],

  getStaticClasses: function () {
    return {
      block : `
        ${this.BLOCK_CLASS}
        ${this.props.cssModifier}
        u-pt24 u-pb24
      `,
      input: `
        ${this.BLOCK_CLASS}__input
        ${this.props.cssModifierInput}
      `,
      icon: `
        ${this.BLOCK_CLASS}__icon
      `,
      labelTitle: `
        u-fs16 u-fs18--600 u-fs20--900
        u-mb3
        u-fws
      `,
      labelDescription: `
        u-w11c
        u-fs14 u-fs16--600 u-fs18--900
        u-mb3
        u-color--dark-gray-alt-1
      `,
      checkWrapper: `
        u-dib u-fl u-pr u-mt2
      `,
      textWrapper: `
        u-w8c u-dib u-tal u-vat u-pr
        u-ml18 u-ml2--600
      `,
      priceWrapper: `
        u-w2c u-dib u-vat
        u-pl36--600
      `,
      price: `
        ${this.BLOCK_CLASS}__price
        u-fs16 u-fs18--600 u-fs20--900 u-fws
      `
    };
  },

  render: function () {
    const classes = this.getClasses();

    const title = this.props.photoVariant === 'transitions'
      ? 'Transitions® lenses'
      : this.props.labelTitle;

    return (
      <label className={classes.block}>
        <div className={classes.checkWrapper}>
          <input
            {...this.props}
            type={'checkbox'}
            className={classes.input} />
          <IconCheckmark
            {...this.props}
            cssModifier={classes.icon}
            cssModifierBox={'-border-light-gray'} />
        </div>
        <div className={classes.textWrapper}>
          <div children={title} className={classes.labelTitle} />
          <div children={this.props.labelDescription} className={classes.labelDescription} />
        </div>
        <div className={classes.priceWrapper}>
          <span className={classes.price} children={this.props.price} />
        </div>
      </label>
    );
  }

});
