const React = require("react/addons");
const Mixins = require("components/mixins/mixins");
const Elm = require("components/atoms/elm/elm");
const { Survey } = require("components/elm/Survey/Main");

require("./eligibility_survey.scss");

module.exports = React.createClass({
  displayName: "EligibilitySurvey",

  mixins: [Mixins.context, Mixins.dispatcher],

  statics: {
    route: function() {
      return {
        path: "/eligibility",
        handler: "EligibilitySurvey",
        title: "Prescription Check"
      };
    }
  },

  receiveStoreChanges: function() {
    return ["eligibilitySurvey"];
  },

  render: function() {
    const { api = "https://store.sight.bz", isTraining = false } =
      this.requestDispatcher("config", "get", "eligibility_survey") || {};

    const store = this.getStore("eligibilitySurvey");
    const { customer = {} } = store.estimate || {};
    const patientDetails = {
      email: customer.email || null,
      firstName: customer.first_name || null,
      lastName: customer.last_name || null,
      phone: customer.telephone || null,
      agreeToTerms: true
    };

    return (
      <main>
        {Survey && store.__fetched
          ? <Elm
              src={Survey.Main}
              flags={{ api, isTraining, patientDetails }}
            />
          : <h1 className="u-fs40 u-tac u-p84">Loading...</h1>}
      </main>
    );
  }
});
