const React = require("react/addons");

const Picture = require("components/atoms/images/picture/picture");
const ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

const Mixins = require("components/mixins/mixins");

const FEATURE_TYPE_LOOKUP = {
  0: "Coil",
  1: "Eyewire",
  2: "Browline"
};

module.exports = React.createClass({
  displayName: "ArchiveCollectionProductHighlight",

  propTypes: {
    title: React.PropTypes.string,
    features: React.PropTypes.array,
    images: React.PropTypes.array,
    classes: React.PropTypes.object
  },

  mixins: [Mixins.image, Mixins.analytics],

  getInitialState() {
    return {
      activeIndex: 0,
      userHasClicked: false
    };
  },

  getDefaultProps() {
    return {
      title: "",
      features: [],
      images: [],
      classes: {}
    };
  },

  componentDidMount() {
    this.interval = window.setInterval(this.updateActiveFeature, 3000);
  },

  componentWillUnMount() {
    window.clearInterval(this.interval);
  },

  updateActiveFeature() {
    if (!this.state.userHasClicked) {
      const max = this.props.features.length;
      const nextIndex = this.state.activeIndex + 1;
      this.setState({ activeIndex: nextIndex >= max ? 0 : nextIndex });
    }
  },

  getImageAttrs(images) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, "desktop-sd"),
          widths: this.getImageWidths(900, 2200, 5),
          quality: this.getQualityBySize(images, "desktop-sd"),
          mediaQuery: "(min-width: 900px)",
          sizes: "(min-width: 1440px) 1440px, 100vw"
        },
        {
          url: this.getImageBySize(images, "tablet"),
          quality: this.getQualityBySize(images, "tablet"),
          widths: this.getImageWidths(600, 1350, 5),
          mediaQuery: "(min-width: 600px)",
          sizes: "100vw"
        },
        {
          url: this.getImageBySize(images, "mobile"),
          quality: this.getQualityBySize(images, "tablet"),
          widths: this.getImageWidths(300, 900, 5),
          mediaQuery: "(min-width: 0px)",
          sizes: "100vw"
        }
      ],
      img: {
        alt: "Warby Parker",
        className: this.props.classes.image
      }
    };
  },

  handleFeatureClick(i) {
    this.trackInteraction(
      `LandingPage-ClickFrameFeature-${FEATURE_TYPE_LOOKUP[i]}`
    );
    if (!this.state.userHasClicked) {
      this.setState({ userHasClicked: true });
      window.clearInterval(this.interval);
    }
    this.setState({ activeIndex: i });
  },

  renderFeatures(features = []) {
    const children = features.map((feature, i) => {
      const isHiglight = i === this.state.activeIndex;
      return (
        <div
          children={feature}
          key={i}
          className={this.props.classes.feature(isHiglight)}
          onClick={this.handleFeatureClick.bind(this, i)}
        />
      );
    });

    return (
      <div className={this.props.classes.featureWrapper} children={children} />
    );
  },

  render() {
    const { images, features, title, classes } = this.props;
    const imageAttrs = this.getImageAttrs(images[this.state.activeIndex]);

    return (
      <div className={classes.block}>
        <div className={classes.mobileTitle} children={title} />
        <div className={classes.featureList}>
          <div className={classes.title} children={title} />
          <div children={this.renderFeatures(features)} />
        </div>
        <div className={classes.transitionWrapper}>
          <ReactCSSTransitionGroup
            transitionName={classes.transitionWrapper}
            transitionEnterTimeout={1200}
            transitionLeaveTimeout={1200}
          >
            <div className={classes.imageWrapper} key={this.state.activeIndex}>
              <Picture children={this.getPictureChildren(imageAttrs)} />
            </div>
          </ReactCSSTransitionGroup>
        </div>
      </div>
    );
  }
});
