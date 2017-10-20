const React = require('react/addons');
const Takeover = require("components/molecules/modals/takeover/takeover");
const Mixins =  require("components/mixins/mixins");

require('./quiz_instructions.scss');

module.exports = React.createClass({
  BLOCK_CLASS: 'c-quiz-instructions',

  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.dispatcher,
  ],

  getDefaultProps: function() {
    return {
      analyticsCategory: "quizResults",
      isActive: false,
      steps: [],
      cta: "",
      header: "",
    };
  },

  getStaticClasses: function() {
    return {
      takeover: `
        u-color-bg--white-95p
      `,
      block: `
        ${this.BLOCK_CLASS}
        u-df u-jc--c u-ai--c u-flexd--c
        u-pt60 u-pb60
      `,
      button: `
        ${this.BLOCK_CLASS}__button
        u-button -button-blue -button-medium
        u-fws
        u-mt48--600
      `,
      step: `
        ${this.BLOCK_CLASS}__step
        u-mb48
        u-pl12 u-pr12
        u-tac
      `,
      stepTitle: `
        u-mt0 u-mb12
        u-ffss u-fs24 u-fs28--600 u-fws
      `,
      stepDescription: `
        u-m0 u-pl2 u-pr2
        u-ffss u-fs18 u-fs20--600
        u-color--dark-gray-alt-3
      `,
      header: `
        ${this.BLOCK_CLASS}__header
        u-pa u-w100p u-tac
        u-m0 u-pt24
        u-fs12 u-ttu u-fws u-ls2g
        u-color-bg--white
      `,
    }
  },

  handleHideTakeover: function() {
    this.trackInteraction(`${this.props.analyticsCategory}-click-showResults`);
    this.commandDispatcher("layout", "hideTakeover");
    this.commandDispatcher("quiz", "hideInstructionsTakeover");
  },

  renderStep: function(classes, step, i) {
    return (
      <div key={i} className={`${classes.step} -step-${i}`}>
        <h3 className={classes.stepTitle} children={step.title} />
        <p className={classes.stepDescription} children={step.description} />
      </div>
    );
  },

  render: function() {
    const classes = this.getClasses();

    return (
      <Takeover
        active={this.props.isActive}
        cssModifier={classes.takeover}
        hasHeader={false}
        transitionAppear={false}>
        <h3 className={classes.header} children={this.props.header} />
        <div className={classes.block}>
          {this.props.steps.map(this.renderStep.bind(this, classes))}
          <button
            onClick={this.handleHideTakeover}
            className={classes.button}
            children={this.props.cta} />
        </div>

      </Takeover>
    );
  }
});
