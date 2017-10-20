const _ = require("lodash");
const Slider = require("components/molecules/collections/utility/slider/slider");
const React = require("react/addons");
const Mixins = require("components/mixins/mixins");

require("./slider.scss");

module.exports = React.createClass({
  displayName: "LightResponiveSlider",

  mixins: [Mixins.classes, Mixins.scrolling],

  BLOCK_CLASS: "c-light-responsive-slider",

  propTypes: {
    slider: React.PropTypes.object
  },

  getInitialState: function() {
    return { range: 0, autoplay: false };
  },

  getStaticClasses: function() {
    return {
      range: `${this.BLOCK_CLASS}__range`,
      rangeContainer:
        "u-df u-pt18 u-pb18 u-bss u-bw2 u-bc--light-gray u-br4 u-jc--sa",
      rangeLabel: `${this.BLOCK_CLASS}__range-label u-fs16 u-fws u-tac`,
      rangeRow: `${this.BLOCK_CLASS}__range-row u-grid__row`,
      sliderColumnContainer:
        "u-grid__col u-pr u-mt48 u-mt0--600 u-mb12 u-mb0--600 u-w12c u-l1c--900 u-w10c--900",
      slideContainer: "u-pr u-w12c",
      slideImageContainer: `${this
        .BLOCK_CLASS}__slide-image-container u-pr u-h0`,
      slideImage: "u-pa u-w100p u-hauto",
      caption:
        "u-fsi u-fs14 u-fs16--900 u-color--dark-gray-alt-2 u-ffs u-pl8 u-pr8 u-tac--900  u-mt18 u-mt14--600"
    };
  },

  componentDidMount: function() {
    if (this.isInView()) {
      this.setState({ autoplay: true });
    } else {
      this.addScrollListener(() => {
        if (this.isInView() && this.state.range === 0) {
          this.setState({ autoplay: true });
          this.__cleanUpEventListeners();
        }
      });
    }
  },

  componentDidUpdate: function(prevProps, prevState) {
    if (!this.state.autoplay) return;

    const range = this.state.range + 0.05;
    if (range.toFixed(2) <= 1) {
      setTimeout(() => this.setState({ range }), 35);
    }
  },

  isInView: function() {
    return this.elementIsInViewport(this.refs["slider"]);
  },

  handleSlider: function() {
    this.setState({ range: this.refs["slider"].value, autoplay: false });
  },

  renderSlides: function(slides, classes) {
    const quality = 80;
    const width = 1440;
    const queryParams = `?quality=${quality}&width=${width}`;

    return slides.map((slide, i) => {
      return (
        <div key={i} className={classes.slideContainer}>
          <div className={classes.slideImageContainer}>
            <img
              alt={`${slide.name} in ${slide.colorway} showing dark lenses in outdoor setting`}
              src={`${slide.outdoor}${queryParams}`}
              width="1440"
              height="594"
              className={classes.slideImage}
              style={{ zIndex: 1, opacity: `${this.state.range}` }}
            />
            <img
              alt={`${slide.name} in ${slide.colorway} showing lighter lenses in an indoor setting`}
              width="1440"
              height="594"
              src={`${slide.indoor}${queryParams}`}
              className={classes.slideImage}
            />
          </div>
        </div>
      );
    });
  },

  render: function() {
    const { slides, labels, caption } = this.props.data;
    const classes = this.getClasses();

    return (
      <div>
        <div className="u-grid__row u-pr">
          <div className={classes.sliderColumnContainer}>
            <Slider
              analyticsSlug="LightResponsiveLanding"
              frameData={_.map(slides, x => _.pick(x, ["name", "colorway"]))}
              showArrows={false}
              showFrameInfo={false}
              slides={this.renderSlides(slides, classes)}
              width="100%"
            />
          </div>
        </div>
        <div className={classes.rangeRow}>
          <div className="u-grid__col u-w12c u-w7c--600 u-w5c--900">
            <div className={classes.rangeContainer}>
              <span className={classes.rangeLabel}>
                {labels.left}
              </span>
              <input
                type="range"
                min="0"
                max="1"
                step="0.01"
                value={this.state.range}
                ref="slider"
                onInput={this.handleSlider}
                className={classes.range}
              />
              <span className={classes.rangeLabel}>
                {labels.right}
              </span>
            </div>
            <p className={classes.caption}>
              {caption}
            </p>
          </div>
        </div>
      </div>
    );
  }
});
