const React = require('react/addons');
const PhoneNumber = require('components/organisms/formgroups/phone_number/phone_number');
const InlineSubmit = require('components/atoms/buttons/inline_submit/inline_submit');
const Form = require('components/atoms/forms/form/form');
const Mixins = require('components/mixins/mixins');

require('./phone_number_form.scss');

module.exports = React.createClass({

  BLOCK_CLASS: 'c-phone-number-form',

  mixins: [
    Mixins.classes,
    React.addons.LinkedStateMixin
  ],

  getDefaultProps: function() {
    return {
      inline: false,
      label: '',
      manageSubmit: function(){}
    };
  },

  getInitialState: function() {
    return {
      errorMessage: '',
      showSuccess: false,
      telephone: ''
    };
  },

  getStaticClasses: function() {
    return {
      phoneContainer: `
        ${this.BLOCK_CLASS}__phone-container
        u-vat u-dib u-mbn18 u-tal
      `,
      phoneLabel: `
        u-pb18 u-fs18 u-fws
      `,
      phoneInput: `
        u-fs20 -large -white
      `,
      phoneInputContainer: `
        ${this.BLOCK_CLASS}__phone-input-container
      `,
      submitButton: `
        ${this.BLOCK_CLASS}__submit-button
        u-vat u-dib
        u-color-bg--white
        u-bw0
      `,
      arrow: `
        u-mt5
      `,
      arrowGroup: `
        u-stroke--blue
      `,
      successMessage: `
        u-ffss u-fws
      `
    };
  },

  classesWillUpdate: function() {
    return {
      form: {
        'u-dib u-vat': this.props.inline
      },
      phoneLabel: {
        'u-dib u-pt18 u-pr24': this.props.inline
      },
      submitButton: {
        'u-bss u-blw1 u-bc--blue': !this.props.inline
      },
      phoneInputContainer: {
        '-inline': this.props.inline
      },
      successMessage: {
        'u-fs16 u-p18': this.props.inline,
        'u-fs20': !this.props.inline
      }
    };
  },

  handleSubmit: function(evt) {
    evt.preventDefault();
    const size = this.state.telephone.length;

    if(size === 0) {
      this.setState({
        errorMessage: 'Can we get your digits?'
      });
      this.props.manageSubmit(false);
    }
    else if(size != 12 && size != 14) {
      this.setState({
        errorMessage: 'Are your digits correct? Give ’em a quick check :-)'
      });
      this.props.manageSubmit(false);
    }
    else {
      this.setState({ showSuccess: true });
      this.props.manageSubmit(this.state.telephone);
    }
  },

  render: function() {
    const classes = this.getClasses();

    return (
      <div>
        {!this.state.showSuccess &&
          <div>
            <div className={classes.phoneLabel} children={this.props.label} />
            <Form onSubmit={this.handleSubmit} className={classes.form}>
              <PhoneNumber
                cssModifierBlock={classes.phoneContainer}
                cssModifierField={classes.phoneInput}
                cssModifierFieldContainer={classes.phoneInputContainer}
                errorIsRed={false}
                name={'telephone'}
                txtPlaceholder={'000-000-0000'}
                txtError={this.state.errorMessage}
                valueLink={this.linkState('telephone')} />

              <InlineSubmit
                analyticsSlug={`phoneNumber-click-submit`}
                cssModifier={classes.submitButton}
                cssArrow={classes.arrow}
                cssArrowColor={classes.arrowGroup} />

            </Form>
          </div>
        }
        {this.state.showSuccess &&
          <div className={classes.successMessage} children={'Enjoy the app!'} />
        }
      </div>
    );
  }
});
