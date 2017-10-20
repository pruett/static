const _ = require("lodash");
const React = require('react/addons');
const Mixins = require('components/mixins/mixins');
const OrderMessaging = require('components/molecules/order_messaging/order_messaging');
const OrderInfo = require('components/molecules/order_info_details/order_info_details');
const AppPromo = require('components/molecules/app_promo/app_promo');

module.exports = React.createClass({

  mixins: [
    Mixins.classes,
    Mixins.dispatcher
    ],

  getStaticClasses() {
    return {
      mainContainer: `
        u-tac u-ffss u-fws u-mw1440 u-m0a
      `,
      messagingContainer: `
        u-pt84 u-pt108--900 u-pl24 u-pr24 u-pb84 u-pb108--900
      `,
    };
  },

  getDefaultProps: function() {
    return {
      appPromoData: {
        "layout_variation": "sprites",
        "body": "Want to get input from friends and family on your next pair of frames? Use our app to make a video you can easily share. Fun!",
        "subhead": "It’s your essential Home Try-On companion.",
        "heading_large_screens": "Share a video of your Home Try-On.",
        "video_files": [
          {
            "file_type": "video/mp4",
            "file_src": "//e.warbyparker.com/img/videos/checkout/hto-photobooth.mp4"
          },
          {
            "file_type": "video/webm",
            "file_src": "//e.warbyparker.com/img/videos/checkout/hto-photobooth.webm"
          },
          {
            "file_type": "video/ogg",
            "file_src": "//e.warbyparker.com/img/videos/checkout/hto-photobooth.ogv"
          }
        ],
        "sprites_background_image": "//i.warbycdn.com/v/c/assets/checkout/image/hto-photobooth-sprites-frame/0/fcd8a3077c.png",
        "download_button": {
          "url": "https://itunes.apple.com/app/apple-store/id1107693363?pt=1427163&ct=htoConfirmationStatic&mt=8",
          "alt_text": "Download on the App Store",
          "image": "//i.warbycdn.com/v/c/assets/checkout/image/app-store-badge/0/b29cee2ece.png"
        },
        "sprites": [
          "//i.warbycdn.com/v/c/assets/checkout/image/hto-photobooth-sprite-1/0/0c10e7ba66.jpg",
          "//i.warbycdn.com/v/c/assets/checkout/image/hto-photobooth-sprite-2/0/d2d72a0bc9.jpg",
          "//i.warbycdn.com/v/c/assets/checkout/image/hto-photobooth-sprite-3/0/52c8d7a180.jpg",
          "//i.warbycdn.com/v/c/assets/checkout/image/hto-photobooth-sprite-4/0/02dc52c9ce.jpg",
          "//i.warbycdn.com/v/c/assets/checkout/image/hto-photobooth-sprite-5/0/28e121ff46.jpg"
        ],
        "subhead_large_screens": "Got an iPhone? Get our app.",
        "heading": "Got an iPhone? Get our app.",
        "video_cover_image": "//i.warbycdn.com/v/c/assets/checkout/image/hto-photobooth-video-cover/1/a6870fa272.jpg"
      },
      order_lead_time_copy_by_order_type: {
        "1": "5 business days",
        "2": "12 business days",
        "3": "10 business days",
        "4": "10 business days",
        "5": "5 business days",
        "6": "2 business days (or within 1 business day if ordered before 1 p.m. ET)",
        "7": "12 business days",
        "8": "12 business days",
        "9": "12 business days",
        "10": "5 business days",
        "11": "E-Gift Card",
        "12": "5 business days",
        "13": "5 business days",
        "14": "Pending"
      },
    }
  },

  orderType: function(type) {
    let item;
    let isType = false;
    this.props.orders.map(function(order, i) {
        for (item in order.line_items) {
          if (type == "frame") {
            if (order.line_items[item].category === "frame") {
              isType = true;
            }
          }
          else if (type != "frame") {
            if (order.line_items[item].category != "frame") {
              isType =  true;
            }
          }
        }
    })
    return isType;
  },

  /*returns bool of whether or not an order contains rx frames*/
  rxFrames: function() {
    let rxFrames = false;
    this.props.orders.map(function(order, i) {
      let item;
      for (item in order.line_items) {
        if (order.rx_status && !(order.rx_status === ("non-rx" || "readers"))){
          rxFrames = true;
        }
      }
    })
    return rxFrames;
  },

  isHto: function() {
    let item;
    let isHTO = false;
    this.props.orders.map(function(order, i) {
      for (item in order.line_items) {
        if (order.line_items[item].option_type && order.line_items[item].option_type== "hto") {
          isHTO =  true;
          return isHTO;
        }
      }
    })
    return isHTO;
  },

  checkOrderItems: function(variable) {
    let containsVar = false;
    this.props.orders.map(function(order, i) {
      for (var i = 0; i < _.size(order.line_items); i++ ){
        if (order.line_items[i].category === variable) {
          containsVar = true;
        }
        if ((variable==="book") && !(_.startsWith(order.line_items[i].product_url, "/editions/books/"))) {
          containsVar = false;
        }
        return containsVar;
      }
    })
    return containsVar;
  },

  getRxStatus: function(desiredStatus) {
    let isDesiredStatus = false;
    this.props.orders.forEach(function(order) {
      let rx_status = order.rx_status;
      if ((desiredStatus === "processing") && (rx_status === ("call-doctor" || "uploaded" || "manual"))) {
        isDesiredStatus = true;
      }
      else if ((desiredStatus === "awaiting") && (rx_status === "send-later")) {
        isDesiredStatus = true;
      }
      else if ((desiredStatus === "expired") && (rx_status === "rx-check")) {
        isDesiredStatus =  true;
      }
      else if ((desiredStatus === "non-rx") && (rx_status === ("non-rx" || "readers"))) {
        isDesiredStatus =  true;
      }
      else {
        isDesiredStatus = false;
      }
    })
    return isDesiredStatus;
  },

  isDogToy: function() {
    let isDogToy = false;
    this.props.orders.map(function(order, i) {
      for (var i = 0; i < _.size(order.line_items); i++ ){
        if (order.line_items[i].display_name === "Dog Toy") {
          isDogToy = true;
          return  isDogToy;
        }
      }
    })
    return isDogToy;
  },

  onlyEGiftCard: function() {
    let isOnlyEGiftCard = false;
    this.props.orders.map(function(order, i) {
      for (var i = 0; i < _.size(order.line_items); i++) {
        if (order.line_items[i].category === "gift_card" && order.line_items[i].display_name === "Electronic Gift Card") {
          isOnlyEGiftCard = true;
        }
        else {
          isOnlyEGiftCard = false;
        }
      }
    })
    return isOnlyEGiftCard;
  },

  receiveStoreChanges: function() {
    return['geo'];
  },

  offersExams: function(store) {
    return store.info.offers_eye_exams;
  },

  storeURL: function() {
    const geo = this.getStore('geo');
    let examStore;
    if (geo.nearbyStores) {
      examStore = geo.nearbyStores.find((store) => {
        return store.info.offers_eye_exams;
      })
    }
    return (
      examStore ?
      `https://www.warbyparker.com/appointments/eye-exams/${examStore.info.city_slug}/${examStore.info.location_slug}`
      : null
    )
  },

  render: function() {
    const classes = this.getClasses();
    const isGiftCard = this.checkOrderItems("gift_card");
    const rxExpired = this.getRxStatus("expired");
    const rxNeeded = this.getRxStatus("awaiting");
    const isHto = this.isHto();
    return (
      <div className={classes.mainContainer}>
        <div className={classes.messagingContainer}>
          <OrderMessaging
            storeURL={this.storeURL()}
            rxExpired={rxExpired}
            rxNeeded={rxNeeded}
            rxProcessing={this.getRxStatus("processing")}
            rxFrames={this.rxFrames()}
            includesEditions={this.orderType("editions")}
            includesFrames={this.orderType("frame")}
            orders={this.props.orders}
            isHto={isHto}
            isGiftCard={isGiftCard}
            onlyEGiftCard={this.onlyEGiftCard()}
            isDogToy={this.isDogToy()}
            isBook={this.checkOrderItems("book")} />
        </div>
        <OrderInfo
          orderLeadTimeCopy={this.props.order_lead_time_copy_by_order_type}
          rxExpired={rxExpired}
          rxNeeded={rxNeeded}
          isHto={isHto}
          isGiftCard={isGiftCard}
          onlyEGiftCard={this.onlyEGiftCard()}
          orders={this.props.orders} />
        {isHto ?
          <AppPromo app_promo={this.props.appPromoData} />
          : null
        }
      </div>
    );
  }
})
