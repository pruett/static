const _ = require('lodash');
const React = require('react/addons');
const Img = require('components/atoms/images/img/img');
const Mixins = require('components/mixins/mixins');

require('./services.scss');

module.exports = React.createClass({
  displayName: 'OrganismsPrescriptionHowToServices',

  BLOCK_CLASS: 'c-prescription-how-to-services',

  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.context,
    Mixins.image
  ],

  propTypes: {
    cssModifier: React.PropTypes.string,
    analyticsSlug: React.PropTypes.string,
    services: React.PropTypes.arrayOf({
      header: React.PropTypes.string,
      description: React.PropTypes.string,
      image: React.PropTypes.string,
      link_text: React.PropTypes.string,
      link_url: React.PropTypes.string
    })
  },

  getDefaultProps: function () {
    return {
      cssModifier: "",
      analyticsSlug: "PrescriptionHowToPage",
      services: [
        {
          header: "Prescription Check app",
          description: "Get an updated prescription at home. (Bunny slippers not required.)",
          image: "https://i.warbycdn.com/v/c/assets/prescription-how-to/image/app/0/85d2d6958d.png",
          link_text: "Download the app",
          link_url: "https://itunes.apple.com/us/app/prescription-check/id1209102842?ls=1&mt=8"
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
        ${this.props.cssModifier}
      `,
      service: `
        ${this.BLOCK_CLASS}__service
        u-tac
        u-pt36 u-pt72--900 u-pb72--900
      `,
      serviceContent: `
        u-grid__col u-w12c u-w5c--600 u-w4c--900
        u-dib
        u-tac u-mla u-mra
        u-mb60 u-mb0--900
      `,
      serviceHeader: `
        u-fs18 u-fs20--900
        u-fws
        u-mb12
        u-reset
      `,
      serviceImage: `
        u-mb18
        u-w100p
      `,
      serviceImageWrapper: `
        u-mla u-mra
        u-w6c
      `,
      serviceDescription: `
        u-color--dark-gray-alt-3
        u-lh26 u-lh28--1200
        u-reset
        u-fs18--900
        u-mb24
        u-ml5 u-mr5
        u-ml42--900 u-mr42--900
      `,
      serviceLink: `
        u-fws
        u-bbw1 u-bbss
        u-bc--blue u-bc--white--600
        u-link--hover
      `
    };
  },

  trackClick: function (text) {
    text = _.camelCase(text);
    this.trackInteraction(`${this.props.analyticsSlug}-click-${text}`);
  },

  getImageProps: function (image) {
    return {
      url: image,
      widths: this.getImageWidths(300, 600, 4)
    };
  },

  render: function () {
    const classes = this.getClasses();
    const imgSizes = [
      {
        breakpoint: 0,
        width: '80vw'
      },
      {
        breakpoint: 600,
        width: '30vw'
      }
    ];

    return (
      <div className={classes.block}>
        <div className={classes.service}>
          {this.props.services.map( (service, index) => {
            return (
              <div className={classes.serviceContent} key={index}>
                <div className={classes.serviceImageWrapper}>
                  <Img
                    srcSet={this.getSrcSet(this.getImageProps(service.image))}
                    sizes={this.getImgSizes(imgSizes)}
                    alt={service.header}
                    cssModifier={classes.serviceImage} />
                </div>
                <h2 children={service.header} className={classes.serviceHeader} />
                <p children={service.description} className={classes.serviceDescription} />
                <div className={classes.serviceLinkWrapper}>
                  <a
                    href={service.link_url}
                    onClick={this.trackClick.bind(this, service.link_text)}
                    className={classes.serviceLink}
                    children={service.link_text} />
                </div>
              </div>
            );
          })}
        </div>
      </div>
    );
  }

});
