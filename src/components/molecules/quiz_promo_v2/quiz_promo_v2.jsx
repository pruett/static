const React  = require("react/addons");

const DownArrow = require('components/quanta/icons/down_arrow_thin/down_arrow_thin');

const Mixins = require("components/mixins/mixins");

require("./quiz_promo_v2.scss");

const ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

module.exports = React.createClass({
  BLOCK_CLASS: "c-quiz-promo-2",

  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.scrolling,
  ],

  getDefaultProps() {
    return {
      active: false,
      hasQuizResults: false,
      gender: "",
      copy: {
        header: "Try at home for free",
        subhead:
          "Find your perfect frames! Answer a few questions to get recommendations for your Home Try-On.",
        cta: "Take the quiz",
        footer: "View Home Try-On frames",
        results_link: 'quiz results',
      }
    };
  },

  getInitialState() {
    return {
      fullscreen: false
    };
  },

  componentWillReceiveProps(newProps) {
    // Make the promo fullscreen if: we turn it on after initial render,
    // and it isn't the quiz results promo.
    if(newProps.active && !this.props.active && !newProps.hasQuizResults) {
      this.setState({ fullscreen: true });
    }
  },

  getStaticClasses() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-pr u-oh u-m0a
        u-mw1440
        u-tac
        u-color-bg--light-gray-alt-2
      `,
      content: `
        ${this.BLOCK_CLASS}__content
        u-w100p u-m0a
        u-pl24 u-pr24
        u-pt60 u-pt72--600
        u-pb60 u-pb72--600
      `,
      header: `
        u-ffss u-fs12 u-ls2_5 u-fws u-ttu u-m0
        u-color--dark-gray-alt-2
      `,
      subhead: `
        u-mt24 u-mb36
        u-ffs u-fws
        u-fs30 u-fs40--600
      `,
      cta: `
        ${this.BLOCK_CLASS}__cta
        u-button -button-medium -button-blue
        u-fws
      `,
      message: `
        u-m0 u-p24
        u-ffss u-fs16
        u-color--dark-gray-alt-3
      `,
      link: `
        u-link--underline
      `,
      downArrow: `
        ${this.BLOCK_CLASS}__down-arrow
        u-dib
        u-stroke--dark-gray-alt-2
      `,
      footerButton: `
        ${this.BLOCK_CLASS}__footer-button
        u-button-reset
        u-pa u-b0 u-center-x u-mb30
      `,
      footerButtonCopy: `
        ${this.BLOCK_CLASS}__footer-button-copy
        u-mb6 u-pb1
        u-fws u-color--dark-gray-alt-2
      `
    };
  },

  classesWillUpdate() {
    return {
      block: {
        "-fullscreen": this.state.fullscreen,
      },
      content: {
        "u-pa u-center": this.state.fullscreen,
      },
      subhead: {
        "u-fs50--900": this.state.fullscreen,
      }
    };
  },

  handleLinkClick() {
    this.trackInteraction(`gallery-click-quiz${this.props.hasQuizResults ? "Results" : ""}Promo`);
  },

  handleFooterClick() {
    this.scrollToNodeBottom(React.findDOMNode(this.refs['promo']));
    this.trackInteraction(`galery-click-quizPromoViewFrames`);
  },

  getResultsMessage() {
    if (this.props.cart.hto_limit_reached) {
     return "Your Home Try-On is full. Go to cart and start your free trial or return to your ";
    }
    else {
      return (
        <span>
          <span
            className={'u-fws'}
            children={`
              ${this.props.cart.hto_quantity || "No"}
              frame${this.props.cart.hto_quantity !== 1 ? 's' : ''}
              in your Home Try-On,
              ${this.props.cart.hto_quantity_remaining}
              to go!
            `} />
          {' Finish filling, or head back to your '}
        </span>
      );
    }
  },

  render() {
    const classes = this.getClasses();
    const copy = this.props.copy;

    return (
      <ReactCSSTransitionGroup
        transitionEnterTimeout={600}
        transitionName="-transition">
        {this.props.active ?
          <section className={classes.block} ref="promo">
            {this.props.hasQuizResults ?
              <p className={classes.message}>
                {this.getResultsMessage()}
                <a
                  children={copy.results_link}
                  className={classes.link}
                  href={"/quiz/results"}
                  onClick={this.handleLinkClick} />
                {'.'}
              </p>
            : <div className={classes.content}>
                <h3
                  className={classes.header}
                  children={copy.header} />
                <p
                  className={classes.subhead}
                  children={copy.subhead} />
                <a
                  href={`/quiz?gender=${this.props.gender === "men" ? "m" : "f"}`}
                  onClick={this.handleLinkClick}
                  className={classes.cta}
                  children={copy.cta} />
              </div>}

            {this.state.fullscreen ?
              <button
                className={classes.footerButton}
                onClick={this.handleFooterClick}>
                <div
                  className={classes.footerButtonCopy}
                  children={copy.footer} />
                <DownArrow cssUtility={classes.downArrow} />
              </button>
            : null}
          </section>
        : null}
      </ReactCSSTransitionGroup>
    );
  }
});
