const _ = require('lodash');
const React = require('react/addons');
const Markdown = require('components/molecules/markdown/markdown');
const Picture = require('components/atoms/images/picture/picture');
const Img = require('components/atoms/images/img/img');
const Mixins = require('components/mixins/mixins');

require('./introduction.scss');

module.exports = React.createClass({
  displayName: 'MoleculesBapGapIntroduction',

  BLOCK_CLASS: 'c-bapgap-introduction',

  mixins: [
    Mixins.classes,
    Mixins.context,
    Mixins.image
  ],

  propTypes: {
    header: React.PropTypes.string,
    subHeader: React.PropTypes.string,
    description: React.PropTypes.array,
    images: React.PropTypes.arrayOf({
      desktop: React.PropTypes.string,
      tablet: React.PropTypes.string,
      mobile: React.PropTypes.string
    })
  },

  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
      `,
      row: `
        u-grid -maxed u-ma u-tac
      `,
      header: `
        u-ffss u-fs12 u-fws
        u-mt48 u-mt72--1200 u-mb24
        u-ls2_5 u-ttu
      `,
      subHeader: `
        u-grid__col
        u-w12c -c-6--900
        u-reset u-heading-lg u-mb24
      `,
      description: `
        u-grid__col
        u-w12c -c-9--900 -c-7--1200
        u-reset u-mb48 u-mb72--1200
        u-ffss u-fs16 u-fs18--900
      `,
      gallery: `
        gallery u-mb48
      `,
      galleryInner: `
        gallery__inner
      `,
      galleryColumn: `
        gallery__column
      `,
      galleryItem: `
        gallery__item
      `
    };
  },

  getImageSources: function(image) {
    return [
      {
        url: image.desktop,
        widths: [ 160, 200, 240, 300, 320, 360, 460 ],
        mediaQuery: '(min-width: 320px)'
      }
    ];
  },

  render: function() {
    const classes = this.getClasses();
    const imgSets = _.chunk(this.props.images, 2);

    return (
      <div className={classes.block}>
        <div className={classes.row}>
          <h1 className={classes.header} children={this.props.header} />
          <h2 className={classes.subHeader} children={this.props.subHeader} />
          {this.props.description.map( (description, index) => {
            return (
              <Markdown
                key={index}
                rawMarkdown={description}
                className={classes.description}
                cssBlock={'u-reset'} />
            );
          })}
        </div>
        <div className={classes.gallery}>
          <div className={classes.galleryInner}>
            {imgSets.map( (imgSet, i) => {
              return (
              <div key={i} className={classes.galleryColumn}>
                {imgSet.map( (imgSrc, j) => {
                  return (
                    <div key={i+j} className={classes.galleryItem}>
                      <Picture children={this.getPictureChildren({sources: this.getImageSources(imgSrc)})} />
                    </div>
                  );
                })}
              </div>
              );
            })}
          </div>
        </div>
      </div>
    );
  }

});
