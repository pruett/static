const React = require('react/addons');

const Markdown = require('components/molecules/markdown/markdown');
const Mixins = require('components/mixins/mixins');

require('./header.scss');

module.exports = React.createClass({
  displayName: 'BirthdayHeader',
  BLOCK_CLASS: 'c-birthday-header',
  mixins: [ Mixins.classes, Mixins.context ],
  propTypes: {
    active: React.PropTypes.bool,
    copy: React.PropTypes.object,
    images: React.PropTypes.object
  },
  getDefaultProps: function() {
    return {
      copy: {
        hero: {},
        how: {},
        what: {},
        ended: {}
      },
      images: {},
      active: false
    };
  },
  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-tac u-mb48
      `,
      title: `
        u-reset u-ffss
        u-fs20 u-fs24--600 u-fs30--900
        u-ttu u-fwb
        u-mb18
        u-ls2_5
      `,
      body: `
        u-reset u-ffss
        u-fs16 u-fs18--600
        u-mb12
      `,
      grid: `
        u-grid -maxed u-ma
      `,
      hero: `
        ${this.BLOCK_CLASS}__hero
        u-p18
        u-pt42 u-pb42
        u-mb60
        u-pb0--600
      `,
      heroRow: `
        u-grid__row
      `,
      heroCol: `
        ${this.BLOCK_CLASS}__hero-col
        u-grid__col u-w12c u-w10c--600 u-w8c--900
      `,
      heroWrapper: `
        u-color-bg--dark-gray
        u-color--white
        u-p24 u-pt48 u-pt42--900
        u-pb48 u-pb72--600 u-pb42--900
        u-pr
      `,
      heroImg: `
        u-w12c u-w8c--600 u-w6c--900
        u-mb36
      `,
      heroTitle: `
        u-ffs u-fsi u-reset
        u-ls1
        u-fs14 u-fs16--600 u-fs18--900
        u-mb36
      `,
      heroBody: `
        u-reset
        u-ffss u-fs16 u-fs18--600
        u-w12c u-w10c--600 u-w8c--900
        u-ma
      `,
      heroBadge: `
        ${this.BLOCK_CLASS}__badge
        u-pa u-r0 u-b0
      `,
      questions: `
        u-grid -maxed u-ma
        u-mb84
      `,
      question: `
        u-pr
        u-w8c--600 u-l2c--600
        u-w6c--900 u-l3c--900
        u-mb48
      `,
      markdown: `
        ${this.BLOCK_CLASS}
      `
    };
  },
  render: function() {
    const classes = this.getClasses();
    const { copy = {}, images = {} } = this.props;
    const hero = copy.hero || {};

    const bgStyle = { backgroundImage: `url(${images.hero_bg})` };

    const questions = this.props.active ? ['what', 'how'] : ['ended'];

    return (
      <section className={classes.block}>
        <section className={classes.hero} style={bgStyle}>
          <section className={classes.grid}>
            <div className={classes.heroRow}>
              <div className={classes.heroCol}>
                <div className={classes.heroWrapper}>
                  <h2 className={classes.heroTitle} children={hero.title} />
                  <img src={images.hero_title} className={classes.heroImg} />
                  <p className={classes.heroBody} children={hero.body} />
                  <img src={images.hero_badge} className={classes.heroBadge} />
                </div>
              </div>
            </div>
          </section>
        </section>
        <section className={classes.questions}>
          {questions.map((question, index) => {
            const {title = '', body = ''} = copy[question] || {};
            return (
              <section key={index} className={classes.question}>
                <h2 className={classes.title} children={title} />
                <Markdown
                  cssBlock={classes.markdown}
                  cssModifiers={{ p: classes.body }}
                  rawMarkdown={body}
                />
              </section>
            );
          })}
        </section>
      </section>
    );
  }
});
