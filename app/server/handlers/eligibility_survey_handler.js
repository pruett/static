'use strict';

const _ = require('lodash');
const BaseHandler = require('hedeia/server/handlers/base_handler');

class EligibilitySurveyHandler extends BaseHandler {
  name() {
    return 'EligibilitySurvey';
  }

  prefetch() {
    const prefetches = [];
    const estimateToken = _.get(this.request, 'query.estimate_token');
    if (estimateToken) {
      prefetches.push(`/api/v2/estimate?estimate_token=${estimateToken}`);
    }
    return prefetches;
  }
}

module.exports = EligibilitySurveyHandler;
