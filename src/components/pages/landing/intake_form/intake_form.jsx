const _ = require("lodash");
const React = require("react/addons");
const LayoutDefault = require("components/layouts/layout_default/layout_default");

const Quiz = require("components/organisms/landing/intake_form/quiz/quiz");
const Success = require("components/organisms/landing/intake_form/success/success");
const Copy = require("components/organisms/landing/intake_form/copy/copy");

const Mixins = require("components/mixins/mixins");

const STEPS = require("components/utilities/intake_form/steps");

require("./intake_form.scss");

const BLOCK_CLASS = "c-intake-form";
const CLASSES = {
  block: `${BLOCK_CLASS} u-mw1440 u-ma u-oh u-ov--900`,
  main: "u-color-bg--light-gray-alt-5 u-pb36 u-pt36",
  quiz: `${BLOCK_CLASS}__quiz u-pt48 u-pb48 u-pt84--900 u-pb84--900 u-tac u-ma`,
  strong: "u-fws"
};

const ANALYTICS_SLUG = "intakeFormStore";

const IntakeForm = React.createClass({
  displayName: _.camelCase(BLOCK_CLASS),

  ANALYTICS_CATEGORY: ANALYTICS_SLUG,

  mixins: [Mixins.analytics, Mixins.context, Mixins.dispatcher, Mixins.routing],

  statics: {
    route: function() {
      return {
        path: "/intake-form",
        handler: "IntakeForm",
        title: "Intake Form"
      };
    }
  },

  getInitialState: function() {
    return {
      intakeFormStores: []
    };
  },

  receiveStoreChanges: function() {
    return ["fetch"];
  },

  getStoreChangeHandlers: function() {
    return {
      fetch: "handleFetch"
    };
  },

  render: function() {
    return (
      <LayoutDefault cssModifier={"-full-page"} {...this.props}>
        <div className={CLASSES.block}>
          <section id="intake_form" className={CLASSES.quiz} style={{ minHeight: "480px" }}>
            <Quiz step={STEPS.START} clickInteraction={this.clickInteraction}>
              <Success intakeFormStores={this.state.intakeFormStores} />
            </Quiz>
          </section>
        </div>
      </LayoutDefault>
    );
  }
});

module.exports = IntakeForm;
