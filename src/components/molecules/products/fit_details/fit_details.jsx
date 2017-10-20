const _ = require("lodash");
const React = require('react/addons');
const IconX = require('components/quanta/icons/x/x')
const Markdown = require('components/molecules/markdown/markdown');

const Img = require('components/atoms/images/img/img');
const Mixins = require('components/mixins/mixins');
const SliderActive = require("components/molecules/sliders/active/active");
const ProductImageSlide = require("components/molecules/products/slides/product_image/product_image");

const ThinX = require('components/quanta/icons/thin_x/thin_x');
const FrameTemple = require('components/quanta/icons/frame_temple/frame_temple');

require('./fit_details.scss');

module.exports = React.createClass({
  BLOCK_CLASS: "c-frame-fit-details",

  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.dispatcher,
    Mixins.image
  ],

  propTypes: {
    content: React.PropTypes.object,
    manageClose: React.PropTypes.func,
    product: React.PropTypes.object
  },

  getDefaultProps() {
    return {
      content: {},
      product: {},
      staffGallery: false,
      fitDescription: { "Narrow": "When you typically try on frames, do they often look oversized on you? If so, you might have a narrow face. These frames are sized best for you.",
                        "Medium": "These frames best fit a medium-width face. If you tend to fit most pairs of frames you’ve tried on, then these are sized well for you.",
                        "Wide": "When you typically try on frames, do they often look undersized on you? If so, you might have a wide face. These frames are best sized for you.",
                      },
      measurementsDescription: "Our measurements (like most eyewear brands') are printed inside the temple arm. It may help to compare these with a pair you already own.",
      fitImages: [
      ],
    };
  },

  getStaticClasses() {
    return {
      modal: `
        u-db
        u-w100p
        u-mla u-mra
        u-pr
        u-color-bg--white
      `,
      contentContainer: `
        u-pb30
      `,
      close: `
        u-button-reset
      `,
      heading: `
        u-mt0 u-mb0
        u-pt12 u-pb12
        u-tac
        u-fws
        u-bw0 u-bss u-bc--light-gray
        u-db
      `,
      diagram: `
        u-dib
        u-mw100p
      `,
      label: `
        u-mt24 u-mt12--900
        u-ffss u-fws u-fs12 u-ttu u-ls1_5
        u-color--dark-gray-alt-2
      `,
      fitValue: `
        u-ffss u-fws u-fs16 u-fs18--900
      `,
      fitDescription: `
        u-ffss u-fwn u-fs16 u-fs18--900
        u-color--dark-gray-alt-1
      `,
      imageSlide: `
        ${this.BLOCK_CLASS}__image-slide u-h100p--900 u-pb1x1 u-pb3x2--600 u-pb0--900
      `
    };
  },

  classesWillUpdate: function() {
    return {
      modal: {
        'u-oh u-df--900 u-mw1440': this.props.staffGallery,
        'u-w10c--600 u-w8c--900 u-bw0 u-bw1--600 u-bss u-br2 u-bc--light-gray': !this.props.staffGallery
      },
      contentContainer: {
        'u-color--dark-gray-alt-3 u-w6c--900 u-pt48--900': this.props.staffGallery,
        'u-pt6 u-pl18 u-pr18 u-pl48--600 u-pr48--600 u-pl66--900 u-pr66--900': !this.props.staffGallery
      },
      close: {
        'u-fr--900': this.props.staffGallery,
        'u-pa u-t0 u-r0 u-mt18 u-mr18': !this.props.staffGallery
      },
      heading: {
        'u-ffs u-fs22 u-fs30--900 u-tal--900 u-bbw0 u-pt24--900 u-color--dark-gray': this.props.staffGallery,
        'u-fs20 u-ffss u-bbw1': !this.props.staffGallery
      },
      frameWidth: {
        'u-fn u-fl--600 u-w5c--600 u-w12c--900': this.props.staffGallery
      },
      frameMeasurements: {
        'u-fn u-fr--600 u-fn--900 u-cl--900 u-w6c--600 u-w12c--900': this.props.staffGallery
      },
      label: {
        'u-mb6--900 u-dib u-db--900 u-color--dark-gray': this.props.staffGallery,
      },
      fitValue: {
        'u-dib u-db--900 u-pl24 u-pl0--900 u-mt0 u-mb6 u-color--dark-gray': this.props.staffGallery,
        'u-mt10 u-mb0': !this.props.staffGallery
      },
      fitDescription: {
        'u-mbn12 u-mb0--900': this.props.staffGallery,
        'u-mt10 u-mb6': !this.props.staffGallery
      },
      diagram: {
        'u-w12c u-w9c--600 u-w10c--900 u-mt36': this.props.staffGallery,
        'u-mt12 u-mw50p--600': !this.props.staffGallery
      },
      gallery: {
        'u-color--white u-ffs u-fs12 u-w6c--900 u-pr--900': this.props.staffGallery
      },
      diagramContainer: {
        'u-tac u-w100p': this.props.staffGallery
      },
      descriptionArea: {
        'u-pl30 u-pr30 u-pl36--600 u-pr36--600 u-pl72--900 u-pr72--900  u-pl84--1200 u-pr96--1200': this.props.staffGallery
      }
    };
  },

  renderSlide(carouselItem, i) {
    const classes = this.getClasses();
    const srcSet = this.getSrcSet ({
      url: carouselItem.image,
      widths: [500, 800, 1080, 1250, 2160],
      quality: 80,
    });
    const sizes = this.getImgSizes ([
      {breakpoint: 0, width: "150vw"},
      {breakpoint: 600, width: "100vw"},
      {breakpoint: 900, width: "1080px"},
    ]);
    return (
      <div className={"u-h100p--900"}>
        <ProductImageSlide srcSet={srcSet} key={i} cssModifier={classes.imageSlide} versionTwo={true} sizes={sizes}/>
      </div>
    );
  },

  renderBridgeFitDescription() {
    return <Markdown rawMarkdown={this.props.content.bridge} />;
  },

  renderMeasurementsDescription() {
    return (
      <Markdown
      key="measurementsDescription"
      rawMarkdown={
        this.props.staffGallery ?
        this.props.measurementsDescription :
        this.props.content.measurements}
      />
    );
  },

  renderMeasurementsValue(addSpaces) {
    const measurements = _.get(this.props, "product.measurements");
    if (measurements) {
      return _.map(
        ["lens_width", "bridge_width", "temple_length"],
        dimension => measurements[dimension]
      ).join(addSpaces ? " - " : "-");
    } else {
      return "–";
    }
  },

  renderWidthDescription() {
    const width = this.props.product.width_group;
    return (
      <Markdown rawMarkdown={this.props.staffGallery ?
        this.props.fitDescription[width] :
        this.props.content.width
      } />
    );
  },

  renderHeading(classes, inContentContainer) {
    let headingClass = classes.heading;
    let closeClass = classes.close;
    if (!inContentContainer && this.props.staffGallery) {
      headingClass += '  u-dn--900';
      closeClass += ' u-mt18 u-mr18 u-pa u-t0 u-r0 u-dn--900';
    } else if (inContentContainer && this.props.staffGallery){
      headingClass += ' u-dn u-dib--900';
      closeClass += ' u-dn u-dib--900';
    }
    return (
      <div>
        {!this.props.staffGallery}
        <button className={closeClass} onClick={this.props.manageClose}>
          {this.props.staffGallery ?
            <ThinX cssModifier={classes.iconX} /> :
            <IconX
              cssModifier={classes.iconX}
              cssUtility="u-icon u-fill--light-gray"
            />
          }

        </button>
        <h2 className={headingClass}
          children={this.props.staffGallery ?
            `More on ${this.props.product.display_name}` : "More fit details"} />
      </div>
    );

  },

  renderStaffGallery(classes) {

    return (
      <div className={classes.gallery}>
        <SliderActive
          fitImages={this.props.fitImages}
          frameName={this.props.product.display_name}
          aria-label="Staff try on images"
          capabilities={this.props.capabilities}
          children={this.props.fitImages.map(this.renderSlide)}
          showDots={true}
          versionTwo={true}
          hideArrowsMobile={false}
          cssModifier={"-v2"}
          analyticsCategory={"staffGallerySlider"}
        />
      </div>
    );
  },

  render() {
    const classes = this.getClasses();
    return (
      <div className={classes.modal}>
        {this.renderHeading(classes, false)}
        {this.props.staffGallery ? this.renderStaffGallery(classes) : ''}
        <div className={classes.contentContainer}>
          <div className={classes.descriptionArea}>
            {this.props.staffGallery ? this.renderHeading(classes, true) : ''}
            <div className={classes.frameWidth}>
              <h3 className={classes.label} children="Frame fit" />
              <h4
                className={classes.fitValue}
                children={_.get(this.props, 'product.width_group', '–')}
              />
              <div
                className={classes.fitDescription}
                children={this.renderWidthDescription()}
              />
            </div>
            <div className={classes.frameMeasurements}>
              {this.props.product.is_low_bridge_fit
                ? [
                    <h4
                      className={classes.fitValue}
                      children="Low Bridge"
                      key="bridgeFitHeading"
                    />,
                    <div
                      className={classes.fitDescription}
                      children={this.renderBridgeFitDescription()}
                      key="bridgeFitDescription"
                    />
                  ]
                : undefined}
              <h3 className={classes.label} children="Measurements" />
              <h4
                className={classes.fitValue}
                children={this.renderMeasurementsValue()}
              />
              <div
                className={classes.fitDescription}
                children={this.renderMeasurementsDescription()}
              />
            </div>
          </div>
          <div className={classes.diagramContainer}>
            {this.props.staffGallery ?
              <div className={classes.diagram}>
                <FrameTemple frameName={this.props.product.display_name} measurements={this.renderMeasurementsValue(true)} />
              </div>
              :
              <Img
                key="measurementsImage"
                srcSet={`${_.get(this.props.content, "measurements_image", "")}`}
                sizes={this.getImgSizes()}
                cssModifier={classes.diagram}
              />
            }
          </div>
        </div>
      </div>
    );
  }
});
