const _ = require("lodash");
const React = require('react/addons');
const TypeKit = require("components/atoms/scripts/typekit/typekit");
const Markdown = require('components/molecules/markdown/markdown');
const Countdown = require('components/organisms/countdown/countdown');
const VideoLoop = require('components/molecules/video_loop/video_loop');
const Picture = require('components/atoms/images/picture/picture');
const Img = require('components/atoms/images/img/img');
const Mixins = require('components/mixins/mixins');

require('./solar_eclipse.scss');

module.exports = React.createClass({
  BLOCK_CLASS: 'c-solar-eclipse-page',

  STICKY_NAV_HEIGHT: 60,

  MIN_WIDTH_DESKTOP: 900,

  mixins: [
    Mixins.classes,
    Mixins.scrolling,
    Mixins.image,
    Mixins.analytics,
    Mixins.context,
  ],

  getStaticClasses: function() {
    return{
      pageWrapper: `
        u-color-bg--black u-tac
      `,
      heroWrapper: `
        ${this.BLOCK_CLASS}__hero-wrapper
        u-pr u-mw1440 u-m0a u-oh
      `,
      heroTextOverlay: `
        ${this.BLOCK_CLASS}__hero-text-overlay-container
        u-pa
      `,
      heroTextOverlayImage: `
        ${this.BLOCK_CLASS}__hero-text-overlay-image
      `,
      backgroundHeroVideo: `
        ${this.BLOCK_CLASS}__background-hero-video
      `,
      fullVideoContainer: `
        u-w100p u-h100p
      `,
      fullVideo: `
        u-w100p u-h100p u-bw0
      `,
      mainWrapper: `
        ${this.BLOCK_CLASS}__main-wrapper
      `,
      mainContainer: `
        ${this.BLOCK_CLASS}__main-container
        u-color--white
        u-pr u-mw1440 u-m0a
        u-fs16 u-fs22--900
      `,
      stickyContainer: `
        u-color-bg--blue
        u-pt12 u-pb12 u-tac u-ttu
        ${this.BLOCK_CLASS}__sticky-container
      `,
      headerLinks: `
        u-futura u-fs16 u-ls2
        u-pl32 u-pr32
        u-m0a u-tac u-mw960
      `,
      headerLink: `
        ${this.BLOCK_CLASS}__header-link
        u-color--white
        u-ml30 u-mr30 u-ml60--900 u-mr60--900
        u-pr
      `,
      preCatImg: `
        ${this.BLOCK_CLASS}__pre-cat-img
        u-mla u-mra u-ml60--900
        u-fl--900
      `,
      preCatWrapper: `
        ${this.BLOCK_CLASS}__pre-cat-wrapper
        u-futura-heavy u-ttu u-color--blue
        u-pl12 u-pr12
        u-mt0 u-oh
        u-pt48 u-pb48
      `,
      preCatContainer: `
        ${this.BLOCK_CLASS}__pre-cat-container
        u-mla u-mra u-oh
      `,
      preCatDescrip: `
        u-pt108
      `,
      preCatLeft: `
        u-fl
      `,
      preCatLeftText: `
        ${this.BLOCK_CLASS}__pre-cat-left-text
        u-pt24--900
        u-dib u-dn--900
        u-m0a
      `,
      preCatRight: `
        ${this.BLOCK_CLASS}__pre-cat-right
        u-fr
      `,
      preCatRightText: `
        ${this.BLOCK_CLASS}__pre-cat-right-text
        u-dib u-dn--900
        u-m0a
      `,
      preCatCircles: `
        ${this.BLOCK_CLASS}__pre-cat-circles
        u-dn u-dib--900
      `,
      catHeader: `
        u-bbss u-bbw1 u-bc--white
      `,
      descriptionWrapper: `
        ${this.BLOCK_CLASS}__description-wrapper
        u-w10c u-w5c--900 u-m0a
        u-futura
      `,
      subDescription: `
        ${this.BLOCK_CLASS}__sub-description
        u-mla u-mra
        u-pt36
      `,
      mainDescription: `
        ${this.BLOCK_CLASS}__main-description
        u-mla u-mra
      `,
      countdownWrapper: `
        ${this.BLOCK_CLASS}__countdown-wrapper
        u-mla u-mra
        u-color--blue
        u-pt24 u-pb48 u-pb72--900
        u-ttu u-futura
      `,
      header: `
        ${this.BLOCK_CLASS}__header
        u-futura-heavy u-color--blue u-ttu
        u-fs18 u-fs30--900
        u-m0a
      `,
      nasaHeader: `
        u-color--white u-pt48 u-pt0--900
      `,
      linkContainer: `
        u-mt48 u-pt12 u-pb12 u-pl24 u-pr24
        u-color--black u-color-bg--white
      `,
      playLinkContainer: `
        ${this.BLOCK_CLASS}__play-link
        u-mt48 u-mt36--900 u-pl18 u-pr18 u-mla u-mra
        u-color--white
        u-bss u-bw2 u-bc--white
      `,
      link: `
        u-futura
        u-color--black u-fs18
      `,
      playLink:`
        u-color--white u-futura
        u-pl6 u-fs16 u-ls2
        u-ttu
      `,
      warning: `
        u-bss u-bw2 u-bc--blue
        u-pt24 u-pl36 u-pr36 u-pb24 u-w4c--900
        u-mt12--900 u-ml36--900 u-mb48 u-mb0--900
      `,
      warningDescription: `
        u-futura
      `,
      viewCat: `
        u-pt84--900
      `,
      contestCat: `
        u-pt84--900
      `,
      videoLoop: `
        ${this.BLOCK_CLASS}__video-loop
        u-mb24 u-mr24
      `,
      markdown: `
        ${this.BLOCK_CLASS}__markdown
        u-futura
      `,
      corona: `
        u-pb48 u-pt48 u-pb0--900 u-pt0--900
      `,
      pinholeWrapper: `
        ${this.BLOCK_CLASS}__pinhole-wrapper
        u-mla u-mra
      `,
      pinholeContainer: `
        u-pt48 u-pb48 u-pt0--900 u-pb0--900
      `,
      peopleContainer: `
        u-pb48 u-pt48 u-pt0--900 u-pb0--900
      `,
      peopleImg: `
        ${this.BLOCK_CLASS}__people-img
      `,
      contestTitle: `
        ${this.BLOCK_CLASS}__contest-title
      `,
      contestBody: `
        u-pl120--900 u-pr120--900
      `,
      contestFineprint: `
        ${this.BLOCK_CLASS}__contest-fineprint
      `,
      map: `
        ${this.BLOCK_CLASS}__map
        u-pb48 u-pb0--900
      `,
      pinholeImg: `
        ${this.BLOCK_CLASS}__pinhole-img
        u-m0a u-ml36
      `,
      smallTitle: `
        ${this.BLOCK_CLASS}__small-title
      `,
      catBody: `
        u-pl18 u-pr18 u-pl72--900 u-pr72--900
        u-pt48
        u-oh
      `,
      categorySection: `
        u-oh u-mb96--900
      `,
      left: `
        u-fn u-fl--900 u-m0a
      `,
      right: `
        u-fn u-fr--900 u-m0a
      `,
      smallVideo: `
        ${this.BLOCK_CLASS}__small-video
      `,
      mixedText: `
        ${this.BLOCK_CLASS}__mixed-text
      `,
      smallLink: `
        ${this.BLOCK_CLASS}__small-link
        u-mla u-mra
      `,
      winSection: `
        u-pt48 u-pb48 u-pt0--900 u-pb0--900
        u-mla u-mra u-mr72--900
      `,
      winHeader: `
        ${this.BLOCK_CLASS}__win-header
      `,
      winBody: `
        ${this.BLOCK_CLASS}__win-body
        u-mla u-mra
      `,
      question_header: `
        ${this.BLOCK_CLASS}__question-header
      `
    };
  },

  getDefaultProps: function() {
    return {
      hero: {},
      pre_category: {},
      categories: {},
      sticky_header: [],
      sources: {
        desktop: 'https://www.warbyparker.com/assets/img/videos/eclipse/hero-desktop.mp4',
        mobile: 'https://www.warbyparker.com/assets/img/videos/eclipse/hero-mobile.mp4'
      },
      posters: {
        mobile: 'https://i.warbycdn.com/v/c/assets/solar-eclipse/image/hero-mobile/0/82fd2a12ec.jpg"',
        desktop: 'https://i.warbycdn.com/v/c/assets/solar-eclipse/image/hero-desktop/0/61a452d87f.jpg'
      },
    };
  },


  checkViewPort: function() {
    const windowWidth = window.innerWidth || _.get(document, 'documentElement.clientWidth');
    if (windowWidth <= this.MIN_WIDTH_DESKTOP) {
      this.setState({viewport: 'mobile'})
    } else {
      this.setState({viewport: 'desktop'})
    }

    this.setState({viewPortChecked: true})
  },

  componentDidMount: function() {
    this.checkViewPort();
    this.throttledCheckViewPort = _.throttle(this.checkViewPort, 100);
    window.addEventListener('resize', this.throttledCheckViewPort);

    if (window.location.hash) {
      const hash = window.location.hash.replace(/#/, "");
      const node = this.refs[hash];
      this.scrollToNode(node, {
        time: 0,
        offset: -this.STICKY_NAV_HEIGHT,
      });
      this.setState({activeCategory: hash});
    }
    return this.addScrollListener(this.updateActiveCategory, 100);
  },

  updateActiveCategory: function() {
    this.setState({
      activeCategory: _.first(
        ['about','view','contest'].filter(ref =>
          this.elementIsInViewport(this.refs[ref], this.STICKY_NAV_HEIGHT)
        )
      )
    });
  },

  getInitialState: function() {
    return {
      viewport: 'desktop',
      viewPortChecked: false,
      activeCategory: `about`,
    }
  },

  getSource: function() {
    return this.props.sources[this.state.viewport];
  },

  getPosterImage: function() {
    return this.props.posters[this.state.viewport];
  },

  getParams: function() {
    let params = {};
    if (typeof window !== 'undefined') {
      const url = window.location.search.substr(1);
      let prmarr = url.split("&");
      for ( var i = 0; i < prmarr.length; i++) {
        let tmparr = prmarr[i].split("=");
        params[tmparr[0]] = tmparr[1];
      }
      return params["time"];
    }
    return null;
  },

  handleHeaderLinkClick: function(id, event) {
    const node = this.refs[id];
    const target = _.camelCase(`header ${id}`);
    this.scrollToNode(node, {
      time: 800,
      offset: -this.STICKY_NAV_HEIGHT,
    });
    this.setState({activeCategory: id});
    this.trackInteraction(`solarEclipse-click-${target}`);
  },

  classesWillUpdate: function() {
    return {
      backgroundPlay: {
        'u-dn': this.state.videoPlaying
      },
      fullVideo: {
        'u-dib': this.state.videoPlaying
      },
    };
  },

  handlePlayClick: function() {
    this.trackInteraction(`solarEclipse-click-playVideo`);
    this.setState({videoPlaying: true});
    const videoNode = this.refs.video;
    videoNode.src = `${videoNode.src}&autoplay=1`;
  },

  renderImgChildren: function(img) {
    const sources = {
      sources: [
        { url: img,
          widths: [375, 414, 700, 800, 900, 1000, 1200, 1440, 2880],
          mediaQuery: "(min-width: 0px)",
          sizes: "100vw",
        },
      ]
    };
    return(
      this.getPictureChildren(sources)
    );
  },

  renderHero: function(classes, hero) {
    const videoSrc = `${hero.full_video}?controls=0&rel=0&showinfo=0`;
    return(
      <div className={classes.heroWrapper}>
        <div className={classes.backgroundPlay}>
          <div className={classes.heroTextOverlay}>
            <img className={classes.heroTextOverlayImage}
                src={hero.header}
                alt={`Text saying the Great American Solar Eclipse`}/>
            <div className={`${classes.playLinkContainer}`}>
              <svg viewBox="0 0 100 100" height="12" width="12" xmlns="http://www.w3.org/2000/svg">
                <polygon points="0 0, 100 50, 0 100" fill="white" stroke="white"/>
              </svg>
              <a href={'#'} children="Play Video" className={classes.playLink}
                onClick={this.handlePlayClick}/>
            </div>
          </div>

          <div className={classes.backgroundHeroVideo}>
            <VideoLoop poster={this.getPosterImage()} src={this.getSource()} />
          </div>
        </div>

        <div className={classes.fullVideoContainer}>
          <iframe
            ref={'video'}
            className={classes.fullVideo}
            src={videoSrc}
            frameBorder={`0`} allowFullScreen>
          </iframe>
        </div>
      </div>
    );
  },

  renderPreCategory: function(classes, pre_category) {
    return(
      <div className={classes.preCatWrapper}>
        <div className={classes.preCatContainer}>
          <div className={classes.preCatDescrip}>
            <p className={classes.preCatLeftText} children={pre_category.left_description} />
            <img className={`${classes.preCatCircles}  ${classes.preCatLeft}`}
                src="https://www.warbyparker.com/assets/img/solar_eclipse/text-circle-1.svg"
                alt={`Spinning circle of text saying Monday, August 21, 2017`}/>
          </div>

          <div>
            <img className={classes.preCatImg} src={pre_category.moon_image}
                alt={`Illustration of a white circle half covered by a moon`} />
          </div>

          <div className={classes.preCatDescrip}>
            <p className={classes.preCatRightText} children={pre_category.right_description} />
            <img className={`${classes.preCatCircles}  ${classes.preCatRight}`}
                src="https://www.warbyparker.com/assets/img/solar_eclipse/text-circle-2.svg"
                alt={`Spinning circle of text saying a cross country spectacle like no other`}/>
          </div>
        </div>

      </div>
    );
  },

  renderAboutCategory: function(classes, about) {
    return(
      <div ref={_.kebabCase(about.title)} >
        <div className={classes.catHeader}>
          <img src="https://www.warbyparker.com/assets/img/solar_eclipse/about.svg"
            className={classes.smallTitle}
            alt={`Image of white text saying About`}/>
        </div>

        <div className={`${classes.catBody} u-pb48`}>
          <div className={classes.descriptionWrapper}>
            <Markdown cssBlock={`${classes.mainDescription} ${classes.markdown} -light `}
                rawMarkdown={about.description} />
            <Markdown cssBlock={`u-fs14 ${classes.subDescription} ${classes.markdown} -light`}
                rawMarkdown={about.sub_description} />
          </div>

          <div className={classes.countdownWrapper}>
              <Countdown currentTime={this.getParams()}/>
          </div>

          <VideoLoop poster={about.solar_image} src={about.solar_video}
            cssModifier={`${classes.videoLoop} ${classes.smallVideo} u-mb48`}/>
        </div>
      </div>
    );
  },

  renderViewCategory: function(classes, view, contest) {
    return(
      <div ref={_.kebabCase(view.title)}>
        <div className={classes.catHeader}>
          <img src="https://www.warbyparker.com/assets/img/solar_eclipse/view.svg"
            className={classes.smallTitle}
            alt={`Image of white text saying View`}/>
        </div>

        <div className={`${classes.catBody} ${classes.viewCat}`}>

          {(this.getLocale('country') === 'US') ?
            <div className={`${classes.pinholeWrapper} ${classes.categorySection}`}>
              <div className={`${classes.pinholeImg}  ${classes.left}`}>
                <img src="https://www.warbyparker.com/assets/img/solar_eclipse/pinhole.svg"
                  alt={`Illustration of a man holding our pinhole and a mirror looking at the sun`}/>
              </div>

              <div className={`${classes.pinholeContainer} ${classes.right} ${classes.mixedText}`}>
                <h3 className={classes.header} children={view.pinhole_header} />
                <div className={`${classes.linkContainer} ${classes.smallLink}`}>
                  <a className={classes.link} href={view.pinhole_links[0].url}
                      children={view.pinhole_links[0].title}
                      onClick={this.trackInteraction.bind(this, `solarEclipse-click-pinholeDownload`)}
                  download={`Great American Solar Eclipse pinhole projector`}/>
                </div>
              </div>
            </div>
          : null }

          <div className={classes.categorySection}>
            <div className={`${classes.map} ${classes.right}`}>
              <img src="https://i.warbycdn.com/v/c/assets/solar-eclipse/image/map/0/d5305d7bb6.png"  />
            </div>

            <div className={`u-ml72--900 ${classes.descriptionWrapper} ${classes.mainDescription} ${classes.left}`}>
              <p children={view.description} />
            </div>
          </div>

          <div className={classes.categorySection}>
            <div className={classes.peopleContainer}>
              <Picture cssModifier={`${classes.peopleImg}  ${classes.left}`}
                children={this.renderImgChildren(view.people_image)} />
            </div>

            <div className={`u-mr48--900 ${classes.right} ${classes.mixedText}`}>
              <h3 className={`${classes.header} ${classes.question_header}`} children={view.question_header}/>
              <div className={`${classes.subDescription} u-futura u-mb0`}>
                <p className={`u-mt0 u-pt0`} children={view.stop_description} />
              </div>
              <div className={`${classes.linkContainer} ${classes.smallLink}`}>
                  <a className={classes.link} href={view.find_links[0].url}
                    children={view.find_links[0].title}
                    onClick={this.trackInteraction.bind(this, `solarEclipse-click-findStore`)}
                    target="_blank"/>
              </div>
            </div>
          </div>

          <div className={classes.categorySection}>
            <div className={`${classes.corona}  ${classes.right}`}>
              <VideoLoop poster={view.corona_img} src={view.corona_video} cssModifier={classes.videoLoop}/>
            </div>

            <div className={`u-ml36--900 u-mt12--900 ${classes.warning}  ${classes.left}`}>
              <h3 className={classes.header} children={view.warning_section.warning_header} />
              <p className={classes.warningDescription} children={view.warning_section.warning_description} />
            </div>
          </div>

          {(this.getLocale('country') === 'CA') ?
            <div className={`${classes.pinholeWrapper} ${classes.categorySection}`}>
              <div className={`${classes.pinholeImg}  ${classes.left}`}>
                <img src="https://www.warbyparker.com/assets/img/solar_eclipse/pinhole.svg"
                  alt={`Illustration of a man holding our pinhole and a mirror looking at the sun`}/>
              </div>
              <div className={`${classes.pinholeContainer} ${classes.right} ${classes.mixedText}`}>
                <h3 className={classes.header} children={view.pinhole_header} />
                <div className={`${classes.linkContainer} ${classes.smallLink}`}>
                  <a className={classes.link} href={view.pinhole_links[0].url}
                      children={view.pinhole_links[0].title}
                      onClick={this.trackInteraction.bind(this, `solarEclipse-click-pinholeDownload`)}
                  download={`Great American Solar Eclipse pinhole projector`}/>
                </div>
              </div>
            </div>
            : null
          }
          {(this.getLocale('country') === 'CA') ?
            this.renderNasaSection(classes, contest)
            : null
          }

        </div>
      </div>
    );
  },

  renderContestSection: function(classes, contest) {
    return (
      <div className={classes.categorySection}>
        <VideoLoop poster={contest.totality_image} src={contest.totality_video}
          cssModifier={`${classes.videoLoop} ${classes.smallVideo} ${classes.left}`} />

        <div className={`${classes.right} ${classes.mixedText} ${classes.winSection}`}>
          <h3 className={`${classes.header} ${classes.winHeader} u-mtn36`} children={contest.win_header} />
            <div className={`u-mr36 ${classes.winBody}`}>
              <Markdown cssBlock={`u-pt36 ${classes.markdown} -dark`}
                  rawMarkdown={contest.entrance_description}
                  onClick={this.trackInteraction.bind(this, `solarEclipse-click-facebookContest`)}/>
              <Markdown cssBlock={`u-pt12 ${classes.contestFineprint} ${classes.markdown} -dark`}
                  rawMarkdown={contest.fineprint_description}
                  onClick={this.trackInteraction.bind(this, `solarEclipse-click-contestRules`)}/>
            </div>
        </div>
      </div>
    );
  },

  renderNasaSection: function(classes, contest) {
    return (
      <div className={classes.categorySection}>
        <VideoLoop poster={contest.arc_image} src={contest.arc_video}
            cssModifier={`${classes.videoLoop} ${classes.smallVideo} ${classes.right}`}/>

        <div className={`u-pb48 ${classes.left} ${classes.mixedText}`}>
          <h3 className={`${classes.header} ${classes.nasaHeader}`} children={contest.nasa_header} />
          <div className={`${classes.linkContainer} ${classes.smallLink}`}>
            <a className={classes.link} href={contest.nasa_links[0].url}
                children={contest.nasa_links[0].title}
                onClick={this.trackInteraction.bind(this, `solarEclipse-click-nasaLink`)}
                target="_blank" />
          </div>
        </div>
      </div>
    );
  },

  renderContestCategory: function(classes, contest) {
    return(
        <div ref={_.kebabCase(contest.title)} >
          <div className={classes.catHeader}>
            <img src="https://www.warbyparker.com/assets/img/solar_eclipse/contest.svg"
              className={classes.contestTitle}
              alt={`Image of white text saying contest`}/>
          </div>

          <div>
            <div className={`${classes.catBody} ${classes.contestCat}`}>
              { this.renderContestSection(classes, contest) }
              { this.renderNasaSection(classes, contest) }
            </div>
          </div>
        </div>
    );
  },

  renderHeaderLink: function(classes, category, i){
    const id = _.kebabCase(category.title);
    return(
        <a
          key={i}
          href={`#${id}`}
          children={category.title}
          onClick={this.handleHeaderLinkClick.bind(this, id)}
          className={
            this.state.activeCategory === id
            ? `${classes.headerLink} -active`
            : classes.headerLink
          }
        />
    );
  },

  render: function() {
    const classes = this.getClasses();
    return(
      <div className={classes.pageWrapper}>
        <TypeKit typeKitModifier={`cdo7qsc`} />
        {this.renderHero(classes, this.props.hero)}

          <div className={classes.mainWrapper}>

            {(this.getLocale('country') === 'US') ?
              <div className={classes.stickyContainer}>
                <div className={classes.headerLinks}
                  children={this.props.sticky_header.map(this.renderHeaderLink.bind(this, classes))} />
              </div>
              : null
            }

            <div className={classes.mainContainer}>
              {this.renderPreCategory(classes, this.props.pre_category)}
              <div className={classes.categoryArea}>
                {this.renderAboutCategory(classes, this.props.categories.about)}
                {this.renderViewCategory(classes, this.props.categories.view, this.props.categories.contest)}
                {(this.getLocale('country') === 'US') ?
                    this.renderContestCategory(classes, this.props.categories.contest)
                    : null
                }
              </div>
            </div>
         </div>
      </div>
    );
  }
});
