const _ = require('lodash');
const React = require('react/addons');

const FormGroupSelect = require('components/organisms/formgroups/select/select');
const FormGroupText = require('components/organisms/formgroups/text_v2/text_v2');
const Markdown = require('components/molecules/markdown/markdown');
const Cta = require('components/atoms/buttons/cta/cta');
const InlineSubmit = require('components/atoms/buttons/inline_submit/inline_submit');
const Form = require('components/atoms/forms/form/form');
const DownloadIcon = require(
  'components/atoms/icons/apple/app_store_download/app_store_download'
);

const Mixins = require('components/mixins/mixins');

require('./prescription_check_quiz.scss');


module.exports = React.createClass({
  BLOCK_CLASS: 'c-prescription-check-quiz',

  ANALYTICS_CATEGORY: 'prescriptionCheckAppLandingQuiz',

  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.dispatcher
  ],

  getDefaultProps: function() {
    return {
      currentState: {},
      inRetailRadius: false,
      intro: {},
      post_signup: {},
      post_success: {},
      questions: [],
      quiz_eyebrow: '',
      regions: []
    };
  },

  getStaticClasses: function() {
    const baseButtonClasses = `
      ${this.BLOCK_CLASS}__button
      u-pl18 u-pr18
      u-bw1 u-bss
      u-fs12 u-ffss u-fws
      u-ttu
    `;

    return {
      block: `
        u-color-bg--white
        u-tac
      `,
      contents: `
        u-w8c--600 u-w6c--900
        u-ml48 u-mr48 u-mla--600 u-mra--600
        u-pt24 u-pb60 u-pt72--600 u-pb96--600
      `,
      title: `
        u-mt24 u-mb24
        u-fs30 u-fs44--600 u-fws u-ffs
      `,
      subhead: `
        u-mb24
        u-fs18 u-ffss
      `,
      quizEyebrow: `
        u-mt0 u-mb36
        u-fs12 u-ffss u-fwb
        u-ls2
        u-ttu
      `,
      stepCounter: `
        u-fs14 u-ffs u-fws
      `,
      introButton: `
        ${baseButtonClasses}
        u-mt8
        u-pt3
        u-color--white
        u-color-bg--blue
        u-bc--blue
        u-ls2_5
      `,
      answers: `
        u-mt36
      `,
      answerButton: `
        ${baseButtonClasses} -answer
        u-w5c u-w4c--600
        u-mb18
        u-ml8 u-mr8 u-ml18--600 u-mr18--600
        u-pt12 u-pb12
        u-color-bg--white
        u-bc--light-gray
      `,
      textButton: `
        u-dib
        u-mt18
        u-pt0 u-pb0 u-pl0 u-pr0
        u-bw0
        u-color-bg--white-0p
        u-color--blue
        u-fs12 u-ffss u-fws
        u-ttu
      `,
      formInputs: `
        u-df u-ai--fs u-jc--c
      `,
      regionSelect: `
        u-mr10
      `,
      regionSelectInner: `
        u-mr12
      `,
      emailInput: `
        u-w8c u-w7c--600 u-w5c--900
      `,
      downloadLink: `
        u-dn--900
        u-color-bg--white-0p
        u-bw0
        u-pt0 u-pb0 u-pl0 u-pr0
      `,
      downloadIcon: `
        ${this.BLOCK_CLASS}__download-icon
        u-dib
      `,
      hr: `
        u-mt0 u-mb0 u-ml48 u-mr48
        u-bw0 u-btw1 u-btss
        u-bc--light-gray
      `,
      markdown: `
        u-reset
      `
    };
  },

  handleClickEnterQuiz: function(evt) {
    this.commandDispatcher('prescriptionCheck', 'enterQuiz');
  },

  handleClickAnswer: function(questionKey, answerKey, fail, evt) {
    this.commandDispatcher(
      'prescriptionCheck',
      'answerQuestion',
      questionKey,
      answerKey,
      this.props.currentState.activeQuestionIndex === this.props.questions.length - 1,
      fail
    );
  },

  handleChangeSignupField: function(fieldName, evt) {
    this.commandDispatcher('prescriptionCheck', 'updateSignup', fieldName, evt.target.value);
  },

  handleSubmitSignup: function(evt) {
    evt.preventDefault();
    this.commandDispatcher('prescriptionCheck', 'submitSignup');
  },

  getActiveQuestion: function() {
    return this.props.questions[this.props.currentState.activeQuestionIndex];
  },

  getRegions: function() {
    return _.map(this.props.regions, (region) => {
      return _.pick(region, 'value');
    });
  },

  renderHeadline: function(classes, title, subhead) {
    const header = [
      <h3 key={'section-title'} className={classes.title} children={title} />
    ];
    if (subhead) {
      header.push(
        <Markdown
          key={'section-subhead'}
          rawMarkdown={subhead}
          className={classes.subhead}
          cssBlock={classes.markdown} />
      );
    }
    return header;
  },

  renderAnswers: function(classes, question) {
    const answerElements = (question.answers || []).map((answer, i) => {
      const targetSlug = `${_.camelCase(question.key)}${_.upperFirst(_.camelCase(answer.key))}`;
      return (
        <Cta key={`${question.key}-answer-${i}`}
          cssModifier={classes.answerButton}
          cssUtility={'u-dib'}
          children={answer.label}
          onClick={this.handleClickAnswer.bind(
            this, question.key, answer.key, answer.causes_failure
          )}
          analyticsSlug={`${this.ANALYTICS_CATEGORY}-click-${targetSlug}`}
          variation={'minimal'}
        />
      );
    });

    if (question.skip_to_failure_text) {
      answerElements.push(
        <div key={`${question.key}-skip-to-fail`}>
          <Cta
            cssModifier={classes.textButton}
            cssUtility={'u-dib'}
            children={question.skip_to_failure_text}
            onClick={this.handleClickAnswer.bind(this, question.key, '', true)}
            analyticsSlug={`${this.ANALYTICS_CATEGORY}-click-${_.camelCase(question.key)}Skip`}
            variation={'minimal'}
          />
        </div>
      );
    }

    return (
      <div className={classes.answers} children={answerElements} />
    );
  },

  renderIntro: function(classes) {
    return (
      <div>
        {this.renderHeadline(classes, this.props.intro.title, this.props.intro.subhead)}
        <Cta cssModifier={classes.introButton}
          cssUtility={'u-dib'}
          children={this.props.intro.button_label}
          onClick={this.handleClickEnterQuiz}
          analyticsSlug={`${this.ANALYTICS_CATEGORY}-click-enterQuiz`}
          variation={'minimal'}
        />
      </div>
    );
  },

  renderActiveQuestion: function(classes) {
    const activeQuestion = this.getActiveQuestion();
    return (
      <div>
        {this.props.quiz_eyebrow &&
          <h4 className={classes.quizEyebrow} children={this.props.quiz_eyebrow} />}
        <div
          className={classes.stepCounter}
          children={`${this.props.currentState.activeQuestionIndex + 1} of
            ${this.props.questions.length}`}
        />
        {this.renderHeadline(classes, activeQuestion.title)}
        {this.renderAnswers(classes, activeQuestion)}
      </div>
    );
  },

  renderFail: function(classes) {
    const activeQuestion = this.getActiveQuestion();
    return (
      <div>
        {this.renderHeadline(classes, activeQuestion.fail_title, activeQuestion.fail_subhead)}
        <Form
          onSubmit={this.handleSubmitSignup}
          method={'POST'}
          validationErrors={this.props.currentState.errors}>
          <div className={classes.formInputs}>
            {activeQuestion.collect_location_on_fail &&
              <FormGroupSelect
                cssModifier={classes.regionSelect}
                cssModifierSelect={classes.regionSelectInner}
                onChange={this.handleChangeSignupField.bind(this, 'region')}
                options={this.getRegions()}
                txtLabel={''}
                value={_.get(this.props, 'currentState.answers.region') || ''}
                valueOnly={true}
                version={2}
              />}
            <FormGroupText
              cssModifier={classes.emailInput}
              name={'email'}
              onChange={this.handleChangeSignupField.bind(this, 'email')}
              txtLabel={''}
              txtPlaceholder={'Email address'}
              type={'email'}
              value={_.get(this.props, 'currentState.answers.email') || ''}
            />
            <InlineSubmit analyticsSlug={`${this.ANALYTICS_CATEGORY}-click-submitQuiz`} />
          </div>
        </Form>
      </div>
    );
  },

  renderPostSubmission: function(classes) {
    const subhead = this.props.inRetailRadius ?
      this.props.post_signup.subhead_retail :
      this.props.post_signup.subhead_nonretail;

    return (
      <div>
        {this.renderHeadline(classes, this.props.post_signup.title, subhead)}
        {this.props.inRetailRadius && this.props.post_signup.eye_exam_label &&
          <p>
            <a href='/appointments/eye-exams' children={this.props.post_signup.eye_exam_label} />
          </p>}
      </div>
    );
  },

  renderSuccess: function(classes) {
    return (
      <div>
        {this.renderHeadline(
          classes, this.props.post_success.title, this.props.post_success.subhead
        )}
        {this.props.download_url &&
          <Cta
            cssModifier={classes.downloadLink}
            cssUtility={'u-dib'}
            href={this.props.download_url}
            analyticsSlug={`${this.ANALYTICS_CATEGORY}-click-downloadQuiz`}
            tagName={'a'}
            variation={'minimal'}>
            <DownloadIcon cssModifier={classes.downloadIcon} />
          </Cta>}
      </div>
    );
  },

  renderQuizSection: function(classes) {
    if (this.props.currentState.open) {
      if (this.props.currentState.failed) {
        if (this.props.currentState.signupSubmitted) {
          return this.renderPostSubmission(classes);
        }
        else {
          return this.renderFail(classes);
        }
      }
      else if (this.props.currentState.succeeded) {
        return this.renderSuccess(classes);
      }
      else {
        return this.renderActiveQuestion(classes);
      }
    }
    else {
      return this.renderIntro(classes);
    }
  },

  render: function() {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <div className={classes.contents} children={this.renderQuizSection(classes)} />
        <hr className={classes.hr} />
      </div>
    );
  }

});
