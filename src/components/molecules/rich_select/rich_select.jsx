const _ = require('lodash');
const React = require('react/addons');

const IconCheck = require('components/quanta/icons/add_check/add_check');
const IconDownArrow = require('components/quanta/icons/down_arrow_thin/down_arrow_thin');
const Mixins = require('components/mixins/mixins');

require('./rich_select.scss');

const ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

module.exports = React.createClass({

  BLOCK_CLASS: 'c-rich-select',

  mixins: [
    Mixins.analytics,
    Mixins.classes
  ],

  getDefaultProps: function() {
    return {
      analyticsCategory: '',
      cssModifier: '',
      handleChange: function(){},
      name: '',
      options: [],
      selected: ''
    };
  },

  getInitialState: function() {
    return {
      isOpen: false
    };
  },

  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-pr--600
      `,
      value: `
        ${this.BLOCK_CLASS}__value
        ${this.props.cssModifier}
        u-button-reset
        u-pr u-dib
        u-wsnw
      `,
      dropdown: `
        ${this.BLOCK_CLASS}__dropdown
        u-pa u-center-x
        u-mt8
        u-color-bg--white
        u-bss u-bw1 u-bc--light-gray
        u-fs16 u-ffss u-fwn
      `,
      option: `
        ${this.BLOCK_CLASS}__option
        u-pr
        u-db
        u-tal
        u-p24 u-pr36--900
        u-bss u-bw0 u-bbw1 u-bc--light-gray
        u-cursor--pointer
      `,
      optionCheck: `
        u-pa
      `,
      optionCopy: `
        u-ml42
      `,
      optionLabel: `
        u-fws
        u-wsnw
      `,
      optionDescription: `
        u-color--dark-gray-alt-3
        u-mt4 u-mb0
        u-lh24
      `,
      radio: `
        u-hide--visual
      `,
      valueLabel: `
        u-pr24 u-pr30--600
      `,
      downArrow: `
        ${this.BLOCK_CLASS}__down-arrow
        u-pa
        u-center-y u-r0
      `
    };
  },

  classesWillUpdate: function() {
    return({
      dropdown: {
        '-full-width': _.some(this.props.options, 'description')
      },
      downArrow: {
        '-open': this.state.isOpen
      }
    });
  },

  showDropdown: function() {
    if(!this.state.isOpen){
      this.setState({isOpen: true});
      document.addEventListener('click', this.handleClickDocument);
      this.trackInteraction(
        `${this.props.analyticsCategory}-click-select${_.capitalize(this.props.name)}`
      );
    }
  },

  hideDropdown: function() {
    if(this.state.isOpen){
      this.setState({isOpen: false});
      document.removeEventListener('click', this.handleClickDocument);
    }
  },

  handleClickDocument: function(evt) {
    const container = React.findDOMNode(this.refs.dropdown);
    if(container && !container.contains(evt.target)){
      this.hideDropdown();
    }
  },

  manageOptionChange: function(evt) {
    this.props.handleChange(evt);
    this.trackInteraction([
      this.props.analyticsCategory,
      'click',
      `option${_.capitalize(evt.target.name)}_${_.camelCase(evt.target.value)}`
    ].join('-'))

    setTimeout(this.hideDropdown, 100);
  },

  getLabel: function() {
    const option = _.find(this.props.options, (option) => {
      return option.value === this.props.selected;
    });
    return option ? option.label : '';
  },

  renderRadioGroup: function(classes) {
    return _.map(this.props.options, (option, i) => {
      const inputId = `${this.props.name}-option-${option.value}`;
      const checked = this.props.selected === option.value;
      return (
        <label key={i} htmlFor={inputId} className={classes.option}>
          <input
            id={inputId}
            type={'radio'}
            name={this.props.name}
            value={option.value}
            checked={checked}
            className={classes.radio}
            onChange={this.manageOptionChange} />
          <IconCheck
            cssModifier={classes.optionCheck}
            isChecked={true}
            inactive={!checked} />
          <div className={classes.optionCopy}>
            <div className={classes.optionLabel} children={option.label} />
            {option.description &&
              <p className={classes.optionDescription} children={option.description} />}
          </div>
        </label>
      );
    });
  },

  renderDropdown: function(classes) {
    return (
      <div
        className={classes.dropdown}
        ref={'dropdown'}
        children={this.renderRadioGroup(classes)} />
    );
  },

  render: function() {
    const classes = this.getClasses();

    return (
      <span className={classes.block}>
        <button
          className={classes.value}
          onClick={this.showDropdown}>
          <span className={classes.valueLabel} children={this.getLabel()} />
          <IconDownArrow cssModifier={classes.downArrow} />
        </button>

        <ReactCSSTransitionGroup
          transitionName='-transition'
          transitionAppear={true}
          children={this.state.isOpen ? this.renderDropdown(classes) : null} />
      </span>
    );
  }

});
