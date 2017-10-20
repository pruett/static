const React = require("react/addons");
const CssTransitionGroup = React.addons.CSSTransitionGroup;
require("./devices.scss");

const BLOCK_CLASS = "c-devices";

class Devices extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      index: 0
    };
  }

  componentDidMount() {
    setInterval(() => {
      this.setState({ index: this.nextSlide });
    }, this.props.timeout);
  }

  get nextSlide() {
    const nextSlide = this.state.index + 1;
    return nextSlide < this.props.slides.length ? nextSlide : 0;
  }

  get prevSlide() {
    const prevSlide = this.state.index - 1;
    return prevSlide < 0 ? this.props.slides.length - 1 : prevSlide;
  }

  get slide() {
    return this.props.slides[this.state.index] || {};
  }

  getClassNameSlide(i) {
    const className = "u-pa u-l0 u-r0 u-t0 u-b0";
    if (this.state.index === i) {
      return `${className} ${BLOCK_CLASS}__curr-slide`;
    } else if (i === this.prevSlide) {
      return `${className} ${BLOCK_CLASS}__prev-slide`;
    } else {
      return className;
    }
  }

  getZIndex(i) {
    return this.state.index === i ? 2 : this.prevSlide === i ? 1 : 0;
  }

  render() {
    return (
      <div className={`${BLOCK_CLASS} u-tac u-pr`}>
        {this.props.slides.map((slide, i) => {
          return (
            <picture
              key={i}
              style={{ animationDuration: `${this.props.duration}ms`, zIndex: this.getZIndex(i) }}
              className={this.getClassNameSlide(i)}
            >
              <source
                media="(min-width: 900px)"
                srcSet={`${slide.desktop}?quality=80?width=1000 1000w, ${slide
                  .desktop}?width=2000 2000w`}
                sizes="1000px"
              />
              <source
                media="(min-width: 600px)"
                srcSet={`${slide.tablet}?quality=80?width=540 540w, ${slide
                  .tablet}?width=1080 1080w`}
                sizes="540px"
              />
              <source
                media="(min-width: 0px)"
                srcSet={`${slide.mobile}?quality=80?width=280 280w, ${slide
                  .mobile}?width=560 560w`}
                sizes="280px"
              />
              <img
                alt=""
                className="u-db u-w100p"
                src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"
              />
            </picture>
          );
        })}
        <picture className="u-pa u-l0 u-r0 u-t0 u-b0" style={{ zIndex: 3 }}>
          <source
            media="(min-width: 900px)"
            srcSet={`${this.props.devices.desktop}?quality=80?width=1000 1000w, ${this.props.devices
              .desktop}?width=2000 2000w`}
            sizes="1000px"
          />
          <source
            media="(min-width: 600px)"
            srcSet={`${this.props.devices.tablet}?quality=80?width=540 540w, ${this.props.devices
              .tablet}?width=1080 1080w`}
            sizes="540px"
          />
          <source
            media="(min-width: 0px)"
            srcSet={`${this.props.devices.mobile}?quality=80?width=280 280w, ${this.props.devices
              .mobile}?width=560 560w`}
            sizes="280px"
          />
          <img
            alt=""
            className="u-db u-w100p"
            src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"
          />
        </picture>
      </div>
    );
  }
}

Devices.defaultProps = {
  timeout: 7000,
  duration: 1200,
  slides: [
    {
      desktop:
        "https://i.warbycdn.com/v/c/assets/prescription-services/image/D-Animation-01/0/9c69057a02.png",
      tablet:
        "https://i.warbycdn.com/v/c/assets/prescription-services/image/T-Animation-01/0/057ae079b4.png",
      mobile:
        "https://i.warbycdn.com/v/c/assets/prescription-services/image/M-Animation-01/0/7d638c32eb.png"
    },
    {
      desktop:
        "https://i.warbycdn.com/v/c/assets/prescription-services/image/D-Animation-02/0/ade5053efb.png",
      tablet:
        "https://i.warbycdn.com/v/c/assets/prescription-services/image/T-Animation-02/0/0631bfc65e.png",
      mobile:
        "https://i.warbycdn.com/v/c/assets/prescription-services/image/M-Animation-02/0/08adaff20a.png"
    },
    {
      desktop:
        "https://i.warbycdn.com/v/c/assets/prescription-services/image/D-Animation-03/0/be46240f1c.png",
      tablet:
        "https://i.warbycdn.com/v/c/assets/prescription-services/image/T-Animation-03/0/996ed71847.png",
      mobile:
        "https://i.warbycdn.com/v/c/assets/prescription-services/image/M-Animation-03/0/1fa79df6cc.png"
    }
  ],
  devices: {
    desktop:
      "//i.warbycdn.com/v/c/assets/quiz-promo/image/device-desktop/0/df6c9f236b.png",
    tablet:
      "//i.warbycdn.com/v/c/assets/quiz-promo/image/device-tablet/0/184c1b8497.png",
    mobile:
      "//i.warbycdn.com/v/c/assets/quiz-promo/image/device-phone/1/706570675e.png"
  }
};

Devices.propTypes = {
  timeout: React.PropTypes.number,
  duration: React.PropTypes.number,
  slides: React.PropTypes.array,
  devices: React.PropTypes.shape({
    desktop: React.PropTypes.string,
    tablet: React.PropTypes.string,
    mobile: React.PropTypes.string
  })
};

module.exports = Devices;
