module.exports = () => `
(function() {
  function pushEvent(event) {
    if (!event.target) return;
    var eventId = event.target.getAttribute('data-eventid');
    if (document.body.className.indexOf('react-mounted') > 0) {
      document.body.removeEventListener('click', pushEvent);
    } else if (eventId) {
      var eventAttrs = eventId.split('-');
      if (eventAttrs.length < 3) return;

      var category = eventAttrs[0],
          action = eventAttrs[1],
          target = 'preReact',
          state = eventAttrs[2]; // Target moves to state.

      if (eventAttrs.length > 3 && eventAttrs[3]) {
        // Combine target and state using upper camel case.
        state = state + eventAttrs[3][0].toUpperCase() + eventAttrs[3].slice(1);
      }

      window.dataLayer.push({
        event: 'wp.event',
        wpEvent: {
          id: [category, action, target, state].join('-'),
          category: category,
          action: action,
          target: target,
          state: state
        }
      });
    }
  }

  if (!window.dataLayer) window.dataLayer = [];
  return document.body.addEventListener('click', pushEvent);
})();
`;
