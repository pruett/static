const React = require("react/addons");

const Markdown = require("components/molecules/markdown/markdown");
const Picture = require("components/atoms/images/picture/picture");

const Mixins = require("components/mixins/mixins");

const ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

require("./provider_grid.scss");

module.exports = React.createClass({
  displayName: "InsuranceProviderGrid",

  BLOCK_CLASS: "c-insurance-provider-grid",

  mixins: [
    Mixins.classes,
    Mixins.context,
    Mixins.analytics,
    Mixins.dispatcher,
    Mixins.image,
  ],

  propTypes: {
    carriers: React.PropTypes.array,
    providers: React.PropTypes.array,
  },

  getDefaultProps: function() {
    return {
      carriers: [],
      providers: [],
    };
  },

  getInitialState: function() {
    return {
      showModal: false,
      activeCarrier: this.props.carriers[0],
    };
  },

  componentDidMount: function() {
    document.addEventListener("keydown", this.handleKeyPress);
  },

  componentWillUnmount: function() {
    document.removeEventListener("keydown", this.handleKeyPress);
  },

  handleKeyPress: function(e) {
    if (e.key === "Escape") {
      this.commandDispatcher("layout", "hideTakeover");
      this.trackInteraction(
        `InsurancePage-closeModal-${this.state.activeCarrier.key}`
      );
      this.setState({ showModal: false });
    }
  },

  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-mw1440
        u-w12c
        u-color-bg--light-gray-alt-2
        u-pt48 u-pt84--900
      `,
      carrierWrapper: `
        ${this.BLOCK_CLASS}__carrier-wrapper
        u-w12c u-w6c--600
        u-color-bg--white
        u-dib
        u-h0
        u-tac
        u-pr u-mb4
      `,
      header: `
        ${this.BLOCK_CLASS}__header
        c-markdown u-fs16 u-tal u-lh26 u-color--dark-gray u-w11c
      `,
      carrierHeader: `
        ${this.BLOCK_CLASS}__carrier-header
        u-fs16 u-tal u-lh26 u-color--dark-gray u-w11c u-tac--600 u-mb24`,
      logoGrid: `${this.BLOCK_CLASS}__logo-grid u-w8c u-pa u-center`,
      logoModal: `
        ${this.BLOCK_CLASS}__logo-modal
        u-w8c u-w5c--600 u-mb8
        u-db
      `,
      gridWrapper: `
        ${this.BLOCK_CLASS}__grid-wrapper
        u-pr u-tac u-pl12 u-pr12
        u-pl0--600 u-pr0--600
        u-mla u-mra u-w12c--600 u-w10c--900 u-w8c--1200
        u-mt36 u-mt48--900
        u-mb24 
      `,
      modalWrapper: `
        ${this.BLOCK_CLASS}__modal-wrapper
      `,
      modalColumnLeft: `
        u-w10c u-w6c--600 u-dib--600
        u-pl8
        u-vat
      `,
      modalColumnRight: `
        u-w12c u-w6c--600 u-dib--600
        u-vat
      `,
      check: `
        u-dib u-w1c
      `,
      info: `
        ${this.BLOCK_CLASS}__info
        u-color-dark-gray-alt-3
        u-reset
        u-mb30 u-mb0--600 u-mt30 u-mt0--600
      `,
      modalInfoWrapper: `
        ${this.BLOCK_CLASS}__modal-info-wrapper
        u-pb36 u-pb18--600
      `,
      contactWrapper: `
        u-tac u-mla u-mra u-pb48 u-pb60--900 u-lh26 u-w3c--900
      `,
      linkWrapper: `
        ${this.BLOCK_CLASS}__link-wrapper
        u-fws
      `,
      x: `
        ${this.BLOCK_CLASS}__x
      `,
      modalContent: `
        ${this.BLOCK_CLASS}__modal-content
        u-pa u-center u-w12c
        u-pl12 u-pr12
      `,
      modalInner: `u-w11c u-w9c--900 u-mla u-mra u-mw1440 u-pa--600 u-center--600`,
      stepTitle: `
        u-fws u-fs18 u-color--dark-gray u-reset u-mb12 u-pl12--600
      `,
      stepBody: `
        u-fs16 u-tal u-lh26 u-color--dark-gray 
        u-w11c u-w12c--600 u-pl12--600 u-pr12--600 
        u-reset
      `,
      stepWrapper: `
        ${this.BLOCK_CLASS}__step-wrapper
        u-mb18 u-dib u-w6c--600 u-vat
      `,
      addressLine: `
        u-fs14 u-lh26 u-color--dark-gray u-reset
      `,
      addressWrapper: `
        ${this.BLOCK_CLASS}__address-wrapper
        u-pl18 u-ml48 u-mt24
      `,
      link: `
        u-fws u-fs18
      `,
      gridTitle: `
        u-tac u-ffs u-fs24 u-fs40--900 u-reset u-fws
      `,
      carrierHeaderWrapper: `
        u-mla u-mra u-w9c--600
        u-mb48--600
      `,
      flexWrapper: `
        ${this.BLOCK_CLASS}__flex-wrapper
      `,
      addressLine: `
        ${this.BLOCK_CLASS}__address-line
      `,
    };
  },

  getLogoAttrs(images, classes) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, "desktop-sd"),
          widths: this.getImageWidths(900, 2200, 5),
          quality: this.getQualityBySize(images, "desktop-sd"),
          mediaQuery: "(min-width: 900px)",
          sizes: "(min-width: 1440px) 1440px, 100vw",
        },
        {
          url: this.getImageBySize(images, "tablet"),
          quality: this.getQualityBySize(images, "tablet"),
          widths: this.getImageWidths(600, 1350, 5),
          mediaQuery: "(min-width: 600px)",
          sizes: "100vw",
        },
        {
          url: this.getImageBySize(images, "mobile"),
          quality: this.getQualityBySize(images, "tablet"),
          widths: this.getImageWidths(300, 900, 5),
          mediaQuery: "(min-width: 0px)",
          sizes: "100vw",
        },
      ],
      img: {
        alt: "Warby Parker",
        className: classes.logoModal,
      },
    };
  },

  handleCarrierClick: function(carrier = {}) {
    this.commandDispatcher("layout", "showTakeover", true);
    this.trackInteraction(`InsurancePage-openModal-${carrier.key}`);
    this.setState({
      activeCarrier: carrier,
      showModal: true,
    });
  },

  handleModalClose: function(carrier) {
    this.commandDispatcher("layout", "hideTakeover");
    this.trackInteraction(`InsurancePage-closeModal-${carrier.key}`);
    this.setState({ showModal: false });
  },

  handleLinkClick: function(link) {
    this.trackInteraction(`InsurancePage-clickLink-${link.ga_slug}`);
  },

  renderCarrier: function(carrier, classes, i) {
    return (
      <div
        onClick={this.handleCarrierClick.bind(this, carrier)}
        key={i}
        className={classes.carrierWrapper}
      >
        <img src={carrier.logo_grid} className={classes.logoGrid} />
      </div>
    );
  },

  renderModal: function(carrier, classes) {
    return (
      <div className={classes.modalWrapper}>
        <div className={classes.modalContent}>
          <button
            className={classes.x}
            onClick={this.handleModalClose.bind(this, carrier)}
          />
          <div className={classes.modalInner}>
            <div className={classes.carrierHeaderWrapper}>
              <Picture
                children={this.getPictureChildren(
                  this.getLogoAttrs(carrier.logo_modal, classes)
                )}
              />
              <Markdown
                rawMarkdown={carrier.header}
                className={classes.carrierHeader}
                cssBlock={"u-reset"}
              />
            </div>
            <div className={classes.flexWrapper}>
              {this.renderFormInfo(carrier.claim_form, classes)}
              {carrier.steps.map((step, i) => {
                return (
                  <div className={classes.stepWrapper} key={`step__${i}`}>
                    <div children={step.title} className={classes.stepTitle} />
                    <div children={step.body} className={classes.stepBody} />
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      </div>
    );
  },

  renderLink: function(link, classes) {
    return (
      <a
        href={link.href}
        className={classes.link}
        children={link.copy}
        onClick={this.handleLinkClick.bind(this, link)}
        target={"_blank"}
      />
    );
  },

  renderFormBody(form, classes) {
    if (form.isDownload) {
      return (
        <div
          className={"u-lh26 u-w11c u-w12c--600 u-pl12--600 u-pr12--600"}
          children={
            "Complete the claim form above and submit it along with your itemized receipt to this address:"
          }
        />
      );
    } else {
      return (
        <div className={"u-lh26 u-w11c u-w12c--600 u-pl12--600 u-pr12--600"}>
          <span children={"Log in to "} />
          {this.renderLink(form.link, classes)}
          <span
            children={
              " to complete a claim form and submit it along with your itemized receipt to this address:"
            }
          />
        </div>
      );
    }
  },

  renderFormInfo(form, classes) {
    const linkText = form.isDownload
      ? "1. Fill out claim form "
      : "1. Fill out claim form at ";
    const linkModifier = form.isDownload ? "u-mr8 u-mr12--600" : "";
    return (
      <div className={classes.stepWrapper}>
        <div className={"u-mb12"}>
          <span
            children={linkText}
            className={`${classes.stepTitle} ${linkModifier}`}
          />
          {this.renderLink(form.link, classes)}
        </div>
        {this.renderFormBody(form, classes)}
        <div className={classes.addressWrapper}>
          {form.address.map((line, i) => {
            return (
              <div
                key={i}
                children={line}
                className={
                  i === 0
                    ? `${classes.addressLine} u-fws`
                    : `${classes.addressLine}`
                }
              />
            );
          })}
        </div>
      </div>
    );
  },

  render: function() {
    const classes = this.getClasses();
    const gridChildren = this.props.carriers.map((carrier, i) => {
      return this.renderCarrier(carrier, classes, i);
    });

    return (
      <div className={classes.block}>
        <h2 className={classes.gridTitle} children="Select your provider" />
        <div className={classes.gridWrapper}>
          <div className={classes.container} children={gridChildren} />
        </div>
        <div className={classes.contactWrapper}>
          <span children={"Don't see your provider? Contact your insurance company directly for instructions on applying for reimbursement."} />
        </div>
        <ReactCSSTransitionGroup
          transitionName={"-transition-toggle"}
          transitionAppear={true}
        >
          {this.state.showModal &&
            this.renderModal(this.state.activeCarrier, classes)}
        </ReactCSSTransitionGroup>
      </div>
    );
  },
});
