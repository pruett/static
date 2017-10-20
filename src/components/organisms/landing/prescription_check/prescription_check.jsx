const _ = require('lodash');
const React = require('react/addons');

const PhoneNumberForm = require(
  'components/organisms/forms/phone_number_form/phone_number_form'
);
const PrescriptionCheckQuiz = require(
  'components/molecules/landing/prescription_check_quiz/prescription_check_quiz'
);
const Takeover = require("components/molecules/modals/takeover/takeover");
const Img = require('components/atoms/images/img/img');
const Picture = require('components/atoms/images/picture/picture');
const DownloadIcon = require(
  'components/atoms/icons/apple/app_store_download/app_store_download'
);
const PlayIcon = require('components/quanta/icons/play/play');
const XIcon = require("components/quanta/icons/thin_x/thin_x");

const Mixins = require('components/mixins/mixins');

require('./prescription_check.scss');

module.exports = React.createClass({
  BLOCK_CLASS: 'c-prescription-check',

  ANALYTICS_CATEGORY: 'prescriptionCheckAppLanding',

  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.context,
    Mixins.dispatcher,
    Mixins.image
  ],

  getDefaultProps: function() {
    return {
      hero: {},
      callouts: [],
      popout: {},
      notices: [],
      quiz: {},
      quizState: {},
      inRetailRadius: false
    };
  },

  getInitialState: function() {
    return {
      footerIsSticky: false,
      showVideo: false,
      showVideoMobile: false
    };
  },

  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-mw1440
        u-mla u-mra
        u-oh
        u-color-bg--light-gray-alt-5
      `,
      hero: `
        u-pr u-oh
      `,
      heroImage: `
        u-dn u-db--600
      `,
      header: `
        ${this.BLOCK_CLASS}__header
        u-pa--600
        u-center--600 u-center-none--1200
        u-w100p
        u-pl18 u-pr18
        u-pb24 u-pb120--600 u-pb0--1200
        u-tac
      `,
      appIcon: `
        ${this.BLOCK_CLASS}__app-icon
        u-mt36 u-m0--600
      `,
      headerText: `
        u-mt12 u-mt24--600 u-mb0
        u-ffs u-fs30 u-fs24--600 u-fs30--900 u-fs34--1200
      `,
      headerDescription: `
        ${this.BLOCK_CLASS}__header-description
        u-w7c--600
        u-mla u-mra
        u-mt12 u-mt24--600
        u-mb24 u-mb36--900
        u-ffss u-fs16 u-fs18--900
        u-color--dark-gray-alt-3
      `,
      downloadIcon: `
        ${this.BLOCK_CLASS}__download-icon
        u-dib
      `,
      watchButtonDesktop: `
        u-button-reset
        u-pa u-center-x
        u-b0 u-mb60
        u-dn u-db--600
      `,
      watchButtonText: `
        u-dib u-vat
        u-mt9 u-ml24
        u-fs20 u-fws u-color--blue
      `,
      popout: `
        ${this.BLOCK_CLASS}__popout
        u-dn--600
        u-color-bg--white
        u-ml18 u-mr18 u-mt24
        u-tac
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
        u-pb48 u-pt48 u-pl24 u-pr24
      `,
      popoutHeader: `
        u-fs12 u-fws u-ls1_5
        u-mt0 u-mb12
        u-ttu
      `,
      popoutDescription: `
        u-ffss u-fs24 u-fws
        u-mt0 u-mb24
      `,
      popoutCta: `
        u-button-reset u-color--blue u-fws
      `,
      callouts: `
        ${this.BLOCK_CLASS}__content
        u-pr
        u-mla u-mra
        u-pt12 u-pb12
        u-pl24 u-pr24
        u-tac u-tal--900
      `,
      callout: `
        ${this.BLOCK_CLASS}__callout
        u-pt36 u-pb36
        u-bss u-bw0 u-bbw1 u-bbw0--900 u-bc--white
      `,
      calloutContent: `
        ${this.BLOCK_CLASS}__callout-content
        u-pr u-clearfix u-m0a
      `,
      calloutText: `
        u-pa--900 u-center-y--900
        u-w6c--900
        u-pl24--900
      `,
      calloutEyebrow: `
        u-fs12 u-fs16--900
        u-ls2_5 u-fws u-ttu
        u-mb12 u-mb18--900
      `,
      calloutHeader: `
        u-ffs
        u-fs30 u-fs45--900
        u-mt0 u-mb24
      `,
      calloutDescription: `
        u-pr24--1200
        u-fs16 u-fs18--900 u-ffss
        u-m0
        u-color--dark-gray-alt-3
      `,
      calloutImage: `
        u-dn u-db--900
        u-w6c
        u-pl48 u-pr48
        u-tac
      `,
      calloutImageFull: `
        u-dn u-db--900
        u-w6c u-fr u-mrn24
      `,
      calloutImageMobile: `
        u-dn--900
        u-mt12 u-mb12
      `,
      notices: `
        u-df--600
        u-pt30--600 u-pb30--600
        u-color-bg--white
      `,
      notice: `
        ${this.BLOCK_CLASS}__notice
        u-w6c--600
        u-m0a
        u-vat
        u-pt48 u-pt60--600 u-pb48 u-pb60--600
        u-pl18 u-pl36--600 u-pl96--900
        u-pr18 u-pr36--600 u-pr96--900
        u-tac
        u-bss u-bw0
        u-bbw1 u-bbw0--600 u-brw1--600
        u-bc--light-gray-alt-1
      `,
      noticeEyebrow: `
        u-fs12 u-ls2_5
        u-fws u-ttu
        u-mb18
      `,
      noticeDescription: `
        u-fs14 u-ffss
        u-color--dark-gray-alt-3
      `,
      noticeLink: `
        u-dib u-wsnw
        u-fs14 u-fws
        u-ml8 u-mr8 u-mt8
      `,
      footerContainer: `
        ${this.BLOCK_CLASS}__sticky-footer
        u-pf u-b0 u-l0 u-r0
        u-mw1440 u-m0a
      `,
      footerMobile: `
        u-db
        u-p18
        u-color--white u-color-bg--blue
        u-ffss u-fs16 u-fws u-tac
      `,
      footerDesktop: `
        u-color-bg--white
        u-tac
        u-bss u-bw0 u-btw1 u-bc--light-gray-alt-1
      `,
      takeover: `
        ${this.BLOCK_CLASS}__takeover
      `,
      takeoverCloseButton: `
        u-button-reset
        u-pa u-t0 u-r0
        u-mt60 u-mr60 u-mr90--900 u-mr120--1200
      `,
      takeoverIconX: `
        u-stroke--light-gray -size-150
      `,
      takeoverVideoContainer: `
        u-pa u-center u-w9c u-mw1440
      `,
      video: `
        u-w100p
      `,
      mobileVideo: `
        u-w100p
      `
    };
  },

  classesWillUpdate: function() {
    return {
      mobileVideo: {
        'u-db': this.state.showVideoMobile,
        'u-dn': !this.state.showVideoMobile
      },
      popoutButton: {
        'u-db': !this.state.showVideoMobile,
        'u-dn': this.state.showVideoMobile
      }
    };
  },

  componentDidMount: function() {
    this.checkStickyFooter();
    this.checkStickyFooterThrottled = _.throttle(this.checkStickyFooter, 100);
    window.addEventListener('scroll', this.checkStickyFooterThrottled);
  },

  componentWillUnmount: function() {
    window.removeEventListener('scroll', this.checkStickyFooterThrottled);
  },

  checkStickyFooter: function() {
    const appInfo = React.findDOMNode(this.refs.appInfo);
    if(appInfo) {
      const rect = appInfo.getBoundingClientRect();
      this.setState({footerIsSticky: rect && rect.bottom <= 0});
    }
  },

  handleSubmitPhone: function(target, telephone) {
    if(telephone) {
      this.trackInteraction(`${this.ANALYTICS_CATEGORY}-click-submitPhone${target}-success`);
      this.commandDispatcher('appLanding', 'sendSms', telephone, 'prescription_check');
    }
    else {
      this.trackInteraction(`${this.ANALYTICS_CATEGORY}-click-submitPhone${target}-error`);
    }
  },

  handleClickDownload: function(target) {
    this.trackInteraction(`${this.ANALYTICS_CATEGORY}-click-download${target}`);
  },

  handleClickPlayVideo: function(evt) {
    this.setState({showVideo: true});
    this.trackInteraction(`${this.ANALYTICS_CATEGORY}-click-playVideoDesktop`);
  },

  handleClickPlayVideoFullscreen: function(evt) {
    this.setState({showVideoMobile: true});
    const vid = React.findDOMNode(this.refs['mobileVideo']);
    vid.addEventListener('ended', this.onMobileVideoEnded);
    if(vid.webkitSupportsFullscreen) vid.webkitEnterFullScreen();
    vid.play();
    this.trackInteraction(`${this.ANALYTICS_CATEGORY}-click-playVideoMobile`);
  },

  onMobileVideoEnded: function(evt) {
    const vid = React.findDOMNode(this.refs['mobileVideo']);
    vid.removeEventListener('ended', this.onMobileVideoEnded);
    if(vid.webkitSupportsFullscreen) vid.webkitExitFullScreen();
    this.setState({showVideoMobile: false});
  },

  handleCloseVideoTakeover: function(evt) {
    this.commandDispatcher('layout', 'hideTakeover');
    this.setState({showVideo: false});
    this.trackInteraction(`${this.ANALYTICS_CATEGORY}-click-closeVideoTakeover`);
  },

  renderVideoTakeover: function(classes, hero) {
    return (
      <Takeover
        cssModifier={classes.takeover}
        active={this.state.showVideo}
        hasHeader={false}>
        <button
          className={classes.takeoverCloseButton}
          onClick={this.handleCloseVideoTakeover}>
          <XIcon cssModifier={classes.takeoverIconX} />
        </button>
        <div className={classes.takeoverVideoContainer}>
          <video
            autoPlay controls
            className={classes.video}
            src={hero.video_url} />
        </div>
      </Takeover>
    );
  },

  renderHero: function(classes, hero) {
    const imgSources = [
      {
        url: hero.image_desktop,
        widths: [ 1200, 1440, 2400, 2880 ],
        mediaQuery: '(min-width: 1200px)'
      },
      {
        url: hero.image_tablet,
        widths: [ 600, 768, 900, 1200, 1536, 1800 ],
        mediaQuery: '(min-width: 600px)'
      }
    ];

    return (
      <div className={classes.hero}>
        <Picture
          cssModifier={classes.heroImage}
          children={this.getPictureChildren({sources: imgSources})} />

        <div className={classes.header}>
          <Img cssModifier={classes.appIcon} src={hero.icon_image} />
          <h1 className={classes.headerText} children={hero.header} />
          <p className={classes.headerDescription} children={hero.description} />
          <div ref={'appInfo'}>
            { this.props.isNativeAppCapable ?
              <a href={hero.download_url}
                onClick={this.handleClickDownload.bind(this, 'Hero')}>
                <DownloadIcon cssModifier={classes.downloadIcon}/>
              </a>
            :
              <div>
                <PhoneNumberForm
                  label={hero.sms_text}
                  manageSubmit={this.handleSubmitPhone.bind(this, 'Hero')} />
              </div>
            }
          </div>
        </div>

        <button className={classes.watchButtonDesktop} onClick={this.handleClickPlayVideo}>
          <PlayIcon />
          <span className={classes.watchButtonText} children={hero.watch_text} />
        </button>
      </div>
    );
  },

  renderPopout: function(classes, popout) {
    return (
      <div>
        <video
          ref={'mobileVideo'}
          controls
          className={classes.mobileVideo}
          src={popout.video_url} />
        <div className={classes.popout}>
          <button className={classes.popoutButton} onClick={this.handleClickPlayVideoFullscreen}>
            <Img
              cssModifier={classes.popoutImage}
              sizes={'calc(100vw - 36px)'}
              srcSet={this.getSrcSet({
                url: popout.background_image,
                widths: [284, 378, 568, 756, 1128],
                quality: 80
              })} />
            <PlayIcon cssModifier={classes.popoutPlayIcon} />
          </button>
          <div className={classes.popoutContent}>
            <h3 className={classes.popoutHeader} children={popout.header} />
            <p className={classes.popoutDescription} children={popout.description} />
            <button
              className={classes.popoutCta}
              children={popout.cta_text}
              onClick={this.handleClickPlayVideoFullscreen} />
          </div>
        </div>
      </div>
    );
  },

  renderCallout: function(classes, callout, i) {
    return(
      <div className={classes.callout} key={i}>
        {i%2 > 0 ?
          <Img
            cssModifier={classes.calloutImageFull}
            sizes={'calc(50vw - 24px)'}
            srcSet={this.getSrcSet({
              url: callout.image_desktop,
              widths: [450, 600, 720, 900, 1200, 1440],
              quality: 80
            })} />
          : null}
        <div className={classes.calloutContent}>
          {i%2 === 0 ?
            <div className={classes.calloutImage}>
              <Img
                sizes={'400px'}
                srcSet={this.getSrcSet({
                  url: callout.image_desktop,
                  widths: [400, 800],
                  quality: 80
                })} />
            </div>
            : null}
          <div className={`${classes.calloutText} ${i%2 === 0 ? 'u-r0' : 'u-l0'}`}>
            <div className={classes.calloutEyebrow} children={callout.eyebrow} />
            <h3 className={classes.calloutHeader} children={callout.header} />
            <Img
              cssModifier={classes.calloutImageMobile}
              sizes={'280px'}
              srcSet={this.getSrcSet({
                url: callout.image_mobile,
                widths: [280, 560],
                quality: 80
              })} />
            <p className={classes.calloutDescription} children={callout.description} />
          </div>
        </div>
      </div>
    );
  },

  renderNotice: function(classes, notice, i) {
    return(
      <div className={classes.notice} key={i}>
        <div className={classes.noticeEyebrow} children={notice.eyebrow} />
        <p className={classes.noticeDescription} children={notice.description} />
        {notice.links.map((link, i) => {
          return (
            <a key={i}
               href={link.link_url}
               className={classes.noticeLink}
               children={link.link_text} />
          );
        })}
      </div>
    );
  },

  renderFooter: function(classes, hero) {
    return (
      <div className={classes.footerContainer}>
        { this.props.isNativeAppCapable ?
          <a
            className={classes.footerMobile}
            href={hero.download_url}
            onClick={this.handleClickDownload.bind(this, 'Footer')}
            children={hero.download_text} />
        :
          <div className={classes.footerDesktop}>
            <PhoneNumberForm
              inline={true}
              label={hero.sms_text}
              manageSubmit={this.handleSubmitPhone.bind(this, 'Footer')}/>
          </div>
        }
      </div>
    );
  },

  render: function() {
    const classes = this.getClasses();
    const {hero, popout, callouts, notices} = this.props;

    return (
      <div className={classes.block}>
        {this.renderVideoTakeover(classes, hero)}

        {this.renderHero(classes, hero)}

        {this.renderPopout(classes, popout)}

        <div
          className={classes.callouts}
          children={callouts.map(this.renderCallout.bind(this, classes))} />

        <PrescriptionCheckQuiz {...this.props.quiz}
          downloadUrl={hero.download_url}
          currentState={this.props.quizState}
          inRetailRadius={this.props.inRetailRadius}
          regions={this.props.regions}
        />

        <div
          className={classes.notices}
          children={notices.map(this.renderNotice.bind(this, classes))} />

        {this.state.footerIsSticky &&
          this.renderFooter(classes, hero)}
      </div>
    );
  }
});
