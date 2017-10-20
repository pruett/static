const React = require("react/addons");
const _ = require("lodash");
const Breadcrumbs = require("components/atoms/breadcrumbs/breadcrumbs");
const Picture = require("components/atoms/images/picture/picture");
const FormGroupText = require("components/organisms/formgroups/text_v2/text_v2");
const Mixins = require("components/mixins/mixins");

require("./hero.scss");

module.exports = React.createClass({
  BLOCK_CLASS: "c-opening-soon--hero",

  mixins: [Mixins.callout, Mixins.dispatcher, Mixins.classes, Mixins.image],

  propTypes: {
    images: React.PropTypes.array,
    locationShortName: React.PropTypes.string,
    retailEmailCapture: React.PropTypes.shape({
      emailCaptureErrors: React.PropTypes.object,
      isEmailCaptureSuccessful: React.PropTypes.bool
    }),
    breadcrumbs: React.PropTypes.arrayOf(React.PropTypes.object),
    storeName: React.PropTypes.string,
    locationShortName: React.PropTypes.string,
    gmaps_url: React.PropTypes.string
  },

  getInitialState() {
    return { email: "" };
  },

  getDefaultProps() {
    return { images: [] };
  },

  getStaticClasses() {
    return {
      block: `${this.BLOCK_CLASS}`,
      copyGrid: "u-grid u-mw1440 u-m0a",
      copyRow: "u-grid__row u-tal",
      copyCol: `u-pr u-grid__col u-w12c u-w6c--900 u-l3c--900 u-tac u-mb0--900`,
      copy: `${this.BLOCK_CLASS}__copy u-pa u-t50p u-l0 u-r0 u-ma u-w100p`,
      picture: `u-h100p`,
      taglineContainer: `u-tac`,
      tagline: `u-fs12 u-ttu u-ls2_5 u-color--dark-gray-alt-3`,
      locationHeadline: `u-ffs u-fws u-fs30 u-fs40--600 u-mb12`,
      locationLink: `u-db u-ffss u-fs18 u-mb30`,
      address: `u-db u-fs16 u-fws`,
      textField: `${this.BLOCK_CLASS}__text-field u-tal u-fs16`,
      arrow: `${this.BLOCK_CLASS}__arrow`,
      arrowGroup: `${this.BLOCK_CLASS}__arrow-group`,
      submit: `${this.BLOCK_CLASS}__submit`,
      about: `u-fs14 u-fs18--900 u-color--dark-gray-alt-3 u-mb24`,
      thanks: `u-fs16`,
      mobileEmailCaptureContainer: "u-dn--900 u-grid",
      mobileEmailCaptureRow: "u-grid__row -center",
      mobileEmailCaptureCol: "u-grid__col u-w12c",
      mobileEmailCaptureAbout: `u-fs20 u-color--dark-gray u-fws u-ffs u-mt36 u-mb24`
    };
  },

  mapSize(size) {
    const image = _.find(_.get(this.props, "images"), { size: size.name });

    if (!image) {
      return size;
    }
    switch (size.name) {
      case "desktop-hd":
        image.widths = _.range(1200, 1800, 100);
        image.mediaQuery = "(min-width: 1200px)";
        image.sizes = "(min-width: 1440px) 1440px, 100vw";
        break;
      case "desktop-sd":
        image.widths = _.range(900, 1800, 100);
        image.mediaQuery = "(min-width: 900px)";
        image.sizes = "(min-width: 1440px) 1440px, 100vw";
        break;
      case "tablet":
        image.widths = _.range(600, 900, 100);
        image.mediaQuery = "(min-width: 600px)";
        image.sizes = "100vw";
        break;
      default:
        image.widths = _.range(300, 600, 100);
        image.mediaQuery = "(min-width: 0)";
        image.sizes = "100vw";
    }
    return image;
  },

  handleChange(evt) {
    this.setState({ email: evt.target.value });
  },

  handleSubmit(evt) {
    evt.preventDefault();

    this.commandDispatcher("retailEmailCapture", "subscribe", {
      email: this.state.email,
      short_name: this.props.locationShortName
    });
  },

  renderEmailCapture(classes, retailEmailCapture) {
    return retailEmailCapture.isEmailCaptureSuccessful ? (
      <div key="email-success">
        <p className={classes.thanks}>Thanks! Stay tuned.</p>
      </div>
    ) : (
      <div key="email-signup" className={"u-df u-ai--fs u-jc--c"}>
        <FormGroupText
          cssModifier={classes.textField}
          name="coming-soon"
          onChange={this.handleChange}
          txtError={_.get(retailEmailCapture, "emailCaptureErrors.email", "")}
          txtLabel="Email"
          txtPlaceholder="Email"
          type="email"
          value={this.state.email}
        />
        <button className={classes.submit} onClick={this.handleSubmit}>
          <svg className={classes.arrow}>
            <title>Right arrow</title>
            <g className={classes.arrowGroup}>
              <path d="M0 7.75h19M13 15l6-7-6-7" />
            </g>
          </svg>
        </button>
      </div>
    );
  },

  render() {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <section className="u-pb5x2--900 u-pb5x4 u-h0 u-pr">
          <Picture
            cssModifier={classes.picture}
            children={this.getPictureChildren({
              sources: this.SIZES.map(this.mapSize),
              img: {
                className: "u-db u-w100p",
                alt: this.props.alt
              }
            })}
          />
          <div className={classes.copy}>
            <div className={classes.copyGrid}>
              <div className={classes.copyRow}>
                <div className={classes.copyCol}>
                  <div className={classes.content}>
                    <div className={classes.taglineContainer}>
                      <span className={classes.tagline}>
                        {this.props.opening_tagline}
                      </span>
                    </div>
                    <h1 className={classes.locationHeadline}>
                      {this.props.storeName}
                    </h1>
                    <a
                      target="_blank"
                      href={this.props.gmaps_url}
                      className={classes.locationLink}
                    >
                      <span className={classes.address}>
                        {this.props.address.street_address}
                      </span>
                      <span className={classes.address}>{`${this.props.address
                        .locality}, ${this.props.address.region_code}`}</span>
                    </a>

                    <div className="u-dn u-db--900">
                      <p className={classes.about}>
                        {this.props.email_capture_copy}
                      </p>
                      {this.renderEmailCapture(
                        classes,
                        this.props.retailEmailCapture
                      )}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>
        <div className={classes.mobileEmailCaptureContainer}>
          <div className={classes.mobileEmailCaptureRow}>
            <div className={classes.mobileEmailCaptureCol}>
              <p className={classes.mobileEmailCaptureAbout}>
                {this.props.email_capture_copy}
              </p>
              {this.renderEmailCapture(classes, this.props.retailEmailCapture)}
            </div>
          </div>
        </div>
      </div>
    );
  }
});
