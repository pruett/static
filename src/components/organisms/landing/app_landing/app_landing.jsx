const _ = require('lodash');
const React = require('react/addons');
const PhoneNumberForm = require(
  'components/organisms/forms/phone_number_form/phone_number_form'
);
const Img = require('components/atoms/images/img/img');
const DownloadIcon = require(
  'components/atoms/icons/apple/app_store_download/app_store_download'
);
const Mixins = require('components/mixins/mixins');

require('./app_landing.scss');

module.exports = React.createClass({
  BLOCK_CLASS: 'c-app-landing',

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
      content: {
        callouts: [],
        background_images: [],
        background_image: ''
      },
      heroImgSizes: [
        { breakpoint: 0, width: '90vw' },
        { breakpoint: 600, width: '50vw' },
        { breakpoint: 1280, width: '640px' }
      ]
    };
  },

  getInitialState: function() {
    return {
      footerIsSticky: false
    };
  },

  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-mw1440
        u-mla u-mra
        u-oh
      `,
      heroContainer: `
        u-pr
      `,
      hero: `
        u-pr
        u-clearfix
        u-color-bg--blue
        u-oh
      `,
      heroImage: `
        ${this.BLOCK_CLASS}__hero-image
        u-db
        u-fr u-fn--600 u-fr--900
        u-mt24 u-mt48--900 u-mla
        u-mrn12 u-mra--600 u-mrn48--900
      `,
      header: `
        ${this.BLOCK_CLASS}__header
        u-pa
        u-l0 u-b0 u-ba--900 u-t0--900
        u-w100p u-w6c--900 u-wauto--1200
        u-mb24
        u-pl18 u-pr18
        u-tac u-tal--900
        u-color--white
      `,
      headerText: `
        u-m0
        u-ffs
        u-fs36 u-fs50--600 u-fs70--1200
      `,
      headerDescription: `
        u-mt12 u-mt24--900
        u-mb18 u-mb48--900
        u-fs16 u-fs18--600 u-fs20--1200
      `,
      smsContainer: `
        u-dn u-db--900
      `,
      downloadLink: `
        u-dn--900
      `,
      downloadIcon: `
        ${this.BLOCK_CLASS}__download-icon
        u-dib
      `,
      subHeader: `
        u-w10c--900
        u-pa--900
        u-b0 u-center-x--900
        u-pl18 u-pr18
        u-mt48 u-mb12 u-mb0--900 u-mb24--1200
        u-color--white--900
        u-tac
      `,
      subheadText: `
        ${this.BLOCK_CLASS}__subhead
        u-df--900
        u-ffs u-fws
        u-fs30 u-fs40--900 u-fs48--1200
      `,
      subheadDescription: `
        ${this.BLOCK_CLASS}__subhead-description
        u-mb0 u-mt18 u-mt24--900 u-mt30--1200
        u-mla u-mra
        u-ffss
        u-fs16 u-fs20--900 u-fs24--1200
      `,
      subheadBadgeDesktop: `
        ${this.BLOCK_CLASS}__badge
        u-dn u-dib--900
      `,
      subheadBadgeMobile: `
        ${this.BLOCK_CLASS}__badge
        u-dn--900
      `,
      content: `
        ${this.BLOCK_CLASS}__content
        u-pr
        u-mla u-mra
        u-pt12 u-pt48--600 u-pt120--900
        u-pb12 u-pb48--600 u-pb120--900
        u-tac u-tal--600
      `,
      contentBackgroundMobile: `
        ${this.BLOCK_CLASS}__content-background-mobile
        u-pa u-mwnone
        u-dn--600
        u-t0 u-center-x
      `,
      contentBackgroundDesktop: `
        ${this.BLOCK_CLASS}__content-background-desktop
        u-pa u-mwnone
        u-dn u-db--900
        u-t0 u-center-x
        u-mt48 u-mb48
      `,
      contentBlock: `
        u-pr u-clearfix
        u-pt36 u-pb36 u-p0--600
        u-ml18 u-mr18 u-mb48--600
      `,
      contentScreenshot: `
        ${this.BLOCK_CLASS}__content-screenshot
        u-dn u-dib--600
        u-mw50p
        u-pl24 u-pl48--900
        u-pr24 u-pr48--900
      `,
      contentText: `
        u-pa--600 u-center-y--600
        u-w6c--600
        u-pl24--600 u-pr24--600
        u-color--white u-color--dark-gray--600
      `,
      contentHeader: `
        u-dn--600
        u-fs12 u-ls2_5 u-fws u-ttu
        u-mb18
      `,
      contentQuote: `
        u-ffs
        u-fs30 u-fs45--900
        u-mt0 u-mb24
      `,
      contentDescription: `
        u-dn u-dib--600
        u-pr24--1200
        u-fs16 u-fs18--900 u-ffss
        u-mt24 u-mt48--900 u-mb0
        u-color--dark-gray-alt-3
      `,
      contentRating: `
        ${this.BLOCK_CLASS}__content-rating
        u-dib
        u-mr18 u-mt2--600
      `,
      contentAuthor: `
        u-vat
        u-fws u-wsnw
        u-fs16 u-fs18--600
      `,
      footerContainer: `
        ${this.BLOCK_CLASS}__sticky-footer
        u-pf u-b0 u-l0 u-r0
        u-mw1440 u-m0a
      `,
      footerMobile: `
        u-db u-dn--900
        u-p18
        u-color--white u-color-bg--blue
        u-ffss u-fs16 u-fws u-tac
      `,
      footerDesktop: `
        u-dn u-db--900
        u-color-bg--white
        u-tac
        u-bss u-bw0 u-btw1 u-bc--light-gray-alt-1
      `
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
      this.setState({footerIsSticky: rect ? rect.bottom <= 0 : false});
    }
  },

  handleSubmitPhone: function(target, telephone) {
    if(telephone) {
      this.trackInteraction(`appLanding-click-submitPhone${target}-success`);
      this.commandDispatcher('appLanding', 'sendSms', telephone);
    }
    else {
      this.trackInteraction(`appLanding-click-submitPhone${target}-error`);
    }
  },

  handleClickDownload: function(target) {
    this.trackInteraction(`appLanding-click-download${target}`);
  },

  renderHero: function(classes, hero) {
    return (
      <div className={classes.heroContainer}>
        <div className={classes.hero}>
          <Img
            cssModifier={classes.heroImage}
            sizes={this.getImgSizes(this.props.heroImgSizes)}
            srcSet={this.getSrcSet({
              url: hero.background_image,
              widths: [300, 640, 800, 1280],
              quality: 90
            })} />
          <div className={classes.header}>
            <h1 className={classes.headerText} children={hero.header} />
            <p className={classes.headerDescription} children={hero.description} />
            <div ref={'appInfo'}>
              <div className={classes.smsContainer}>
                <PhoneNumberForm
                  label={hero.sms_text}
                  manageSubmit={this.handleSubmitPhone.bind(this, 'Hero')} />
              </div>
              <a
                className={classes.downloadLink}
                href={hero.download_url}
                onClick={this.handleClickDownload.bind(this, 'Hero')}>
                <DownloadIcon cssModifier={classes.downloadIcon} />
              </a>
            </div>
          </div>
        </div>
        <div className={classes.subHeader}>
          <div className={classes.subheadText} children={hero.subhead} />
          <p className={classes.subheadDescription} children={hero.sub_description} />
          <Img cssModifier={classes.subheadBadgeDesktop} src={hero.badge_image} />
          <Img cssModifier={classes.subheadBadgeMobile} src={hero.badge_image_mobile} />
        </div>
      </div>
    );
  },

  renderContentBlock: function(classes, content, i) {
    return(
      <div className={classes.contentBlock} key={i}>
        <Img
          cssModifier={`${classes.contentScreenshot} ${i%2 > 0 ? 'u-fr' : ''}`}
          sizes={'360px'}
          srcSet={this.getSrcSet({
            url: content.image,
            widths: [360, 720],
            quality: 80
          })} />
        <div className={`${classes.contentText} ${i%2 === 0 ? 'u-r0' : 'u-l0'}`}>
          <div className={classes.contentHeader} children={content.header} />
          <h3 className={classes.contentQuote} children={content.title} />
          <Img cssModifier={classes.contentRating} src={content.stars} />
          <span className={classes.contentAuthor} children={content.author} />
          <p className={classes.contentDescription} children={content.description} />
        </div>
      </div>
    );
  },

  renderFooter: function(classes, hero) {
    return (
      <div className={classes.footerContainer}>
        <a
          className={classes.footerMobile}
          href={hero.download_url}
          onClick={this.handleClickDownload.bind(this, 'Footer')}
          children={hero.download_text} />

        <div className={classes.footerDesktop}>
          <PhoneNumberForm
            inline={true}
            label={hero.sms_text}
            manageSubmit={this.handleSubmitPhone.bind(this, 'Footer')} />
        </div>
      </div>
    );
  },

  render: function() {
    const classes = this.getClasses();
    const {hero, content} = this.props;

    return (
      <div className={classes.block}>
        {this.renderHero(classes, hero)}

        <div className={classes.content}>
          <Img cssModifier={classes.contentBackgroundMobile}
            sizes={'600px'}
            srcSet={this.getSrcSet({
              url: content.background_image_mobile,
              widths: [600, 1200],
              quality: 70
            })} />
          <Img cssModifier={classes.contentBackgroundDesktop}
            sizes={'1440px'}
            srcSet={this.getSrcSet({
              url: content.background_image,
              widths: [1440, 2880],
              quality: 80
            })} />
          {content.callouts.map(this.renderContentBlock.bind(this, classes))}
        </div>

        {this.state.footerIsSticky &&
          this.renderFooter(classes, hero)}
      </div>
    );
  }
});
