const React = require('react/addons');

const Faq = require('components/molecules/expanding_faq/expanding_faq');
const Frame = require('components/molecules/collections/utility/frame/frame');

const Mixins = require('components/mixins/mixins');

module.exports = React.createClass({
  displayName: 'BirthdayFooter',
  BLOCK_CLASS: 'c-birthday-footer',
  mixins: [Mixins.analytics, Mixins.classes, Mixins.dispatcher, Mixins.context],
  propTypes: {
    copy: React.PropTypes.object,
    images: React.PropTypes.object,
    frames: React.PropTypes.array
  },
  getDefaultProps: function() {
    return {
      frames: [],
      copy: {}
    };
  },
  getStaticClasses: function() {
    return {
      block: (
        `
        ${this.BLOCK_CLASS}
        u-tac
      `
      ),
      body: (
        `
        u-reset u-ffss
        u-fs16 u-fs18--600
        u-mb12
      `
      ),
      grid: (
        `
        u-grid -maxed u-ma
      `
      ),
      prizes: (
        `
        u-df--900 u-color--white
        u-ffss
        u-mw1440 u-ma
      `
      ),
      prizeWrapper: (
        `
        u-w10c u-w6c--600 u-w8c--900 u-ma
        u-mw600
      `
      ),
      prizeCta: (
        `
        u-color--dark-gray
        u-button -button-white -button-large
        u-fws u-ttu u-fs16
        u-mt24
      `
      ),
      prizeTitle: (
        `
        u-reset
        u-fs24 u-fs30--600 u-fs40--900
        u-ttu u-fwb
        u-mb24 u-ma
        u-w8c--900
        u-ls2_5
      `
      ),
      winner: (
        `
        u-w100p u-w6c--900
        u-color-bg--blue
        u-pt84 u-pt72--600
        u-pb84 u-pb72--600
        u-mr6--900
      `
      ),
      loser: (
        `
        u-w100p u-w6c--900
        u-color-bg--dark-gray
        u-pt84 u-pt72--600
        u-pb84 u-pb72--600
        u-ml6--900
      `
      ),
      frames: (
        `
        u-tac
        u-pt60 u-pt96--900
        u-mw960 u-ma
      `
      ),
      framesWrapper: (
        `
        u-tac
      `
      ),
      framesTitle: (
        `
        u-reset u-ffss
        u-fs20 u-fs24--600 u-fs30--900
        u-ttu u-fwb
        u-ls2_5
        u-tac
        u-mb12
      `
      ),
      framesBody: (
        `
        u-reset u-ffss
        u-fs16 u-fs18--600
        u-tac u-ma
        u-w10c u-w12c--600
        u-mb48 u-mb60--900
      `
      ),
      frame: (`
        "u-dib
        u-w11c u-w6c--600
        u-mb60
        u-pr24--600 u-pl24--600
        u-pl48--900 u-pr48--900";
      `),
      terms: (
        `
        u-grid -maxed
        u-ma u-mb84--900
        u-oh
      `
      )
    };
  },
  handleClick: function(target) {
    this.trackInteraction(`seventhBirthday-click-${target}`);
  },
  renderFrame: function(classes, womensOnlyIds = [], frame, i) {
    // TODO: Remove inactive products on Python side.
    const womenOnly = womensOnlyIds.indexOf(frame.product_id) > -1;
    const gendered_links = womenOnly ? ['f'] : ['f', 'm'];
    return (
      <Frame
        {...frame}
        key={i}
        cssModifierBlock={classes.frame}
        gaCategory="seventhBirthday"
        gaList="SeventhBirthday"
        renderLinks={true}
        gendered_links={gendered_links}
      />
    );
  },
  render: function() {
    const classes = this.getClasses();
    const { copy } = this.props;

    const {
      winner = {},
      loser = {},
      frames = {},
      terms = {}
    } = copy;

    const section = {
      section_id: 'terms',
      section_title: terms.title,
      section_faqs: terms.sections,
      section_intro: terms.intro
    };

    return (
      <section className={classes.block}>
        <section className={classes.prizes}>
          <div className={classes.winner}>
            <div className={classes.prizeWrapper}>
              <h2 className={classes.prizeTitle} children={winner.title} />
              <p className={classes.body} children={winner.body} />
              <a
                href={winner.link}
                className={classes.prizeCta}
                children={winner.cta}
                onClick={this.handleClick.bind(this, 'winner')}
              />
            </div>
          </div>
          <div className={classes.loser}>
            <div className={classes.prizeWrapper}>
              <h2 className={classes.prizeTitle} children={loser.title} />
              <p className={classes.body} children={loser.body} />
              <a
                href={loser.link}
                className={classes.prizeCta}
                children={loser.cta}
                onClick={this.handleClick.bind(this, 'loser')}
              />
            </div>
          </div>
        </section>
        <section className={classes.grid}>
          <section className={classes.frames}>
            <h2 className={classes.framesTitle} children={frames.title} />
            <p className={classes.framesBody} children={frames.body} />
            <div
              className={classes.framesWrapper}
              children={this.props.frames.map(
                this.renderFrame.bind(this, classes, frames.womens_only_ids)
              )}
            />
          </section>
        </section>
        <section className={classes.terms}>
          <Faq section={section} />
        </section>
      </section>
    );
  }
});
