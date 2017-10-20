const _ = require("lodash");
const React = require("react/addons");
const LeftArrowLarge = require("components/quanta/icons/left_arrow_large/left_arrow_large");
const RightArrowLarge = require("components/quanta/icons/right_arrow_large/right_arrow_large");
const Mixins = require("components/mixins/mixins");

const ArrowThin = require("components/quanta/icons/down_arrow_thin/down_arrow_thin");

require("./active.scss")

const ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

module.exports = React.createClass({
  BLOCK_CLASS: "c-slider-active",

  mixins: [Mixins.analytics, Mixins.classes, Mixins.dispatcher],

  propTypes: {
    initialActiveIndex: React.PropTypes.number,
    "aria-label": React.PropTypes.string,
    capabilities: React.PropTypes.object,
    children: React.PropTypes.node,
    cssModifier: React.PropTypes.string,
    showDots: React.PropTypes.bool,
    cssModifierListItem: React.PropTypes.string,
    hideArrowsMobile: React.PropTypes.bool,
    enableDragging: React.PropTypes.bool
  },

  getDefaultProps() {
    return {
      initialActiveIndex: 0,
      cssModifier: "",
      arrowColor: "u-fill--light-gray",
      showDots: false,
      cssModifierListItem: "",
      hideArrowsMobile: true,
      enableDragging: true,
      manageChangeActiveIndex: () => {},
      versionTwo: false,
      analyticsCategory: "slider",
    };
  },

  getInitialState() {
    return {
      activeIndex: this.props.initialActiveIndex,
      childrenUpdateCount: 0,
      deltaX: 0,
      focusedToggle: null,
      initialPosition: {
        x: 0,
        y: 0
      },
      isDragging: false,
      nextIndex: null,
      transition: {
        duration: "0s",
        property: "none"
      },
      slideWidth: 0
    };
  },

  getStaticClasses() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        ${this.props.cssModifier}
      `,
      list: `
        ${this.BLOCK_CLASS}__list
        u-list-reset
      `,
      listItem: `
        ${this.BLOCK_CLASS}__list-item
        ${this.props.cssModifierListItem}
      `,
      leftToggle: `
        ${this.BLOCK_CLASS}__toggle -left
        u-button-reset
        js-ga-click
      `,
      rightToggle: `
        ${this.BLOCK_CLASS}__toggle -right
        u-button-reset
        js-ga-click
      `,
      leftArrow: `
        ${this.BLOCK_CLASS}__arrow -left
        ${this.props.arrowColor}
        u-w100p
      `,
      rightArrow: `
        ${this.BLOCK_CLASS}__arrow -right
        ${this.props.arrowColor}
        u-w100p
      `,
      subtitle: `
        ${this.BLOCK_CLASS}__subtitle
        u-fws u-color--white u-fl
      `,
      subtitleFrameName: `
        u-mt0 u-mb6 u-fs18
      `,
      subtitleFrameColor: `
        u-fs16 u-fwl u-fsi u-mt6 u-mb0
      `,
      dotsContainer: `
        ${this.BLOCK_CLASS}__dots-container
        u-p0
        u-mt0
        u-mb6
        u-tac
      `,
      dot: `
        ${this.BLOCK_CLASS}__dot
      `,
      shadow: `
        ${this.BLOCK_CLASS}__shadow
      `
    };
  },

  classesWillUpdate() {
    return {
      block: {
        "u-h100p--900": this.props.versionTwo
      },
      list: {
        "-single": this.props.children.length < 2,
        "u-h100p--900": this.props.versionTwo
      },
      listItem: {
        "u-h100p--900": this.props.versionTwo
      },
      leftArrow: {
        "-focused": this.state.focusedToggle === "left",
        "-v2": this.props.versionTwo
      },
      rightArrow: {
        "-focused": this.state.focusedToggle === "right",
        "-v2": this.props.versionTwo
      },
      leftToggle: {
        "u-dn u-db--720": this.props.hideArrowsMobile,
        "-v2 u-ml12 u-ml24--600": this.props.versionTwo
      },
      rightToggle: {
        "u-dn u-db--720": this.props.hideArrowsMobile,
        "-v2 u-mr24": this.props.versionTwo
      },
      dotsContainer: {
        "-v2 u-fr": this.props.versionTwo,
        "u-dn--720": !this.props.versionTwo
      },
      dot: {
        "-v2": this.props.versionTwo,
      },
      shadow: {
        "u-pa u-pl24 u-pl36--600 u-pl48--900 u-pr24 u-pr36--600 u-pr48--900 u-pt60 u-pb24 u-pb48--900 u-w100p u-mb6 u-mb4--600 u-mb0--900": this.props.versionTwo
      }
    };
  },

  dividendDependentModulo(a, b) {
    return (a % b + b) % b;
  },

  componentDidMount() {
    this.setState(
      { listRef: React.findDOMNode(this.refs.list) },
      this.setSlideWidth
    );
    return window.addEventListener("resize", this.handleResize);
  },

  componentWillUnmount() {
    return window.removeEventListener("resize", this.handleResize);
  },

  componentDidUpdate(prevProps, prevState) {
    if (this.state.activeIndex !== prevState.activeIndex) {
      // Tell parent about updates to the active index.
      this.props.manageChangeActiveIndex(this.state.activeIndex);
    } else if (
      this.props.children.length !== prevProps.children.length &&
      this.state.activeIndex > this.props.children.length - 1
    ) {
      // Adjust active index if it exceeds the bounds of a new children array.
      this.setState({ activeIndex: this.props.children.length - 1 });
    }
  },

  handleResize() {
    this.setSlideWidth();
  },

  setSlideWidth() {
    this.setState({
      slideWidth: _.get(this.state, "listRef.offsetWidth")
    });
  },

  getClientPosition(evt) {
    return {
      x: _.get(evt, "touches[0].clientX", evt.clientX),
      y: _.get(evt, "touches[0].clientY", evt.clientY)
    };
  },

  handleDragStart(evt) {
    evt.preventDefault();

    this.setState({
      initialPosition: this.getClientPosition(evt),
      isDragging: true
    });
  },

  handleDrag(evt) {
    if (!this.state.isDragging) {
      return;
    }

    const clientPosition = this.getClientPosition(evt);
    const deltaX = clientPosition.x - this.state.initialPosition.x;
    const deltaY = clientPosition.y - this.state.initialPosition.y;

    // Ignore drag events that are more vertical than horizontal. If this check
    // proves too coarse, peek at how Slick does it:
    // https://github.com/kenwheeler/slick/blob/master/slick/slick.js#L2235
    if (Math.abs(deltaY) > Math.abs(deltaX)) {
      return;
    }

    if (!evt.touches) {
      evt.preventDefault();
    }

    return this.setState({ deltaX });
  },

  handleDragEnd(evt) {
    if (!this.state.isDragging) {
      return;
    }

    this.setState(
      {
        deltaX: this.getClientPosition(evt).x - this.state.initialPosition.x,
        isDragging: false,
        nextIndex: this.getNextIndexFromDeltaX()
      },
      this.animateToNextSlide
    );
  },

  animateToNextSlide() {
    const deltaX = this.getDeltaXToNextSlide();
    const cssTransition = _.get(this.props, "capabilities.cssTransition", {});
    const cssTransform = _.get(this.props, "capabilities.cssTransform", {});

    if (cssTransition.available && cssTransform.available) {
      this.state.listRef.addEventListener(
        cssTransition.vendor.endEvent,
        this.handleTransitionEnd
      );

      this.setState({
        deltaX,
        initialPosition: {
          x: 0,
          y: 0
        },
        transition: {
          duration: "0.3s",
          property: cssTransform.vendor.cssProperty
        }
      });
    } else {
      this.setNewSlidePosition(this.state.nextIndex);
    }
  },

  getChangeSlideThreshold(slideWidth) {
    return slideWidth * 0.25;
  },

  getNextIndexFromDeltaX() {
    const { deltaX } = this.state;

    if (
      Math.abs(deltaX) < this.getChangeSlideThreshold(this.state.slideWidth)
    ) {
      return this.state.activeIndex;
    } else if (deltaX < 0) {
      return this.state.activeIndex + 1;
    } else if (deltaX > 0) {
      return this.state.activeIndex - 1;
    }
  },

  getDeltaXToNextSlide() {
    switch (this.state.nextIndex - this.state.activeIndex) {
      case -1:
        return this.state.slideWidth;
      case 0:
        return 0;
      case 1:
        return -this.state.slideWidth;
    }
  },

  handleTransitionEnd(evt) {
    evt.target.removeEventListener(
      this.props.capabilities.cssTransition.vendor.endEvent,
      this.handleTransitionEnd
    );
    if (this.state.nextIndex !== null) {
      // `transitionend` event should only fire once, while `@state.nextIndex`
      // value is set, but we're seeing mysterious cases where the event fires a
      // second time, after `@state.nextIndex` has already been cleared. To avoid
      // unnecessary calls to `@setNewSlidePosition` that this causes, first
      // confirm that `@state.nextIndex` hasn't already been cleared before
      // setting the new slide position.
      this.setNewSlidePosition(this.state.nextIndex);
    }
  },

  setNewSlidePosition(nextIndex) {
    const activeIndex = this.dividendDependentModulo(
      nextIndex,
      this.props.children.length
    );

    this.setState({
      activeIndex,
      nextIndex: null,
      deltaX: 0,
      transition: {
        duration: "0s",
        property: "none"
      }
    });
    this.trackInteraction(`${this.props.analyticsCategory}-update-${activeIndex + 1}`);
  },

  getChildIndices() {
    // Order the slides so that the active slide is in view, with only its
    // previous slide before it (out of view), so that moving the slider in
    // direction shows a slide.
    // TODO: support 2 items in the slider
    const slideCount = this.props.children.length;
    const firstIndex = this.state.activeIndex - 1;
    const lastIndex = firstIndex + slideCount - 1;

    return _.map(_.range(firstIndex, lastIndex + 1), i => {
      return this.dividendDependentModulo(i, slideCount);
    });
  },

  getListStyle() {
    const listStyle = {
      transitionDuration: this.state.transition.duration,
      transitionProperty: this.state.transition.property
    };

    const transformProp = _.get(
      this.props,
      "capabilities.cssTransform.vendor.jsProperty"
    );

    if (transformProp) {
      _.assign(listStyle, {
        [transformProp]: `translate3d(${this.state.deltaX}px, 0px, 0px)`
      });
    }

    return listStyle;
  },

  handleClickIndex(nextIndex) {
    this.setState(
      { nextIndex },
      this.animateToNextSlide
    );
  },

  handleClickToggle(direction) {
    const nextIndex = direction === 'left' ? this.state.activeIndex - 1 : this.state.activeIndex + 1;
    this.handleClickIndex(nextIndex);
  },

  handleFocusToggle(direction) {
    return evt => {
      return this.setState({ focusedToggle: direction });
    };
  },

  handleBlurToggle() {
    this.setState({ focusedToggle: null });
  },

  componentWillReceiveProps(nextProps) {
    const childrenUpdated =
      this.props.children.length !== nextProps.children.length ||
      _.reduce(
        nextProps.children,
        (acc, child, i) => {
          return acc || child.key !== this.props.children[i].key;
        },
        false
      );

    if (childrenUpdated) {
      this.setState(prevState => ({
        childrenUpdateCount: prevState.childrenUpdateCount + 1
      }));
    }
  },

  render() {
    let props;
    const classes = this.getClasses();

    const children = _.map(this.getChildIndices(), index => {
      return {
        child: this.props.children[index],
        index
      };
    });

    return (
      <div
        aria-label={this.props['aria-label']}
        className={classes.block}
        id={this.props.id}
        role={'region'}
      >
        <ReactCSSTransitionGroup
          component="ul"
          ref="list"
          className={classes.list}
          transitionName="-transition-fade"
          style={this.getListStyle()}
        >
          {_.map(children, (childData, i) => {
            props = {
              key: `${this.state.childrenUpdateCount}-${childData.index}`,
              className: classes.listItem,
              children: childData.child
            };

            if (childData.index === this.state.activeIndex) {
              props["aria-live"] = "polite";
            }

            if (children.length > 1 && this.props.enableDragging) {
              _.assign(props, {
                onMouseDown: this.handleDragStart,
                onTouchStart: this.handleDragStart,
                onMouseMove: this.handleDrag,
                onTouchMove: this.handleDrag,
                onTouchEnd: this.handleDragEnd,
                onTouchCancel: this.handleDragEnd,
                onMouseUp: this.handleDragEnd,
                onMouseLeave: this.handleDragEnd
              });
            }

            return <li {...props} />;
          })}
        </ReactCSSTransitionGroup>
        <button
          className={classes.leftToggle}
          onClick={this.handleClickToggle.bind(this, "left")}
          onFocus={this.handleFocusToggle.bind(this, "left")}
          onBlur={this.handleBlurToggle}
        >
          {this.props.versionTwo ?
            <ArrowThin
              title="Previous slide"
              id={`${this.BLOCK_CLASS}__previous-slide`}
              cssModifier={`${classes.leftArrow} u-stroke--white`}
            /> :
            <LeftArrowLarge
              title="Previous slide"
              id={`${this.BLOCK_CLASS}__previous-slide`}
              cssModifier={classes.leftArrow}
            />
          }
        </button>
        <button
          className={classes.rightToggle}
          onClick={this.handleClickToggle.bind(this, "right")}
          onFocus={this.handleFocusToggle.bind(this, "right")}
          onBlur={this.handleBlurToggle}
        >
          {this.props.versionTwo ?
            <ArrowThin
              title="Next slide"
              id={`${this.BLOCK_CLASS}__next-slide`}
              cssModifier={`${classes.rightArrow} u-stroke--white`}
            /> :
            <RightArrowLarge
              title="Next slide"
              id={`${this.BLOCK_CLASS}__next-slide`}
              cssModifier={classes.rightArrow}
            />
          }
        </button>
        <div className={this.props.versionTwo ? classes.shadow : null}>
          {this.props.versionTwo ?
            <div className={classes.subtitle}>
              <h3 className={classes.subtitleFrameName} children={this.props.frameName} />
              <h3 className={classes.subtitleFrameColor} children={this.props.fitImages[this.state.activeIndex].color} />
            </div>
            : null
          }
          {this.props.showDots
            ? <ul className={classes.dotsContainer} aria-hidden={true}>
                {_.map(children, (childData, i) => {
                  return (
                    <li
                      key={i}
                      className={`${classes.dot} ${i === this.state.activeIndex ? "-active" : ""}`}
                      onClick={this.handleClickIndex.bind(this, i)}
                    />
                  );
                })}
              </ul>
            : undefined}
        </div>
      </div>
    );
  }
});
