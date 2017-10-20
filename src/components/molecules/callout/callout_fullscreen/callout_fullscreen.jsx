const _ = require('lodash');
const React = require('react/addons');
const Mixins = require('components/mixins/mixins');

const Picture = require('components/atoms/images/picture/picture');

require('./callout_fullscreen.scss');

module.exports = React.createClass({
  BLOCK_CLASS: 'c-callout-fullscreen',

  mixins: [
    Mixins.classes,
    Mixins.image,
  ],

  getDefaultProps: function() {
    return {
      altText: '',
      background: '',
      images: [],
      smartBannerActive: false,
    };
  },

  getInitialState: function() {
    return {
      innerHeight: 0
    };
  },

  getStaticClasses: function() {
    return {
      block: `
        u-pr
      `,
      imageContainer: `
        ${this.BLOCK_CLASS}__image-container
        u-w100p u-oh u-pr
      `,
      image: `
        ${this.BLOCK_CLASS}__image
        u-pa u-w100p
        u-t0 u-l0 u-center-y--900
      `
    };
  },

  classesWillUpdate: function() {
    return {
      image: {
        '-banner': this.props.smartBannerActive
      },
      imageContainer: {
        '-banner': this.props.smartBannerActive
      },
    };
  },

  componentDidMount: function() {
    this.setViewportHeight();
    this.throttledSetViewportHeight = _.throttle(this.setViewportHeight, 100);
    // Update the callout height on window resize, except on mobile devices...
    // (we want to avoid content jumping around on browser scroll)
    if(window.matchMedia('(min-device-width: 600px)').matches) {
      window.addEventListener('resize', this.throttledSetViewportHeight);
    }
  },

  componentWillUnmount: function() {
    window.removeEventListener('resize', this.throttledSetViewportHeight);
  },

  setViewportHeight: function() {
    this.setState({ innerHeight: window.innerHeight });
  },

  getPictureSources: function() {
    return ['desktop', 'tablet', 'mobile'].map((name) => {
      const img = _.find(this.props.images, {size: name});
      if(!img) return {};

      const source = {
        url: img.url,
        quality: 80,
        sizes: '100vw',
      };

      if(name === 'mobile') {
        source.mediaQuery = '(min-width: 0)';
        source.widths = [375, 414, 640, 750, 828, 1000, 1200];
      }
      else if(name === 'tablet') {
        source.mediaQuery = '(min-width: 600px)';
        source.widths = [640, 768, 900, 1280, 1536, 1800];
      }
      else if(name === 'desktop') {
        source.mediaQuery = '(min-width: 900px)';
        source.sizes = '(min-width: 1920px) 1920px, 100vw';
        source.widths = [1024, 1280, 1366, 1440, 1600, 1920];
      }

      return source;
    });
  },

  getImageStyle: function() {
    // Make the image fill the window height (accounting for window chrome).
    // Offset the image height by 84px if the smart banner is active.
    const style = {};
    if(this.state.innerHeight) {
      style.height = this.state.innerHeight - (this.props.smartBannerActive ? 84 : 0);
    }
    if(this.props.background) {
      style.background = this.props.background;
    }

    return style;
  },

  render: function() {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <div className={classes.imageContainer} style={this.getImageStyle()}>
          <Picture children={
            this.getPictureChildren({
              sources: this.getPictureSources(),
              img: {
                className: classes.image,
                alt: this.props.altText,
              }
            })} />
        </div>

        {this.props.children}

      </div>
    );
  }

});
