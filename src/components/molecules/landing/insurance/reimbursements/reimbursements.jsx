const React = require("react/addons");

const Img = require("components/atoms/images/img/img");

const Mixins = require("components/mixins/mixins");

require("./reimbursements.scss");

module.exports = React.createClass({
  displayName: "MoleculesInsuranceHero",

  BLOCK_CLASS: "c-insurance-reimbursements",

  // Anchor ID, currently linked to from
  // Organisms/static/flexible_spending_accounts.cjsx
  ANCHOR_ID: "steps",

  IMAGE_SIZES: [
    {
      breakpoint: 0,
      width: "80vw",
    },
    {
      breakpoint: 600,
      width: "30vw",
    },
  ],

  mixins: [Mixins.classes, Mixins.context, Mixins.image, Mixins.analytics],

  propTypes: {
    header: React.PropTypes.string,
    nearbyExams: React.PropTypes.bool,
    options: React.PropTypes.array,
    renderLinks: React.PropTypes.bool,
    showBottomBorder: React.PropTypes.bool,
  },

  getDefaultProps: function() {
    return {
      header: "",
      nearbyExams: false,
      options: [],
      renderLinks: true,
      showBottomBorder: false,
    };
  },

  getStaticClasses: function() {
    return {
      block: `
        ${this.BLOCK_CLASS}
        u-mb60
      `,
      grid: `
        u-grid
      `,
      optionsWrapper: `
        u-tac
        u-pt36 u-pt72--900
        u-bbss u-bc--light-gray u-bbw1
        u-mb36--1200
      `,
      option: `
        ${this.BLOCK_CLASS}__option
        u-grid__col u-w12c u-w5c--600 u-w4c--900
        u-dib
        u-tac u-mla u-mra
        u-mb60 u-mb48--900
      `,
      optionHeader: `
        u-fs18 u-fs20--900
        u-fws
        u-mb12
        u-reset
      `,
      image: `
        u-mb18
        u-w100p
      `,
      imageWrapper: `
        ${this.BLOCK_CLASS}__image-wrapper
        u-mla u-mra
        u-w6c
      `,
      imageWrapperExams: `
        ${this.BLOCK_CLASS}__image-wrapper -exams
        u-mla u-mra
      `,
      body: `
        ${this.BLOCK_CLASS}__body
        u-color--dark-gray-alt-3
        u-lh26 u-lh28--1200
        u-reset
        u-fs18--1200
        u-mb12
      `,
      link: `
        ${this.BLOCK_CLASS}__link
        u-pb6 u-bbss u-bbw2 u-bbw0--900
        u-fws
      `,
      header: `
        u-mb30 u-mb48--600 u-mb60--900
        u-fs24 u-fs40--900
        u-fws u-ffs
        u-tac
        u-reset
      `,
    };
  },

  classesWillUpdate: function() {
    return {
      optionsWrapper: {
        "u-bbss u-bbw1 u-pb24--900": this.props.showBottomBorder,
      },
    };
  },

  getImageProps: function(image) {
    return {
      url: image,
      widths: this.getImageWidths(300, 600, 4),
    };
  },

  getWrapperKlass: function(option, classes) {
    if (option.key === "exams") {
      return classes.imageWrapperExams;
    } else {
      return classes.imageWrapper;
    }
  },

  renderOptions: function(classes) {
    const options = this.props.options;
    const imgSizes = this.getImgSizes(this.IMAGE_SIZES);

    const children = options.map((option, i) => {
      const imgSrcSet = this.getSrcSet(this.getImageProps(option.img));
      return (
        <div className={classes.option} key={i}>
          <div className={this.getWrapperKlass(option, classes)}>
            <Img
              srcSet={imgSrcSet}
              sizes={imgSizes}
              alt={"Warby Parker"}
              cssModifier={classes.image}
            />
          </div>
          <h2 children={option.header} className={classes.optionHeader} />
          <p children={option.body} className={classes.body} />
          <div
            className={classes.linkWrapper}
            children={this.renderLinks(option, classes)}
          />
        </div>
      );
    });

    return (
      <div>
        <h2 children={this.props.header} className={classes.header} />
        <div children={children} />
      </div>
    );
  },

  handleLinkClick: function(link) {
    this.trackInteraction(`InsurancePage-clickLink-${link.ga_slug}`);
  },

  renderLinks: function(option, classes) {
    if (option.key === "exams" && !this.props.nearbyExams) {
      return false;
    }

    const links = option.links || [];

    const children = links.map((link, i) => {
      return (
        <a
          href={link.path}
          key={i}
          onClick={this.handleLinkClick.bind(this, link)}
          className={classes.link}
          children={link.copy}
        />
      );
    });

    return children;
  },

  render: function() {
    const classes = this.getClasses();

    return (
      <div className={classes.block} id={this.ANCHOR_ID}>
        <div className={classes.grid}>
          <div
            className={classes.optionsWrapper}
            children={this.renderOptions(classes)}
          />
        </div>
      </div>
    );
  },
});
