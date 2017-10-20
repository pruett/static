const _ = require('lodash');
const React = require('react/addons');
const Mixins = require('components/mixins/mixins');
const Hero = require('components/molecules/landing/prescription_how_to/hero/hero');
const Services = require('components/molecules/landing/prescription_how_to/services/services');

require('./prescription_how_to.scss');

module.exports = React.createClass({
  displayName: 'OrganismsPrescriptionHowTo',

  BLOCK_CLASS: 'c-prescription-how-to',

  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.context
  ],

  propTypes: {
    cssModifier: React.PropTypes.string,
    isVideoAvailable: React.PropTypes.bool,
    analyticsSlug: React.PropTypes.string,
    hero: React.PropTypes.objectOf({
      header: React.PropTypes.string,
      description: React.PropTypes.string,
      image_desktop: React.PropTypes.string,
      image_tablet: React.PropTypes.string,
      image_mobile: React.PropTypes.string,
      video_text: React.PropTypes.string,
      video_url: React.PropTypes.string
    }),
    popout: React.PropTypes.objectOf({
      header: React.PropTypes.string,
      description: React.PropTypes.string
    }),
    services: React.PropTypes.arrayOf({
      header: React.PropTypes.string,
      description: React.PropTypes.string,
      link_text: React.PropTypes.string,
      link_url: React.PropTypes.string,
      image: React.PropTypes.string
    })
  },

  getDefaultProps: function () {
    return {
      cssModifier: "",
      isVideoAvailable: true,
      analyticsSlug: "PrescriptionHowToPage",
      hero: {
        header: "How to get a prescription",
        description: "We've got three ways to keep your vision and eyes in the tippest-toppest shape. Let's see what's right for you.",
        image_desktop: "https://i.warbycdn.com/v/c/assets/prescription-how-to/image/D_Hero-IMG_Hub_2x/0/87e13e5599.png",
        image_tablet: "https://i.warbycdn.com/v/c/assets/prescription-how-to/image/D_Hero-IMG_Hub_2x/0/87e13e5599.png",
        image_mobile: "https://i.warbycdn.com/v/c/assets/prescription-how-to/image/M_Hero-IMG_Hub_2x/0/8bc7cd5d07.png",
        video_text: "Watch a quick video",
        video_url: "https://player.vimeo.com/external/234384885.hd.mp4?s=1509af925d8ec664ead4266585e39ed726d21a83&profile_id=174"
      },
      popout: {
        header: "Options? We got 'em",
        description: "Where to go, what to do, things like that"
      },
      services: [
        {
          header: "Prescription Check app",
          description: "Get an updated prescription at home. (Bunny slippers not required.)",
          image: "https://i.warbycdn.com/v/c/assets/prescription-how-to/image/app/0/85d2d6958d.png",
          link_text: "Download the app",
          link_url: "/prescription-check-app"
        },
        {
          header: "In-store Prescription Check",
          description: "Spend 10 minutes at a store and we’ll help you get an updated prescription",
          image: "https://i.warbycdn.com/v/c/assets/prescription-how-to/image/eye-exam/0/b728ae5a48.png",
          link_text: "See if you're eligible",
          link_url: "/prescription-check-store"
        },
        {
          header: "Comprehensive eye exam",
          description: "Have a doctor examine your eyes in person and get a new glasses prescription",
          image: "https://i.warbycdn.com/v/c/assets/prescription-how-to/image/in-store/0/87d9fba6d5.png",
          link_text: "Book an eye exam",
          link_url: "/appointments/eye-exams"
        }
      ]
    };
  },

  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-mw1440
        u-mla u-mra
        u-oh
      `
    };
  },

  render: function () {
    const classes = this.getClasses();

    return (
      <div className={classes.block}>
        <Hero
          cssModifier={this.props.cssModifier}
          isVideoAvailable={this.props.isVideoAvailable}
          analyticsSlug={this.props.analyticsSlug}
          hero={this.props.hero}
          popout={this.props.popout}
        />
        <Services
          cssModifier={this.props.cssModifier}
          analyticsSlug={this.props.analyticsSlug}
          services={this.props.services}
        />
      </div>
    );
  }

});
