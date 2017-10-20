const _ = require("lodash");
const React = require("react/addons");
const FormGroupText = require("components/organisms/formgroups/text_v2/text_v2");
const Form = require("components/atoms/forms/form/form");
const Mixins = require("components/mixins/mixins");

require("./email_capture_form.scss");

module.exports = React.createClass({
  displayName: "EmailCaptureForm",
  BLOCK_CLASS: "c-email-capture-form",
  ANALYTICS_CATEGORY: "emailCaptureForm",
  mixins: [Mixins.context, Mixins.classes, Mixins.dispatcher],
  propTypes: {
    email: React.PropTypes.string,
    email_capture: React.PropTypes.object,
    isEmailCaptureSuccessful: React.PropTypes.bool
  },
  getDefaultProps: function() {
    return { isEmailCaptureSuccessful: false };
  },
  getStaticClasses: function() {
    const title = `u-color--dark-gray u-fs24 u-ffs u-fws u-mt0 u-m0--960`;

    return {
      block: `
        u-w11c u-m0a u-pt24 u-pb24
        u-btw1 u-bc--light-gray u-btss
      `,
      textField: `${this.BLOCK_CLASS}__text-field`,
      contentContainer: `
        ${this.BLOCK_CLASS}__content-container
        u-df u-flexd--c u-jc--c u-ai--c
      `,
      innerTextContainer: `
        u-df u-flexd--r u-jc--c u-ai--c
      `,
      innerFormContainer: `
        ${this.BLOCK_CLASS}__inner-form-container
        u-df u-flexd--r u-jc--c u-ai--fs
      `,
      plane: `
        ${this.BLOCK_CLASS}__plane
        u-mr18 u-dn
      `,
      defaultTitle: `
        ${this.BLOCK_CLASS}__title
        ${title}
        u-mb24 u-tac u-tal--960
      `,
      successTitle: `${title} u-mb0 u-tac`,
      arrow: `${this.BLOCK_CLASS}__arrow`,
      arrowGroup: `${this.BLOCK_CLASS}__arrow-group`,
      submit: `${this.BLOCK_CLASS}__submit`
    };
  },

  getInitialState: function() {
    return { email: this.props.email || "" };
  },
  handleSubmit: function(evt) {
    evt.preventDefault();
    return this.commandDispatcher("emailCapture", "subscribe", this.state);
  },
  handleChange: function(evt) {
    return this.setState({ email: evt.target.value });
  },
  render: function() {
    if (!_.isObject(this.props.email_capture)) return false;

    const classes = this.getClasses();

    const emailCaptureDefault = _.get(this.props, "email_capture.default", {});
    const emailCaptureSuccess = _.get(this.props, "email_capture.success", {});

    return (
      <Form className={classes.block} onSubmit={this.handleSubmit}>
        {this.props.isEmailCaptureSuccessful && (
          <div className={classes.contentContainer} key="success">
            <img
              alt="Illustration of paper airplane flying in from left"
              src={this.props.email_capture.icon}
              className={classes.plane}
            />
            <h2
              className={classes.successTitle}
              children={emailCaptureSuccess.title}
            />
          </div>
        )}
        {!this.props.isEmailCaptureSuccessful && (
          <div className={classes.contentContainer} key="default">
            <div className={classes.innerTextContainer}>
              <img
                alt=""
                src={this.props.email_capture.icon}
                className={classes.plane}
              />
              <h4
                className={classes.defaultTitle}
                children={emailCaptureDefault.title}
              />
            </div>
            <div className={classes.innerFormContainer}>
              <FormGroupText
                cssModifier={classes.textField}
                name="subscribe"
                onChange={this.handleChange}
                txtError={_.get(this.props, "emailCaptureErrors.email", "")}
                txtLabel="Email"
                txtPlaceholder="Email"
                type="email"
                value={this.state.email}
              />
              <button className={classes.submit} type="submit">
                <span className="u-hide--visual">Submit</span>
                <svg className={classes.arrow}>
                  <title>Right arrow</title>
                  <g className={classes.arrowGroup}>
                    <path d="M0 7.75h19M13 15l6-7-6-7" />
                  </g>
                </svg>
              </button>
            </div>
          </div>
        )}
      </Form>
    );
  }
});
