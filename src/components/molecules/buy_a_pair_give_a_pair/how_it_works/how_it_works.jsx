const _ = require('lodash');
const React = require('react/addons');
const Markdown = require('components/molecules/markdown/markdown');
const Picture = require('components/atoms/images/picture/picture');
const Mixins = require('components/mixins/mixins');

module.exports = React.createClass({
  displayName: 'MoleculesBapGapHowItWorks',

  BLOCK_CLASS: 'c-bapgap-how-it-works',

  mixins: [
    Mixins.classes,
    Mixins.context,
    Mixins.image
  ],

  propTypes: {
    header: React.PropTypes.string,
    description: React.PropTypes.array,
    images: React.PropTypes.objectOf({
      desktop: React.PropTypes.string,
      tablet: React.PropTypes.string,
      mobile: React.PropTypes.string
    })
  },

  getStaticClasses() {
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
      description: `
        u-grid__col
        u-w12c -c-8--900
        u-reset u-mb24
        u-ffss u-fs16 u-fs18--900
      `,
      image: `
        u-grid__col
        u-w12c -c-10--900
        u-mt24 u-mt48--1200
      `,
    };
  },

  getImageSources() {
    return [
      {
        url: this.props.images.desktop,
        widths: [ 360, 460, 560, 768, 900, 1042 ],
        mediaQuery: '(min-width: 320px)'
      }
    ];
  },

  render() {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <div className={classes.row}>
          <h2 className={classes.header} children={this.props.header} />
          {this.props.description.map( (description, index) => {
            return (
              <Markdown
                key={index}
                rawMarkdown={description}
                className={classes.description}
                cssBlock={'u-reset'} />
            );
          })}
          <Picture
            cssModifier={classes.image}
            children={this.getPictureChildren({sources: this.getImageSources()})} />
        </div>
      </div>
    );
  }

});
