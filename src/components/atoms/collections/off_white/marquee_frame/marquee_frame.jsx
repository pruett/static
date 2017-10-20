const React = require("react/addons");
const _ = require("lodash");

const Img = require("components/atoms/images/img/img");

const Mixins = require("components/mixins/mixins");

require("./marquee_frame.scss");
module.exports = React.createClass({
  displayName: "OffWhiteMarqueeFrame",

  BLOCK_CLASS: "c-off-white-marquee-frame",

  Frame_SIZES: [
    {
      breakpoint: 0,
      width: "33vw"
    }
  ],

  mixins: [Mixins.classes, Mixins.image],

  getInitialState() {
    return {
      caption: ``,
      captionIndex: 0
    };
  },

  getDefaultProps() {
    return {
      alt_text: "Warby Parker Frame",
      caption: ``,
      css_modifier: "",
      inViewport: false,
      offset: 0,
      onClick: () => {},
      image: ""
    };
  },

  propTypes: {
    alt_text: React.PropTypes.string,
    caption: React.PropTypes.string,
    css_modifier: React.PropTypes.string,
    inViewport: React.PropTypes.bool,
    offset: React.PropTypes.number,
    onClick: React.PropTypes.func,
    image: React.PropTypes.string
  },

  getStaticClasses() {
    return {
      block: `${this
        .BLOCK_CLASS} u-w4c u-dib u-pr12 u-pl12 u-pl24--900 u-pr24--900 u-pr`,
      captionWrapper: `${this.BLOCK_CLASS}__caption-wrapper u-w12c u-center-x`,
      frameWrapper: `${this.BLOCK_CLASS}__frame-wrapper`,
      caption: `
        ${this.BLOCK_CLASS}__caption  
        ${this.props.css_modifier}
        u-mt12 u-mt24--600 u-fs12 u-fs16--600
        u-fs24--900 u-tal u-color--black u-fwb`
    };
  },

  componentDidMount() {
    this.updateCaption();
  },

  componentWillUnmount() {
    window.clearInterval(this.interval);
  },

  setUpTimer() {
    this.interval = window.setInterval(() => {
      const caption = `"${this.props.caption}"`;
      const captionLength = caption.length;
      if (this.state.captionIndex === captionLength || !this.props.inViewport) {
        return false;
      }
      const nextLetter = caption[this.state.captionIndex];
      const prevState = _.clone(this.state);
      const prevCaption = prevState.caption;
      const prevCaptionIndex = prevState.captionIndex;
      this.setState({
        caption: prevCaption + nextLetter,
        captionIndex: prevCaptionIndex + 1
      });
    }, 100);
  },

  updateCaption() {
    window.setTimeout(this.setUpTimer, this.props.offset);
  },

  getFrameProps: function() {
    return {
      url: this.props.image,
      widths: this.getImageWidths(300, 1200, 4)
    };
  },

  render() {
    const classes = this.getStaticClasses();
    const frameSrcSet = this.getSrcSet(this.getFrameProps());
    const frameSizes = this.getImgSizes(this.FRAME_SIZES);

    return (
      <div className={classes.block} onClick={this.props.onClick}>
        <div className={classes.frameWrapper}>
          <Img
            srcSet={frameSrcSet}
            sizes={frameSizes}
            alt={this.props.alt_text}
            cssModifier={"u-w12c"}
          />
        </div>
        <div className={classes.captionWrapper}>
          <div className={classes.caption} children={`${this.state.caption}`} />
        </div>
      </div>
    );
  }
});
