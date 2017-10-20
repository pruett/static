const _ = require('lodash');
const React = require('react/addons');
const Markdown = require('components/molecules/markdown/markdown');
const Picture = require('components/atoms/images/picture/picture');
const Img = require('components/atoms/images/img/img');
const Mixins = require('components/mixins/mixins');

module.exports = React.createClass({
  displayName: 'MoleculesBapGapConclusion',

  BLOCK_CLASS: 'c-bapgap-conclusion',

  mixins: [
    Mixins.classes,
    Mixins.context,
    Mixins.image
  ],

  propTypes: {
    description: React.PropTypes.array,
    icon: React.PropTypes.string,
    images: React.PropTypes.arrayOf({
      desktop: React.PropTypes.string,
      tablet: React.PropTypes.string,
      mobile: React.PropTypes.string
    })
  },

  getStaticClasses() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-mb84 u-mb96--1200
      `,
      row: `
        u-grid -maxed u-ma u-tac
      `,
      description: `
        u-grid__col
        u-w12c -c-9--900
        u-reset u-heading-md
        u-mt24 u-mb24
      `,
      icon: `
        u-grid__col
        u-w12c -c-2--900
      `,
      icon: `
        u-grid__col
        u-w12c -c-10--900
      `,
      gallery: `
        gallery
        u-mt84 u-mt96--1200
        u-mb84 u-mb96--1200
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

  getImageSources(image) {
    return [
      {
        url: image.desktop,
        widths: [ 160, 200, 240, 300, 320, 360, 460 ],
        mediaQuery: '(min-width: 320px)'
      }
    ];
  },

  getImageSizes() {
    return this.getImgSizes([
      {
        breakpoint: 0,
        width: '70px'
      },
      {
        breakpoint: 600,
        width: '130px'
      }
    ]);
  },

  getImageSrcSet() {
    return this.getSrcSet({
      quality: 100,
      url: this.props.icon,
      widths: this.getImageWidths(70, 130, 1)
    });
  },

  render() {
    const classes = this.getClasses();
    const imgSets = _.chunk(this.props.images, 2);

    return (
      <div className={classes.block}>
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
        <div className={classes.row}>
          <div className={classes.icon}>
            <Img
              sizes={this.getImageSizes()}
              srcSet={this.getImageSrcSet()} />
          </div>
        </div>
        <div className={classes.row}>
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
      </div>
    );
  }

});
