'use strict';
const _ = require('lodash');

const REFERENCE = {
  labels: {
    company: 'Company',
    country_code: 'Country',
    extended_address: 'Apt/Suite',
    first_name: 'First Name',
    last_name: 'Last Name',
    full_name: 'First and Last Name',
    email: 'Email',
    locality: 'City',
    postal_code: {
      CA: 'Postal Code',
      US: 'Zip Code'
    },
    region: {
      CA: 'Province',
      US: 'State'
    },
    street_address: 'Street Address',
    telephone: 'Phone'
  }
};

module.exports = {
  localize: function(key, country = 'US') {
    const content = _.get(REFERENCE, key);
    if (_.isObject(content)) {
      return _.get(content, country, content);
    } else {
      return content;
    }
  }
};
