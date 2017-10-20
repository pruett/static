const React = require("react/addons");

const Hero = require("components/molecules/landing/insurance/hero/hero");
const Reimbursements = require("components/molecules/landing/insurance/reimbursements/reimbursements");
const ProviderGrid = require("components/atoms/landing/insurance/provider_grid/provider_grid");

const Mixins = require("components/mixins/mixins");

require("./insurance.scss");

module.exports = React.createClass({
  displayName: "OrganismsInsurance",

  BLOCK_CLASS: "c-insurance",

  mixins: [Mixins.classes, Mixins.context, Mixins.dispatcher, Mixins.analytics],

  propTypes: {
    allowInsurancePurchase: React.PropTypes.bool,
    footer: React.PropTypes.object,
    hero: React.PropTypes.object,
    nearbyExams: React.PropTypes.bool,
    reimbursements: React.PropTypes.object,
    provider_grid: React.PropTypes.array,
    steps: React.PropTypes.object,
  },

  getDefaultProps: function() {
    return {
      allowInsurancePurchase: false,
      footer: {},
      hero: {},
      nearbyExams: false,
      reimbursements: {},
      provider_grid: [],
      steps: {},
    };
  },

  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-mw1440
        u-mla u-mra
      `,
      grid: `
        u-grid u-tac
        u-mb48 u-mb72--900
      `,
      footer: `
        u-grid__col u-w12c u-w10c--900
      `,
      header: `
        u-w8c--1200
        u-tac u-mla u-mra
        u-fs24 u-fs40--900
        u-fws u-ffs
        u-mb18 u-m36--900
        u-reset
        u-color-darky-gray-alt-3
      `,
      body: `
        u-w12c u-w9c--900 u-w7c--1200
        u-tac u-mla u-mra
        u-lh26 u-lh28--900
        u-mb24
        u-reset
        u-color--dark-gray-alt-3
        u-fs18--1200
      `,
      footerIcon: `
        u-mb18
        u-w3c u-w1c--600
      `,
      button: `
        u-fs16 u-fws
        u-button -button-modular -button-blue
      `,
    };
  },

  handleFooterClick: function() {
    this.trackInteraction("InsurancePage-clickLink-fsaFooter");
  },

  renderFooter: function(classes) {
    const footer = this.props.footer;
    return (
      <div className={classes.grid}>
        <div className={classes.footer}>
          <img src={footer.icon} className={classes.footerIcon} />
          <h2 children={footer.header} className={classes.header} />
          <p children={footer.body} className={classes.body} />
          <a
            className={classes.button}
            children={footer.link.text}
            onClick={this.handleFooterClick}
            href={footer.link.path}
          />
        </div>
      </div>
    );
  },

  render: function() {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <Hero {...this.props.hero} />
        <ProviderGrid
          carriers={this.props.provider_grid}
          allowInsurancePurchase={this.props.allowInsurancePurchase}
        />
        <Reimbursements
          {...this.props.reimbursements}
          nearbyExams={this.props.nearbyExams}
        />
        {this.renderFooter(classes)}
      </div>
    );
  },
});
