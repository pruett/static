const _ = require('lodash');
const React = require('react/addons');
const Img = require('components/atoms/images/img/img');
const Picture = require('components/atoms/images/picture/picture');
const PlayIcon = require('components/quanta/icons/play/play');
const XIcon = require('components/quanta/icons/thin_x/thin_x');
const Takeover = require('components/molecules/modals/takeover/takeover');
const Mixins = require('components/mixins/mixins');

require('./hero.scss');

module.exports = React.createClass({
  displayName: 'MoleculesPrescriptionHowToHero',

  BLOCK_CLASS: 'c-prescription-how-to-hero',

  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.context,
    Mixins.dispatcher,
    Mixins.image
  ],

  propTypes: {
    cssModifier: React.PropTypes.string,
    cssModifierHeader: React.PropTypes.string,
    cssModifierDescription: React.PropTypes.string,
    isVideoAvailable: React.PropTypes.bool,
    analyticsSlug: React.PropTypes.string,
    hero: React.PropTypes.objectOf({
      header: React.PropTypes.string,
      description: React.PropTypes.string,
      image_desktop: React.PropTypes.string,
      image_tablet: React.PropTypes.string,
      image_mobile: React.PropTypes.string,
      video_text: React.PropTypes.string,
      video_url: React.PropTypes.string
    }),
    popout: React.PropTypes.objectOf({
      header: React.PropTypes.string,
      description: React.PropTypes.string
    })
  },

  getDefaultProps: function () {
    return {
      cssModifier: "",
      cssModifierHeader: "u-fs30 u-fs36--600 u-fs48--900 u-fs55--1200",
      cssModifierDescription: "u-fs16 u-fs18--900",
      isVideoAvailable: true,
      analyticsSlug: "PrescriptionHowToPage",
      hero: {
        header: "How to get a prescription",
        description: "We've got three ways to keep your vision and eyes in the tippest-toppest shape. Let's see what's right for you.",
        image_desktop: "https://i.warbycdn.com/v/c/assets/prescription-how-to/image/D_Hero-IMG_Hub_2x/0/87e13e5599.png",
        image_tablet: "https://i.warbycdn.com/v/c/assets/prescription-how-to/image/D_Hero-IMG_Hub_2x/0/87e13e5599.png",
        image_mobile: "https://i.warbycdn.com/v/c/assets/prescription-how-to/image/M_Hero-IMG_Hub_2x/0/8bc7cd5d07.png",
        video_text: "Watch a quick video",
        video_url: "https://player.vimeo.com/external/218052326.hd.mp4?s=cd52d95a90dbe741d6d1ce07b38f67e1ff600214&profile_id=119"
      },
      popout: {
        header: "Options? We got 'em",
        description: "Where to go, what to do, things like that"
      }
    };
  },

  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        ${this.props.cssModifier}
      `,
      hero: `
        ${this.BLOCK_CLASS}__hero
        u-pr
        u-oh
        u-color-bg--light-gray-alt-5
      `,
      heroImage: `
        u-dn u-db--600
      `,
      heroContent: `
        ${this.BLOCK_CLASS}__hero-content
        u-pa--600
        u-center-y--600
        u-t0 u-t25p--900
        u-w12c u-w6c--600
        u-ml96--900 u-ml180--1200
        u-pl18 u-pl0--900
        u-pr18 u-pr18
        u-pb24 u-pt48 u-pt24--600
        u-color--white--600
        u-tac u-tal--600
      `,
      heroHeader: `
        u-mt0 u-mb0
        u-ffs u-fws
        ${this.props.cssModifierHeader}
      `,
      heroDescription: `
        u-ffss u-fwn
        ${this.props.cssModifierDescription}
      `,
      heroButton: `
        u-reset--button
        u-button-reset
        u-dn u-db--600
        u-mla u-mra u-ml0--600 u-mr0--600
      `,
      heroButtonText: `
        u-dib u-vat
        u-mt9 u-ml24
        u-fs20 u-fws
      `,
      popout: `
        ${this.BLOCK_CLASS}__popout
        u-dn--600
        u-color-bg--white
        u-ml18 u-mr18 u-mb48
        u-tac
        u-br4
      `,
      popoutButton: `
        u-button-reset u-pr u-w100p
      `,
      popoutPlayIcon: `
        u-pa u-center -size-150
      `,
      popoutImage: `
        u-w100p
      `,
      popoutContent: `
        u-pb42 u-pt42 u-pl24 u-pr24
      `,
      popoutHeader: `
        u-fs12 u-fws
        u-mt0 u-mb12
        u-ttu u-ls1_5
      `,
      popoutDescription: `
        u-ffss u-fs24 u-fws
        u-mt0 u-mb24
      `,
      popoutCTA: `
        u-button-reset u-color--blue u-fws u-fs16
      `,
      popoutVideo: `
        u-w100p u-mb18
      `,
      takeover: `
        ${this.BLOCK_CLASS}__takeover
      `,
      takeoverButton: `
        u-button-reset
        u-pa u-t0 u-r0
        u-mt60 u-mr60 u-mr90--900 u-mr120--1200
      `,
      takeoverIcon: `
        u-stroke--light-gray -size-150
      `,
      takeoverVideoWrapper: `
        u-pa u-center u-w9c u-mw1440
      `,
      takeoverVideo: `
        u-w100p
      `
    };
  },

  getInitialState: function() {
    return {
      showDesktopVideo: false,
      showMobileVideo: false
    };
  },

  classesWillUpdate: function() {
    return {
      popoutVideo: {
        'u-db': this.state.showMobileVideo,
        'u-dn': !this.state.showMobileVideo
      },
      popoutButton: {
        'u-db': !this.state.showMobileVideo,
        'u-dn': this.state.showMobileVideo
      }
    };
  },

  trackClick: function (text) {
    text = _.camelCase(text);
    this.trackInteraction(`${this.props.analyticsSlug}-click-${text}`);
  },

  showDesktopVideo: function () {
    this.setState({showDesktopVideo: true});

    this.trackClick('showDesktopVideo');
  },

  hideDesktopVideo: function() {
    this.commandDispatcher('layout', 'hideTakeover');

    this.setState({showDesktopVideo: false});

    this.trackClick('hideDesktopVideo');
  },

  showMobileVideo: function () {
    this.setState({showMobileVideo: true});

    const video = React.findDOMNode(this.refs['mobileVideo']);
    video.addEventListener('ended', this.hideMobileVideo);

    if (video.webkitSupportsFullscreen) {
      video.webkitEnterFullScreen();
    } else if (document.fullscreenEnabled) {
      video.requestFullScreen();
    }

    video.play();

    this.trackClick('showMobileVideo');
  },

  hideMobileVideo: function () {
    const video = React.findDOMNode(this.refs['mobileVideo']);
    video.removeEventListener('ended', this.hideMobileVideo);

    if (video.webkitSupportsFullscreen) {
      video.webkitExitFullScreen();
    } else if (document.fullscreenEnabled) {
      video.exitFullscreen();
    }

    this.setState({showMobileVideo: false});

    this.trackClick('hideMobileVideo');
  },

  getImageProps: function (image) {
    return {
      url: image,
      widths: this.getImageWidths(300, 600, 4)
    };
  },

  render: function () {
    const classes = this.getClasses();
    const imgSources = [
      {
        url: this.props.hero.image_desktop,
        widths: [ 1200, 1440, 2400, 2880 ],
        mediaQuery: '(min-width: 1200px)'
      },
      {
        url: this.props.hero.image_tablet,
        widths: [ 600, 768, 900, 1200, 1536, 1800 ],
        mediaQuery: '(min-width: 600px)'
      },
      {
        url: this.props.hero.image_mobile,
        widths: [ 320, 360, 420, 460, 520, 560 ],
        mediaQuery: '(min-width: 320px)'
      }
    ];

    return (
      <div className={classes.block}>
        <Takeover
          cssModifier={classes.takeover}
          active={this.state.showDesktopVideo}
          hasHeader={false}>
          <button
            className={classes.takeoverButton}
            onClick={this.hideDesktopVideo}>
            <XIcon cssModifier={classes.takeoverIcon} />
          </button>
          <div className={classes.takeoverVideoWrapper}>
            <video
              autoPlay controls
              className={classes.takeoverVideo}
              src={this.props.hero.video_url} />
          </div>
        </Takeover>

        <div className={classes.hero}>
          <Picture
            cssModifier={classes.heroImage}
            children={this.getPictureChildren({sources: imgSources})} />

          <div className={classes.heroContent}>
            <h1 className={classes.heroHeader} children={this.props.hero.header} />
            <p className={classes.heroDescription} children={this.props.hero.description} />
            {this.props.isVideoAvailable &&
              <button className={classes.heroButton} onClick={this.showDesktopVideo}>
                <PlayIcon />
                <span className={classes.heroButtonText} children={this.props.hero.video_text} />
              </button>}
          </div>

          <video
            ref={'mobileVideo'}
            controls
            className={classes.popoutVideo}
            src={this.props.hero.video_url} />

          <div className={classes.popout}>
            <button className={classes.popoutButton} onClick={this.showMobileVideo}>
              <Img
                cssModifier={classes.popoutImage}
                sizes={'calc(100vw - 36px)'}
                srcSet={this.getSrcSet({
                  url: this.props.hero.image_mobile,
                  widths: [284, 378, 568, 756, 1128],
                  quality: 80
                })} />
              {this.props.isVideoAvailable &&
                <PlayIcon cssModifier={classes.popoutPlayIcon} />}
            </button>
            <div className={classes.popoutContent}>
              <h3 className={classes.popoutHeader} children={this.props.popout.header} />
              <p className={classes.popoutDescription} children={this.props.popout.description} />
              {this.props.isVideoAvailable &&
                <button
                  className={classes.popoutCTA}
                  children={this.props.hero.video_text}
                  onClick={this.showMobileVideo} />}
            </div>
          </div>
        </div>
      </div>
    );
  }

});
