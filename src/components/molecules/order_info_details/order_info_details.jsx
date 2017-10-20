const _ = require("lodash");
const React = require('react/addons');
const Mixins = require('components/mixins/mixins');

module.exports = React.createClass({

  BLOCK_CLASS: "c-order-info-details",

  mixins: [
    Mixins.classes,
    Mixins.analytics,
    Mixins.conversion
  ],

  getStaticClasses() {
    return {
      orderInfoWrapper: `
        u-pt12 u-pt24--900 u-pb24 u-pl12 u-pl0--900 u-pr0 u-oh
        u-btss u-bbss u-bw1 u-bc--light-gray-alt-1
        u-w11c--900 u-m0a--900 u-ml12 u-mr12
        u-tal u-fwn u-color--dark-gray-alt-3
      `,
      orderInfoContainer: `
        ${this.BLOCK_CLASS}__order-info-container
        u-w12c u-w7c--600 u-w12c--900 u-oh u-mla u-ml180--600 u-mla--900 u-mra
      `,
      item: `
        u-dib u-tal u-ml0 u-mr1c u-vat
        u-w6c u-w2c--900 u-fl
      `,
      header: `
        ${this.BLOCK_CLASS}__header
        u-ttu u-fws u-ls1 u-fs10 u-fs12--600 u-mb6 u-mt24 u-mt12--900 u-color--dark-gray
      `,
      description: `
       u-mt0 u-mb0 u-fwn
      `,
      headerDesktop: `
        u-dn u-dib--900
      `,
      headerMobile: `
        u-dib u-dn--900
      `,
    }
  },

  classesWillUpdate: function() {
    return {
      rxDescription: {
        'u-color--red': (this.props.rxNeeded || this.props.rxExpired)
      },
      orderInfoWrapper: {
        'u-bbw0--900': !this.props.isHto,
        'u-bbw0 u-bbw1--900 u-mb48': this.props.isHto
      }
    }
  },

  getPaymentTypes: function(){
    if(!_.size(this.props.orders[0].payments)) {
      return ['Promo Code'];
    }
    return _.map(this.props.orders[0].payments, (payment) => {
      if(payment.type === 'credit_card') {
        return `Ending in ${payment.cc_last_four}`;
      }
      else {
        return _.startCase(payment.type);
      }
    })
  },

  renderPaymentTypes(classes) {
    const payments = this.getPaymentTypes();
    _.size(payments) > 1 ? payments[0] = `${payments[0]},` : null;
    return(
      <div>
        {payments.map(function(text, i) {
          return (<h4 className={classes.description} children={text} key={i}/>);
        })
        }
      </div>
    );
  },

  getPaymentValue: function() {
    let price = 0;
    this.props.orders.forEach(function(order) {
      order.payments.forEach(function(payment) {
        price += payment.amount_cents;
      })
    })
    return (price / 100).toFixed(2);
  },

  renderPaymentValue: function(classes) {
    const price = this.getPaymentValue();
    return(
      <div>
        <h4 className={classes.description} children={`\u0024${price}`} />
      </div>
    );
  },

  renderOrderType: function(classes, order, i) {
    let orderType = "Editions";
    /*you can almost always check line_items[0].category, because orders are split based on category.
        ie no single order will have category of hto and dog toy, the exception is different types of editions*/
    let category = order.line_items[0].category;
    if (category === "frame") {
      orderType = _.startCase(order.line_items[0].assembly_type);
    }
    if (order.line_items[0].option_type === "hto") {
        orderType = "Home Try-On";
    }
    if (_.size(order.line_items) === 1 ) {
      if (category === "gift_card") {
        orderType = `${order.line_items[0].display_name === "Electronic Gift Card" ? "E-": ""}Gift Card`;
      }
      else if (category === "book") {
        if (order.line_items[0].display_name === "Dog Toy") {
          orderType = "Dog Toy";
        }
        else if (_.startsWith(order.line_items[0].product_url, "/editions/books/")) {
          orderType = "Book";
        }
      }
    }
    return (<h4 className={classes.description} children={orderType} key={i} />);
  },

  getDeliveryHeader: function() {
    return `${this.props.onlyEGiftCard ? '' : 'Est '}Delivery Date`;
  },

  getDeliveryDates: function() {
    return _.flatten(this.props.orders.map((order) => {
      // HTOs can have rx requests attached if placed alongside an rx order, but we'll ignore them
      if (order.order_lead_time_category === 5) {
        return this.props.orderLeadTimeCopy[order.order_lead_time_category];
      }
      else if (order.order_lead_time_category === 11) {
        return order.line_items.map((item) => {
          let fullDate = this.convert('date', 'object', item.option_metadata.delivery_date);
          return `${fullDate.month} ${fullDate.date}`;
        });
      }
      else if (order.rx_status === "rx-check") {
        return "Expired Rx";
      }
      else if (order.rx_status === ("call-doctor" || "uploaded" || "manual")) {
        return "Processing Rx";
      }
      else if (order.rx_status === "send-later") {
        return "Awaiting Rx";
      }
      else {
        return this.props.orderLeadTimeCopy[order.order_lead_time_category]  || "";
      }
    }));
  },

  getEGiftRecipients: function() {
    if(!this.props.onlyEGiftCard) return;
    return _.flatten(this.props.orders.map((order) => {
      return order.line_items.map((item) => {
        return _.get(item, "option_metadata.recipient_name", "");
      });
    }));
  },

  getShippingDescription: function(shipping_address) {
    let shippingDescription = `${shipping_address.street_address}`;
    if (shipping_address.extended_address && this.props.onlyEGiftCard) {
      shippingDescription += `, ${shipping_address.extended_address}`;
    }
    return shippingDescription;
  },

  renderDeliveryInfo: function(classes, shipping_address) {
    const state = `${shipping_address.locality}, ${shipping_address.region} ${shipping_address.postal_code}`;
    const eGiftRecipients = this.getEGiftRecipients();
    const deliveryDates = this.getDeliveryDates();
    const shippingDescription = this.getShippingDescription(shipping_address);
    return (
      <div>
        <div className={classes.item}>
          <h3 className={classes.header} children={this.getDeliveryHeader()} />
          {deliveryDates.map(function(date, i) {
            return ( <h4 className={`${classes.description} ${classes.rxDescription}`} children={date} key={i} /> );
          })
          }
        </div>
        <div className={classes.item}>
          <h3 className={classes.header} children={this.props.onlyEGiftCard ? "Recipient" : "Shipping address"} />
          {this.props.onlyEGiftCard ?
            eGiftRecipients.map(function(recipient, i){
              return ( <h4 className={classes.description} children={recipient} /> );
            })
            : <h4 className={classes.description} children={shippingDescription} />
          }
          {!this.props.onlyEGiftCard ? <h4 className={classes.description} children={state} /> : null}
        </div>
      </div>
    );
  },

  handleOrderLinkClick: function(event) {
    this.trackInteraction(`orderConfirmation-click-detailOrderPage`);
  },

  render: function() {
    const classes = this.getClasses();
    return (
      <div className={classes.orderInfoWrapper}>
        <div className={classes.orderInfoContainer}>
          <div>
            <div className={classes.item}>
              <span className={`${classes.header} ${classes.headerDesktop}`} children={"Order number"} />
              <span className={`${classes.header} ${classes.headerMobile}`} children={"Order no"} />
              <ul className={"u-list-reset"}>
              {this.props.orders.map((order, i) => {
                return (
                  <li>
                    <a
                      href={`/account/orders/${order.id}`}
                      className={`${classes.description} u-color--blue u-fwb u-link--hover`}
                      children={order.id}
                      key={i}
                      onClick={this.handleOrderLinkClick} />
                  </li>
                )
              })}
              </ul>
            </div>
              <div className={classes.item}>
                <h3 className={classes.header} children={"Order type"} />
                {this.props.orders.map(this.renderOrderType.bind(this, classes))}
              </div>
          </div>

          <div>
            {this.renderDeliveryInfo(classes, this.props.orders[0].shipping_address)}
          </div>

          <div>
            <div className={classes.item}>
              <h3 className={classes.header} children={"Payment"} />
              {this.renderPaymentTypes(classes)}
            </div>
            <div className={classes.item}>
              <h3 className={classes.header} children={"Total"} />
              {this.renderPaymentValue(classes)}
            </div>
          </div>
        </div>

      </div>
    );
  }
})
