const React = require('react/addons');

const Img = require('components/atoms/images/img/img');
const Picture = require('components/atoms/images/picture/picture');
const Faq = require('components/molecules/expanding_faq/expanding_faq');

const Mixins = require('components/mixins/mixins');

require('./prizes.scss');

module.exports = React.createClass({
  displayName: 'BirthdayPrizes',
  BLOCK_CLASS: 'c-birthday-prizes',
  ANALYTICS_CATEGORY: 'seventhBirthday',
  mixins: [Mixins.analytics, Mixins.classes, Mixins.context],
  propTypes: { copy: React.PropTypes.object, images: React.PropTypes.object },
  getDefaultProps: function() {
    return {
      copy: {
        lead: '',
        hero: {},
        comm: {},
        eyes: {},
        brain: {},
        library: {},
        ears: {},
        funny: {},
        mind: {}
      },
      images: {
        hero: {}
      }
    };
  },
  getStaticClasses: function() {
    const wrapper = `
      u-ma
      u-pr18 u-pl18
      u-pl18--600 u-pl36--1200
      u-pr18--600 u-pr36--1200
      u-w11c u-w6c--600 u-w10c--900 u-w8c--1200
    `;

    const wrapperFloat = `
      ${wrapper}
      u-pt42 u-pt60--600
      u-pb42 u-pb60--600
      u-pr24 u-pr48--600
      u-pl24 u-pl48--600
    `;

    return {
      block: (
        `
        ${this.BLOCK_CLASS}
        u-df
        u-flexw--w
        u-mw1440 u-ma
        u-tac`
      ),
      title: (
        `
        u-pr
        u-reset
        u-fwb u-ffss
        u-fs24 u-fs30--900
        u-ls2
        u-ttu
        u-mb18`
      ),
      lead: (
        `
        u-pr
        u-fs14 u-ffs u-fsi u-ls1
        u-mb18 u-db`
      ),
      body: (
        `
        u-pr
        u-reset
        u-fs16 u-fs18--900
        u-w11c u-w12c--600 u-w12c--900
        u-ma
        u-ffss
        u-mb18`
      ),
      link: (
        `
        ${this.BLOCK_CLASS}__link
        u-fs16 u-fs18--900
        u-link--unstyled
        u-fws u-pb4`
      ),
      hero: (
        `
        ${this.BLOCK_CLASS}__container--letters
        u-w100p u-mb8--900
      `
      ),
      heroWrapper: (
        `
        ${this.BLOCK_CLASS}__hero-wrapper
        u-ma
        u-p48
        u-pt96--600 u-pt120--600
        u-pb96--600
        u-w9c--600 u-w8c--600`
      ),
      heroTitle: (
        `
        u-mb24`
      ),
      heroBody: (
        `
        u-reset
        u-fs16 u-fs18--900
        u-w11c--900
        u-ma
        u-ffss
        u-mb18`
      ),
      comm: (
        `
        ${this.BLOCK_CLASS}__communications
        u-df
        u-pt120 u-pb120
        u-w12c u-w6c--900
        u-color-bg--dark-gray
        u-bc--white u-bss u-bw0 u-brw4--900
        u-color--white`
      ),
      commWrapper: wrapper,
      eyes: (
        `
        u-df
        u-bgs--cv
        u-pt72 u-pb72
        u-pl12 u-pr12
        u-bc--white u-bss u-bw0 u-blw4--900
        u-w12c u-w6c--900 u-color--white`
      ),
      eyesWrapper: (
        `
        ${this.BLOCK_CLASS}__wrapper--shadow
        ${wrapperFloat} u-color-bg--blue`
      ),
      brain: (
        `
        ${this.BLOCK_CLASS}__container--letters
        u-pt42--900
        u-pb72 u-pb0--600
        u-w12c u-pr u-oh u-df--1200
        u-mt8--900 u-mb8--900`
      ),
      brainMore: `u-link--unstyled`,
      brainWrapper: (
        `
        u-ma u-ma--1200
        u-mb42
        u-mt42 u-mt60--600
        u-pr24 u-pl24
        u-w10c u-w3c--1200`
      ),
      riddles: (
        `
        ${this.BLOCK_CLASS}__riddles
        u-p24 u-p48--600
        u-pt60--600 u-pb60--600
        u-ma u-ml0--1200
        u-w11c u-w10c--1200
        u-tal`
      ),
      riddle: (
        `
        ${this.BLOCK_CLASS}__riddle
        u-bc--blue u-b0 u-bbw1 u-bbss
        u-fs16 u-fs18--900 u-ffss
        u-pt12 u-pb12
        u-pr72--600 u-pr120--900`
      ),
      library: (
        `
        u-df
        u-pt72 u-pb72
        u-pl12 u-pr12
        u-bgs--cv
        u-w12c u-w6c--900
        u-color--white
        u-bc--white u-bss u-bw0 u-brw4--900`
      ),
      libraryWrapper: (
        `
        ${this.BLOCK_CLASS}__wrapper--shadow
        ${wrapperFloat} u-color-bg--dark-gray`
      ),
      ears: (
        `
        u-df
        u-pt72 u-pb72
        u-w12c u-w6c--900
        u-color-bg--blue
        u-color--white
        u-bc--white u-bss u-bw0 u-blw4--900`
      ),
      earsWrapper: (
        `
        ${wrapper}`
      ),
      funny: (
        `
        ${this.BLOCK_CLASS}__container--letters
        u-w12c u-df--900
        u-pt72 u-pb72
        u-mt8--900 u-mb8--900`
      ),
      funnyWrapper: (
        `
        u-ma u-mb36
        u-pr18 u-pl18
        u-pt18--900
        u-pb18--900
        u-pl18--600 u-pl36--900
        u-pr18--600 u-pr36--900
        u-w11c u-w10c--600 u-w5c--900`
      ),
      funnyImg: (
        `
        u-ma
        u-mb36 u-mba--900
        u-w10c u-w4c--600
      `
      ),
      mind: (
        `
        ${this.BLOCK_CLASS}__mind
        u-pt72 u-pt0--1200
        u-pb72 u-pb0--1200
        u-df--1200
        u-w12c
        u-color-bg--dark-gray u-color--white
        u-pr u-oh`
      ),
      mindWrapper: (
        `
        u-ma u-m0--1200
        u-mb36
        u-w10c u-w6c--600 u-w8c--900
        u-h100p--1200`
      ),
      mindCopy: (
        `
        u-pa--1200
        u-mt42--1200
        u-l25p--1200
        u-t50p--1200
        u-ttn50n50--1200
      `
      ),
      books: (
        `
        ${this.BLOCK_CLASS}__books
        u-tal--1200
        u-w8c--600
        u-pl24 u-pr24
        u-pt60--1200
        u-pb48 u-pb36--900 u-pb42--1200
        u-ma`
      ),
      book: (
        `
        u-dib--1200
        u-mb18 u-mr6`
      ),
      bookBg: (
        `
        ${this.BLOCK_CLASS}__book-bg
        u-dn u-db--1200
        u-pa u-b0
        u-mln6--1200
        u-l25p--1200
        u-ttxn50--1200`
      ),
      bookTitle: (
        `
        u-reset u-fws
        u-fs16 u-fs18--1200 u-ffss`
      ),
      bookAuthor: (
        `
        u-reset u-fsi
        u-fs16 u-fs18--1200 u-ffss`
      ),
      bookDescription: (
        `
        u-reset
        u-fs16 u-fs18--1200 u-ffss
        u-w11c u-w12c
        u-ma `
      ),
      pencil: (
        `
        ${this.BLOCK_CLASS}__pencil
        u-pa`
      ),
      answers: 'u-grid -maxed u-ma u-mt60--900 u-mb60--900 u-w100p u-oh'
    };
  },
  renderBook: function(classes, book, index) {
    return (
      <div className={classes.book} key={index}>
        <a
          href={book.href}
          target="_blank"
          onClick={this.clickInteraction.bind(this, `book-${book.title}`)}
        >
          <h3 children={book.title} className={classes.bookTitle} />
        </a>
        <h4 children={book.author} className={classes.bookAuthor} />
        <p children={book.description} className={classes.bookDescription} />
      </div>
    );
  },
  renderRiddle: function(classes, riddle, index) {
    return <li key={index} className={classes.riddle} children={riddle} />;
  },
  getSrcSet: function(img, w) {
    const w2 = w * 2;
    return `${img}?width=${w} ${w}w, ${img}?width=${w2} ${w2}w`;
  },
  getBg: function(image, w) {
    return { backgroundImage: `url(${image}?width=${w})` };
  },
  render: function() {
    const classes = this.getClasses();
    const { copy = {}, images = {} } = this.props;

    const {
      hero = {},
      comm = {},
      eyes = {},
      brain = {},
      library = {},
      ears = {},
      funny = {},
      mind = {},
      answers = {}
    } = copy;

    const { desktop = '', tablet = '', mobile = '' } = images.hero || {};
    const section = {
      section_id: 'answers',
      section_title: answers.title,
      section_faqs: answers.sections
    };

    return (
      <section className={classes.block}>

        <section
          className={classes.hero}
          style={this.getBg(images.letters, 439)}
        >
          <div className={classes.heroWrapper}>
            <Picture>
              <source
                srcSet={this.getSrcSet(desktop, 600)}
                sizes="50vw"
                media="(min-width: 900px)"
              />
              <source
                srcSet={this.getSrcSet(tablet, 535)}
                sizes="70vw"
                media="(min-width: 600px)"
              />
              <Img
                srcSet={this.getSrcSet(mobile, 265)}
                alt={hero.title}
                sizes="80vw"
                cssModifier={classes.heroTitle}
              />
            </Picture>
            <p className={classes.heroBody} children={hero.body} />
          </div>
        </section>

        <section className={classes.comm}>
          <div className={classes.commWrapper}>
            <span className={classes.lead} children={copy.lead} />
            <h2 className={classes.title} children={comm.title} />
            <p className={classes.body} children={comm.body} />
            <a
              href={comm.href}
              target="_blank"
              className={classes.link}
              children={comm.link}
              onClick={this.clickInteraction.bind(this, 'communications')}
            />
          </div>
        </section>

        <section className={classes.eyes} style={this.getBg(images.map, 700)}>
          <div className={classes.eyesWrapper}>
            <span className={classes.lead} children={copy.lead} />
            <h2 className={classes.title} children={eyes.title} />
            <p className={classes.body} children={eyes.body} />
            <a
              href={eyes.href}
              target="_blank"
              className={classes.link}
              children={eyes.link}
              onClick={this.clickInteraction.bind(this, 'eyes')}
            />
          </div>
        </section>

        <section
          className={classes.brain}
          style={this.getBg(images.letters, 439)}
        >
          <div className={classes.brainWrapper}>
            <span className={classes.lead} children={copy.lead} />
            <h2 className={classes.title} children={brain.title} />
            <p className={classes.body} children={brain.body} />
            <a
              href={'#answers'}
              className={classes.brainMore}
              children={brain.more}
              onClick={this.clickInteraction.bind(this, 'brain')}
            />
          </div>
          <Img
            cssModifier={classes.pencil}
            srcSet={this.getSrcSet(images.pencil, 347)}
            sizes="346px"
            alt="pencil"
          />
          <ol
            className={classes.riddles}
            style={this.getBg(images.paper)}
            children={(brain.riddles || []).map(riddle =>
              this.renderRiddle(classes, riddle))}
          />
        </section>

        <section
          className={classes.library}
          style={this.getBg(images.reading, 700)}
        >
          <div className={classes.libraryWrapper}>
            <span className={classes.lead} children={copy.lead} />
            <h2 className={classes.title} children={library.title} />
            <p className={classes.body} children={library.body} />
            <a
              href={library.href}
              target="_blank"
              className={classes.link}
              children={library.link}
              onClick={this.clickInteraction.bind(this, 'library')}
            />
          </div>
        </section>

        <section className={classes.ears}>
          <div className={classes.earsWrapper}>
            <span className={classes.lead} children={copy.lead} />
            <h2 className={classes.title} children={ears.title} />
            <p className={classes.body} children={ears.body} />
            <a
              href={ears.href}
              target="_blank"
              className={classes.link}
              children={ears.link}
              onClick={this.clickInteraction.bind(this, 'ears')}
            />
          </div>
        </section>

        <section
          className={classes.funny}
          style={this.getBg(images.letters, 439)}
        >
          <div className={classes.funnyWrapper}>
            <span className={classes.lead} children={copy.lead} />
            <h2 className={classes.title} children={funny.title} />
            <p className={classes.body} children={funny.body} />
            <p className={classes.body} children={funny.rules} />
            <p className={classes.body} children={funny.rating} />
          </div>
          <div className={classes.funnyImg}>
            <Img
              alt={funny.title}
              sizes="(min-width: 1200px) 350px, 279px"
              srcSet={this.getSrcSet(images.beehive, 350)}
            />
          </div>
        </section>

        <section className={classes.mind}>
          <div className={classes.mindWrapper}>
            <Picture>
              <source
                srcSet={this.getSrcSet(images.book, 500)}
                media="(min-width: 1200px)"
                sizes="500px"
              />
              <img
                src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"
                className={classes.bookBg}
                alt="book"
              />
            </Picture>
            <div className={classes.mindCopy}>
              <span className={classes.lead} children={copy.lead} />
              <h2 className={classes.title} children={mind.title} />
              <p className={classes.body} children={mind.body} />
            </div>
          </div>
          <div
            className={classes.books}
            children={(mind.books || []).map(book =>
              this.renderBook(classes, book))}
          />
        </section>

        <section className={classes.answers}>
          <Faq section={section} />
        </section>

      </section>
    );
  }
});
