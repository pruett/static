const _ = require("lodash");
const React = require('react/addons');
const Mixins = require('components/mixins/mixins');
require('./order_messaging.scss')

module.exports = React.createClass({

  BLOCK_CLASS: "c-order-messaging",

  mixins: [
      Mixins.classes,
      Mixins.analytics,
  ],

  getStaticClasses() {
    return {
      confirmationEyebrow: `
        ${this.BLOCK_CLASS}__confirmation-eyebrow
        u-fs12 u-ttu u-ls1 u-color--dark-gray u-fws
        u-mt0 u-mb6 u-mb12--900
      `,
      mainHeadline: `
        u-fws u-ffs u-color--dark-gray u-fs40 u-fs55--600 u-fs70--900
        u-w9c--600 u-m0a
        ${this.BLOCK_CLASS}__main-headline
      `,
      primaryMessaging: `
        u-w7c--600 u-w6c--900 u-m0a u-fwn u-fs16 u-fs18--900
        u-pt24 u-pb24 u-color--dark-gray-alt-3
      `
    }
  },

  getEditionsHeadline: function(numItems) {
    if (numItems > 1) {
      return "You’ve got some good stuff coming your way";
    }
    else if (this.props.isGiftCard) {
      return "Nice job on the gift card ;-)";
    }
    else if (this.props.isDogToy) {
      return "Your dog is in for a treat";
    }
    else if (this.props.isBook) {
      return "You have great taste in books";
    }
    else {
      return "We hope you like it as much as we do";
    }
  },

  /*Either the rx is uploaded, call to doctor is selected, or frames are non-rx*/
  noRxIssueMainHeadline: function(frames, numItems) {
    if (numItems === 1) {
      return `You'll be seeing ${frames} very soon`;
    }
    else if (numItems === 2  && !this.props.includesEditions) {
      return `${frames} are on their way`;
    }
    else if (numItems >= 3 || this.props.includesEditions) {
      return "You've got some good stuff coming your way";
    }
  },

  expiredOrMissingRxPrimary: function() {
    let message="";
    if (this.props.rxExpired) {
      message = "We noticed that your prescription is out of date. (And we need it to get started!) ";
      if (this.props.storeURL) {
        message += "Upload a new one below or schedule an eye exam.";
      } else {
        message += "Upload a new one and we'll get started.";
      }
    } else if (this.props.rxNeeded) {
      message = "Before we get started on your order, we're going to need your prescription. ";
      if (this.props.storeURL) {
        message += "You can upload it below or schedule an eye exam.";
      } else {
        message += "You can upload it below!";
      }
    }
    return message;
  },

  rxFramesPrimary: function(numItems) {
    if (numItems === 1 && !this.props.includesEditions) {
      return "Here comes some other good news: If you have vision insurance, you can apply for reimbursement. (It’s quick and easy!)";
    }
    else if (numItems >= 1 && this.props.includesEditions) {
      return "Here comes some other good stuff: If you have vision insurance, you can apply for reimbursement. (It’s quick and easy!)";
    }
    else if (numItems >= 2) {
      return "Here comes some other good news: If you have vision insurance, you can apply for reimbursement for your prescription frames. (It’s quick and easy!)";
    }
  },

  htoPrimary: function(frames) {
    if (this.props.storeURL) {
      return `The frames in attendance: ${frames}. P.S. If you need a prescription, you can schedule one below.`;
    }
    else {
      return `The frames in attendance: ${frames}. Don’t forget to share your pictures with us using #warbyhometryon.`;
    }
  },

  getLineItems: function() {
    let lineItems = [];
    for (var i = 0; i < (_.size(this.props.orders)); i++) {
      this.props.orders[i].line_items.forEach(function (item) {
        if (item.category === ("frame" || "hto")) {
          lineItems.push(_.startCase(item.display_name));
        }
      })
    }
    return lineItems;
  },

  /*return string of only one or two frames*/
  frameText: function() {
    return this.getLineItems().join(" and ");
  },

  /*return comma separated string of every frame in every order*/
  htoFrameText: function() {
    return this.getLineItems().join(", ").replace(/,(?!.*,)/, ", and");
  },

  numItems: function() {
    let numItems = 0;
    this.props.orders.map(function(order){
      numItems += _.size(order.line_items);
    })
    return numItems;
  },

  renderMainContent: function(classes) {
    let headline;
    let message;
    let buttonText;
    let buttonLink;
    let secondaryButton;
    let secondaryLinkText;
    let secondaryLink;
    let frames;
    const numItems = this.numItems();
    if (this.props.includesFrames) {
      frames = this.frameText(numItems);
    }
    if (this.props.rxNeeded || this.props.rxExpired) {
      headline = `${frames} will soon be yours. But just one more thing...`;
      if (numItems > 2) {
        headline = "You've got some good stuff coming your way. But just one more thing...";
      }
      message = this.expiredOrMissingRxPrimary();
      buttonText = "Upload prescription";
      buttonLink = `/account/orders/${this.props.orders[0].id}/prescription`;
      if (this.props.storeURL) {
        secondaryLinkText = "Book eye exam";
        secondaryLink = this.props.storeURL;
      }
    }
    else if (this.props.rxFrames) {
      headline = this.noRxIssueMainHeadline(frames, numItems);
      message = this.rxFramesPrimary(numItems);
      buttonText = "Submit reimbursement";
      buttonLink = "/insurance";
    }
    else if (this.props.isHto) {
      frames = this.htoFrameText();
      headline = "Get ready for your Home Try-On party";
      message = this.htoPrimary(frames);
      if (numItems > 5) { /*if > 5 then something other than HTO was ordered*/
        headline = "You’ve got some good stuff coming your way";
      }
      if (this.props.storeURL) {
        buttonText = "Book eye exam";
        buttonLink = this.props.storeURL;
      }
    }
    else if (this.props.includesEditions) {
      headline = this.getEditionsHeadline(numItems);
      message = "If you snap a photo of your beautiful new item, be sure to share it with us using #warbyparker!";
      if (numItems > 1) {
        message = "If you snap a photo of your beautiful new items, be sure to share it with us using #warbyparker!";
      }
      else if (this.props.isGiftCard){
        message = "If you’re looking to immediately reward yourself for giving such a great gift, we know a good place.";
        buttonText = "Right here";
        buttonLink = "/retail";
      }
      else if (this.props.isBook) {
        message = "If you’re still in the literary mood, we recommend perusing our blog. (Lots of book recommendations live there.)";
        buttonText = "Warby Parker blog";
        buttonLink = "/blog";
      }
      else if (this.props.isDogToy) {
        message = "If you snap a photo of your pup with Sal, be sure to share it with us using #warbybarker. (Your dog may just get famous.)";
        buttonText = "See what we mean";
        buttonLink = "https://www.instagram.com/warbybarker";
      }
    }
    else {
      headline = this.noRxIssueMainHeadline(frames, numItems);
      message = "If you snap a photo of your beautiful new frames, be sure to share it with us using #warbyparker!";
    }
    const buttonTarget = _.camelCase(buttonText);
    const secondaryLinkTarget = _.camelCase(secondaryLinkText);
    return (
      <div>
        <h1 className={classes.mainHeadline} children={headline} />
        <h3 className={classes.primaryMessaging} children={message} />
        {buttonText ?
            <a  href={buttonLink}
                className={"u-button -button-medium -button-blue"}
                children={buttonText}
                onClick={this.trackInteraction.bind(this, `orderConfirmation-click-${buttonTarget}`)} />
            : null }
        {secondaryLink ?
          <h3 className={"u-mbn24 u-mb0--900 u-pb24--900"}>
            <a  href={secondaryLink}
                className={"u-color--blue u-fws u-fs16 u-link--hover"}
                children={secondaryLinkText}
                onClick={this.trackInteraction.bind(this, `orderConfirmation-click-${secondaryLinkTarget}`)} />
          </h3>
          : null }
      </div>
    );
  },

  render: function() {
    const classes = this.getClasses();
    return (
      <div>
          <h4 className={classes.confirmationEyebrow} children={"Order Confirmed!"} />
          {this.renderMainContent(classes)}
      </div>
    );
  }
})
