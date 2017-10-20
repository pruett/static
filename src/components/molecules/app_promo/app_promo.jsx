const _ = require("lodash");
const React = require("react/addons");
const Img = require("components/atoms/images/img/img");
const Markdown = require("components/molecules/markdown/markdown");
const Mixins = require("components/mixins/mixins");
const DownloadIcon = require('components/atoms/icons/apple/app_store_download/app_store_download');

require('./app_promo.scss');

module.exports =  React.createClass({

   mixins: [
    Mixins.classes,
    Mixins.image,
    Mixins.analytics,
  ],

  BLOCK_CLASS: "c-app-promo",

  getStaticClasses() {
    return {
      appPromo: `
        ${this.BLOCK_CLASS}__app-promo`,
      appPromoVideoWrap: `
        u-w8c--600
        u-mla--600 u-mra--600`,
      appPromoVideo: `
        u-db
        u-mw100p`,
      appPromoSpritesArea: `
        ${this.BLOCK_CLASS}__app-promo-sprites-area
        u-pr
        u-mt30 u-mt48--600 u-mla u-mra u-ml0--600 u-mr0--600 u-mr60--900
        u-bgp--c u-bgr--nr u-bgs--cv`,
      appPromoSpritesContainer: `
        ${this.BLOCK_CLASS}__app-promo-sprites-container
        u-pa`,
      appPromoSprite: `
        ${this.BLOCK_CLASS}__app-promo-sprite
        u-pa u-t0 u-l0`,
      appPromoMainCopyArea: `
        u-pr u-fwn
        u-ml9 u-mr9 u-mla--300 u-mra--300
        u-pl9 u-pr9 u-pl0--300 u-pr0--300`,
      appPromoHeading: `
        u-mt0 u-mb0
        u-fws`,
      appPromoSubhead: `
        u-ffss`,
      appPromoHeadingLarge: `
        u-mt6 u-mb12
        u-ffs u-fs24 u-fs28--600 u-fws`,
      appPromoSubheadLarge: `
        u-mt0
        u-ffss u-fs12 u-fws u-ls1 u-ttu`,
      appPromoBody: `
        u-mb30
        u-color--dark-gray-alt-3
        u-ffss u-fs16 u-fs18--600`,
      appPromoDownloadLink: `
        u-dib`,
      downloadIcon: `
        ${this.BLOCK_CLASS}__download-icon
        u-dib
      `,
    };
  },

  classesWillUpdate() {
    const promoLayoutIsVideo =
      _.get(this.props.app_promo, "layout_variation") === "video";

    return {
      appPromo: {
        '-sprites \
          u-df--600 u-ai--c u-jc--c \
          u-pt36 u-pt48--300 u-pt0--600 \
          u-pb36 u-pb48--300 u-pb0--600 \
          u-btss u-btw1 u-bc--light-gray-alt-1 u-btw0--600 \
          u-color-bg--light-gray-alt-2': !promoLayoutIsVideo
      },
      appPromoMainCopyArea: {
        'u-w9c--300 u-w7c--600 u-mtn18 u-mtn36--300 u-mb24 \
        u-pt36 u-pb36 u-pl48--300 u-pr48--300 \
        u-color-bg--white \
        u-tac': promoLayoutIsVideo,
        'u-w10c--300 u-w5c--600 \
        u-ml0--600 u-mr0--600 \
        u-tac u-tal--600': !promoLayoutIsVideo
      },
      appPromoHeading: {
        'u-dn': promoLayoutIsVideo,
        'u-dn--600 \
        u-tac u-tal--600 \
        u-ffss u-fs18 u-ffs--600 u-fs30--600': !promoLayoutIsVideo
      },
      appPromoSubhead: {
        'u-dn': promoLayoutIsVideo,
        'u-dn--600 \
        u-tac u-tal--600 \
        u-color--dark-gray \
        u-ffss u-fs16 u-fs12--600 u-fwn u-ttu--600 u-mt6': !promoLayoutIsVideo
      },
      appPromoHeadingLarge: {
        'u-fs30 u-dn u-db--600': !promoLayoutIsVideo
      },
      appPromoSubheadLarge: {
        'u-dn u-db--600': !promoLayoutIsVideo
      },
      appPromoBody: {
        'u-pt30 u-pt0--600 u-pl48--300 u-pr48--300 u-pl0--600 u-pr0--600 \
        u-btss u-btw1 u-bc--white u-btw0--600': !promoLayoutIsVideo
      }
    };
  },

  isTouchDevice() {
    return (
      "ontouchstart" in window ||
      (window.DocumentTouch && document instanceof DocumentTouch)
    );
  },

  renderSprites(sprites, classes) {
    return _.map(sprites, (sprite, i) => {
      const imgSrc = this.getSrcSet({
        url: sprite,
        widths: [185],
        quality: 85
      });
      return (
        <Img
          key={i}
          cssModifier={classes.appPromoSprite}
          srcSet={imgSrc}
          sizes="185px"
          alt="Home Try-On frame"
        />
      );
    });
  },

  renderVideoSources(videos) {
    return _.map(videos, (video, i) =>
      <source key={i} src={video.file_src} type={video.file_type} />
    );
  },

  handleClickLink(slug) {
    this.trackInteraction(`checkoutConfirmation-clickLink-${slug}`);
  },

  handleClickVideo(evt) {
    const video = React.findDOMNode(this.refs.appPromoVideo);
    if (video) {
      if (video.paused || video.ended) {
        return video.play();
      } else {
        return video.pause();
      }
    }
  },

  render() {
    const classes = this.getClasses();
    if (_.isEmpty(this.props.app_promo)) {
      return false;
    }
    const app_promo = this.props.app_promo || {};
    const headingContent = app_promo.heading;
    const subheadContent = app_promo.subhead;
    const headingLargeScreensContent =
      app_promo.heading_large_screens || headingContent;
    const subheadLargeScreensContent =
      app_promo.subhead_large_screens || subheadContent;

    return (
      <div key="appPromo" className={classes.appPromo}>
        <h3 className={classes.appPromoHeading} children={headingContent} />
        <p className={classes.appPromoSubhead} children={subheadContent} />
        {app_promo.layout_variation === "video"
          ? <div className={classes.appPromoVideoWrap}>
              <video
                autoPlay={!this.isTouchDevice()}
                className={classes.appPromoVideo}
                children={this.renderVideoSources(app_promo.video_files)}
                controls={false}
                muted={true}
                onClick={this.handleClickVideo}
                poster={app_promo.video_cover_image}
                ref="appPromoVideo"
              />
            </div>
          : <div
              className={classes.appPromoSpritesArea}
              style={{
                backgroundImage: `url('${app_promo.sprites_background_image}')`
              }}
            >
              <div
                className={classes.appPromoSpritesContainer}
                children={this.renderSprites(app_promo.sprites, classes)}
              />
            </div>}
        <div className={classes.appPromoMainCopyArea}>
          <p
            className={classes.appPromoSubheadLarge}
            children={subheadLargeScreensContent}
          />
          <h3
            className={classes.appPromoHeadingLarge}
            children={headingLargeScreensContent}
          />
          <Markdown
            className={classes.appPromoBody}
            cssModifiers={{ p: "u-fs16 u-fs18--600" }}
            rawMarkdown={app_promo.body}
          />
          <a
            className={classes.appPromoDownloadLink}
            href={_.get(app_promo, "download_button.url")}
            onClick={this.handleClickLink.bind(this,"downloadApp")}>
            <DownloadIcon cssModifier={classes.downloadIcon} />
          </a>
        </div>
      </div>
    );
  }
});
