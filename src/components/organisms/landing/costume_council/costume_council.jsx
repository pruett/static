const React = require("react/addons");
const Mixins = require("components/mixins/mixins");
const BLOCK_CLASS = "c-costume-council";
const PHONEURL =
  "//i.warbycdn.com/v/c/assets/halloween-sms/image/phone/1/9c9eae2910.png";

require("./costume_council.scss");

const Title = () => (
  <img
    src="//i.warbycdn.com/v/c/assets/halloween-sms/image/header/0/adc25520cf.png?quality=80&width=570"
    alt="Warby Parker Costume Council"
    className={`${BLOCK_CLASS}__title u-db u-mla u-mra u-mt60`}
  />
);

const Phone = () => (
  <img
    srcSet={`${PHONEURL}?quality=80&width=1200 1200w, ${PHONEURL}?quality=80&width=720 720w, ${PHONEURL}?quality=80&width=600 600w, ${PHONEURL}?quality=80&width=500 500w`}
    sizes="(min-width: 1440px) 720px, (min-width: 1000px) 50vw"
    className={`${BLOCK_CLASS}__phone u-db u-mla u-mra`}
    alt="Warby Parker Costume Council"
  />
);

const Copy = () => (
  <div className={`${BLOCK_CLASS}__copy-container`}>
    <picture>
      <source
        media="(min-width: 1000px)"
        srcSet={
          "//i.warbycdn.com/v/c/assets/halloween-sms/image/body/1/b19a756364.png?quality=80&width=750 750w"
        }
        sizes="500px"
      />
      <source
        media="(min-width: 0px)"
        srcSet={
          "//i.warbycdn.com/v/c/assets/halloween-sms/image/body/0/dbf2a9c742.png?quality=80&width=807 807w"
        }
        sizes="807px"
      />
      <img
        alt="Introducing your 24/7 resource for scary-good costume ideas. We ask a few Qs, you respond in emojis, and poof: out comes a scientifically personalized suggestion."
        className={`${BLOCK_CLASS}__copy u-db u-mla u-mra u-w100p`}
        src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"
      />
    </picture>
    <a href="sms:68848" title="Click to send sms to 68848">
      <img
        srcSet="//i.warbycdn.com/v/c/assets/halloween-sms/image/cta/0/a80a08aa17.png?width=380 380w, //i.warbycdn.com/v/c/assets/halloween-sms/image/cta/0/a80a08aa17.png?width=570 570w"
        sizes="380px"
        alt="Text BOO to 68848 and we'll get cracking."
        className={`${BLOCK_CLASS}__copy-cta u-db u-mla u-mra u-mt30`}
      />
    </a>
    <p
      className={`${BLOCK_CLASS}__legal u-fs10 u-lh16 u-tac u-mt30 u-mb0 u-pb30 u-color--dark-gray-alt-3`}
    >
      By sending us a text message, you agree to receive text messages (aka SMS
      messages) from Warby Parker, some of which may be considered marketing and
      may be sent using an autodialer. You’ll be responsible for all messaging
      and data charges that may apply. You can opt-out of receiving text
      messages from us at any time by texting “STOP” from the mobile device
      receiving the messages. For additional help, you can contact us at
      888.492.7297 or{" "}
      <a href="mailto:privacy@warbyparker.com">privacy@warbyparker.com</a>. For
      more information, see our full <a href="/terms-of-use">Terms of Use</a>.
    </p>
  </div>
);

module.exports = React.createClass({
  displayName: "OrganismsCostumeCouncil",

  render: function() {
    return (
      <div className="u-mw1440 u-mla u-mra u-pr">
        <div className={`${BLOCK_CLASS}__content-container u-w100p`}>
          <Title />
          <div className={`${BLOCK_CLASS}__phone-plus-copy-container`}>
            <Phone />
            <Copy />
          </div>
        </div>
      </div>
    );
  }
});
