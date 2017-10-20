const React = require('react/addons');
const _ = require('lodash');

const Mixins = require('components/mixins/mixins');
const ImpressionsMixin = require('components/mixins/collections/ga_impressions_mixin');

const Picture = require('components/atoms/images/picture/picture');


require('./callout.scss');

module.exports = React.createClass({

  displayName: 'MoleculesCollectionsSummer2017Callout',

  BLOCK_CLASS: 'c-summer-2017-callout',

  mixins: [
    Mixins.classes,
    Mixins.dispatcher,
    Mixins.analytics,
    ImpressionsMixin,
    Mixins.image
  ],

  propTypes: {
    desktop_link_modifier: React.PropTypes.string,
    frameData: React.PropTypes.object,
    frame_color: React.PropTypes.string,
    frame_name: React.PropTypes.string,
    frame_name_img: React.PropTypes.string,
    frame_type: React.PropTypes.string,
    genders: React.PropTypes.array,
    identifier: React.PropTypes.string,
    image: React.PropTypes.array,
    link_text_modifier: React.PropTypes.string,
    pdp_link: React.PropTypes.string,
    gaPosition: React.PropTypes.number,
    sold_out: React.PropTypes.bool,
    version: React.PropTypes.string,
  },

  getDefaultProps: function () {
    return {
      desktop_link_modifier: '',
      frameData: {},
      frame_color: '',
      frame_name: '',
      frame_name_img: '',
      frame_type: 'optical',
      genders: [],
      image: [],
      identifier: '',
      link_text_modifier: '',
      pdp_link: '',
      gaPosition: 0,
      sold_out: false,
      version: 'fans'
    };
  },

  getStaticClasses: function () {
    return {
      block: `${this.BLOCK_CLASS} u-mla u-mra u-pr u-mw1440 u-mb48 u-mb96--600`,
      soldOut: `u-fs16 u-fws u-reset u-pt12`,
      mobileLinkText: `
        ${this.BLOCK_CLASS}__link-text
        ${this.props.link_text_modifier}
        u-dn--900
        u-ttu u-fwb u-ls3
        u-reset
      `,
      shopLinkWrapper: `
        u-tac u-pt24
      `,
      desktopLinkWrapper: `
        ${this.BLOCK_CLASS}__desktop-link-wrapper
        ${this.props.desktop_link_modifier}
        u-dn u-dib--900
        u-pa u-center-y
      `,
      desktopLinkText: `
        ${this.BLOCK_CLASS}__desktop-link-text
        ${this.props.link_text_modifier}
        u-fwb u-ls3
        u-db u-pt12
      `,
      linkWrapper: `u-dn--900`,
      image: `u-w100p`,
      desktopFrameName: `u-w5c`,
      desktopFrameNameText: `
        ${this.BLOCK_CLASS}__frame-name-text
        ${this.props.link_text_modifier}
        u-fwb u-color--white
      `,
      sunLinkWrapper: `
        u-tac u-pa--900 u-b0--900 u-r0--900
        u-pt12 u-pt0--900 u-pr72--900 u-pb24--900
      `,
      sunLink: `
        u-pb6 u-bbss u-bbw0
        ${this.BLOCK_CLASS}__sun-link
        ${this.props.link_text_modifier}
      `
    }
  },

  getPictureAttrs: function (images, classes) {
    return {
      sources: [
        {
          url: this.getImageBySize(images, 'desktop-sd'),
          widths: this.getImageWidths(900, 2200, 5),
          mediaQuery: '(min-width: 900px)'
        },
        {
          url: this.getImageBySize(images, 'tablet'),
          widths: this.getImageWidths(700, 1400, 5),
          mediaQuery: '(min-width: 600px)'
        },
        {
          url: this.getImageBySize(images, 'mobile'),
          widths: this.getImageWidths(300, 800, 5),
          mediaQuery: '(min-width: 0px)'
        }
      ],
      img: {
        alt: 'Warby Parker',
        className: classes.image
      }
    };
  },

  renderLinks: function (classes) {
    if (this.props.frame_type === 'optical') {
      const tag = this.props.sold_out ? 'div' : 'a';
      return this.renderOpticalShopLink(tag, classes);
    } else {
      return this.renderSunShopLink(classes);
    }
  },

  handleShopLinkClick: function () {
    if (this.props.sold_out || _.isEmpty(this.props.frameData)) return;
    const calloutGender = this.props.genders[0];
    const genderedDetails = _.find(this.props.frameData.gendered_details, {gender: calloutGender});

    if (!genderedDetails) return;

    this.trackInteraction(`LandingPage-clickShop${this.GA_GENDER_LOOKUP[calloutGender]}-${this.props.frameData.sku}`);

    const options = {
      gender: calloutGender,
      category: this.props.frameData.assembly_type,
      list: this.props.identifier,
      identifier: this.props.identifier,
      color: this.props.frameData.color,
      id: genderedDetails.product_id,
      name: this.props.frameData.display_name,
      position: this.props.gaPosition,
      sku: this.props.frameData.sku
    }

    const productImpression = this.buildBaseImpression(options);

    this.commandDispatcher('analytics', 'pushProductEvent', {
      type: 'productClick',
      eventMetadata: {
        list: this.props.identifier
      },
      products: productImpression
    });

  },

  renderSoldOutState: function (classes) {
    return <div children={'Sold out'} className={classes.soldOut} />
  },

  renderSunShopLink: function (classes) {
    return (
      <div className={classes.sunLinkWrapper}>
        <a
          children={`${this.props.frame_name} in ${this.props.frame_color}`}
          href={this.props.pdp_link}
          onClick={this.handleShopLinkClick}
          className={classes.sunLink}>
            <span children={`${this.props.frame_name}`} className={'u-fws'} />
            <span children={` in ${this.props.frame_color}`} />
        </a>
      </div>
    );
  },

  renderOpticalShopLink: function (Tag, classes) {
    return (
      <div className={classes.shopLinkWrapper}>
        <Tag href={this.props.pdp_link} className={classes.linkWrapper} onClick={this.handleShopLinkClick}>
          <span
            children={`${this.props.frame_name} IN ${this.props.frame_color}`}
            className={classes.mobileLinkText} />
          {this.props.sold_out && this.renderSoldOutState(classes)}
        </Tag>
          <div className={classes.desktopLinkWrapper}>
            <Tag href={this.props.pdp_link} className={'durr'} onClick={this.handleShopLinkClick}>
              <div children={this.props.frame_name} className={classes.desktopFrameNameText} />
              <span
                children={`IN ${this.props.frame_color}`}
                className={classes.desktopLinkText} />
            </Tag>
            {this.props.sold_out && this.renderSoldOutState(classes)}
          </div>
      </div>
    );
  },

  render: function () {
    const classes = this.getClasses();
    const pictureAttrs = this.getPictureAttrs(this.props.image, classes);

    return (
      <div className={classes.block}>
        <Picture className={classes.picture} children={this.getPictureChildren(pictureAttrs)} />
        <div children={this.renderLinks(classes)} />
      </div>
    );
  }

});
