const _ = require("lodash");
const React = require("react/addons");
const Mixins = require("components/mixins/mixins");
const LayoutDefault = require("components/layouts/layout_default/layout_default");
const Callout = require("components/organisms/glossary/callout/callout");
const Definition = require("components/organisms/glossary/definition/definition");
const {
  GlossaryStatus,
  BackToTop
} = require("components/organisms/glossary/extras/extras");

require("./glossary.scss");

module.exports = React.createClass({
  displayName: "GlossaryPage",

  BLOCK_CLASS: "c-glossary",

  CALLOUT_PATH: "/eyewear-a-z/callout",

  GLOSSARY_PATH: "/eyewear-a-z/definitions",

  STICKY_NAV_HEIGHT: 72,

  // We'll build up a map of definition refs
  // to enable deep linking to specific definitions
  definition: {},

  mixins: [
    Mixins.analytics,
    Mixins.context,
    Mixins.dispatcher,
    Mixins.routing,
    Mixins.classes,
    Mixins.scrolling
  ],

  fetchVariations: function() {
    return [this.CALLOUT_PATH, this.GLOSSARY_PATH];
  },

  statics: {
    route: function() {
      return {
        path: "/eyewear-a-z",
        handler: "Glossary",
        title: "Eyewear A-Z"
      };
    }
  },

  getInitialState: function() {
    return {
      activeLetter: null,
      showAlphabetDrawer: false
    };
  },

  componentDidMount: function() {
    if (window.location.hash) {
      const hash = window.location.hash.replace(/#/, "");
      const node = this.definition[hash] || this.refs[hash];
      this.scrollToNode(node, {
        time: 0,
        offset: -this.STICKY_NAV_HEIGHT + 2
      });
    }

    return this.addScrollListener(this.updateActiveLetter, 1000);
  },

  updateActiveLetter: function() {
    this.setState({
      activeLetter: _.first(
        Object.keys(this.refs).filter(ref =>
          this.elementIsInViewport(this.refs[ref], this.STICKY_NAV_HEIGHT)
        )
      )
    });
  },

  getId: function(letter, term) {
    return `${_.lowerCase(letter)}-${_.camelCase(term)}`;
  },

  appendHash: function(term, e) {
    e.preventDefault();

    if (history.pushState) {
      history.pushState(null, null, `#${term}`);
    } else {
      window.location.hash = `#${term}`;
    }
  },

  scrollToTop: function(e) {
    e.stopPropagation();
    this.scrollTo(0, { time: 800 });
  },

  updateHashAndScroll: function(term, event) {
    const node = this.definition[term] || this.refs[term];
    this.appendHash(term, event);

    this.setState({ showAlphabetDrawer: false });
    this.trackInteraction(`Glossary-clickPosition-${_.camelCase(term)}`);
    this.scrollToNode(node, {
      time: 800,
      offset: -this.STICKY_NAV_HEIGHT + 2
    });
  },

  toggleGlossaryDrawer: function() {
    this.setState({ showAlphabetDrawer: !this.state.showAlphabetDrawer });
  },

  handleMarkdownClick: function(event) {
    const { currentTarget } = event;

    if (currentTarget.tagName === "A" && !currentTarget.target) {
      this.updateHashAndScroll(currentTarget.hash.slice(1), event);
    }
  },

  getStaticClasses: function() {
    return {
      activeContainer: "u-pr u-df u-ai--c u-jc--fe u-cursor--pointer",
      activeArrow: `${this.BLOCK_CLASS}__active-arrow`,
      activeContent: "u-ma u-pa u-l0 u-r0 u-center-y",
      activeLetter: "u-mr12",
      stickyContainer: `${this.BLOCK_CLASS}__sticky-container`,
      alphabetContainer: `${this.BLOCK_CLASS}__alphabet-container u-pa u-l0 u-r0 u-oa u-ps--900 u-color-bg--white--900`,
      alphabet: "u-mw960 u-ma u-reset--list u-df u-jc--fs u-jc--sa--900 u-flexw--w u-color-bg--white",
      letterContainer: `${this.BLOCK_CLASS}__letter-container u-color-bg--white`,
      letter: `${this.BLOCK_CLASS}__letter u-fs36 u-fs16--900 u-fwn u-ffs u-dib u-w100p u-pt24 u-pb24 u-ttu u-tac u-color--dark-gray`,
      selectBtn: `${this.BLOCK_CLASS}__select-btn u-fs16 u-fwn u-w100p u-tac u-button-reset u-tac u-color--blue`,
      arrowDown: `${this.BLOCK_CLASS}__arrow-down`,
      btnBackToTop: `${this.BLOCK_CLASS}__btn-back-to-top u-button-reset`,
      arrowBackToTop: `${this.BLOCK_CLASS}__arrow-back-to-top`,
      definitionContainer: `${this.BLOCK_CLASS}__defn-container`,
      definitionList: `u-m0`
    };
  },

  classesWillUpdate: function() {
    return {
      alphabetContainer: {
        "u-dn u-db--900": !this.state.showAlphabetDrawer,
        "u-db": this.state.showAlphabetDrawer
      },
      btnBackToTop: {
        "u-vh": !this.state.activeLetter
      },
      activeArrow: {
        "-flip": this.state.showAlphabetDrawer
      },
      activeLetter: {
        "u-fs22 u-ffs u-ttu u-fwn u-color--dark-gray": this.state.activeLetter
      }
    };
  },

  render: function() {
    const classes = this.getClasses();
    const { callout } = this.getContentVariation(this.CALLOUT_PATH) || {};
    const glossary = this.getAllVariants(this.GLOSSARY_PATH) || {};
    const alphabet = "abcdefghijklmnopqrstuvwxyz".split("");

    return (
      <LayoutDefault {...this.props} cssModifier={"-full-page"}>

        {callout && <Callout {...callout} />}

        <div className={classes.stickyContainer}>
          <div
            onClick={this.toggleGlossaryDrawer}
            className={classes.selectBtn}
          >
            <div className={classes.activeContainer}>
              <GlossaryStatus
                classes={classes}
                activeLetter={this.state.activeLetter}
              />
              <BackToTop classes={classes} scrollToTop={this.scrollToTop} />
            </div>
          </div>

          <div className={classes.alphabetContainer}>
            <ul className={classes.alphabet}>
              {_.map(alphabet, (letter, i) => (
                <li className={classes.letterContainer} key={i}>
                  <a
                    onClick={this.updateHashAndScroll.bind(this, letter)}
                    className={
                      this.state.activeLetter === letter
                        ? `${classes.letter} -active`
                        : classes.letter
                    }
                  >
                    {letter}
                  </a>
                </li>
              ))}
            </ul>
          </div>
        </div>

        {Object.keys(glossary).length > 0 &&
          <dl className={classes.definitionList}>
            {_.map(
              alphabet,
              (letter, index) =>
                glossary[letter]
                  ? <div
                      className={classes.definitionContainer}
                      ref={letter}
                      key={letter}
                    >
                      {_.map(glossary[letter].glossary, (dict, i) => (
                        <Definition
                          key={`${index}-${i}`}
                          handleClick={this.appendHash.bind(
                            this,
                            this.getId(letter, dict.term)
                          )}
                          handleMarkdownClick={this.handleMarkdownClick}
                          dynamicRef={el =>
                            (this.definition[
                              this.getId(letter, dict.term)
                            ] = el)}
                          {...dict}
                        />
                      ))}
                    </div>
                  : null
            )}
          </dl>}
      </LayoutDefault>
    );
  }
});
