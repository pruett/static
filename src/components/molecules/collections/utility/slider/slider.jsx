// https://github.com/Stanko/react-slider/blob/gh-pages/slider.js
// https://github.com/kenwheeler/slick
const React = require("react/addons");
const ReactDOM = require("react-dom");

const CollectionConstants = require("components/utilities/collections/constants");

const Mixins = require("components/mixins/mixins");

require("./slider.scss");

module.exports = React.createClass({
  BLOCK_CLASS: "c-collection-utility-slider",

  displayName: "MoleculesCollectionsSlider",

  mixins: [Mixins.classes, Mixins.analytics, Mixins.dispatcher],

  propTypes: {
    analyticsSlug: React.PropTypes.string,
    arrowImageLeft: React.PropTypes.string,
    arrowImageRight: React.PropTypes.string,
    frameData: React.PropTypes.array,
    info: React.PropTypes.array,
    links: React.PropTypes.array,
    loop: React.PropTypes.bool,
    selected: React.PropTypes.number,
    showArrows: React.PropTypes.bool,
    showFrameInfo: React.PropTypes.bool,
    showLinks: React.PropTypes.bool,
    showNav: React.PropTypes.bool,
    slides: React.PropTypes.array,
    useImageArrows: React.PropTypes.bool,
    width: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      analyticsSlug: "",
      arrowImageLeft: "",
      arrowImageRight: "",
      frameData: [],
      info: [],
      links: [],
      loop: false,
      selected: 0,
      showArrows: true,
      showFrameInfo: true,
      showLinks: true,
      showNav: true,
      slides: [],
      useImageArrows: false,
      width: "80%"
    };
  },

  getInitialState() {
    return {
      dragStart: 0,
      dragStartTime: new Date(),
      index: 0,
      lastIndex: 0,
      transition: false
    };
  },

  getStaticClasses() {
    return {
      block: `${this.BLOCK_CLASS} u-mla u-mra u-mb48`,
      colorWay:
        "u-ffs u-fs18 u-fs20--600 u-fwn u-color--dark-gray-alt-2 u-fsi u-mt0 u-mb8",
      frameInfoWrapper: `u-mt12 u-mb6 u-fws`,
      frameName:
        "u-fs30 u-fs34--600 u-fs40--900 u-ffs u-fws u-color--dark-gray u-mt0 u-mb5",
      link: `${this.BLOCK_CLASS}__link u-fws u-pb6 u-bbss u-bbw1 u-bbw0--900`,
      linkWrapper: `u-tac u-mb12`,
      sliderArrow: `${this.BLOCK_CLASS}__slider-arrow`,
      sliderArrowLeft: `${this.BLOCK_CLASS}__slider-arrow--left`,
      sliderArrowRight: `${this.BLOCK_CLASS}__slider-arrow--right`,
      sliderArrows: `${this.BLOCK_CLASS}__slider-arrows`,
      sliderArrowsNoNav: `${this.BLOCK_CLASS}__slider-arrows--no-nav`,
      sliderNav: `${this.BLOCK_CLASS}__slider-nav`,
      sliderNavButton: `${this.BLOCK_CLASS}__slider-nav-button`,
      sliderNavButtonActive: `${this.BLOCK_CLASS}__slider-nav-button--active`,
      sliderArrows: `${this.BLOCK_CLASS}__slider-arrows`,
      sliderArrowsNoNav: `${this.BLOCK_CLASS}__slider-arrows--no-nav`,
      sliderArrow: `${this.BLOCK_CLASS}__slider-arrow`,
      sliderArrowLeft: `${this.BLOCK_CLASS}__slider-arrow--left`,
      sliderArrowRight: `${this.BLOCK_CLASS}__slider-arrow--right`,
      leftImageArrow: `${this.BLOCK_CLASS}__left-fancy-arrow`,
      rightImageArrow: `${this.BLOCK_CLASS}__right-fancy-arrow`,
      slides: `${this.BLOCK_CLASS}__slides`,
      slidesTransition: `${this.BLOCK_CLASS}__slides--transition`
    };
  },

  getDragX(event, isTouch) {
    return isTouch ? event.touches[0].pageX : event.pageX;
  },

  handleDragStart(event, isTouch) {
    const x = this.getDragX(event, isTouch);

    this.setState({
      dragStart: x,
      dragStartTime: new Date(),
      transition: false,
      slideWidth: ReactDOM.findDOMNode(this.refs.slider).offsetWidth
    });
  },

  handleDragMove(event, isTouch) {
    const { dragStart, lastIndex, slideWidth } = this.state;

    const x = this.getDragX(event, isTouch);
    const offset = dragStart - x;
    const percentageOffset = offset / slideWidth;
    const newIndex = lastIndex + percentageOffset;
    const SCROLL_OFFSET_TO_STOP_SCROLL = 30;

    // Stop scrolling if you slide more than 30 pixels
    if (Math.abs(offset) > SCROLL_OFFSET_TO_STOP_SCROLL) {
      event.stopPropagation();
      event.preventDefault();
    }

    this.setState({
      index: newIndex
    });
  },

  handleDragEnd() {
    const { slides } = this.props;
    const { dragStartTime, index, lastIndex } = this.state;

    const timeElapsed = new Date().getTime() - dragStartTime.getTime();
    const offset = lastIndex - index;
    const velocity = Math.round(offset / timeElapsed * 10000);

    let newIndex = Math.round(index);

    if (Math.abs(velocity) > 5) {
      newIndex = velocity < 0 ? lastIndex + 1 : lastIndex - 1;
    }

    if (newIndex < 0) {
      newIndex = 0;
    } else if (newIndex >= slides.length) {
      newIndex = slides.length - 1;
    }

    this.setState({
      dragStart: 0,
      index: newIndex,
      lastIndex: newIndex,
      transition: true
    });
  },

  goToSlide(index, event) {
    const { slides, loop } = this.props;

    if (event) {
      event.preventDefault();
      event.stopPropagation();
    }

    if (index < 0) {
      index = loop ? slides.length - 1 : 0;
    } else if (index >= slides.length) {
      index = loop ? 0 : slides.length - 1;
    }

    this.setState({
      index: index,
      lastIndex: index,
      transition: true
    });

    this.trackInteraction(
      `${this.props.analyticsSlug || "Slider"}-click-navDot${index + 1}`
    );
  },

  renderNav(classes) {
    const { slides } = this.props;
    const { lastIndex } = this.state;

    const nav = slides.map((slide, i) => {
      const buttonClasses =
        i === lastIndex
          ? `${classes.sliderNavButton} ${classes.sliderNavButtonActive}`
          : `${classes.sliderNavButton}`;
      return (
        <button
          className={buttonClasses}
          key={i}
          onClick={event => this.goToSlide(i, event)}
        />
      );
    });

    return (
      <div className={classes.sliderNav}>
        {nav}
      </div>
    );
  },

  getLeftArrow(classes) {
    const { lastIndex } = this.state;
    const button = (
      <button
        className={`${classes.sliderArrow} ${classes.sliderArrowLeft}`}
        onClick={event => this.goToSlide(lastIndex - 1, event)}
      />
    );
    const arrow = (
      <img
        onClick={event => this.goToSlide(lastIndex - 1, event)}
        className={classes.leftImageArrow}
        src={this.props.arrowImageLeft}
      />
    );

    if (!this.props.useImageArrows) {
      return button;
    } else {
      return arrow;
    }
  },

  getRightArrow(classes) {
    const { lastIndex } = this.state;
    const button = (
      <button
        className={`${classes.sliderArrow} ${classes.sliderArrowRight}`}
        onClick={event => this.goToSlide(lastIndex + 1, event)}
      />
    );
    const arrow = (
      <img
        onClick={event => this.goToSlide(lastIndex + 1, event)}
        className={classes.rightImageArrow}
        src={this.props.arrowImageRight}
      />
    );

    if (!this.props.useImageArrows) {
      return button;
    } else {
      return arrow;
    }
  },

  renderArrows(classes) {
    const { slides, loop, showNav } = this.props;
    const { lastIndex } = this.state;
    const arrowsClasses = showNav
      ? `${classes.sliderArrows}`
      : `${classes.sliderArrows} ${classes.sliderArrowsNoNav}`;

    return (
      <div className={arrowsClasses}>
        {loop || lastIndex > 0 ? this.getLeftArrow(classes) : null}
        {loop || lastIndex < slides.length - 1
          ? this.getRightArrow(classes)
          : null}
      </div>
    );
  },

  getTranslateX(index, slides) {
    // prevent overflow
    const max = 100 / slides.length;
    const delta = -1 * index * max;
    return index === 0 ? 0 : delta;
  },

  handleLinkClick(gaData) {
    this.trackInteraction(
      `LandingPage-clickShop${CollectionConstants.GA_GENDER_LOOKUP[
        gaData.gender
      ]}-${gaData.sku}`
    );

    const productImpression = {
      brand: "Warby Parker",
      category: gaData.type,
      collections: [
        {
          slug: gaData.collections
        }
      ],
      color: gaData.color,
      gender: gaData.gender,
      id: gaData.id,
      list: gaData.list,
      name: gaData.name,
      position: gaData.position,
      sku: gaData.sku
    };

    this.commandDispatcher("analytics", "pushProductEvent", {
      type: "productClick",
      products: productImpression,
      eventMetadata: {
        list: gaData.list
      }
    });
  },

  renderLinks(index, classes) {
    const { links } = this.props;
    const activeLinks = links[Math.floor(index)];
    if (!activeLinks) return;
    const linkChildren = activeLinks.map((link, i) => {
      return (
        <a
          href={link.href}
          className={classes.link}
          key={i}
          onClick={this.handleLinkClick.bind(this, link.gaData)}
          children={link.link_text}
        />
      );
    });
    return <div children={linkChildren} className={classes.linkWrapper} />;
  },

  renderFrameInfo(index) {
    const { info } = this.props;
    if (!info) return;
    const activeInfo = info[Math.floor(index)];
    if (!activeInfo) return;

    return (
      <div children={`${activeInfo.frameName} in ${activeInfo.frameColor}`} />
    );
  },

  renderFrameData: function(index, data, classes) {
    const activeData = data[Math.max(0, Math.floor(index))];
    if (!activeData) return;

    return (
      <div className="u-tac u-mt30">
        <h2 className={classes.frameName}>
          {activeData.name}
        </h2>
        <h3 className={classes.colorWay}>
          {activeData.colorway}
        </h3>
      </div>
    );
  },

  render() {
    const classes = this.getClasses();
    const { frameData, slides, showArrows, showNav } = this.props;

    const { index, transition } = this.state;

    const slidesStyles = {
      width: `${100 * slides.length}%`,
      transform: `translateX(${this.getTranslateX(index, slides)}%)`
    };

    const slidesClasses = transition
      ? `${classes.slides} ${classes.slidesTransition}`
      : `${classes.slides}`;

    return (
      <div
        className={classes.block}
        style={{ width: this.props.width }}
        ref="slider"
      >
        {showArrows ? this.renderArrows(classes) : null}

        <div
          onTouchStart={event => this.handleDragStart(event, true)}
          onTouchMove={event => this.handleDragMove(event, true)}
          onTouchEnd={() => this.handleDragEnd(true)}
        >
          <div className={slidesClasses} style={slidesStyles}>
            {slides}
          </div>
        </div>
        {frameData && this.renderFrameData(index, frameData, classes)}
        {showNav ? this.renderNav(classes) : null}
        {this.props.showFrameInfo &&
          <div className={classes.frameInfoWrapper}>
            {this.renderFrameInfo(index)}
          </div>}
        <div>
          {this.props.showLinks && this.renderLinks(index, classes)}
        </div>
      </div>
    );
  }
});
