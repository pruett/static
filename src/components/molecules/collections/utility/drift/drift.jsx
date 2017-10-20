const React = require("react/addons");

/**
 * Image Slider
 * Uses unique IDs to help denote slides and keep count.
 */

class Drift extends React.Component {
  static get displayName() {
    return "Slider";
  }

  static get defaultProps() {
    return {
      duration: "0.4s",
      disabled: false,
      easingFn: "ease-in-out",
      dragMax: 100,
      indexDidUpdate: (prevIndex, nextIndex) => {}
    };
  }

  constructor(props) {
    super(props);

    this.slides = [];
    this.dragStart = { x: 0, y: 0 };
    this.dragEnd = { x: 0, y: 0 };

    this.bindHandlers();
    this.state = {
      index: 0,
      indexLast: 0
    };
  }

  /**
   * Component Life Cycles
   */

  componentDidMount() {
    this.setState({ indexLast: this.indexLast });
    this.addListeners();
  }

  componentDidUpdate(prevProps, prevState) {
    if (this.indexLast !== this.indexLast) {
      // Update last index if slides change.
      this.setState({ indexLast: this.indexLast });
    }

    if (this.state.index !== prevState.index) {
      // Notify that index has changed.
      this.props.indexDidUpdate(prevState.index, this.state.index);
    }

    if (!prevState.disabled && this.state.disabled) {
      this.removeListeners();
    }

    if (prevState.disabled && !this.state.disabled) {
      this.addListeners();
    }
  }

  addListeners() {
    window.addEventListener("keydown", this.handleKeyDown);
  }

  removeListeners() {
    window.removeEventListener("keydown", this.handleKeyDown);
  }

  bindHandlers() {
    this.handleDragMove = this.handleDragMove.bind(this);
    this.handleDragStart = this.handleDragStart.bind(this);
    this.handleDragEnd = this.handleDragEnd.bind(this);
    this.handleKeyDown = this.handleKeyDown.bind(this);

    this.propsSlide = this.propsSlide.bind(this);
    this.propsSlides = this.propsSlides.bind(this);
    this.propsContainer = this.propsContainer.bind(this);

    this.goToSlide = this.goToSlide.bind(this);
  }

  getDragXY(event) {
    const coords = event.touches ? event.touches[0] : event;
    return { x: coords.pageX || 0, y: coords.pageY || 0 };
  }

  getProps(props) {
    return this.props.disabled ? {} : props;
  }

  /**
   * Getters
   */

  get indexLast() {
    // Get index of last slide.
    return Math.max(0, this.slides.length - 1);
  }

  get swipeDirection() {
    const xDist = this.dragStart.x - this.dragEnd.x;
    const yDist = this.dragStart.y - this.dragEnd.y;
    const r = Math.atan2(yDist, xDist);

    const angle = this.normalizeAngle(Math.round(r * 180 / Math.PI));

    if ((angle <= 45 && angle >= 0) || (angle <= 360 && angle >= 315)) {
      return 1;
    } else if (angle >= 135 && angle <= 225) {
      return -1;
    } else {
      return 0;
    }
  }

  get offset() {
    return this.normalizeOffset(this.dragEnd.x - this.dragStart.x);
  }

  get translateX() {
    return this.normalizeTranslateX(
      -100 * this.state.index + (this.state.dragging ? this.state.offset : 0)
    );
  }

  get nextIndex() {
    return this.normalizeIndex(this.state.index + this.swipeDirection);
  }

  get isPastDragThreshold() {
    return Math.abs(this.offset) > this.props.dragMax;
  }

  /**
   * Handlers
   */

  handleKeyDown(evt) {
    if (evt.keyCode === 37) {
      this.goToSlide(this.state.index - 1);
    } else if (evt.keyCode === 39) {
      this.goToSlide(this.state.index + 1);
    }
  }

  handleDragStart(event) {
    this.dragStart = this.getDragXY(event);
    this.setState({ dragging: true });
  }

  handleDragMove(event) {
    this.dragEnd = this.getDragXY(event);
    if (this.isPastDragThreshold) {
      event.stopPropagation();
      this.setState({ dragging: false });
    } else {
      this.setState({ offset: this.offset });
    }
  }

  handleDragEnd() {
    this.setState({
      dragging: false,
      index: this.nextIndex
    });
  }

  /**
   * Normalizers.
   */

  normalizeIndex(index) {
    return Math.max(0, Math.min(this.indexLast, index));
  }

  normalizeAngle(angle) {
    return 360 - Math.abs(angle);
  }

  normalizeTranslateX(x) {
    return Math.max(-100 * this.indexLast, Math.min(0, x));
  }

  normalizeOffset(offset) {
    return Math.max(-100, Math.min(100, offset));
  }

  /**
   * Props for Slider components.
   */

  propsContainer(style = {}) {
    return this.getProps({
      onDragStart: this.handleDragStart,
      onDragOver: this.handleDragMove,
      onDragEnd: this.handleDragEnd,
      onTouchStart: this.handleDragStart,
      onTouchMove: this.handleDragMove,
      onTouchEnd: this.handleDragEnd,
      style: {
        overflow: "hidden",
        ...style
      }
    });
  }

  propsSlides(style = {}) {
    return this.getProps({
      style: {
        whiteSpace: "noWrap",
        transition: `${this.props.duration} transform ${this.props.easingFn}`,
        transform: `translateX(${this.translateX}%)`,
        ...style
      }
    });
  }

  propsSlide(id, style = {}) {
    if (this.slides.indexOf(id) < 0) {
      // A unique ID is needed to count slides.
      this.slides.push(id);
    }

    return this.getProps({
      style: {
        width: "100%",
        display: "inline-block",
        whiteSpace: "normal",
        ...style
      }
    });
  }

  goToSlide(index) {
    return this.setState({
      index: this.normalizeIndex(index)
    });
  }

  render() {
    return this.props.children({
      index: this.state.index,
      indexLast: this.indexLast,
      propsContainer: this.propsContainer,
      propsSlide: this.propsSlide,
      propsSlides: this.propsSlides,
      goToSlide: this.goToSlide
    });
  }
}

module.exports = Drift;
