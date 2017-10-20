const _ = require("lodash");
const DOMPurify = require("dompurify");

const sanitize = html => {
  const isBrowser = !(typeof window === 'undefined' || window === null);
  return (isBrowser ? DOMPurify.sanitize(html) : html);
};

const formatPriceRange = priceRange => {
  if (!_.startsWith(priceRange, "$")) {
    return `Starting at $${priceRange}`;
  }

  return priceRange;
};

const formatUrl = url => {
  if (_.startsWith(url, "//")) {
    return `https:${url}`;
  } else if (!_.startsWith(url, "http")) {
    return `https:\/\/www.warbyparker.com${url}`;
  }

  return url;
};

const formatPhone = phone => {
  phone = _.replace(phone, '-', '.');
  if (!_.startsWith(phone, "1.")) {
    return `+1.${phone}`;
  }

  return phone;
};

module.exports = {
  sanitize,
  formatPriceRange,
  formatUrl,
  formatPhone
}
