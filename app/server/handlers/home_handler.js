'use strict';

const _ = require('lodash');
const BaseHandler = require('hedeia/server/handlers/base_handler');

class HomeHandler extends BaseHandler {
  name() {
    return 'Home';
  }

  cacheTTL() {
    return 2 * 60 * 60 * 1000; // 2 hours.
  }

  cacheMaxAge() {
    return 5 * 60 * 1000; // 5 minutes.
  }

  prefetch() {
    return [
      '/api/v2/variations/home',
      '/api/v2/variations/homepage-fluid'
    ];
  }

  cacheKey() {
    return(
      [
        // Show the results treatment of the quiz promo
        this.getCookie('hasQuizResults') ? 'quizresults:' : '',
        this.path
      ].join('')
    );
  }

  handleSurveyGizmoUrl() {
    const query_params = this.request.query
    const delivered_on = _.get(query_params, 'delivered', 0)
    const sales_order_id = _.get(query_params, 'sales_order_id', 0)

    const time_cap_in_days = 4
    const elapsed_time = Date.now() - delivered_on
    const surveygizmo_url =  'http://www.surveygizmo.com/s3/2161901/Warby-Parker-Store-Experience-Survey'
    const num_milliseconds_until_ineligible = time_cap_in_days * 24 * 60 * 60 * 1000
    const error_msg = `This survey is now closed!
      (The survey automatically closes four days after your visit,
      because feedback is like milk: better when fresh.) If you have
      any questions about your order or want to chat with a
      Customer Experience representative, please call us at
      888-492-7297 Monday through Friday between the hours of
      9AM and 9PM EST.`

    if (elapsed_time < num_milliseconds_until_ineligible) {
      this.redirect(`${surveygizmo_url}?gsuid=${sales_order_id}`)
    } else {
      this.throwError({ statusCode: 403, message: error_msg })
    }
  }

  prepare() {
    // Handling RES survey links WARB-2661.
    if (_.get(this.request, 'query.redirect_to') === 'surveygizmo') {
      this.handleSurveyGizmoUrl()
      return false
    }
  }

  initialize() {
    // For debugging WARB-1768.
    this.log('direct_traffic_debugging',{
      url: this.requestUrl,
      query: this.request.query,
      headers: this.request.headers
    });
  }

}

module.exports = HomeHandler;
