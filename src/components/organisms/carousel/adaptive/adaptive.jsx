const _ = require("lodash");
const React = require("react/addons");
const Arrow = require("components/quanta/icons/down_arrow_thin/down_arrow_thin");
const Styles = require("./style/style")("c-adaptive-carousel");
const Mixins = require("components/mixins/mixins");

require("./adaptive.scss");

const Slide = ({ grouping, slides }) => {
  const el = (src, half = true) => (
    <picture className={`${half ? Styles.halfSlide : Styles.fullSlide}`}>
      <source
        media={"(min-width: 1440px)"}
        srcSet={`${src.desktop} 1440w`}
        sizes={"1440px"}
      />
      <source
        media={"(min-width: 900px)"}
        srcSet={`${src.desktop} 1200w`}
        sizes={"100vw"}
      />
      <source srcSet={`${src.mobile} 600w`} sizes={"100vw"} />
      <img className={Styles.slide} src={`${src.mobile}`} alt={"showroom"} />
    </picture>
  );

  return grouping.length > 1 ? (
    <div key={"group"}>
      {[el(slides[grouping[0]]), el(slides[grouping[1]])]}
    </div>
  ) : (
    el(slides[grouping[0]], false)
  );
};

module.exports = React.createClass({
  ANALYTICS_CATEGORY: "RetailDetailCarousel",

  displayName: "AdaptiveCarousel",

  BREAKPOINT: 900,
  MAXWIDTH: 1440,

  mixins: [Mixins.analytics],

  getDefaultProps() {
    return {
      aspectRatio: { mobile: 4 / 5, desktop: 2 / 5 },
      grouping: {
        desktop: [[0], [1, 2], [3], [4, 5]],
        mobile: [[0], [1], [2], [3], [4], [5]]
      }
    };
  },

  getInitialState() {
    return {
      activeIndex: 0,
      numSlides: this.props.slides.length,
      screenSize: "mobile",
      dragStart: 0,
      dragDistance: 0,
      dragging: false,
      viewportWidth: this.getViewportWidth()
    };
  },

  componentDidMount() {
    this.updateSlider();

    return window.addEventListener(
      "resize",
      _.throttle(this.updateSlider, 500)
    );
  },

  getViewportWidth() {
    return typeof window !== "undefined" && window !== null
      ? window.innerWidth || _.get(document, "documentElement.clientWidth")
      : 0;
  },

  updateSlider(viewportWidth) {
    if (this.getViewportWidth() >= this.BREAKPOINT) {
      return this.setState({
        screenSize: "desktop",
        numSlides: this.props.grouping.desktop.length,
        viewportWidth: this.getViewportWidth()
      });
    } else {
      return this.setState({
        screenSize: "mobile",
        numSlides: this.props.grouping.mobile.length,
        viewportWidth: this.getViewportWidth()
      });
    }
  },

  getDragX(event) {
    return event.touches ? event.touches[0].pageX : event.pageX;
  },

  handleDragStart(event) {
    this.setState({
      dragStart: this.getDragX(event)
    });
  },

  handleDragMove(event) {
    const { dragStart, viewportWidth } = this.state;

    const offset = dragStart - this.getDragX(event);
    const dragDistance = parseInt(offset / viewportWidth * 100, 10);

    this.setState({
      dragging: true,
      dragDistance
    });
  },

  handleDragEnd() {
    const { dragDistance, viewportWidth, activeIndex, numSlides } = this.state;

    let newIndex;

    if (dragDistance >= 30) {
      newIndex = activeIndex === numSlides - 1 ? activeIndex : activeIndex + 1;
      this.trackInteraction(`${this.ANALYTICS_CATEGORY}-drag-nextSlide`);
    } else if (dragDistance <= -30) {
      newIndex = activeIndex === 0 ? 0 : activeIndex - 1;
      this.trackInteraction(`${this.ANALYTICS_CATEGORY}-drag-prevSlide`);
    } else {
      newIndex = activeIndex;
    }

    this.setState({
      dragging: false,
      dragStart: 0,
      dragDistance: 0,
      activeIndex: newIndex
    });
  },

  nextSlide() {
    return this.setState({ activeIndex: this.state.activeIndex + 1 }, () => {
      this.trackInteraction(`${this.ANALYTICS_CATEGORY}-click-nextSlide`);
    });
  },

  previousSlide() {
    return this.setState({ activeIndex: this.state.activeIndex - 1 }, () => {
      this.trackInteraction(`${this.ANALYTICS_CATEGORY}-click-prevSlide`);
    });
  },

  getTranslateDrag(activeIndex, dragDistance, viewportWidth) {
    const current = this.getTranslatePosition(activeIndex, viewportWidth);

    if (dragDistance < 0) {
      return current + Math.abs(dragDistance);
    } else {
      return `${current - dragDistance}`;
    }
  },

  getTranslatePosition(activeIndex, viewportWidth) {
    return viewportWidth >= this.MAXWIDTH
      ? activeIndex === 0 ? "0" : `${-parseInt(activeIndex * 1440, 10)}px`
      : activeIndex === 0 ? "0" : `${-parseInt(activeIndex * 100, 10)}vw`;
  },

  render() {
    const { aspectRatio, grouping, slides } = this.props;
    const {
      activeIndex,
      numSlides,
      screenSize,
      dragging,
      dragDistance,
      viewportWidth
    } = this.state;

    const containerTransition = dragging
      ? {
          transform: `translateX(${this.getTranslateDrag(
            activeIndex,
            dragDistance,
            viewportWidth
          )}vw)`
        }
      : {
          transform: `translateX(${this.getTranslatePosition(
            activeIndex,
            viewportWidth
          )})`
        };

    return (
      <div className={Styles.stage}>
        <div
          className={Styles.slidesContainer}
          style={containerTransition}
          onDragStart={this.handleDragStart}
          onDragOver={this.handleDragMove}
          onDragEnd={this.handleDragEnd}
          onTouchStart={this.handleDragStart}
          onTouchMove={this.handleDragMove}
          onTouchEnd={this.handleDragEnd}
        >
          {grouping[screenSize].map((x, i) => (
            <Slide key={i} grouping={x} slides={slides} />
          ))}
        </div>
        <div
          className={`${Styles.arrowContainer} ${numSlides > 1
            ? "u-db--900"
            : "u-dn"}`}
        >
          <button
            className={Styles.button}
            onClick={this.previousSlide}
            disabled={activeIndex === 0}
          >
            <Arrow
              title="Previous slide"
              cssModifier={`${Styles.arrow} -left u-stroke--white`}
            />
          </button>
          <button
            onClick={this.nextSlide}
            disabled={activeIndex >= numSlides - 1}
            className={Styles.button}
          >
            <Arrow
              title="Next slide"
              cssModifier={`${Styles.arrow} -right u-stroke--white`}
            />
          </button>
        </div>
        <div className={Styles.shadow} />
        <ul className={Styles.indicatorContainer(numSlides > 1)}>
          {_.map(new Array(numSlides), (x, i) => (
            <li
              key={`${screenSize}_indicator_${i}`}
              className={Styles.indicator(i === activeIndex)}
            />
          ))}
        </ul>
      </div>
    );
  }
});
