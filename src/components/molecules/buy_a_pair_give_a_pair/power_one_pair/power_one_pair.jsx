const _ = require('lodash');
const React = require('react/addons');
const Markdown = require('components/molecules/markdown/markdown');
const Picture = require('components/atoms/images/picture/picture');
const Img = require('components/atoms/images/img/img');
const Mixins = require('components/mixins/mixins');

module.exports = React.createClass({
  displayName: 'MoleculesBapGapPowerOnePair',

  BLOCK_CLASS: 'c-bapgap-power-one-pair',

  mixins: [
    Mixins.classes,
    Mixins.context,
    Mixins.image
  ],

  propTypes: {
    header: React.PropTypes.string,
    footnote: React.PropTypes.string,
    formula: React.PropTypes.objectOf({
      equal: React.PropTypes.string,
      plus: React.PropTypes.string,
      left: React.PropTypes.objectOf({
        text: React.PropTypes.string,
        image: React.PropTypes.string
      }),
      middle: React.PropTypes.objectOf({
        text: React.PropTypes.string,
        image: React.PropTypes.string
      }),
      right: React.PropTypes.objectOf({
        text: React.PropTypes.string,
        image: React.PropTypes.string
      })
    })
  },

  getStaticClasses() {
    const ITEM_CLASS = `
      u-grid__col -col-bottom
      u-w8c u-tac u-mla u-mra
      u-ffss u-fs16 u-fs18--600
    `;

    const TEXT_CLASS = `
      u-ffss u-fs16 u-fs18--900 u-mt18 
    `;

    return {
      block: `
        ${this.BLOCK_CLASS}
        u-grid -maxed u-ma u-tac
      `,
      row: `
        u-grid__row -center
      `,
      header: `
        u-reset u-heading-md
        u-mt48 u-mt72--1200 u-mb24
      `,
      footnote: `
        u-mt24
        u-ffss u-fs12
        u-color--dark-gray-alt-2
      `,
      list: `
        u-grid__col
        u-w12c -c-8--900
        u-tac
      `,
      item: `
        ${ITEM_CLASS}
        u-w3c--600
      `,
      item2: `
        ${ITEM_CLASS}
        u-w1c--600
      `,
      text: `
        ${TEXT_CLASS}
      `,
      text2: `
        ${TEXT_CLASS}
        u-ml18 u-mr18
      `,
      sign: `
        u-mt24 u-mb24
        u-ffss u-fs30 u-fs48-600
      `
    };
  },

  getImageSizes() {
    return this.getImgSizes([
      {
        breakpoint: 0,
        width: '100px'
      }
    ]);
  },

  getImageSrcSet(imageUrl) {
    return this.getSrcSet({
      quality: 100,
      url: imageUrl,
      widths: this.getImageWidths(60, 100, 1)
    });
  },

  render() {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <div className={classes.row}>
          <h2 className={classes.header} children={this.props.header} />
          <div className={classes.list}>
            <div className={classes.item}>
              <Img
                alt={this.props.formula.left.text}
                sizes={this.getImageSizes()}
                srcSet={this.getImageSrcSet(this.props.formula.left.image)} />
              <Markdown
                key={'left'}
                rawMarkdown={this.props.formula.left.text}
                className={classes.text}
                cssBlock={'u-reset'} />
            </div>
            <div className={classes.item2}>
              <p className={classes.sign} children={this.props.formula.equal} />
            </div>
            <div className={classes.item}>
              <Img
                alt={this.props.formula.middle.text}
                sizes={this.getImageSizes()}
                srcSet={this.getImageSrcSet(this.props.formula.middle.image)} />
              <Markdown
                key={'middle'}
                rawMarkdown={this.props.formula.middle.text}
                className={classes.text2}
                cssBlock={'u-reset'} />
            </div>
            <div className={classes.item2}>
              <p className={classes.sign} children={this.props.formula.plus} />
            </div>
            <div className={classes.item}>
              <Img
                alt={this.props.formula.right.text}
                sizes={this.getImageSizes()}
                srcSet={this.getImageSrcSet(this.props.formula.right.image)} />
              <Markdown
                key={'right'}
                rawMarkdown={this.props.formula.right.text}
                className={classes.text2}
                cssBlock={'u-reset'} />
            </div>
          </div>
          <div className={classes.footnote}>
            <Markdown
              key={'footnote'}
              rawMarkdown={this.props.footnote}
              cssBlock={'u-reset'} />
          </div>
        </div>
      </div>
    );
  }

});
