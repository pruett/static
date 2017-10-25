module.exports = (href) => `
(function() {
  window.dataLayer = window.dataLayer || [];
  window.dataLayer.push({ originalLocation: '${href}' });
})();
`;
