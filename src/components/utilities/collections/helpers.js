const transformDeepArray = (products = []) => {
  // Backbone deep model mangles large objects into arrays (if they are keyed by integers).
  // This filters out bad data and gives you an object with product ids as keys.
  return products.reduce(
    (obj, val) => (val ? { ...obj, [val.product_id]: val } : obj),
    {}
  );
};

module.exports = {
  transformDeepArray
};
