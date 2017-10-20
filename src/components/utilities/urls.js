module.exports = {

  relativeLinkFor: function (link) {
    return link.replace(/^http(s)*:\/\/[A-z-\.]*/,'');
  },

};
