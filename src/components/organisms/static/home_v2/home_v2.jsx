const _ = require('lodash');
const React = require('react/addons');
const Mixins = require('components/mixins/mixins');

const Takeover = require('components/molecules/modals/takeover/takeover');
const Hero = require('components/molecules/callout/callout_fullscreen/callout_fullscreen');
const Picture = require('components/atoms/images/picture/picture');
const DownArrow = require('components/quanta/icons/down_arrow_thin/down_arrow_thin');
const BackArrow = require('components/quanta/icons/left_line_arrow/left_line_arrow');

require('./home_v2.scss');

module.exports = React.createClass({
  BLOCK_CLASS: 'c-homepage',

  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.dispatcher,
    Mixins.image,
    Mixins.scrolling,
  ],

  getDefaultProps: function() {
    return {
      analyticsCategory: 'homepage',
      smartBannerActive: false,
      hero: {},
      callouts: [],
      shop_links: [],
    };
  },

  getInitialState: function() {
    return {
      showShopTakeover: false
    };
  },

  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-mla u-mra u-tac u-mbn1
      `,
      heroText: `
        ${this.BLOCK_CLASS}__hero-text
        u-pa u-center-x u-w100p u-tac u-tal--900
        u-color--dark-gray
      `,
      heroHeader: `
        ${this.BLOCK_CLASS}__hero-header
        u-w7c--900
        u-mla u-ml0--900 u-mra u-mr0--900
        u-mb24 u-mb48--600
        u-ffs u-fws u-fs40 u-fs60--600
      `,
      heroCta: `
        ${this.BLOCK_CLASS}__hero-cta
        u-button-reset
        u-fws u-fs20 u-fs24--600
      `,
      downArrow: `
        ${this.BLOCK_CLASS}__down-arrow
        u-dib u-ml12
        u-stroke--dark-gray
      `,
      callouts: `
        u-pr
      `,
      callout: `
        ${this.BLOCK_CLASS}__callout
        u-pr u-h100p u-oh u-vat
        u-dib--900
      `,
      calloutLight: `
        u-color--white -gradient
      `,
      calloutImage: `
        ${this.BLOCK_CLASS}__callout-image
        u-w100p u-pr u-oh
      `,
      calloutPicture: `
        u-db u-h0
        u-pb4x3 u-pb16x9--600 u-pb0--900
      `,
      calloutPictureImage: `
        u-db u-w100p
        u-pa--900 u-t0--900
      `,
      calloutText: `
        ${this.BLOCK_CLASS}__callout-text
        u-pa u-w100p
        u-center-x u-center-none--900
      `,
      calloutHeader: `
        u-mt0 u-mb18
        u-fws u-fs20 u-fs24--900
      `,
      calloutContent: `
        ${this.BLOCK_CLASS}__callout-content
        u-mw100p
      `,
      calloutDescription: `
        u-dn u-db--900
        u-mt12 u-mb18
        u-ffss u-fs18
      `,
      calloutLinks: `
        u-mln6 u-mrn6
      `,
      calloutLink: `
        ${this.BLOCK_CLASS}__pill
        u-button-reset
        u-dib
        u-fws u-tac u-fs16
        u-color--dark-gray
      `,
      takeoverContainer: `
        u-color-bg--dark-gray-95p
      `,
      shopTakeover: `
        u-pa
        u-t0 u-b0 u-l0 u-r0
      `,
      takeoverImageContainer: `
        ${this.BLOCK_CLASS}__takeover-image-container
        u-pr u-oh
      `,
      takeoverImage: `
        u-pa u-l0 u-b0 u-w100p
      `,
      takeoverLink: `
        ${this.BLOCK_CLASS}__takeover-link
        u-pa u-center-x u-b0 u-mb36 u-mb48--600
      `,
      takeoverLinkInline: `
        u-center--900 u-ba--900
      `,
      backButton: `
        ${this.BLOCK_CLASS}__back-button
        u-button-reset
        u-pa u-t0 u-l0
      `,
      iconX: `
        u-ml24 u-mr24 u-mt24 u-mb24
      `,
    }
  },

  classesWillUpdate: function() {
    const shopIndex = _.findIndex(this.props.callouts, {type: 'shop'});

    return {
      callout: {
        'u-w4c--900': !this.isTwoUp(),
        'u-w6c--900': this.isTwoUp(),
      },
      calloutContent: {
        '-wide': this.isTwoUp(),
      },
      calloutImage: {
        '-header': _.isEmpty(this.props.hero.images),
      },
      takeoverContainer: {
        'u-tal': shopIndex === 0,
        'u-tar': shopIndex !== 0,
      }
    };
  },

  onClickScrollDown: function(evt) {
    this.trackInteraction(`${this.props.analyticsCategory}-hero-getStarted`);
    this.scrollToNode(this.refs.callouts);
  },

  openShopTakeover: function(category) {
    this.trackInteraction(`${this.props.analyticsCategory}-callout-${category}`);
    this.setState({showShopTakeover: category});
  },

  handleTakeoverClick: function(evt) {
    if(evt.currentTarget === this.refs.takeoverBackground) {
      this.trackInteraction(`${this.props.analyticsCategory}-callout-shopClose`);
      this.setState({showShopTakeover: false});
      this.commandDispatcher('layout', 'hideTakeover');
    }
  },

  handleTakeoverBack: function(evt) {
    this.trackInteraction(`${this.props.analyticsCategory}-callout-shopCloseBack`);
    this.setState({showShopTakeover: false});
    this.commandDispatcher('layout', 'hideTakeover');
  },

  isTwoUp: function() {
    return this.props.callouts.length === 2;
  },

  getCalloutPictureSources: function(images) {
    return ['desktop-tall', 'desktop', 'tablet', 'mobile'].map((name) => {
      const img = _.find(images, {size: name});
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
      else if(name === 'desktop' || name === 'desktop-tall') {
        source.mediaQuery = `(min-width: 900px)${name === 'desktop-tall' ? ' and (max-aspect-ratio: 3/2)' : ''}`;

        if(this.isTwoUp()) {
          source.sizes = '(min-width: 1920px) 960px, 50vw';
          source.widths = [500, 640, 720, 840, 960, 1280, 1440, 1920];
        }
        else {
          source.sizes = '(min-width: 1920px) 640px, 34vw';
          source.widths = [400, 500, 600, 640, 800, 1000, 1280];
        }
      }

      return source;
    });
  },

  getShopLinks: function() {
    return _.filter(this.props.shop_links, {type: this.state.showShopTakeover});
  },

  renderHeroContent: function(classes) {
    return (
      <div className={classes.heroText}>
        <h1 className={classes.heroHeader} children={this.props.hero.header} />
        <button
          className={classes.heroCta}
          onClick={this.onClickScrollDown}
          children={[
            this.props.hero.cta,
            <DownArrow cssUtility={classes.downArrow} />
          ]} />
      </div>
    );
  },

  renderCalloutLink: function(classes, cssModifier, link, i) {
    const sharedProps = {
      key: i,
      className: `${classes.calloutLink} ${cssModifier}`,
      children: link.title,
    };

    if(link.url) {
      return (
        <a {...sharedProps}
          href={link.url}
          onClick={this.trackInteraction.bind(
            this,
            `${this.props.analyticsCategory}-callout-${link.category}`
          )} />
      );
    }
    else {
      return (
        <button {...sharedProps}
          onClick={this.openShopTakeover.bind(this, link.title.toLowerCase())} />
      );
    }
  },

  renderCallout: function(classes, callout, i) {
    const links = (
      <div
        className={classes.calloutLinks}
        children={callout.links.map(
          this.renderCalloutLink.bind(this, classes, callout.dark ? '-outline' : '')
        )} />
    );

    const content = callout.description ?
    (
      <div className={`${classes.calloutContent}`}>
        <p className={classes.calloutDescription} children={callout.description} />
        {links}
      </div>
    ) : links;

    return (
      <div key={i} className={`${classes.callout} ${!callout.dark ? classes.calloutLight : ''}`}>

        <div className={classes.calloutImage} style={{background: callout.background}}>
          <Picture
            cssModifier={classes.calloutPicture}
            children={
              this.getPictureChildren({
                sources: this.getCalloutPictureSources(callout.images),
                img: {
                  className: classes.calloutPictureImage,
                  alt: callout.alt_text,
                }
              })
            } />
        </div>

        <div className={`${classes.calloutText}${callout.description ? ' u-tal--900' : ''}`}>
          <h3
            className={`${classes.calloutHeader}${callout.description ? ' u-mb0--900' : ''}`}
            children={callout.header} />
          {content}
        </div>
      </div>
    );
  },

  renderShopTakeover: function(classes, shopLinks) {
    return (
      <Takeover
        active={Boolean(this.state.showShopTakeover)}
        cssModifier={classes.takeoverContainer}
        hasHeader={false}
        pageHeader={true}>

        <div
          ref={'takeoverBackground'}
          className={classes.shopTakeover}
          onClick={this.handleTakeoverClick}>
          <div className={classes.callout}>
            <div className={classes.shopTakeover}>
              <button
                className={classes.backButton}
                onClick={this.handleTakeoverBack}>
                <BackArrow cssModifier={classes.iconX} />
              </button>
              {_.map(this.getShopLinks(), (link, i) => {
                return(
                  <div key={i} className={classes.takeoverImageContainer}>
                    <Picture
                      cssModifier={classes.calloutPicture}
                      children={
                        this.getPictureChildren({
                          sources: this.getCalloutPictureSources(link.images),
                          img: {
                            className: classes.takeoverImage,
                            alt: link.alt_text,
                          }
                        })
                      } />
                    <div
                      className={`${classes.takeoverLink} ${this.isTwoUp() ? classes.takeoverLinkInline : ''} -${link.link_style}`}
                      children={this.renderCalloutLink(classes, this.isTwoUp() ? '-outline--900': '', link)} />
                  </div>
                );
              })}
            </div>
          </div>
        </div>

      </Takeover>
    );
  },

  render: function() {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        {!_.isEmpty(this.props.hero.images) &&
          <Hero
            altText={this.props.hero.alt_text}
            background={this.props.hero.background}
            images={this.props.hero.images}
            smartBannerActive={this.props.smartBannerActive}
            children={this.renderHeroContent(classes)} />}

        <div ref='callouts' className={classes.callouts}>
          <div children={_.map(this.props.callouts, this.renderCallout.bind(this, classes))} />
          {this.renderShopTakeover(classes, this.props.shop_links)}
        </div>
      </div>
    );
  }
});
