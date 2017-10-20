const React = require('react/addons');
const _ = require('lodash');

const Mixins = require('components/mixins/mixins');

require('./video.scss');


module.exports = React.createClass({
  displayName: 'CollectionSunscapadesVideo',

  BLOCK_CLASS: 'c-sunscapades-video',

  MIN_WIDTH_DESKTOP: 900,

  mixins: [
    Mixins.classes
  ],

  propTypes: {
    src: React.PropTypes.string,
    cssModifier: React.PropTypes.string
  },

  checkViewPort: function () {
    const windowWidth = window.innerWidth || _.get(document, 'documentElement.clientWidth');
    if (windowWidth > this.MIN_WIDTH_DESKTOP) {
      this.setState({desktop: true});
    } else {
      this.setState({desktop: false});
    }
  },

  componentDidMount: function () {
    this.checkViewPort();
    this.throttledCheckViewPort = _.throttle(this.checkViewPort, 100);
    window.addEventListener('resize', this.throttledCheckViewPort);
  },

  getInitialState: function () {
    return {
      desktop: false
    }
  },

  getDefaultProps: function () {
    return {
      src: '',
      callouts: []
    };
  },

  getStaticClasses: function () {
    return {
      block: this.BLOCK_CLASS,
      video: `
        ${this.BLOCK_CLASS}__video
        ${this.props.cssModifier}
        u-pa
      `
    }
  },


  render: function () {
    const classes = this.getClasses();

    if (this.state.desktop) {
      return (
        <div className={classes.block}>
          <video
            autoPlay={'autoplay'}
            muted={true}
            loop={'loop'}
            className={classes.video}
            ref={'desktopVideo'} >
            <source src={this.props.src} type={'video/mp4'} />
          </video>
        </div>
      );
    } else {
      return false;
    }
  }

});
