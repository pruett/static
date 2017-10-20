const _ = require('lodash');
const React = require('react/addons');
const Markdown = require('components/molecules/markdown/markdown');
const Picture = require('components/atoms/images/picture/picture');
const SliderActive = require('components/molecules/sliders/active/active');
const Mixins = require('components/mixins/mixins');

require('./our_partners.scss');

module.exports = React.createClass({
  displayName: 'MoleculesBapGapOurPartners',

  BLOCK_CLASS: 'c-bapgap-our-partners',

  mixins: [
    Mixins.classes,
    Mixins.context,
    Mixins.image
  ],

  propTypes: {
    capabilities: React.PropTypes.object,
    header: React.PropTypes.string,
    description: React.PropTypes.array,
    slides: React.PropTypes.arrayOf({
      color: React.PropTypes.string,
      images: React.PropTypes.arrayOf({
        desktop: React.PropTypes.string,
        tablet: React.PropTypes.string,
        mobile: React.PropTypes.string
      })
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

  getImageSources(images) {
    return [
      {
        url: images.desktop,
        quality: 80,
        widths: [ 1092 ],
        mediaQuery: '(min-width: 900px)'
      },
      {
        url: images.tablet,
        quality: 80,
        widths: [ 768, 900 ],
        mediaQuery: '(min-width: 768px)'
      },
      {
        url: images.mobile,
        quality: 80,
        widths: [ 360, 460, 560 ],
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
          <div className={classes.image}>
            <SliderActive
              showDots={true}
              versionTwo={true}
              hideArrowsMobile={false}
              frameName={" "}
              cssModifier={" "}
              analyticsCategory={"bapgapSlider"}
              fitImages={this.props.slides}
              aria-label={this.props.header}
              capabilities={this.props.capabilities}>
              {this.props.slides.map( (slide, index) => {
                return (
                  <div key={index} className={"u-h100p--900"}>
                    <Picture children={this.getPictureChildren({sources: this.getImageSources(slide.images)})} />
                  </div>
                );
              })}
            </SliderActive>
          </div>
        </div>
      </div>
    );
  }

});
