const _ = require('lodash');
const React = require('react/addons');
const Markdown = require('components/molecules/markdown/markdown');
const Picture = require('components/atoms/images/picture/picture');
const Mixins = require('components/mixins/mixins');

require('./doing_good_work.scss');

module.exports = React.createClass({
  displayName: 'MoleculesBapGapDoingGoodWork',

  BLOCK_CLASS: 'c-bapgap-doing-good-work',

  mixins: [
    Mixins.classes,
    Mixins.context,
    Mixins.scrolling,
    Mixins.image
  ],

  propTypes: {
    header: React.PropTypes.string,
    subHeader: React.PropTypes.string,
    description: React.PropTypes.array,
    images: React.PropTypes.objectOf({
      desktop: React.PropTypes.string,
      tablet: React.PropTypes.string,
      mobile: React.PropTypes.string
    }),
    pins: React.PropTypes.arrayOf({
      top: React.PropTypes.string,
      left: React.PropTypes.string
    })
  },

  getStaticClasses() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-grid -maxed u-ma u-tac
        u-pt84 u-pr
      `,
      row: `
        u-grid__row -center
      `,
      content: `
        u-pa u-t0 u-l0 u-w12c
      `,
      header: `
        u-reset u-heading-md
        u-mt84 u-mt96--1200
        u-mb24
      `,
      subHeader: `
        u-reset u-heading-md
        u-mt12
      `,
      total: `
        u-color--blue
      `,
      description: `
        u-grid__col u-reset u-w12c
        u-ffss u-fs16 u-fs18--900
      `,
      image: `
        ${this.BLOCK_CLASS}__image
        u-db u-mt108
      `,
      map: `
        ${this.BLOCK_CLASS}__map
        u-pr
        u-mla u-mra
      `,
      pins: `
        ${this.BLOCK_CLASS}__pins
        u-pa u-w100p u-h100p u-t0 u-l0
      `,
      pin: `
        ${this.BLOCK_CLASS}__pin
        u-pa u-vh
      `
    };
  },

  classesWillUpdate() {
    return {
      pin: {
        'bounceInDown': this.state.showPins,
      }
    };
  },

  getInitialState() {
    return {
      showPins: false,
      isMobile: false
    }
  },

  componentDidMount() {
    if (this.refs.map && !this.state.isMobile) {
      this.throttleShowPins = _.throttle(this.showPins, 200, { 'trailing': false });
      window.addEventListener('scroll', this.throttleShowPins);
    }

    this.isMobile();
    this.debounceIsMobile = _.debounce(this.isMobile, 200);
    window.addEventListener("resize", this.debounceIsMobile);
  },

  componentWillUnmount() {
    if (this.refs.map && !this.state.isMobile) {
      window.removeEventListener('scroll', this.throttleShowPins);
    }

    window.removeEventListener('resize', this.debounceIsMobile);
  },

  showPins() {
    if (this.refIsInViewport(this.refs.map)) {
      this.setState({showPins: true});
    }
  },

  isMobile() {
    const isMobile = window.matchMedia("(max-width: 599px)").matches;
    if (isMobile !== this.state.isMobile) {
      this.setState({ isMobile: isMobile });
    }
  },

  getPinStyle(pin, index) {
    return {
      top: pin.top,
      left: pin.left,
      WebkitAnimationDelay: `.${index}s`,
      animationDelay: `.${index}s`
    };
  },

  getImageSources() {
    return [
      {
        url: this.props.images.desktop,
        quality: 100,
        widths: [ 1536 ],
        mediaQuery: '(min-width: 1200px)'
      },
      {
        url: this.props.images.tablet,
        quality: 100,
        widths: [ 1200 ],
        mediaQuery: '(min-width: 600px)'
      },
      {
        url: this.props.images.mobile,
        quality: 100,
        widths: [ 750 ],
        mediaQuery: '(min-width: 320px)'
      }
    ];
  },

  render() {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <div className={classes.row}>
          <div className={classes.map} ref="map">
            <Picture cssModifier={classes.image} children={this.getPictureChildren({sources: this.getImageSources()})} />
            {!this.state.isMobile &&
              <div className={classes.pins} ref="pins">
                {this.props.pins.map( (pin, index) => {
                  return (
                    <a key={index} className={classes.pin} style={this.getPinStyle(pin, index)} />
                  );
                })}
              </div>}
          </div>
          <div className={classes.content}>
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
            <h3 className={classes.subHeader}>
              <span className={classes.total}>
                {Math.floor((this.props.pins.length+1)/10)*10}+
              </span>
              &nbsp;
              {this.props.subHeader}
            </h3>
          </div>
        </div>
      </div>
    );
  }

});
