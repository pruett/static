const React = require('react/addons');

require('./video_loop.scss')

class VideoLoop extends React.Component {

  componentDidMount() {
    const videoNode = this.refs.video;
    videoNode.setAttribute('playsinline', '');
  }

  handleClick(evt) {
    const video = evt.target;
    video.paused ? video.play() : video.pause();
  }

  render() {
    const inBrowser = !(typeof window === 'undefined' || window === null);

    return (
      <video
        ref={'video'}
        autoPlay={inBrowser}
        muted loop
        className={`c-video-loop ${this.props.cssModifier}`}
        poster={this.props.poster}
        src={this.props.src}
        onClick={this.handleClick} />
    );
  }
}

VideoLoop.defaultProps = {
  cssModifier: '',
  poster: '',
  src: '',
};

module.exports = VideoLoop;
