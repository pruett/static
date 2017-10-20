const React = require('react/addons');

const Picture = require('components/atoms/images/picture/picture');

const Mixins = require('components/mixins/mixins');


module.exports = React.createClass({
  displayName: 'MoleculesInsuranceHero',

  BLOCK_CLASS: 'c-insurance-hero',

  mixins: [
    Mixins.classes,
    Mixins.context,
    Mixins.image,
    Mixins.analytics
  ],

  propTypes: {
    body: React.PropTypes.string,
    header: React.PropTypes.string,
    image: React.PropTypes.array,
    link: React.PropTypes.object

  },

  getDefaultProps: function () {
    return {
      body: '',
      header: '',
      image: [],
      link: {}
    };
  },

  getStaticClasses: function () {
    return {
      block: `
        ${this.BLOCK_CLASS}
      `,
      copyWrapper: `
        u-mb36
        u-mb72--900
      `,
      image: `u-w100p u-mb30 u-mb60--1200`,
      grid: `u-grid u-tac`,
      header: `
        u-fs30 u-fs55--1200 u-tac u-ffs u-fws
        u-grid__col u-w12c u-w8c--900
        u-mb18 u-mb24--900
        u-reset
      `,
      body: `
        u-fs16 u-fs18--900
        u-grid__col u-w12c u-w6c--900
        u-lh26 u-lh28--900
        u-mb36 u-mb24--900
        u-color--dark-gray-alt-3
        u-reset
      `,
      linkWrapper: `
        u-w10c u-tac
        u-mla u-mra
      `,
      linkBody: `
        u-fs16 u-fws
        u-mb8
        u-di--900
        u-mr8--900
        u-reset
      `,
      linkText: `
        u-fws
      `
    }
  },

  getPictureAttrs: function (images, classes) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, 'desktop-sd'),
          widths: this.getImageWidths(900, 2200, 5),
          mediaQuery: '(min-width: 900px)'
        },
        {
          url: this.getImageBySize(images, 'tablet'),
          widths: this.getImageWidths(700, 1400, 5),
          mediaQuery: '(min-width: 600px)'
        },
        {
          url: this.getImageBySize(images, 'mobile'),
          widths: this.getImageWidths(300, 800, 5),
          mediaQuery: '(min-width: 0px)'
        }
      ],
      img: {
        alt: 'Warby Parker',
        className: classes.image
      }
    };
  },

  handleLinkClick: function () {
    this.trackInteraction('InsurancePage-clickLink-Fsa');
  },

  renderCopy: function (classes) {
    const link = this.props.link || {};

    return (
      <div className={classes.grid}>
        <div className={classes.copyWrapper}>
          <h1 children={this.props.header} className={classes.header} />
          <p children={this.props.body} className={classes.body} />
          <div className={classes.linkWrapper}>
            <h4 children={link.body} className={classes.linkBody} />
            <a
              children={link.link_text}
              onClick={this.handleLinkClick}
              href={link.link_href}
              className={classes.linkText} />
          </div>
        </div>
      </div>
    );
  },

  render: function () {
    const classes = this.getClasses();
    const pictureAttrs = this.getPictureAttrs(this.props.image, classes);

    return (
      <div className={classes.block}>
        <Picture className={classes.picture}
                  children={this.getPictureChildren(pictureAttrs)} />
        {this.renderCopy(classes)}
      </div>
    );
  }

});

