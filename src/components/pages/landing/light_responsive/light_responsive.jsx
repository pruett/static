const React = require("react/addons");
const LayoutDefault = require("components/layouts/layout_default/layout_default");
const Mixins = require("components/mixins/mixins");
const Hero = require("components/organisms/landing/light_responsive/hero/hero");
const Slider = require("components/organisms/landing/light_responsive/slider/slider");
const HowTo = require("components/organisms/landing/light_responsive/how_to/how_to");
const Footer = require("components/organisms/landing/light_responsive/footer/footer");
const Details = require("components/organisms/landing/light_responsive/details/details");

const { hero, slider, details, howTo, footer } = require("./data.json");

module.exports = React.createClass({
  displayName: "LightResponsiveLanding",

  mixins: [Mixins.context, Mixins.routing, Mixins.scrolling],

  statics: {
    route: function() {
      return {
        path: "/light-responsive",
        handler: "Default",
        title: "Light Responsive"
      };
    }
  },

  handleScrollableClick: function() {
    this.scrollToNode(this.howToNode.getDOMNode());
  },

  render: function() {
    return (
      <LayoutDefault cssModifier={"-full-page"} {...this.props}>
        <section className="u-grid u-mw1440 u-ma u-mb60">
          <Hero
            data={hero}
            scrollableClickHandler={this.handleScrollableClick}
          />
          <Slider data={slider} />
        </section>
        <Details data={details} />
        <HowTo data={howTo} ref={el => (this.howToNode = el)} />
        <Footer data={footer} />
      </LayoutDefault>
    );
  }
});
