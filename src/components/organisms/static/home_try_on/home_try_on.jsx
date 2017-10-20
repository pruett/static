const _ = require('lodash');
const React = require('react/addons');

const Img = require('components/atoms/images/img/img');
const BuyableFrame = require('components/molecules/products/buyable_frame/buyable_frame');
const TabBar = require('components/molecules/tab_bar/tab_bar');
const QuizPromo = require('components/molecules/quiz_promo_animated/quiz_promo_animated');
const Callout = require('components/organisms/callout/callout');
const StarterKits = require('components/organisms/starter_kits/starter_kits');

const Mixins = require('components/mixins/mixins');

require('./home_try_on.scss');

module.exports = React.createClass({

  BLOCK_CLASS: 'c-home-try-on',

  ANALYTICS_CATEGORY: 'hto',

  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.context,
    Mixins.image
  ],

  propTypes: {
    cms: React.PropTypes.object,
    favorites: React.PropTypes.array,
    showFavorites: React.PropTypes.bool
  },

  getDefaultProps: function() {
    return {
      cms: {},
      favorites: [],
      showFavorites: false
    };
  },

  getInitialState: function() {
    return {
      showMobile: false
    };
  },

  getStaticClasses: function() {
    return {
      block:
        'u-tac u-mw1440 u-m0a',
      col:
        'u-grid__col u-w12c u-tac',

      header:
        'u-mb36',
      heading:
        'u-reset u-heading-md u-mb12',
      detail:
        'u-reset u-body-standard',

      tout:
        'u-grid__col u-w12c u-w4c--600 u-tac',
      toutBody:
        `${this.BLOCK_CLASS}__tout-body
        u-pb0--600 u-pl24 u-pl0--600 u-tal u-tac--600 u-pr
        u-bw0 u-blw0--600 u-blss u-bc--light-gray`,
      toutImg:
        'u-dn u-dib--600 u-mb24',
      toutTitle:
        'u-reset u-fs18 u-fs20--900 u-ffss u-fws u-mb6',

      link:
        'u-grid__col u-w12c u-w6c--1200 u-mb24 u-tac',
      linkHeader:
        'u-mb36',
      linkTitle:
        'u-reset u-fs12 u-ffss u-ttu u-ls2_5 u-mb12',
      linkButton:
        'u-button -button-modular -button-white u-fs16 u-fws',

      frame:
        'u-grid__col u-w12c u-w6c--600 u-w4c--1200 u-dib--600 u-tac',

      showMobile:
        'u-tac u-db u-dn--600 u-ma u-tac',
      showButton:
        `u-reset u-color-bg--white u-color--blue u-fws
         u-mb60 u-mb72--600 u-fs16 u-dib`,
      showLink:
        `u-reset u-color--blue u-mb60 u-mb72--600
        u-fs16 u-fws u-dib u-link--underline`,
      showPlus:
        'u-sign -plus -w10 u-pr u-mr12 u-color--blue',

      hrMain:
        `u-reset
        u-bw0 u-bbw1 u-bbss u-bc--light-gray
        u-mt60 u-mt72--600
        u-mb60 u-mb72--600`,
      hrFrame:
        `u-reset
        u-bw0 u-bbw1 u-bbss u-bc--light-gray
        u-mt72 u-mb60 u-mb72--600`,
      hrHelp:
        `u-reset
        u-bw0 u-bbw1 u-bbss u-bc--light-gray
        u-mt36 u-mt48--600
        u-mb48`,

      help:
        'u-dib u-ma u-fs16 u-fws u-ffss u-color--blue'
    };
  },

  classesWillUpdate: function() {
    const htoStarterKitVariant = this.getExperimentVariant('htoStarterKit');

    return {
      shopAll: {
        'u-pt36 u-pt72--600': htoStarterKitVariant === 'withQuiz',
        'u-pt36 u-pt72--600 u-btss u-btw1 u-bc--light-gray': htoStarterKitVariant === 'withoutQuiz'
      }
    };
  },

  handleClick: function(name, evt) {
    this.clickInteraction(name, evt);
    this.setState({showMobile: true});
  },

  wrapGrid: function(children) {
    // Grid wrapper helper function
    return (
      <div className={'u-grid -maxed u-ma'}>
        <div className={'u-grid__row u-tal'} children={children} />
      </div>
    );
  },

  // TOUTS

  renderTouts: function(classes, content) {
    if (!content) return;

    const renderTout = function(tout, i, touts) {
      let cssToutBody = `${classes.toutBody}`;
      cssToutBody = `${cssToutBody} -tout-${i}`;
      if (touts.length - 1 !== i) {
        cssToutBody = `${cssToutBody} u-pb36 u-blw1`;
      }

      return (
        <div className={classes.tout} key={i}>
          <div className={cssToutBody}>
            <Img
              cssModifier={classes.toutImg}
              sizes={'(min-width: 600px) 241px, 200px'}
              srcSet={this.getSrcSet({
                url: tout.image,
                quality: tout.quality,
                widths: [ 200, 300, 400, 500 ]
              })} />
            <h3 children={tout.title} className={classes.toutTitle} />
            <p children={tout.detail} className={classes.detail} />
          </div>
        </div>
      );
    };

    return (
      <section>
        <header className={`${classes.header} u-dn u-db--900`}>
          <h2 className={classes.heading} children={content.title} />
        </header>
        {this.wrapGrid(content.blocks.map(renderTout.bind(this)))}
      </section>
    );
  },

  // FRAMES

  renderProducts: function(classes, content) {
    if (!content) return;

    const reduceGenderToMaxIndex = function(max, gender, index, genders) {
      // Make sure to base spacer tab on gender with most frames.
      if (gender.frames.length > genders[max].frames.length) {
        return index;
      }
      else {
        return max;
      }
    };

    return (
      <section>
        <header className={classes.header}>
          <h2 className={classes.heading} children={content.title} />
          <p className={classes.detail} children={content.detail} />
        </header>
        <TabBar
          analyticsSlug={this.ANALYTICS_CATEGORY}
          tabs={_.map(content.genders, this.renderGender.bind(this, classes))}
          spacerIndex={_.reduce(content.genders, reduceGenderToMaxIndex, 0)}/>
        {this.wrapGrid(
          <div className={classes.col}>
            <hr className={classes.hrFrame} />
          </div>
        )}
      </section>
    );
  },

  renderGender: function(classes, gender, i) {
    return {
      heading: gender.title,
      content: this.wrapGrid([
        _.map(gender.frames, this.renderFrame.bind(this, classes))
      ])
    };
  },

  renderFrame: function(classes, product, i) {
    product.visible = true;

    return (
      <span key={i}>
        <BuyableFrame
          addedVia={'hto-landing'}
          cssModifier={classes.frame}
          analyticsCategory={this.ANALYTICS_CATEGORY}
          cart={_.get(this.props, 'session.cart', {})}
          canHto={true}
          canPurchase={false}
          canFavorite={false}
          product={product} />
      </span>
    );
  },

  // SHOP ALL

  renderShopAll: function(classes, content) {
    if (!content) return;

    const renderShop = function(shop, i) {
      return (
        <div className={classes.link} key={i}>
          <div className={`u-f${i % 2 ? 'l' : 'r'}--1200`}>
            <h3 className={classes.linkTitle} children={shop.title} />
            {shop.links.map((link, i) => {
              return (
                <a key={i}
                  href={link.url}
                  children={link.label}
                  className={classes.linkButton}
                  onClick={this.clickInteraction.bind(this, `${shop.title + link.label}Bottom`)} />
              );
            })}
          </div>
        </div>
      );
    };

    return (
      <section className={classes.shopAll}>
        <header className={classes.linkHeader}>
          <h2 className={classes.heading} children={content.title} />
        </header>
        {this.wrapGrid(content.shop.map(renderShop.bind(this)))}
      </section>
    );
  },

  // HELP

  renderHelp: function(classes, content) {
    if (!content) {
      return;
    }
    else {
      return (
        <section>
          {this.wrapGrid(
            <div className={classes.col}>
              <hr className={classes.hrHelp} />
              <a href={content.href}
                className={classes.help}
                children={content.copy}
                onClick={this.clickInteraction.bind(this, 'help')} />
            </div>
          )}
        </section>
      );
    }
  },

  render: function() {
    if (_.isEmpty(this.props.cms)) return false;

    const cms = this.props.cms || {};
    const classes = this.getClasses();
    const inHtoStarterKitExperiment = _.includes(
      ['withQuiz', 'withoutQuiz'],
      this.getExperimentVariant('htoStarterKit')
    );

    return (
      <div className={classes.block}>
        <Callout {...cms.hero} />

        {this.renderTouts(classes, cms.touts)}

        {inHtoStarterKitExperiment &&
          <StarterKits
            favorites={this.props.favorites}
            showFavorites={this.props.showFavorites}
            timesKitGroupsHaveShown={cms.timesKitGroupsHaveShown}
            kits={cms.activeStarterKits}
            session={this.props.session}
            settings={cms.starterKitSettings} />}

        {!this.inExperiment('htoStarterKit', 'withoutQuiz') &&
          <QuizPromo
            analyticsSlug={this.ANALYTICS_CATEGORY}
            hasMargins={!inHtoStarterKitExperiment}
            hasQuizResults={cms.hasQuizResults} />}

        {!inHtoStarterKitExperiment &&
          this.renderProducts(classes, cms.products)}

        {this.renderShopAll(classes, cms.shop_all)}

        {this.renderHelp(classes, cms.help)}
      </div>
    );
  }

});
