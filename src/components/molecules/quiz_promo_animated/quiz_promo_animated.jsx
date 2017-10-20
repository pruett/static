const React = require('react/addons');
const Mixins = require('components/mixins/mixins');
const Picture = require('components/atoms/images/picture/picture');
const RightArrow = require('components/quanta/icons/right_arrow/right_arrow');

require('./quiz_promo_animated.scss');

module.exports = React.createClass({
  BLOCK_CLASS: 'c-quiz-promo-animated',

  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.image
  ],

  getDefaultProps: function() {
    return {
      analyticsSlug: '',
      hasMargins: true,
      hasQuizResults: false,
      copy: {
        header: 'Need help? Take a quiz!',
        subhead: 'Answer 5 quick questions and we’ll suggest some great-looking glasses to fill your Home Try-On.',
        cta: 'Start the quiz'
      },
      hasResultsCopy: {
        header: 'Want more suggestions?',
        subhead: 'Retake our quiz or take a look at the frames we already recommended.',
        cta: 'Take quiz again',
        link: 'See results'
      },
      deviceUrls: {
        mobile: '//i.warbycdn.com/v/c/assets/quiz-promo/image/device-phone/1/706570675e.png',
        tablet: '//i.warbycdn.com/v/c/assets/quiz-promo/image/device-tablet/0/184c1b8497.png',
        desktop: '//i.warbycdn.com/v/c/assets/quiz-promo/image/device-desktop/0/df6c9f236b.png'
      },
      slideUrls: [
        {
          mobile: '//i.warbycdn.com/v/c/assets/quiz-promo/image/slide-0-mobile/0/5b44d89f9b.jpg',
          tablet: '//i.warbycdn.com/v/c/assets/quiz-promo/image/slide-0-tablet/0/c30c9a3460.jpg',
          desktop: '//i.warbycdn.com/v/c/assets/quiz-promo/image/slide-0-desktop/0/eb504d87d2.jpg'
        },
        {
          mobile: '//i.warbycdn.com/v/c/assets/quiz-promo/image/slide-1-mobile/0/6f558c6e2e.jpg',
          tablet: '//i.warbycdn.com/v/c/assets/quiz-promo/image/slide-1-tablet/0/e0443fd657.jpg',
          desktop: '//i.warbycdn.com/v/c/assets/quiz-promo/image/slide-1-desktop/0/f96af1efa1.jpg'
        },
        {
          mobile: '//i.warbycdn.com/v/c/assets/quiz-promo/image/slide-2-mobile/0/fc893d76c1.jpg',
          tablet: '//i.warbycdn.com/v/c/assets/quiz-promo/image/slide-2-tablet/0/5663257745.jpg',
          desktop: '//i.warbycdn.com/v/c/assets/quiz-promo/image/slide-2-desktop/0/32f69cc91a.jpg'
        }
      ]
    };
  },

  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-pr
        u-oh
        u-mw1440
        u-mla u-mra
        u-tac
        u-color-bg--light-gray-alt-5
      `,
      colLeft: `
        u-pr
        u-w7c--900
        u-fl--900
        u-h100p--900
      `,
      colRight: `
        u-pr
        u-w5c--900
        u-fr--900
        u-h100p--900
      `,
      imageContainer: `
        ${this.BLOCK_CLASS}__image-container
        u-pr u-pa--900
        u-oh
        u-r0 u-t0
        u-mla u-mra
        u-mt36 u-mt48--600 u-mt72--900
        u-color-bg--white
      `,
      slideImage: `
        ${this.BLOCK_CLASS}__slide
        u-pa u-l0 u-r0 u-t0 u-b0
      `,
      deviceImage: `
        u-pa u-l0 u-r0 u-t0 u-b0
      `,
      content: `
        ${this.BLOCK_CLASS}__content
        u-pa--900 u-center--900
        u-pt36 u-pt48--600 u-pt0--900
        u-pr24--900
        u-mw100p
        u-mla u-mra
      `,
      header: `
        u-ffs u-fws
        u-fs24 u-fs30--600 u-fs40--900
        u-m0
      `,
      subhead: `
        u-mt12 u-mb30
        u-ml18 u-ml6--900
        u-mr18 u-mr6--900
        u-fs16 u-fs18--900
        u-lh24 u-lh26--900
        u-color--dark-gray-alt-3
      `,
      cta: `
        ${this.BLOCK_CLASS}__cta
        u-button -button-medium -button-clear
        u-fws
      `,
      arrow: `
        u-mt4 u-ml12
        u-fill--dark-gray
      `,
      link: `
        u-dib
        u-mt18
        u-fs16
        u-link--underline
      `
    };
  },

  classesWillUpdate: function() {
    return {
      block: {
        'u-mt48 u-mt60--600 u-mt72--900 u-mb48 u-mb60--600 u-mb72--900': this.props.hasMargins
      },
      slideImage: {
        'u-dn': typeof window !== 'object'
      }
    };
  },

  getPictureAttrs: function(urls) {
    return {
      sources: [
        {
          url: urls.desktop,
          widths: [ 1000, 2000 ],
          sizes: '1000px',
          quality: 80,
          mediaQuery: '(min-width: 900px)'
        },
        {
          url: urls.tablet,
          widths: [ 540, 1080 ],
          sizes: '540px',
          quality: 80,
          mediaQuery: '(min-width: 600px)'
        },
        {
          url: urls.mobile,
          widths: [ 280, 560 ],
          sizes: '280px',
          quality: 80,
          mediaQuery: '(min-width: 0px)'
        }
      ]
    }
  },

  render: function () {
    const classes = this.getClasses();
    const copy = this.props.hasQuizResults ? this.props.hasResultsCopy : this.props.copy;

    const ctaAnalytics = `${this.props.analyticsSlug}-click-${this.props.hasQuizResults ? 're' : ''}takeQuiz`
    const linkAnalytics = `${this.props.analyticsSlug}-click-seeQuizResults`

    return (
      <div className={classes.block}>
        <div className={classes.colRight}>
          <div className={classes.content}>
            <h3 className={classes.header} children={copy.header} />
            <p className={classes.subhead} children={copy.subhead} />
            <a
              href='/quiz?active=true'
              className={classes.cta}
              onClick={this.trackInteraction.bind(this, ctaAnalytics)}>
              {copy.cta}
              <RightArrow cssModifier={classes.arrow} />
            </a>
            <br />
            {this.props.hasQuizResults &&
              <a
                href='/quiz/results'
                className={classes.link}
                children={copy.link}
                onClick={this.trackInteraction.bind(this, linkAnalytics)} />}
          </div>
        </div>
        <div className={classes.colLeft}>
          <div className={classes.imageContainer}>
            {this.props.slideUrls.map((urls, i) => {
              return (
                <Picture
                  key={i}
                  cssModifier={`${classes.slideImage} -slide-${i}`}
                  children={this.getPictureChildren(this.getPictureAttrs(urls))} />
              );
            })}

            <Picture
              cssModifier={classes.deviceImage}
              children={this.getPictureChildren(this.getPictureAttrs(this.props.deviceUrls))} />
          </div>
        </div>
      </div>
    );
  }
});
