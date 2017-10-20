const React = require('react/addons');
const _ = require('lodash');

const Mixins = require('components/mixins/mixins');

require('./video.scss');


module.exports = React.createClass({
  displayName: 'CollectionUtilityVideo',

  BLOCK_CLASS: 'c-collection-utility-video',

  MIN_WIDTH_DESKTOP: 900,

  MIN_WIDTH_TABLET: 600,

  mixins: [
    Mixins.classes,
    Mixins.analytics
  ],

  propTypes: {
    autoPlay: React.PropTypes.bool,
    css_modifier_block: React.PropTypes.string,
    gaLabel: React.PropTypes.string,
    posters: React.PropTypes.object,
    sources: React.PropTypes.object,
    play_button: React.PropTypes.string,
    renderPlayButton: React.PropTypes.bool
  },

  getDefaultProps() {
    return {
      autoPlay: false,
      css_modifier: '',
      css_modifier_block: '-middle',
      cover: `${this.BLOCK_CLASS}__cover`,
      gaLabel: '',
      sources: {
        desktop: 'https://player.vimeo.com/external/219742141.hd.mp4?s=43302d864dcff840c76a70ae401752f1f74b3a22&profile_id=174',
        tablet: 'https://player.vimeo.com/external/219742141.hd.mp4?s=43302d864dcff840c76a70ae401752f1f74b3a22&profile_id=174',
        mobile: 'https://player.vimeo.com/external/219732737.sd.mp4?s=80ae02ffb8836b20cf5d7512484bb1e39e355d96&profile_id=164'
      },
      posters: {
        mobile: 'https://i.warbycdn.com/v/c/assets/spring-2017/image/cover-flat-brow-mobile/0/10f1b1ba2b.jpg',
        tablet: 'https://i.warbycdn.com/v/c/assets/spring-2017/image/cover-fans-hero-desktop/0/b08d3b98db.jpg',
        desktop: 'https://i.warbycdn.com/v/c/assets/spring-2017/image/cover-fans-hero-desktop/0/b08d3b98db.jpg'
      },
      play_button: 'https://i.warbycdn.com/v/c/assets/spring-2017/image/play-button/0/6d5033a043.png',
      renderPlayButton: false
    };
  },

  inLineVideo() {
    const videoNode = this.refs.video;
    if(videoNode) {
      videoNode.setAttribute('playsinline', true);
    }
  },

  checkViewPort() {
    this.inLineVideo()

    const windowWidth = window.innerWidth || _.get(document, 'documentElement.clientWidth');
    if (windowWidth <= this.MIN_WIDTH_TABLET) {
      this.setState({viewport: 'mobile'})
    } else if (windowWidth > this.MIN_WIDTH_TABLET && windowWidth <= this.MIN_WIDTH_DESKTOP) {
      this.setState({viewport: 'tablet'})
    } else if (windowWidth > this.MIN_WIDTH_DESKTOP) {
      this.setState({viewport: 'desktop'})
    }

    this.setState({viewPortChecked: true})
  },

  componentDidMount() {
    this.checkViewPort();
    this.throttledCheckViewPort = _.throttle(this.checkViewPort, 100);
    window.addEventListener('resize', this.throttledCheckViewPort);
  },

  getInitialState() {
    return {
      viewport: 'mobile',
      viewPortChecked: false
    }
  },

  getStaticClasses() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        ${this.props.css_modifier}
      `,
      cover: `${this.BLOCK_CLASS}__cover`,
      playButton: `u-pa u-center u-w4c u-w2c--600`,
      video: `u-w100p`,
      wrapper: `${this.BLOCK_CLASS}__wrapper ${this.props.css_modifier_block}`
    }
  },

  classesWillUpdate() {
    return {
      playButton: {
        'u-dn': this.state.mobileVideoPlaying
      }
    };
  },

  componentDidUpdate(prevProps) {
    if(!prevProps.autoPlay && this.props.autoPlay) {
      this.play();
    }

    if(prevProps.autoPlay && !this.props.autoPlay) {
      this.pause();
    }
  },

  getSource() {
    return this.props.sources[this.state.viewport];
  },

  getPosterImage() {
    return this.props.posters[this.state.viewport];
  },

  handlePlayClick() {
    this.trackInteraction(`LandingPage-ClickPlay-${this.props.gaLabel}`);
    this.play()
  },

  play() {
    const videoNode = this.refs.video;
    this.setState({mobileVideoPlaying: true})
    videoNode.play();
  },

  pause() {
    const videoNode = this.refs.video;
    this.setState({mobileVideoPlaying: false})
    videoNode.pause();
  },

  renderPlayButton(classes) {
    return (
      <img
        onClick={this.handlePlayClick}
        alt={'play'}
        className={classes.playButton}
        src={this.props.play_button} />
    );
  },

  render() {
    const classes = this.getClasses();
    if (typeof window === 'undefined' || window === null) {return false;}
    return (
      <div className={classes.block}>
        <div className={classes.wrapper}>
          <div className={'u-pr'}>
            <video
              autoPlay={this.props.autoPlay}
              muted={true}
              loop={true}
              poster={this.getPosterImage()}
              className={classes.video}
              src={this.getSource()}
              ref={'video'} >
            </video>
            {this.props.renderPlayButton && this.renderPlayButton(classes)}
          </div>
        </div>
      </div>
    );
  }

});
