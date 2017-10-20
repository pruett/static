const React = require("react/addons");
const Mixins = require("components/mixins/mixins");
const Styles = require("./style/style")("c-appointment-success");
require("./success.scss");

module.exports = React.createClass({
  ANALYTICS_CATEGORY: "AppointmentSuccess",

  mixins: [Mixins.analytics, Mixins.conversion],

  render() {
    const timestamp = _.get(this.props, "appointment.date.timestamp");
    let dateObj = { month: "", ordinalDate: "", formattedTime: "" };

    if (timestamp) {
      dateObj = this.convert("utcdate", "object", `${timestamp}Z`);
    }

    return (
      <div className={Styles.col}>
        <img
          style={{ maxWidth: "80%" }}
          src="//i.warbycdn.com/v/c/assets/eye-exam/image/rx-card/0/0f25f2fa64.png"
        />
        <div className={Styles.content}>
          <h2
            className={Styles.header}
          >{`See you ${dateObj.month} ${dateObj.ordinalDate} at ${dateObj.formattedTime}!`}</h2>
          <p className={Styles.description}>
            Bam. Your appointment is confirmed. Check your email for a full
            rundown on when to arrive, what to bring, stuff like that.
          </p>
          <div className={Styles.linkContainer}>
            <a
              onClick={this.clickInteraction.bind(this, "shopEyeglasses")}
              href={"/eyeglasses"}
              className={Styles.shopLink}
            >
              Shop eyeglasses
            </a>
            <a
              onClick={this.clickInteraction.bind(this, "shopSunglasses")}
              href={"/sunglasses"}
              className={Styles.shopLink}
            >
              Shop sunglasses
            </a>
          </div>
        </div>
      </div>
    );
  }
});
