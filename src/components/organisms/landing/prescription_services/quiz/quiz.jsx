const React = require("react/addons");
const Checkbox = require("components/atoms/forms/checkbox/checkbox");
const FormGroupText = require("components/organisms/formgroups/text_v2/text_v2");
const { INPUT_TYPES } = require("components/utilities/prescription_services/constants");
const { µ, ƒ } = require("components/utilities/classNames");

require("./quiz.scss");

const BLOCK_CLASS = "c-prescription-services-quiz";

const CLASSES = {
  button: isPair => µ`
    u-button -button-blue -button-medium
    ${ƒ(isPair)("-button-pair", "-button-block")}
    -mobile-stack
    u-fs16 u-fws u-h48
    u-center--vertical
    u-ma u-mb6`,
  title: body => µ`
    u-reset
    u-fws u-fs30 u-fs40--900 u-ffs
    ${ƒ(body)("u-mb6 u-mb12--900", "u-mb24 u-mb48--900")}
  `,
  none: "u-pr36 u-pl36",
  article: "u-fs16 u-fs18--900 u-ffss u-color--dark-gray-alt-3",
  copy: `${BLOCK_CLASS}__copy u-tac u-p24 u-p0--900 u-ma`,
  body: "u-mb24 u-fs16 u-fs18--900 u-ffss u-color--dark-gray-alt-3",
  paragraph: "u-reset u-mb6",
  multi: µ`
    u-w12c u-w6c--900
    u-db u-dib--900
    u-vat
    u-tal u-mb24--900`,
  checkbox: "u-db u-mb12",
  arrow: "u-stroke--white u-fill--blue u-vam u-mr12 u-ml12",
  submit: "u-button -button-blue u-h48 u-center--vertical",
  input: "u-w8c u-w6c--600 u-w4c--900 u-m0 u-dib u-fs16",
  grid: "u-grid -maxed",
  row: "u-grid__row"
};

module.exports = class Quiz extends React.Component {
  static get defaultProps() {
    return {
      step: {},
      clickInteraction: () => {}
    };
  }

  static propTypes() {
    return {
      steps: React.PropTypes.object,
      clickInteraction: React.PropTypes.func
    };
  }

  constructor(props) {
    super(props);

    this.state = {
      answers: {},
      step: this.props.step
    };
  }

  sendAnswer(answer = this.answer) {
    this.step.next(answer)(step => {
      this.setState({ step });
    });
  }

  setAnswer(answer) {
    this.setState({ answers: { ...this.state.answers, [this.answerKey]: answer } });
  }

  get answerKey() {
    return this.state.step.answerKey;
  }

  get answer() {
    return this.state.answers[this.answerKey];
  }

  get step() {
    return this.state.step;
  }

  renderInput() {
    return (
      <Copy {...this.step.copy}>
        <FormGroupText
          cssModifier={CLASSES.input}
          name={this.step.answerKey}
          onChange={evt => this.setAnswer(evt.currentTarget.value)}
          onKeyDown={evt => {
            if (evt.key === "Enter" && this.answer) {
              this.sendAnswer();
              this.props.clickInteraction(`${this.step.answerKey}--submit`);
            }
          }}
          txtLabel={this.step.placeholder}
          txtPlaceholder={this.step.placeholder}
          type={this.step.answerKey}
          value={this.answer}
        />
        <button
          className={CLASSES.submit}
          disabled={!Boolean(this.answer)}
          onClick={() => {
            this.sendAnswer();
            this.props.clickInteraction(`${this.step.answerKey}--submit`);
          }}
        >
          <svg className={CLASSES.arrow} width="20" height="16">
            <title>Right arrow</title>
            <path d="M0 7.75h19M13 15l6-7-6-7" />
          </svg>
        </button>
      </Copy>
    );
  }

  renderChoice() {
    return (
      <Copy {...this.step.copy}>
        {this.step.answers.map((answer, i) => {
          return (
            <button
              key={i}
              className={CLASSES.button(this.step.answers.length <= 3)}
              onClick={() => {
                this.props.clickInteraction(`${this.step.answerKey}--${answer}`);
                this.sendAnswer(i);
              }}
              children={answer}
            />
          );
        })}
      </Copy>
    );
  }

  renderMulti() {
    const { answers = [] } = this.step;
    const middleIndex = Math.ceil(answers.length / 2);

    return (
      <Copy {...this.step.copy}>
        {[answers.slice(0, middleIndex), answers.slice(middleIndex)].map((side, i) => {
          return (
            <div className={CLASSES.multi} key={`${this.answerKey}${i}`}>
              {side.map((answer, j) => {
                return (
                  <Checkbox
                    key={`${this.answerKey}${i}${j}`}
                    cssModifierBox="-border-light-gray"
                    cssModifier={CLASSES.checkbox}
                    onChange={() => {
                      this.props.clickInteraction(`${this.step.answerKey}--${answer}`);
                      this.setAnswer(toggleValue(this.answer, answer));
                    }}
                    defaultChecked={(this.answer || []).indexOf(answer) > -1}
                    txtLabel={answer}
                  />
                );
              })}
            </div>
          );
        })}
        <button
          className={CLASSES.button()}
          onClick={() => {
            this.sendAnswer();
            this.props.clickInteraction(`${this.step.answerKey}--submit`);
          }}
        >
          <span className={CLASSES.none}>
            {this.answer && this.answer.length ? "Next" : "None of these"}
          </span>
        </button>
      </Copy>
    );
  }

  renderReject() {
    return <Copy title="We're sorry" {...this.step.copy} />;
  }

  render() {
    // Assume rejection if no step.
    switch (this.step && this.step.type) {
      case INPUT_TYPES.INPUT:
        return this.renderInput();
      case INPUT_TYPES.CHOICE:
        return this.renderChoice();
      case INPUT_TYPES.MULTI:
        return this.renderMulti();
      case INPUT_TYPES.REJECT:
        return this.renderReject();
      case INPUT_TYPES.SUCCESS:
        return this.props.children;
      default:
        return <h1>Error...</h1>;
    }
  }
};

const toggleValue = (arr = [], val = "") => {
  const index = arr.indexOf(val);
  return index > -1 ? [...arr.slice(0, index), ...arr.slice(index + 1)] : arr.concat(val);
};

const Copy = ({ title, children, body }) => {
  return (
    <div className={CLASSES.copy}>
      {title && <h1 className={CLASSES.title(body)} children={title} />}
      {body && <div className={CLASSES.body} children={body} />}
      <article className={CLASSES.article}>{children}</article>
    </div>
  );
};

Copy.defaultProps = {
  title: "",
  body: "",
  children: () => {}
};

Copy.propTypes = {
  title: React.PropTypes.string,
  body: React.PropTypes.string,
  children: React.PropTypes.children
};
