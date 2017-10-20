const _ = require("lodash");
const React = require("react/addons");
const FooterColumn = require("components/organisms/footer/column/column");
const EmailCaptureForm = require("components/organisms/forms/email_capture_form/email_capture_form");
const Social = require("components/molecules/footer/social/social");
const CountrySelector = require("components/atoms/footer/country_selector/country_selector");
const Help = require("components/atoms/footer/help/help");
const Legal = require("components/atoms/footer/legal/legal");
const Mixins = require("components/mixins/mixins");

require("./footer.scss");

module.exports = React.createClass({
  displayName: "OrganismsFooter",
  BLOCK_CLASS: "c-footer",
  mixins: [Mixins.classes],
  propTypes: {
    cssModifier: React.PropTypes.string,
    columns: React.PropTypes.array,
    hideFooterEmailCapture: React.PropTypes.bool
  },
  getDefaultProps: function() {
    return {
      cssModifier: "",
      columns: [],
      hideFooterEmailCapture: false
    };
  },
  getStaticClasses: function() {
    return {
      block: `${this.BLOCK_CLASS}`,
      help: `
        ${this.BLOCK_CLASS}__help
        u-tac u-pt24 u-pt42--600 u-pt0--1200
      `,
      utility: `
        ${this.BLOCK_CLASS}__utility
        u-w11c u-m0a u-pt24 u-pb24
        u-df--1200 u-flexd--r u-ai--c u-jc--sb
      `,
      countrySocialContainer: `
        ${this.BLOCK_CLASS}__country-social-container
        u-df u-flexd--r u-ai--c u-jc--sb
        u-bss u-bbw1 u-bbw0--1200 u-btw0 u-blw0 u-brw0 u-bc--light-gray u-pb24 u-mb24 u-pb0--1200 u-mb0--1200
      `,
      mainContainer: `
        u-color-bg--light-gray-alt-2
        u-pt48--600 u-pb30 u-pb48--600
      `,
      mainContentContainer: `
        ${this.BLOCK_CLASS}__main-content-container
        u-w100p
        u-w11c--600 u-m0a
        u-df--600 u-flexd--c--600 u-jc--sb--600 u-ai--c
        u-flexd--r--1200
      `,
      linkListContainer: `
        ${this.BLOCK_CLASS}__link-list-container
        u-w100p
        u-df--600 u-jc--sb--600
        u-pb42--600 u-pb0--1200
        u-bc--light-gray-alt-1
        u-bss u-bw0 u-btw1 u-bbw1
        u-btw0--600 u-bbw0--1200 u-brw1--1200
      `
    };
  },
  render: function() {
    const classes = this.getClasses();
    const isLoggedIn = _.get(this.props, "session.customer");
    const columns = this.props.columns || [];

    return (
      <footer className={classes.block}>
        {!isLoggedIn &&
        !this.props.hideFooterEmailCapture && (
          <section className={classes.emailCapture}>
            <EmailCaptureForm {...this.props} />
          </section>
        )}

        <div className={classes.mainContainer}>
          <div className={classes.mainContentContainer}>
            <nav className={classes.linkListContainer}>
              {columns.map((column, i) => <FooterColumn key={i} column={column} />)}
            </nav>
            <section className={classes.help}>
              <Help {...this.props} />
            </section>
          </div>
        </div>

        <section className={classes.utility}>
          <div className={classes.countrySocialContainer}>
            <CountrySelector {...this.props} />
            <Social {...this.props} />
          </div>
          <Legal {...this.props} />
        </section>
      </footer>
    );
  }
});
