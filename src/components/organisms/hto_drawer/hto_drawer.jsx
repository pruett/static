const _ = require('lodash');
const React = require('react/addons');

const Alert = require('components/quanta/icons/alert/alert');
const IconX = require('components/quanta/icons/thin_x/thin_x');
const BuyableFrame = require('components/molecules/products/buyable_frame_v2/buyable_frame_v2');
const FrameImage = require('components/molecules/products/gallery_frame_image/gallery_frame_image');

const Mixins =  require('components/mixins/mixins');

require('./hto_drawer.scss')

const ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

module.exports = React.createClass({
  BLOCK_CLASS: 'c-hto-drawer',
  TRANSITION_LENGTH: 300,

  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.context,
    Mixins.dispatcher,
  ],

  getDefaultProps: function() {
    return {
      analyticsCategory: 'htoDrawer',
      htoDrawerActive: false,
      items: [],
      messages: [
        {header: 'Pick 5 frames', body: 'Free trial–no prescription necessary (shipping both ways is on us)'},
        {header: 'Try them on at home', body: 'You’ve got 5 days to test ’em out. Send all 5 back to us when you’re done.'},
        {header: 'Find your favorite?', body: 'Place an order and we’ll make you a fresh new pair'},
      ],
      placeholder: '//i.warbycdn.com/v/c/assets/hto-drawer/image/placeholder/0/957a977fcd.jpg',
      oosMessage: 'This is now out of stock. Just remove it and add another frame to continue filling your Home Try-On.',
      sessionCart: {},
    };
  },

  getStaticClasses: function() {
    return {
      takeover: `
        ${this.BLOCK_CLASS}
        c-modal-takeover
        u-color-bg--dark-gray-95p
      `,
      container: `
        u-grid -maxed u-pa u-r0 u-t0 u-b0
        u-w100p
      `,
      drawer: `
        ${this.BLOCK_CLASS}__drawer
        u-pa u-r0 u-oa
        u-color-bg--white
        u-h100p
        u-w12c u-w6c--600 u-w4c--1200
        u-pl24 u-pr24 u-pt24 u-pb48
        u-tac
      `,
      drawerContents: `
        u-pr u-w100p
      `,
      closeButton: `
        ${this.BLOCK_CLASS}__close-button
        u-button-reset
        u-pa u-t0 u-r0 u-mt12 u-mr12
      `,
      x: `
        ${this.BLOCK_CLASS}__x
        u-dib u-m12
        u-stroke--dark-gray-alt-2
      `,
      header: `
        u-mt12--600 u-mb48
      `,
      count: `
        u-fs12 u-ls2 u-fws
        u-ttu
        u-color--dark-gray-alt-2
      `,
      title: `
        u-mt12 u-mt18--600
        u-fs20 u-fs22--600 u-fws
      `,
      frame: `
        ${this.BLOCK_CLASS}__frame
      `,
      placeholder: `
        ${this.BLOCK_CLASS}__placeholder
        u-button-reset
        u-mb60
      `,
      footer: `
        ${this.BLOCK_CLASS}__footer
        u-pa u-r0 u-b0
        u-w12c u-w6c--600 u-w4c--1200
      `,
      button: `
        ${this.BLOCK_CLASS}__button
        u-button -button-large -button-blue
        u-fws
      `,
      banner: `
        ${this.BLOCK_CLASS}__banner
        u-pr u-tal
        u-br4
        u-mtn24
        u-mb48
        u-pt12 u-pb12 u-pl48 u-pr24
      `,
      bannerIcon: `
        ${this.BLOCK_CLASS}__banner-icon
        u-pa u-center-y u-l0
        u-icon u-fill--red
        u-ml18
      `,
      bannerCopy: `
        u-di u-m0
        u-fs14 u-color--dark-gray-alt-3
      `,
      bannerCta: `
        ${this.BLOCK_CLASS}__banner-cta
        u-button-reset
        u-fs14 u-fws u-color--blue
      `,
      messages: `
        u-mtn24 u-mtn12--600
        u-pt36 u-pt48--600
        u-pb24 u-pb36--600
        u-bss u-bw0 u-btw1 u-bc--light-gray-alt-1
      `,
      message: `
        ${this.BLOCK_CLASS}__message
        u-m0a u-pb30
      `,
      messageHeader: `
        u-fws u-ffss u-fs20 u-fs22--600
        u-mt0 u-mb12
      `,
      messageBody: `
        u-ffss u-fs16 u-fs18--600
        u-color--dark-gray-alt-3
        u-m0
      `,
    }
  },

  componentDidUpdate: function(prevProps) {
    if (!prevProps.htoDrawerActive && this.props.htoDrawerActive) {
      this.commandDispatcher('layout', 'showTakeover');
      window.addEventListener('keyup', this.handleKeypress);
    }
  },

  handleKeypress: function(evt) {
    const code = evt.which || evt.keyCode;
    if (code === 27) {
      // ESC key pressed, close drawer
      this.handleClose('escKey');
    }
  },

  handleClickOverlay: function(evt) {
    if (
      !this.refs['drawer'].contains(evt.target) &&
      !this.refs['footer'].contains(evt.target) &&
      !_.includes(this.refs['takeover'].className, '-transition')
    ) {
      this.handleClose('overlay');
    }
  },

  handleClose: function(target) {
    this.commandDispatcher('cart', 'hideHtoDrawer');
    _.delay(this.commandDispatcher, this.TRANSITION_LENGTH * 2, 'layout', 'hideTakeover');
    this.trackInteraction([
      this.props.analyticsCategory,
      'click',
      _.camelCase(`close ${target}`),
    ].join('-'));
    window.removeEventListener('keyup', this.handleKeypress);
  },

  handleClickRemoveUnavailable: function(evt) {
    this.trackInteraction(`${this.props.analyticsCategory}-click-removeUnavailable`);
    this.commandDispatcher('cart', 'removeUnavailableItems');
  },

  renderHtoFrame: function(arr, frame) {
    if (frame.option_type === 'hto') {
      return arr.concat(
        <BuyableFrame
          key={frame.product_id}
          analyticsCategory={this.props.analyticsCategory}
          cart={this.props.sessionCart}
          canHto={true}
          canFavorite={false}
          cssModifier={this.getClasses().frame}
          onGrid={false}
          oosMessage={frame.in_stock ? '' : this.props.oosMessage}
          product={frame} />
      );
    }
    else {
      return arr;
    }
  },

  renderPlaceholder: function(i) {
    return (
      <button
        key={i}
        className={this.getClasses().placeholder}
        onClick={this.handleClose.bind(this, 'placeholder')}>
        <FrameImage image={this.props.placeholder} />
      </button>
    );
  },

  renderFrames: function() {
    const htoFrames = this.props.items.reduceRight(this.renderHtoFrame, []);
    const placeholders = _.times(this.props.htoLimit - htoFrames.length, this.renderPlaceholder);
    const transitionLeave = 2000 + this.TRANSITION_LENGTH;

    return (
      <div>
        <ReactCSSTransitionGroup
          children={htoFrames}
          transitionEnterTimeout={this.TRANSITION_LENGTH}
          transitionLeaveTimeout={transitionLeave}
          transitionName='-transition' />
        <ReactCSSTransitionGroup
          children={placeholders}
          transitionEnterTimeout={transitionLeave}
          transitionLeave={false}
          transitionName='-transition' />
      </div>
    );
  },

  renderMessages: function(classes) {
    return (
      <div className={classes.messages} children={this.props.messages.map((message, i) => {
        return (
          <div key={i} className={classes.message}>
            <h3 className={classes.messageHeader} children={message.header} />
            <p className={classes.messageBody} children={message.body} />
          </div>
        );
      })} />
    );
  },

  renderButtons: function(classes) {
    const url = this.props.purchaseItemQuantity ? 'cart' : 'checkout';
    return (
      <div ref={'footer'} className={classes.footer}>
        <button
          className={`${classes.button} -dark`}
          children={'Keep browsing'}
          onClick={this.handleClose.bind(this, 'keepBrowsing')} />
        <a
          className={`${classes.button}${this.props.outOfStockCount || !this.props.htoQuantity ? ' -disabled u-pen' : ''}`}
          children={'Start free trial'}
          href={`/${url}`}
          onClick={this.clickInteraction.bind(this, _.camelCase(`startFreeTrial ${url}`))} />
      </div>
    );
  },

  renderOutOfStockBanner: function(classes) {
    return (
      <div className={classes.banner}>
        <Alert cssUtility={classes.bannerIcon} />
        <p
          className={classes.bannerCopy}
          children={`${this.props.outOfStockCount === 1 ? 'An item you’ve added is' : 'Items you’ve added are'} out of stock. `} />
        <button
          className={classes.bannerCta}
          children={`Remove unavailable item${this.props.outOfStockCount === 1 ? '' : 's'}`}
          onClick={this.handleClickRemoveUnavailable} />
      </div>
    );
  },

  render: function() {
    const classes = this.getClasses();

    return (
      <ReactCSSTransitionGroup
        transitionEnterTimeout={3 * this.TRANSITION_LENGTH}
        transitionLeaveTimeout={2 * this.TRANSITION_LENGTH}
        transitionName='-transition'>

        {this.props.htoDrawerActive ?
          <div ref={'takeover'} className={classes.takeover} onClick={this.handleClickOverlay}>
            <div className={classes.container}>
              <div ref={'drawer'} className={classes.drawer}>
                <button className={classes.closeButton} onClick={this.handleClose.bind(this, 'x')}>
                  <IconX cssUtility={classes.x} />
                </button>
                <div className={classes.drawerContents}>
                  <div className={classes.header}>
                    <div className={classes.count} children={`${this.props.htoQuantity} of ${this.props.htoLimit} added`} />
                    <div
                      className={classes.title}
                      children={`Your Home Try-On${this.props.htoQuantity === this.props.htoLimit ? ' is full' : ''}`} />
                  </div>
                  {this.props.outOfStockCount > 0 ? this.renderOutOfStockBanner(classes) : null}
                  {this.renderFrames()}
                  {this.inExperiment('htoDrawer', 'enabledWithMessage') ? this.renderMessages(classes) : null}
                </div>
              </div>
              {this.renderButtons(classes)}
            </div>
          </div>
        : null}

      </ReactCSSTransitionGroup>
    );
  }
});
