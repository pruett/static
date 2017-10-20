const _ = require('lodash');
const React = require('react/addons');

const Checkbox = require('components/organisms/formgroups/checkbox/checkbox');
const PhoneNumber = require(
  'components/organisms/formgroups/phone_number/phone_number'
);
const PostalCode = require(
  'components/organisms/formgroups/postal_code/postal_code'
);
const Select = require('components/organisms/formgroups/select/select');
const Text = require('components/organisms/formgroups/text_v2/text_v2');
const Error = require('components/atoms/forms/error/error');

const Mixins = require('components/mixins/mixins');

require('./form.scss')

module.exports = React.createClass({
  displayName: 'BirthdayForm',
  BLOCK_CLASS: 'c-birthday-form',
  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.context,
    Mixins.dispatcher,
    Mixins.localization
  ],
  propTypes: {
    birthdayErrors: React.PropTypes.object,
    copy: React.PropTypes.object,
    country: React.PropTypes.string,
    customer: React.PropTypes.object,
    locales: React.PropTypes.object,
    manageChange: React.PropTypes.func,
    manageSubmit: React.PropTypes.func,
    success: React.PropTypes.bool,
    validated: React.PropTypes.array
  },
  getDefaultProps: function() {
    return {
      birthdayErrors: {},
      customer: {},
      country: 'US',
      copy: {},
      locales: {},
      manageChange: function() {},
      manageSubmit: function() {},
      success: false,
      validated: []
    };
  },
  getInitialState: function() {
    const customer = this.props.customer || {};
    return {
      full_name: customer.full_name || '',
      email: customer.email || '',
      company: '',
      country_code: '',
      extended_address: '',
      locality: '',
      postal_code: '',
      region: '',
      street_address: '',
      telephone: '',
      wants_marketing_emails: this.props.country === 'US'
    };
  },
  getStaticClasses: function() {
    return {
      block: (
        `
        ${this.BLOCK_CLASS}
        u-grid -maxed
        u-ma u-mb84
      `
      ),
      row: 'u-grid__row',
      col: (
        `
        u-grid__col u-w12c u-w8c--600 u-w6c--900
        u-pr u-l2c--600 u-l3c--900
        u-fs16
      `
      ),
      checkbox: 'u-fs14 u-color--dark-gray-alt-2',
      checkboxLabel: '-inline u-pt2',
      error: 'u-mtn18 u-mb18',
      heading: 'u-fs20 u-fws u-mb18',
      information: 'u-mb12',
      submit: (
        `
        ${this.BLOCK_CLASS}__submit
        u-button -button-blue -button-full
        u-color--white
        u-fs16 u-ffss u-fws
        u-h60 u-center--vertical
        u-w100p
      `
      ),
      error: 'u-fs16 u-m0 u-mb12 u-color--yellow',
      shipping: 'u-reset u-fs16 u-fs18 u-fws u-mt30 u-mb24'

    };
  },
  handleChange: function(key, event) {
    if (event.target !== document.activeElement) {
      // Don't validate active until blur.
      this.props.manageChange(key, event.target.value);
    }
  },
  handleSubmit: function(event) {
    event.preventDefault();
    this.trackInteraction('seventhBirthday-submit-contestForm');
    this.props.manageSubmit(this.state);
  },
  getLabel: function(field) {
    return this.localize(`labels.${field}`, this.props.country);
  },
  getLinkedState: function(key) {
    // Drop-in replacement for deprecated LinkedStateMixin.
    return {
      value: this.state[key],
      requestChange: value => this.setState({ [key]: value })
    };
  },
  data: function(key = '') {
    const txtLabel = this.getLabel(key);
    const handleChange = this.handleChange.bind(this, key);
    return {
      key: key,
      name: key,
      txtError: _.get(this.props, `birthdayErrors[${key}]`),
      isValid: this.props.validated.indexOf(key) > -1,
      valueLink: this.getLinkedState(key),
      onChange: handleChange,
      onBlur: handleChange,
      txtLabel: txtLabel,
      txtPlaceholder: txtLabel
    };
  },
  getGridCss: function(cols = 6) {
    // Inline Form hides/shows right border.
    return `${this.BLOCK_CLASS}__col u-w12c u-w${cols}c--600 -inline`;
  },
  render: function() {
    const classes = this.getClasses();

    const locale = this.props.locales[this.getLocale('country')] || {};
    const regionOptGroups = locale.regionOptGroups || [];

    return (
      <form
        method="post"
        className={classes.block}
        onSubmit={this.handleSubmit}
        noValidate
      >
        <div className={classes.row}>
          <div className={classes.col}>
            {this.props.birthdayErrors.generic
              ? <Error
                  key="error"
                  children={this.props.birthdayErrors.generic}
                  cssModifier={classes.error}
                />
              : null}
            <section className={classes.information}>
              <Text {...this.data('full_name')} />
              <Text {...this.data('email')} />
              <PhoneNumber {...this.data('telephone')} />
            </section>
            <section className={classes.address}>
              <h2
                className={classes.shipping}
                children={this.props.copy.shipping}
              />
              <Text {...this.data('street_address')} />
              <div>
                <Text
                  {...this.data('extended_address')}
                  cssModifier={this.getGridCss(6)}
                />
                <Text
                  {...this.data('company')}
                  cssModifier={this.getGridCss(6)}
                />
              </div>
              <div>
                <Text
                  {...this.data('locality')}
                  cssModifier={this.getGridCss(4)}
                />
                <Select
                  {...this.data('region')}
                  options={regionOptGroups}
                  version={2}
                  valueOnly={true}
                  showErrorText={false}
                  cssModifier={this.getGridCss(4)}
                />
                <PostalCode
                  {...this.data('postal_code')}
                  validation={false}
                  showErrorText={false}
                  cssModifier={this.getGridCss(4)}
                />
              </div>
              <Checkbox
                key="wants_marketing_emails"
                txtLabel={this.props.copy.opt_in}
                name="wants_marketing_emails"
                checkedLink={this.getLinkedState('wants_marketing_emails')}
                cssModifier={classes.checkbox}
                cssLabelModifier={classes.checkboxLabel}
                cssModifierBox="-border-light-gray"
              />
            </section>
            <button
              className={classes.submit}
              type="submit"
              children={this.props.copy.cta}
            />
          </div>
        </div>
      </form>
    );
  }
});
