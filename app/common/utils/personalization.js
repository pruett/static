'use strict';

// List of url path starts which should not prefetch the personalization endpoint; all others do
const BLACKLIST = [
  '/eyeglasses/men/', '/sunglasses/men/', '/eyeglasses/women/', '/sunglasses/women/',
  '/account', '/appointments', '/cart', '/checkout', '/gift-card',
];

const _ = require('lodash');

module.exports = {
  isPathBlacklisted: (path) => {
    return BLACKLIST.some((pattern) => _.startsWith(path, pattern));
  }
};
